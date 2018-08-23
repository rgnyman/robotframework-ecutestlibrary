""" Windows COM API library to access ECU-TEST Application from Robot Framework 

TODO Add documentation

Copyright 2018 Rannicon Oy All Rights Reserved 

TODO Add License
"""

import win32com.client
from logging import debug, error, info, warn

class EcuComApi:

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def run_test_package(self, packageName, timeOutSeonds=30):
        pkg = self.etApp.OpenPackage(packageName)
        
        if pkg is None:
            raise AssertionError("Package '%s' not found" % (packageName))

        execInfo = self.etEnv.ExecutePackage(packageName)
        execInfo.WaitForTestexecutionCompletion(timeOutSeonds)
        status = execInfo.GetPackageResult()
        if not "SUCCESS" == status:
            raise RuntimeError("Test execution failed with result '%s'" % (status))

        return status

    def close_test_package(self, packageName):
        self.etApp.ClosePackage(packageName)

    def __init__(self):
        self.etApp = win32com.client.Dispatch('ECU-TEST.Application')
        self.etEnv = self.etApp.Start()
