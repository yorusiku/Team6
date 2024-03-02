@isTest
private class ContactControllerTest {
    @isTest
    private static void testGetPurchaseCustomers(){
        List<Contact> testContacts = TestDataFactory.createContact(2, Constants.CONTACT_TYPE_PURCHASE, Constants.CUSTOMER_RECORD_TYPE_ID);

        Test.startTest();
        List<Contact> cts = ContactController.getPurchaseCustomers();
        Test.stopTest();
        
        for (Integer i = 0; i < testContacts.size(); i++) {
            System.assertEquals(cts[i].Name, testContacts[i].Name, 'Contact names do not match');
        }
    } 
}