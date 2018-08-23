*** Settings ***
Library		EcuApiClient
Library		EcuComApi


*** Variables ***
${TutorialCalculationPackage}		c:\\Users\\User\\Documents\\ecu\\Test Package.pkg

*** Test Cases ***
Ecu Client Tutorial Calculation Test Step
	Create New Pakage
	Create Test Step Api
	Add Calculation Step With Expectation 	3+4		7
	Save Package 		${TutorialCalculationPackage}
	Run Test Package   	${TutorialCalculationPackage}
	[Teardown]		Close Test Package  	${TutorialCalculationPackage}
	
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
	${numeric_expetation}=	ExpectationApi.CreateNumericExpectation
	NumericExpectation.SetExpression	${expression}
	${calculation_step}=			Create Test Step Calculation
	TsCalculation.SetExpectation	${numeric_expetation}
	TsCalculation.SetFormula		${expected}
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