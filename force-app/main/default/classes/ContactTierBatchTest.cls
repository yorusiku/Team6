@isTest
private class ContactTierBatchTest {

    /**
    * ContactTierBatch 테스트
    */
    @isTest
    static void testContactTierBatchExecute() {
        // Testing 에 쓰일 각 Tier 데이터를 만들어줌
        Tier__c testTierA = TestDataFactory.createTier(Constants.A_TIER, 5000000, 0);
        Tier__c testTierB = TestDataFactory.createTier(Constants.B_TIER, 2000000, 4999999);
        Tier__c testTierC = TestDataFactory.createTier(Constants.C_TIER, 1, 199999);
        Tier__c testTierD = TestDataFactory.createTier(Constants.D_TIER, 0, 0);
             
        List<Contact> testPurchaseContacts = TestDataFactory.createContacts(4, Constants.CUSTOMER_RECORD_TYPE_ID, Constants.CONTACT_TYPE_PURCHASE,
        Utility.getTierId(Constants.D_TIER), 0, 0, 0, Date.today().addDays(-7));
        
        List<Contact> testContactsToUpdate = [SELECT Id, Name, Total_Purchase_Amount__c, Purchase_In_Recent_90Days__c
                                              FROM Contact];
        
        // 각 TIer에 맞는 구매금액을 각각 할당 
        for(Contact c: testContactsToUpdate){
            if (c.Name == testContactsToUpdate[0].Name) {
                c.Total_Purchase_Amount__c = 6000000;
            } else if (c.Name == testContactsToUpdate[1].Name) {
                c.Total_Purchase_Amount__c = 2500000;
            } else if (c.Name == testContactsToUpdate[2].Name) {
                c.Total_Purchase_Amount__c = 10000;
            } else if (c.Name == testContactsToUpdate[3].Name) {
                c.Total_Purchase_Amount__c = 0;
            }
        }
        // 업데이트
        update testContactsToUpdate;

        Test.startTest();
        ContactTierBatch batch = new ContactTierBatch();
        Database.QueryLocator queryLocator = batch.start(null);
        batch.execute(null, testContactsToUpdate);
        batch.finish(null);
        Test.stopTest();
        
        System.assertEquals(testContactsToUpdate[0].Customer_Tier__c, testTierA.Id, 'Tier does not match');
        System.assertEquals(testContactsToUpdate[1].Customer_Tier__c, testTierB.Id, 'Tier does not match');
        System.assertEquals(testContactsToUpdate[2].Customer_Tier__c, testTierC.Id, 'Tier does not match');
        System.assertEquals(testContactsToUpdate[3].Customer_Tier__c, testTierD.Id, 'Tier does not match');
    }
}