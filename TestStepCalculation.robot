*** Test Cases ***
Ecu Client Tutorial Peroform Expression and Check Result
	Execute Expression and Check Result 	4+3		7

Adding Many Expession
	Create New Package
	Add Calculation Step With Expectation 	4+2 	6
	Add Calculation Step With Expectation 	4*2 	8
	Add Calculation Step With Expectation 	4-2 	2
	Save And Run Package 	${TutorialCalculationPackage}
	
*** Keywords ***
Clean After Test
	Close Test Package  	${TutorialCalculationPackage}

Execute Expression and Check Result 
	[Arguments] 	${expression}	${result}
	Create New Package
	Add Calculation Step With Expectation 	${expression}		${result}
	Save And Run Package 	${TutorialCalculationPackage}

*** Settings ***
Library			EcuApiClient
Library			EcuComApi
Resource		Ecu Keywords.robot		
Test Teardown 	Clean After Test
Documentation	Demonstrates usage of ECU-TEST via Robot Framework using simple test step with one expression and expectation
...				Robot Framework is first used via Object Api to create test package that is saved.
...				This test package is then loaded to ECU-TEST and executed

*** Variables ***
${TutorialCalculationPackage}		c:\\Users\\User\\Documents\\ecu\\Tutorial-Expression.pkg
