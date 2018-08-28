""" Windows COM API library to access ECU-TEST Application from Robot Framework 

TODO Add documentation

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

import win32com.client
from logging import debug, error, info, warn, log

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
        reportStr = self.create_report_string(execInfo.GetTestReport(), execInfo.GetLogFolder())
        if not "SUCCESS" == status:
            raise RuntimeError("Test execution failed with result '%s'" % (status))

        info("ECU test run completed with result '%s'\n", status)
        return status

    def create_report_string(self, testReport, testReportFolder):
        info("Full test report is at location\n" + testReportFolder)
        """html_str = "<a href=" + testReportFolder + ">Test Report</a>"
        info(html_str, True)"""
        for i in range(0, testReport.GetCount()):
            tr = "Activity/Name: " + testReport.Activity(i) + " / " + testReport.Name(i) + "\n"
            tr += "Result: " + testReport.Result(i) + "\n"
            tr += "Comment: " + testReport.Comment(i) + "\n"
            tr += "-----------------------------------------------------------------------------\n"
            info(tr)

    def open_test_configuration(self, testConfigurationName):
        debug("Opening test configuration '%s'", testConfigurationName)
        if not True == self.etApp.OpenTestConfiguration(testConfigurationName):
            raise RuntimeError("Can not open test configuration '%s'", testConfigurationName)


    def open_test_bench_configuration(self, testBenchConfigurationName):
        debug("Opening test configuration '%s'", testBenchConfigurationName)
        if not True == self.etApp.OpenTestBenchConfiguration(testBenchConfigurationName):
            raise RuntimeError("Can not open test bench configuration '%s'", testBenchConfigurationName)

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
