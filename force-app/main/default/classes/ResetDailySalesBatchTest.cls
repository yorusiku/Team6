@isTest
private class ResetDailySalesBatchTest {
    @isTest
    private static void testResetDailySalesBatch() {
        List<Account> testAccts = TestDataFactory.createAccount(15);

        Test.startTest();
        ResetDailySalesBatch batch = new ResetDailySalesBatch();
        Database.QueryLocator queryLocator = batch.start(null);
        batch.execute(null, testAccts);
        batch.finish(null);
        Test.stopTest();

        System.assertEquals(testAccts[0].LastDailyUpdate__c, Date.today().day());
        System.assertEquals(testAccts[1].LastDailyUpdate__c, Date.today().day());
        System.assertEquals(testAccts[2].LastDailyUpdate__c, Date.today().day());
        System.assertEquals(testAccts[3].LastDailyUpdate__c, Date.today().day());
        System.assertEquals(testAccts[4].LastDailyUpdate__c, Date.today().day());
        System.assertEquals(testAccts[5].LastDailyUpdate__c, Date.today().day());
        System.assertEquals(testAccts[6].LastDailyUpdate__c, Date.today().day());
        System.assertEquals(testAccts[7].LastDailyUpdate__c, Date.today().day());
        System.assertEquals(testAccts[8].LastDailyUpdate__c, Date.today().day());
        System.assertEquals(testAccts[9].LastDailyUpdate__c, Date.today().day());
        System.assertEquals(testAccts[10].LastDailyUpdate__c, Date.today().day());
        System.assertEquals(testAccts[11].LastDailyUpdate__c, Date.today().day());
        System.assertEquals(testAccts[12].LastDailyUpdate__c, Date.today().day());
        System.assertEquals(testAccts[13].LastDailyUpdate__c, Date.today().day());
        System.assertEquals(testAccts[14].LastDailyUpdate__c, Date.today().day());
    }
}