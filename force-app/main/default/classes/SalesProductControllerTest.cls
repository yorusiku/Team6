@isTest
private class SalesProductControllerTest {
    @isTest
    public static void testGetSaleProducts() {
        List<Sales_Product__c> testSalesProdcuts = TestDataFactory.createSalesProducts(1);

        String contactName;

        List<Contact> contactList = [SELECT Id, Name FROM Contact];

        contactName = contactList[0].Name;

        Test.startTest();
        testSalesProdcuts = SalesProductController.getSaleProducts(contactName);
        Test.stopTest();

        List<Sales_Product__c> salesProducts = [SELECT Id, Name, Product_Name_Text__c, Status__c, Serial_Number__c, Image_URL__c, Contact__c
                                                FROM Sales_Product__c]; 

        System.assertEquals(testSalesProdcuts.size(), salesProducts.size(), 'Expected number of sales products does not match actual number.');
        System.assertEquals(testSalesProdcuts[0].Id, salesProducts[0].Id, 'Sales product Id mismatch at index ');
    }
}