@isTest
private class AccountControllerTest {
    
    /**
    * AccountController getAccounts() 테스트 
    */
    @isTest
    private static void testGetAccounts(){
        List<Account> testAccounts = TestDataFactory.createAccount(2);

        Test.startTest();
        List<Account> accts = AccountController.getAccounts();
        Test.stopTest();
        
        for (Integer i = 0; i < testAccounts.size(); i++) {
            System.assertEquals(accts[i].Name, testAccounts[i].Name, Constants.TESTGETACCOUNTS_ACCOUNT_ASSERTION_MESSAGE);
        }
    }  
}