

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

Add First Calculation Step With Expectation
	[Arguments]		${expression}		${expected}
	${numeric_expetation}=	ExpectationApi CreateNumericExpectation
	NumericExpectation SetExpression	${expression}
	${calculation_step}=			Create Test Step Calculation
	TsCalculation SetExpectation	${numeric_expetation}
	TsCalculation SetFormula		${expected}
	Package AppendTestStep			${calculation_step}

Add Calculation Step With Expectation
	[Arguments]		${expression}		${expected}
	${numeric_expetation}=	NumericExpectation Clone
	NumericExpectation SetExpression	${expression}
	${calculation_step}=			TsCalculation Clone
	TsCalculation SetExpectation	${numeric_expetation}
	TsCalculation SetFormula		${expected}
	Package AppendTestStep			${calculation_step}

Create Test Bench Configuration
	[Arguments]		${tool host}	${tool name}		${tool port}  	${tool access}
	ConfigurationApi CreateTestBenchConfiguration
	TestBenchConfiguration CreateToolHost	${tool host}
	ToolHost Add Tool 	${tool name}
	Tool Create Port 	${tool port} 	${tool access}

Save Test Bench Configuration
	[Arguments]		${config name}
	TestBenchConfiguration Save 	${config name}

Create Test Configuration
	ConfigurationApi CreateTestConfiguration

Create Model
	[Arguments]		${plant_model_name}		${model_file} 	${model port}
	TestConfiguration Platform
	Platform ModelAccess
	ModelAccess Add		${plant_model_name}
	Model SetFile		${model_file}
	Model SetPort		${model port}

Create Model Mapping
	[Arguments]		${Model Key}	${Model Path}	${Variable Type}		
	${Mapping Item}=	MappingApi Create Model Mapping Item		${Model Key}	${Model Path}	${Variable Type}
	Package GetMapping
	LocalMapping AddItem	${Mapping Item}
	[return]	${Mapping Item}

Add First Test Step Write
	[Arguments]		${value}	${Mapping Item}  ${model mapping item}
	${ts write}=	Create Test Step Write 	${model mapping item}
	TsWrite SetValue	${value}
	Package AppendTestStep 		${ts write}

Add Test Step Write
	[Arguments]		${value}	${Mapping Item}  ${model mapping item}
	${ts write}=	TsWrite Clone
	TsWrite SetValue	${value}
	Package AppendTestStep 		${ts write}

Add First Test Step Read
	[Arguments]		${value}	${Mapping Item} 	${model mapping item}
	${ts read}=	Create Test Step Read 	${model mapping item}
	TsRead SetExpectationExpression 	${value}
	Package AppendTestStep 		${ts read}

Add Test Step Read
	[Arguments]		${value}	${Mapping Item} 	${model mapping item}
	${ts read}=	TsRead Clone
	TsRead SetExpectationExpression 	${value}
	Package AppendTestStep 		${ts read}

Create Test Step Write
	[Arguments]		${Mapping Item}
	${ts write}=	TestStepApi CreateTswrite	${Mapping Item}
	[return]		${ts write}

Create Test Step Read
	[Arguments]		${Mapping Item }
	${ts read}=	TestStepApi CreateTsRead	${Mapping Item}
	[return]		${ts read}

Save Test Configuration
	[Arguments]					${config_file_path}
	TestConfiguration Save  	${config_file_path}

Save And Run Package
	[Arguments]			${package name}
	Save Package 		${package name}
	Run Test Package   	${package name}
