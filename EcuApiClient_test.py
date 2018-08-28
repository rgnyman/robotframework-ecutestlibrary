""" Test for ApiClient Robot Framework interface

"""

import unittest
from EcuApiClient import EcuApiClient
from logging import debug, error, info, warn

class DummyApi:
    def method_one(self):
        return 1

    def method_two(sefl):
        """
        Method that has important documentation

        """
        return 2

    @property    
    def property_one(self):
        return self.p_one

    def __init__(self):
        self.p_one = "p1"


class EcuApiClientTest(unittest.TestCase):
    def test_get_keyword_names(self):
        a = EcuApiClient(False)
        a.initialize_method_mapping()
        self.assertEqual(5317, len(a.get_keyword_names()))

    def test_add_api_class(self):
        self.e.add_main_api_class(DummyApi())
        names = self.e.get_keyword_names()
        self.assertEqual(30, len(names))
        self.assertTrue("DummyApi_method_one" in names)
        self.assertTrue("DummyApi_method_two" in names)

    def test_run_method_one(self):
        self.e.add_main_api_class(DummyApi())
        result = self.e.run_keyword("DummyApi_method_one", [], dict())
        self.assertEqual(1, result)

    def test_run_method_two(self):
        self.e.add_main_api_class(DummyApi())
        result = self.e.run_keyword("DummyApi_method_two", [], dict())
        self.assertEqual(2, result)
    
    def test_run_property(self):
        self.e.add_main_api_class(DummyApi())
        prop = self.e.run_keyword("DummyApi_property_one", [], dict())
        self.assertEqual("p1", prop)

    def test_remove_not_needed_methods(self):
        purified_names = self.e.clean_methods(self.e.get_method_names(DummyApi()))
        self.assertEqual(4, len(purified_names))

    def setUp(self):
        self.e = EcuApiClient(False, False)

if __name__ == '__main__':
    unittest.main()
