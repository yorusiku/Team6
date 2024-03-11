@isTest
private class ContactControllerTest {
    
    /**
    * ContacController GetPurchaseCustomers 테스트 
    */
    @isTest
    private static void testGetPurchaseCustomers(){
        Tier__c testTier = TestDataFactory.createTier(Constants.D_TIER, 0, 0);
        List<Contact> testContacts = TestDataFactory.createContacts(2, Constants.CUSTOMER_RECORD_TYPE_ID , Constants.CONTACT_TYPE_PURCHASE,
                                                                   Utility.getTierId(Constants.D_TIER), 0 , 0 , 0 , Date.today());
        System.debug(testContacts);
        Test.startTest();
        List<Contact> cts = ContactController.getPurchaseCustomers();
        Test.stopTest();
        
        
        for (Integer i = 0; i < testContacts.size(); i++) {
            System.assertEquals(cts[i].Name,  testContacts[i].LastName + Constants.BLANK_STRING + testContacts[i].FirstName, Constants.CONTACT_NAME_ASSERTION_MESSAGE);
        }
    } 
}