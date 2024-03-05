@isTest
private class ContactPurchaseAmountBatchSchedularTest {

    
    /**
    * ContactPurchaseAmountBatchSchedular 테스트 
    */
    @isTest
    private static void contactPurchaseAmountBatchSchedularTest() {        
        Test.startTest();
        ContactPurchaseAmountBatchSchedular cpb = new ContactPurchaseAmountBatchSchedular ();   
        String chron = '0 0 0 1 * ?'; 
        system.schedule('ContactPurchaseAmountBatchTest', chron, cpb);
        Test.stopTest();
   }
}