*** Settings ***
Library			EcuApiClient
Library			EcuComApi
Resource		Ecu Keywords.robot		
Test Teardown 	Clean After Test

*** Variables ***
${TutorialCalculationPackage}		c:\\Users\\User\\Documents\\ecu\\Test Package.pkg

*** Test Cases ***
Ecu Client Tutorial Calculation Test Step
	Create New Package
	Add Calculation Step With Expectation 	3+4		7
	Save Package 		${TutorialCalculationPackage}
	Run Test Package   	${TutorialCalculationPackage}
	
*** Keywords ***
Clean After Test
	Close Test Package  	${TutorialCalculationPackage}
