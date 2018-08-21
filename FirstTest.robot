*** Settings ***
Library		EcuApiClient

*** Test Cases ***
Ecu Client Tutorial
	Create New Pakage
	Create Test Step Api
	Create Test Step Calculation
	Add Step Expectation 	3+4		7
	
*** Keywords ***
Create New Pakage
	PackageApi.CreatePackage
	PackageApi.ExpectationApi

Create Test Step Api
	PackageApi.TestStepApi

Create Test Step Calculation
	TestStepApi.CreateTsCalculation

Add Step Expectation
	[Arguments]		${expression}		${expected}
	${numeric_expetation}=	ExpectationApi.CreateNumericExpectation
	NumericExpectation.SetExpression	${expression}
	TSCalculation.SetExpectation	${numeric_expetation}

CreateAndStoreTestConfiguration
	LOG		Calling
	${TEST_CONFIG}=		ConfigurationApi.CreateTestConfiguration
	TestConfiguration.Save	"Test Saving"

CreateTestBenchConfiguration
	ConfigurationApi.CreateTestBenchConfiguration
	TestBenchConfiguration.CreateToolHost	"ToolhostURL"