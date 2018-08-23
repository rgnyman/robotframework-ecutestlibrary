*** Settings ***
Library		EcuApiClient

*** Test Cases ***
Ecu Client Tutorial
	Create New Pakage
	Create Test Step Api
	Add Calculation Step With Expectation 	3+4		7
	Save Package 	c:\\Users\\User\\Documents\\ecu\\Test Package
	
*** Keywords ***
Create New Pakage
	PackageApi.CreatePackage
	PackageApi.ExpectationApi

Create Test Step Api
	PackageApi.TestStepApi

Create Test Step Calculation
	${ts_calculation}=	TestStepApi.CreateTsCalculation
	[return]	${ts_calculation}

Add Calculation Step With Expectation
	[Arguments]		${expression}		${expected}
	${calculation_step}=	Create Test Step Calculation
	${numeric_expetation}=	ExpectationApi.CreateNumericExpectation
	NumericExpectation.SetExpression	${expression}
	TsCalculation.SetExpectation	${numeric_expetation}
	TsCalculation.SetFormula		"7"	
	Package.AppendTestStep			${calculation_step}

Save Package
	[Arguments]			${package-file}
	Package.Save		${package-file}

CreateAndStoreTestConfiguration
	LOG		Calling
	${TEST_CONFIG}=		ConfigurationApi.CreateTestConfiguration
	TestConfiguration.Save	"Test Saving"

CreateTestBenchConfiguration
	ConfigurationApi.CreateTestBenchConfiguration
	TestBenchConfiguration.CreateToolHost	"ToolhostURL"