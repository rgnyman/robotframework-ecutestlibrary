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
        self.etEnv = self.etApp.Start()
        pkg = self.etApp.OpenPackage(packageName)
        
        if pkg is None:
            raise AssertionError("Package '%s' not found" % (packageName))

        execInfo = self.etEnv.ExecutePackage(packageName)
        runResult = execInfo.WaitForTestexecutionCompletion(timeOutSeonds)
        if not "FINISHED" == runResult:
            raise RuntimeError("Test execution timed out. Result'%s'" % (runResult))

        status = execInfo.GetPackageResult()
        if not "SUCCESS" == status:
            reportStr = self.create_report_string(execInfo.GetTestReport(), execInfo.GetLogFolder())
            raise RuntimeError("Test execution failed with result '%s' \n\n%s" % (status, reportStr))

        info("ECU test run compelted with result '%s'", status)
        return status

    def create_report_string(self, testReport, testReportFolder):
        tr = "Full test report is at location "
        tr += testReportFolder + "\n"
        for i in range(0, testReport.GetCount()):
            tr += "Activity/Name: " + testReport.Activity(i) + " / " + testReport.Name(i) + "\n"
            tr += "Result: " + testReport.Result(i) + "\n"
            tr += "Comment: " + testReport.Comment(i) + "\n"
            tr += "-----------------------------------------------------------------------------\n"
        return tr

    def open_test_configuration(self, testConfigurationName):
        debug("Opening test configuration '%s'", testConfigurationName)
        if not True == self.etApp.OpenTestConfiguration(testConfigurationName):
            raise RuntimeError("Can not opent test configuration '%s'", testConfigurationName)

    def start_test_environment(self):
        self.etEnv = self.etApp.Start()

    def close_test_package(self, packageName):
        self.etApp.ClosePackage(packageName)

    def stop_test_environment(self):
        self.etEnv = self.etApp.Stop()
        self.etEnv = None

    def __init__(self):
        self.etApp = win32com.client.Dispatch('ECU-TEST.Application')
        self.etEnv = None
