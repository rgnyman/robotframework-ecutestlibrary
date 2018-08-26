*** Settings ***
Library			EcuApiClient
Library			EcuComApi
Resource		Ecu Keywords.robot
Test TearDown	Clean After Test


*** Variables ***
${TUTORIAL_ACCESING_SUT_PKG}		c:\\Users\\User\\Documents\\ecu\\Tutorial-Accessing-SUT.pkg
${TUTORIAL_ACCESING_SUT_TCF}		c:\\Users\\User\\Documents\\ecu\\Tutorial-Accessing-SUT.tcf
${TUTORIAL_ACCESING_SUT_SDF}		C:\\Users\\User\\ECU-TEST\\Workspace-GS\\Offline-Models\\HiL.sdf

*** Test Cases ***
Ecu Client Tutorial Calculation Test Step
	Create Test Configuration
	Create Model  				Plant Model 	${TUTORIAL_ACCESING_SUT_SDF}
	Save Test Configuration 	${TUTORIAL_ACCESING_SUT_TCF}
	Open Test Configuration		${TUTORIAL_ACCESING_SUT_TCF}
	Start Test Environment
	Create New Package
	Create Model Mapping   		Plant Model 	simState 	VALUE
	Add Test Step Write			5	Plant Model/simState
	Save Package 				${TUTORIAL_ACCESING_SUT_PKG}
	Run Test Package  			${TUTORIAL_ACCESING_SUT_PKG}

*** Keywords ***
Clean After Test
	Stop Test Environment
	Save Package 	${TUTORIAL_ACCESING_SUT_PKG}
