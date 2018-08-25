""" Proxy library to access ECU-TEST Api from Robot Framework 

TODO Add documentation

Copyright 2018 Rannicon Oy All Rights Reserved 

TODO Add License
"""
from ApiClient import ApiClient as ApiClientClass
import ApiClient as ApiClientModule
from logging import debug, error, info, warn
import types
import inspect

class EcuApiClient:

    ROBOT_LIBRARY_SCOPE = 'TEST SUITE'
    
    def initialize_method_mapping(self):
        self.keywordMapping = self.get_all_api_methods()
        self.add_main_api_class(self.api.ConfigurationApi)
        self.add_main_api_class(self.api.PackageApi)
    
    def get_all_api_methods(self):
        classes = self.get_all_api_classes()
        for c in classes:
            class_methods = dir(c[1])
            class_methods = self.remove_not_needed_methods(class_methods)
            self.update_keyword_dictionary(c[0], class_methods, c[1])
        return self.keywordMapping

    def get_all_api_classes(self):
        return inspect.getmembers(ApiClientModule, inspect.isclass)

    def update_keyword_dictionary(self, class_name, methods, object_id):
        for mn in methods:
            mn = class_name + '_' + mn
            self.keywordMapping[mn] = object_id

    def remove_not_needed_methods(self, methods):
        methods = self.remove_undescore_names(methods)
        methods = self.remove_all_capital_names(methods)
        return methods

    def remove_all_capital_names(self, methods):
        return [elem for elem in methods if not (elem.isupper())]

    def remove_undescore_names(self, methods):
        return [elem for elem in methods if elem[0] != '_']
            
    def add_main_api_class(self, api_class):
        members = self.get_method_names(api_class)
        self.add_new_keywords(members, api_class.__class__.__name__)

    def get_method_names(self, classObject):
        debug(classObject)
        methods = inspect.getmembers(classObject)
        debug(methods)
        return methods

    def run_keyword(self, name, args, kwargs):
        method = self.keywordMapping[name]
        debug("calling method '%s' found with name '%s' args '%s' kwargs '%s'", method, name, args, kwargs)
        call_result = self.call_method(method, args, kwargs)
        debug("call_result '%s'", call_result)
        object_methods = self.get_method_names(call_result)
        self.update_method_dictionary(object_methods, call_result.__class__.__name__)
        docs = inspect.getdoc(method)
        if len(docs) > 5:
            info(docs)
        return call_result

    def call_method(self, method, args, kwargs):
        if len(args) == 0 and len(kwargs) == 0:
            return self.property_or_method_call(method)
        else:
            return self.args_kwargs_call(method, args, kwargs)

    def property_or_method_call(self, method):
        if callable(method):
            return method()
        else:
            return method

    def args_kwargs_call(self, method, args, kwargs):
        if len(kwargs) == 0:
            return method(*args)
        else:
            return method(*args, **kwargs)

    def update_method_dictionary(self, members, object_name):
        if object_name == 'NoneType':
            return
        members = self.clean_methods(members)
        self.add_new_keywords(members, object_name)
    
    def clean_methods(self, members):
        members = [elem for elem in members if not (elem[0].isupper())]
        members = [elem for elem in members if not (elem[0][0] == "_")]
        return members

    def add_new_keywords(self, members, object_name):
        for m in members:
            name = object_name + '_' + m[0]
            debug("Adding keyword with name '%s' for method '%s'", name, m[1])
            self.keywordMapping[name] = m[1]

    def get_keyword_documentation(self, name):
        obj = self.keywordMapping[name]
        docs = inspect.getdoc(obj)
        return docs

    def get_keyword_tags(self, name):
        pass

    def get_keyword_arguments(self, name):
        pass

    def get_mappings(self):
        return self.keywordMapping

    def get_keyword_names(self):
        self.initialize_method_mapping()
        debug(self.keywordMapping.keys())
        return self.keywordMapping.keys()

    def __init__(self):
        self.api = ApiClientClass()
        self.keywordMapping = dict()
        self.initialize_method_mapping()
    
