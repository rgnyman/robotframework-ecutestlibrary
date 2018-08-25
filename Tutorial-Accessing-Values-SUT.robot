*** Settings ***
Library		EcuApiClient
Library		EcuComApi
Test TearDown	Clean After Test


*** Variables ***
${TUTORIAL_ACCESING_SUT_PKG}		c:\\Users\\User\\Documents\\ecu\\Tutorial-Accessing-SUT.pkg
${TUTORIAL_ACCESING_SUT_TCF}		c:\\Users\\User\\Documents\\ecu\\Tutorial-Accessing-SUT.tcf
${TUTORIAL_ACCESING_SUT_SDF}		C:\\Users\\User\\ECU-TEST\\Workspace-GS\\Offline-Models\\HiL.sdf

*** Test Cases ***
Ecu Client Tutorial Calculation Test Step
	Create Test Configuration
	Create Model  				Plant Model
	Save Test Configuration 	${TUTORIAL_ACCESING_SUT_TCF}
	Open Test Configuration		${TUTORIAL_ACCESING_SUT_TCF}
	Start Test Environment
	Create New Package
	Create Model Mapping   		Plant Model 	simState 	VALUE
	Add Test Step Write			5	Plant Model/simState
	Save Package 				${TUTORIAL_ACCESING_SUT_PKG}
	Run Test Package  			${TUTORIAL_ACCESING_SUT_PKG}

*** Keywords ***
Create New Package
	PackageApi CreatePackage
	PackageApi ExpectationApi
	PackageApi MappingApi
	PackageApi TestStepApi

Create Model Mapping
	[Arguments]		${Model Key}	${Model Path}	${Variable Type}		
	${Mapping Item}=	MappingApi Create Model Mapping Item		${Model Key}	${Model Path}	${Variable Type}
	Package GetMapping
	LocalMapping AddItem	${Mapping Item}

Add Test Step Write
	[Arguments]		${value}	${Mapping Item}
	${ts write}=	Create Test Step Write 	${Mapping Item}
	TsWrite SetValue	${value}
	Package AppendTestStep 		${ts write}

Create Test Step Write
	[Arguments]		${Mapping Item Name}
	${Mapping Item}=	LocalMapping GetItemByName	${Mapping Item Name}	
	${ts write}=	TestStepApi CreateTswrite	${Mapping Item}
	[return]		${ts write}

Create Test Step Calculation
	${ts_calculation}=	TestStepApi CreateTsCalculation
	[return]	${ts_calculation}

Add Calculation Step With Expectation
	[Arguments]		${expression}		${expected}
	${numeric_expetation}=	ExpectationApi CreateNumericExpectation
	NumericExpectation SetExpression	${expression}
	${calculation_step}=			Create Test Step Calculation
	TsCalculation SetExpectation	${numeric_expetation}
	TsCalculation SetFormula		${expected}
	Package AppendTestStep			${calculation_step}

Save Package
	[Arguments]			${package-file}
	Package Save		${package-file}

Clean After Test
	Stop Test Environment
	Save Package 	${TUTORIAL_ACCESING_SUT_PKG}

CreateTestConfiguration
	ConfigurationApi CreateTestConfiguration

Save Test Configuration
	[Arguments]					${config_file_path}
	TestConfiguration Save  	${config_file_path}

Create Model
	[Arguments]		${plant_model_name}
	TestConfiguration Platform
	Platform ModelAccess
	ModelAccess Add		${plant_model_name}
	Model SetFile		${TUTORIAL_ACCESING_SUT_SDF}


CreateTestBenchConfiguration
	ConfigurationApi CreateTestBenchConfiguration
	TestBenchConfiguration CreateToolHost	"ToolhostURL"