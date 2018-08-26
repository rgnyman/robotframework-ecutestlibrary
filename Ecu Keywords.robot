

*** Keywords ***
Save Package
	[Arguments]			${package-file}
	Package Save		${package-file}

Create New Package
	PackageApi CreatePackage
	PackageApi ExpectationApi
	PackageApi TestStepApi

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