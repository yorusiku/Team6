@isTest
private class ContactTierBatchSchedularTest {

    /**
    * contactTierBatchSchedular 테스트 
    */
    @isTest
    private static void contactTierBatchSchedularTest() {        
        Test.startTest();
        ContactTierBatchSchedular cbs = new ContactTierBatchSchedular ();   
        String chron = '0 0 0 * * ?';
        system.schedule('contactTierBatchSchedularTest', chron, cbs);
        Test.stopTest();
   }
}