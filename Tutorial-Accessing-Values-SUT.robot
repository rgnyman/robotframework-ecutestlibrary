

*** Test Cases ***
Ecu Client Tutorial Accessing Values From SUT
	Prapare Test And Test Bench Configurations
	Create Test Package Writing and Reading SUT
	Save And Run Package 				${TUTORIAL_ACCESING_SUT_PKG}
	
*** Keywords ***
Clean After Test
	Stop Test Environment
	Save Package 	${TUTORIAL_ACCESING_SUT_PKG}
	Close Test Package	${TUTORIAL_ACCESING_SUT_PKG}

Create Test Package Writing and Reading SUT
	Create New Package
	Create Model Mapping   		Plant Model 	simState 	VALUE
	Add Test Step Write			5   Plant Model/simState
	Add Test Step Read			5   Plant Model/simState

Prapare Test And Test Bench Configurations
	Create Test Configuration
	Create Model  				Plant Model 	${TUTORIAL_ACCESING_SUT_SDF} 	MDL01
	Save Test Configuration 	${TUTORIAL_ACCESING_SUT_TCF}
	Open Test Configuration		${TUTORIAL_ACCESING_SUT_TCF}
	Create Test Benchconfiguration	local 	MODELDUMMY 		MODELACCESS 	Standard
	Save Test Bench Configuration 	${TUTORIAL_ACCESING_SUT_TBC}
	Open Test Bench Configuration	${TUTORIAL_ACCESING_SUT_TBC}
	Start Test Environment

*** Settings ***
Library			EcuApiClient
Library			EcuComApi
Resource		Ecu Keywords.robot
Suite Setup		Start Test Environment
Test TearDown	Clean After Test


*** Variables ***
${TUTORIAL_ACCESING_SUT_PKG}		c:\\Users\\User\\Documents\\ecu\\Tutorial-Accessing-SUT.pkg
${TUTORIAL_ACCESING_SUT_TCF}		c:\\Users\\User\\Documents\\ecu\\Tutorial-Accessing-SUT.tcf
${TUTORIAL_ACCESING_SUT_SDF}		C:\\Users\\User\\ECU-TEST\\Workspace-GS\\Offline-Models\\HiL.sdf
${TUTORIAL_ACCESING_SUT_TBC}		c:\\Users\\User\\Documents\\ecu\\Tutorial-Accessing-SUT.tbc