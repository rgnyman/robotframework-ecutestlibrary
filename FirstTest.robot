*** Settings ***
Library		EcuApiClient

*** Test Cases ***
Creating Test Configuration
	CreateAndStoreTestConfiguration
	
*** Keywords ***
CreateAndStoreTestConfiguration
	LOG		Calling
	${TEST_CONFIG}=		ConfigurationApi.CreateTestConfiguration
	TestConfiguration.Save	"Test Saving"