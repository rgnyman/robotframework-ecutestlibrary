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

*** Test Cases ***
Ecu Client Tutorial Calculation Test Step
	Create Test Configuration
	Create Model  				Plant Model 	${TUTORIAL_ACCESING_SUT_SDF} 	MDL01
	Save Test Configuration 	${TUTORIAL_ACCESING_SUT_TCF}
	Open Test Configuration		${TUTORIAL_ACCESING_SUT_TCF}
	Start Test Environment
	Create New Package
	Create Model Mapping   		Plant Model 	simState 	VALUE
	Add Test Step Write			5   Plant Model/simState
	Add Test Step Read			5   Plant Model/simState
	Save Package 				${TUTORIAL_ACCESING_SUT_PKG}
	Create Test Benchconfiguration	local
	Save Test Bench Configuration 	${TUTORIAL_ACCESING_SUT_TBC}
	Open Test Bench Configuration	${TUTORIAL_ACCESING_SUT_TBC}
	Run Test Package  			${TUTORIAL_ACCESING_SUT_PKG}

*** Keywords ***
Clean After Test
	Stop Test Environment
	Save Package 	${TUTORIAL_ACCESING_SUT_PKG}
	Close Test Package	${TUTORIAL_ACCESING_SUT_PKG}
