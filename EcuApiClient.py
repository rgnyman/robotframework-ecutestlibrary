""" Proxy library to access ECU-TEST Api from Robot Framework 

TODO Add documentation

"""

"""from ApiClient import ConfigurationApi"""

from ApiClient import ApiClient as ApiClientClass
import ApiClient as ApiClientModule
from logging import debug, error, info, warn
import types
import inspect

class EcuApiClient:

    ROBOT_LIBRARY_SCOPE = 'TEST SUITE'
    
    def get_all_api_classes(self):
        return inspect.getmembers(ApiClientModule, inspect.isclass)

    def get_all_api_methods(self):
        classes = self.get_all_api_classes()
        for c in classes:
            class_methods = dir(c[1])
            class_methods = self.remove_not_needed_methods(class_methods)
            self.append_class_name(c[0], class_methods, c[1])
        return self.keywordMapping

    def append_class_name(self, class_name, methods, object_id):
        for mn in methods:
            mn = class_name + "." + mn
            self.keywordMapping[mn] = object_id

    def remove_not_needed_methods(self, methods):
        methods = self.remove_undescore_names(methods)
        methods = self.remove_all_capital_names(methods)
        return methods

    def remove_all_capital_names(self, methods):
        return [elem for elem in methods if not (elem.isupper())]

    def remove_undescore_names(self, methods):
        return [elem for elem in methods if elem[0] != '_']
        
    def initialize_method_mapping(self):
        self.keywordMapping = self.get_all_api_methods()
        self.add_main_api_classes(self.api.ConfigurationApi)
        self.add_main_api_classes(self.api.PackageApi)
        
    def add_main_api_classes(self, api_class):
        members = self.get_method_names(api_class)
        self.add_api_objects(api_class.__class__.__name__, members)

    def add_api_objects(self, class_name, members):
        for mn in members:
            name = class_name + "." + mn[0]
            debug(name)
            debug(mn[1])
            self.keywordMapping[name] = mn[1]

    def get_method_names(self, classObject):
        methods = inspect.getmembers(classObject)
        debug(classObject)
        debug(methods)
        return methods

    def run_keyword(self, name, args, kwargs):
        method = self.keywordMapping[name]
        debug(name)
        debug(method)
        if len(args) == 0:
            if callable(method):
                ret = method()
            else:
                ret = method
        else:
            ret = method(args[0])
        object_methods = self.get_method_names(ret)
        self.update_method_dictionary(object_methods, ret.__class__.__name__)
        return ret

    def get_keyword_documentation(self, name):
        pass

    def get_keyword_tags(self, name):
        pass

    def get_keyword_arguments(self, name):
        pass

    def update_method_dictionary(self, members, object_name):
        for m in members:
            name = object_name + '.' + m[0]
            debug(name, m[1])
            self.keywordMapping[name] = m[1]
            
    def get_mappings(self):
        return self.keywordMapping

    def get_keyword_names(self):
        self.initialize_method_mapping()
        self.keywordMapping['store_methods'] = self.store_methods
        debug(self.keywordMapping.keys())
        return self.keywordMapping.keys()

    def store_methods(self, classObject):
        info("Looking for object", classObject)
        members = self.get_method_names(classObject)
        info(members)
        self.update_method_dictionary(members)


    def __init__(self):
        self.api = ApiClientClass()
        self.keywordMapping = dict()
        self.initialize_method_mapping()
    
