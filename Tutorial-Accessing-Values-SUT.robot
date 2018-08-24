*** Settings ***
Library		EcuApiClient
Library		EcuComApi


*** Variables ***
${TUTORIAL_ACCESING_SUT_PKG}		c:\\Users\\User\\Documents\\ecu\\Tutorial-Accessing-SUT.pkg
${TUTORIAL_ACCESING_SUT_TCF}		c:\\Users\\User\\Documents\\ecu\\Tutorial-Accessing-SUT.tcf
${TUTORIAL_ACCESING_SUT_SDF}		C:\\Users\\User\\ECU-TEST\\Workspace-GS\\Offline-Models\\HiL.sdf

*** Test Cases ***
Ecu Client Tutorial Calculation Test Step
	Create Test Configuration
	Create Model  				Plant Model  	WinDev1806Eval
	Save Test Configuration 	${TUTORIAL_ACCESING_SUT_TCF}
	Open Test Configuration		${TUTORIAL_ACCESING_SUT_TCF}
	Start Test Environment

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

CreateTestConfiguration
	ConfigurationApi.CreateTestConfiguration

Save Test Configuration
	[Arguments]					${config_file_path}
	TestConfiguration.Save  	${config_file_path}

Create Model
	[Arguments]		${plant_model_name}		${host}
	TestConfiguration.Platform
	Platform.ModelAccess
	ModelAccess.Add		${plant_model_name}
	Model.SetFile		${TUTORIAL_ACCESING_SUT_SDF}


CreateTestBenchConfiguration
	ConfigurationApi.CreateTestBenchConfiguration
	TestBenchConfiguration.CreateToolHost	"ToolhostURL"