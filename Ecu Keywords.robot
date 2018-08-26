

*** Keywords ***
Save Package
	[Arguments]			${package-file}
	Package Save		${package-file}

Create New Package
	PackageApi CreatePackage
	PackageApi ExpectationApi
	PackageApi TestStepApi
	PackageApi MappingApi

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

CreateTestBenchConfiguration
	ConfigurationApi CreateTestBenchConfiguration
	TestBenchConfiguration CreateToolHost	"ToolhostURL"

CreateTestConfiguration
	ConfigurationApi CreateTestConfiguration

Create Model
	[Arguments]		${plant_model_name}		${model_file}
	TestConfiguration Platform
	Platform ModelAccess
	ModelAccess Add		${plant_model_name}
	Model SetFile		${model_file}

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

Save Test Configuration
	[Arguments]					${config_file_path}
	TestConfiguration Save  	${config_file_path}
