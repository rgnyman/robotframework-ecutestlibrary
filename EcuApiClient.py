""" Proxy library to access ECU-TEST Api from Robot Framework 

Library collects all keywords names from ApiClient module using dir(). These methods are stored to dictionary 
so that in Format [ClassName_Method][method]. Since most of the objects can not be created at initialization phase only
main Api objects are created in initialization phase. Rest of the method in dictionary are replaced with real callable methods
when the class containing the methods is created using the main Api methods. 

Copyright 2018 Ran Nyman, Rannicon Oy and Gosei Oy

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"""
from ApiClient import ApiClient as ApiClientClass
import ApiClient as ApiClientModule
from logging import debug, error, info, warn
from EcuComApi import EcuComApi
import inspect

class EcuApiClient:

    ROBOT_LIBRARY_SCOPE = 'TEST SUITE'
    
    def initialize_method_mapping(self):
        self.keywordMapping = self.get_all_api_methods()
        self.create_api_classes()

    def create_api_classes(self):
        if self.ecuTestRunning:
            self.add_main_api_class(self.api.ConfigurationApi)
            self.add_main_api_class(self.api.PackageApi)
            self.add_main_api_class(self.api.GlobalMappingApi)
            self.add_main_api_class(self.api.ParameterApi)
            self.add_main_api_class(self.api.ProjectApi)
            self.add_main_api_class(self.api.ReportApi)
            self.add_main_api_class(self.api.SignalDescriptionApi)
            self.add_main_api_class(self.api.TraceFileApi)
            self.add_main_api_class(self.api.TraceStepTemplateApi)
    
    def get_all_api_methods(self):
        classes = self.get_all_api_classes()
        self.store_class_methods(classes)
        return self.keywordMapping

    def store_class_methods(self, classes):
        for c in classes:
            class_methods = dir(c[1])
            class_methods = self.remove_not_needed_methods(class_methods)
            self.update_keyword_dictionary(c[0], class_methods, c[1])

    def get_all_api_classes(self):
        return inspect.getmembers(ApiClientModule, inspect.isclass)

    def update_keyword_dictionary(self, class_name, methods, object_id):
        for mn in methods:
            self.add_name_object_keywords(class_name, mn, object_id)
        
    def add_name_object_keywords(self, class_name, method_name, object_id):
        key = class_name + '_' + method_name
        debug("Adding keyword with name '%s' for method '%s'", key, object_id)
        self.keywordMapping[key] = object_id

    def add_new_keywords(self, members, class_name):
        for m in members:
            self.add_name_object_keywords(class_name, m[0], m[1])

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
        method = self.get_method(name)
        
        call_result = self.call_method(method, args, kwargs)
        debug("call_result '%s'", call_result)

        self.write_info_docs(method)
        self.after_run_update_new_objects_keywords(call_result)
        
        return call_result

    def get_method(self, name):
        debug("calling method '%s' found with name '%s' args '%s' kwargs '%s'", method, name, args, kwargs)
        return self.keywordMapping[name]

    def after_run_update_new_objects_keywords(self, call_result):
        object_methods = self.get_method_names(call_result)
        self.update_method_dictionary(object_methods, call_result.__class__.__name__)
        
    def write_info_docs(self, method):
        docs = inspect.getdoc(method)
        if (not (docs == None)) and len(docs) > 5:  
            info(docs)
        
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

    
    def get_keyword_documentation(self, name):
        pass

    def get_keyword_tags(self, name):
        pass

    def get_keyword_arguments(self, name):
        pass

    def get_mappings(self):
        return self.keywordMapping

    def get_keyword_names(self):
        debug(self.keywordMapping.keys())
        return self.keywordMapping.keys()

    def __init__(self, startEcuTest=True, initializeKeywordMapping=True):
        self.ecuTestRunning = startEcuTest
        if startEcuTest:
            self.ecuComApi = EcuComApi()
            self.ecuComApi.start_test_environment()
            self.api = ApiClientClass()
        self.keywordMapping = dict()
        if (initializeKeywordMapping):
            self.initialize_method_mapping()
    
