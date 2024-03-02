@isTest
private class AccountControllerTest {
    
    @isTest
    private static void testGetAccounts(){
        List<Account> testAccounts = TestDataFactory.createAccount(2);

        Test.startTest();
        List<Account> accts = AccountController.getAccounts();
        Test.stopTest();
        
        for (Integer i = 0; i < testAccounts.size(); i++) {
            System.assertEquals(accts[i].Name, testAccounts[i].Name, 'Account names do not match');
        }
    }  
}