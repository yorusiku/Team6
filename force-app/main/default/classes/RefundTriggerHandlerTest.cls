@isTest
private class RefundTriggerHandlerTest {
    @isTest
    private static void testUpdateCustomerTypeToConsultation(){
        List<Contact_Products__c> testContactProducts = TestDataFactory.createContactProducts(1, 5, Datetime.now());
        List<Sale__c> testSaleList = [SELECT Id, Customer__c, Is_Refund__c FROM Sale__c];

        Test.startTest();
        testSaleList[0].Is_Refund__c = true;
        update testSaleList;
        Test.stopTest();

        List<Refund__c> refundList = [SELECT Id, Sale__c, Date_Refund__c FROM Refund__c];

        for(Refund__c re : refundList){
            System.assertEquals(testSaleList[0].Id, re.Sale__c, 'Incorrect refund sale__c.');
            System.assertEquals(Date.today(), re.Date_Refund__c, 'Incorrect Date refund.');
        }
    }
}