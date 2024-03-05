@isTest
private class ContactProductControllerTest {
    @isTest
    private static void testaddContactProducts(){
        List<Contact_Products__c> testContactProducts = TestDataFactory.createContactProducts(1, 5, Datetime.now());
        Id testAccountId;
        Id testContactId;
        Id testProductTypeId;
        Integer recordSize;
        Datetime testorderDate;
        String testOrderCode;

        testAccountId = testContactProducts[0].Account__c; 
        testContactId = testContactProducts[0].Contact__c;
        testProductTypeId = testContactProducts[0].Product__c;
        recordSize = testContactProducts.size();
        testorderDate = testContactProducts[0].Order_Date_Time__c;
        //testOrderCode = testContactProducts[0].Order_Code__c;

        Test.startTest();
        ContactProductController.addContactProducts(testContactId, testAccountId, testProductTypeId, 1, '', 0 , testorderDate, 5);
        Test.stopTest();

        List<Contact_Products__c> cps = [SELECT Id, Name, Contact__c, Account__c, Product__c, Discount_Percent__c, Order_Date_Time__c, Order_Code__c
                                         FROM Contact_Products__c];

        for(Contact_Products__c cp : cps) {
            //System.assertEquals(recordSize, cps.size(), 'Incorrect number of records created.');
            System.assertEquals(testContactId, cp.Contact__c, 'Incorrect contact ID.');
            System.assertEquals(testAccountId, cp.Account__c, 'Incorrect account ID.');
            System.assertEquals(testProductTypeId, cp.Product__c, 'Incorrect product type ID.');
            System.assertEquals(5, cp.Discount_Percent__c, 'Incorrect discount percentage.');
            System.assertEquals(testorderDate, cp.Order_Date_Time__c, 'Incorrect order date time.');
            //System.assertEquals(testOrderCode, cp.Order_Code__c, 'Incorrect order code.');
        }
    }


    /**
    * ContactProductController newContactProduct() 테스트
    */
    @isTest
    private static void testnewContactProduct(){
        List<Contact_Products__c> testContactProducts = TestDataFactory.createContactProducts(1, 5, Datetime.now());
        Id testAccountId;
        Id testContactId;
        Id testProductTypeId;
        Integer recordSize;
        Datetime testorderDate;
        String testOrderCode;

        testAccountId = testContactProducts[0].Account__c; 
        testContactId = testContactProducts[0].Contact__c;
        testProductTypeId = testContactProducts[0].Product__c;
        recordSize = testContactProducts.size();
        testorderDate = testContactProducts[0].Order_Date_Time__c;
        testOrderCode = testContactProducts[0].Order_Code__c;

        Test.startTest();
        List<Contact_Products__c> cps = ContactProductController.newContactProduct(recordSize, testContactId, testAccountId, testProductTypeId, 5, testorderDate);
        Test.stopTest();

        System.assertEquals(recordSize, cps.size(), 'Incorrect number of records created.');
        for(Contact_Products__c cp : cps) {
            System.assertEquals(testContactId, cp.Contact__c, 'Incorrect contact ID.');
            System.assertEquals(testAccountId, cp.Account__c, 'Incorrect account ID.');
            System.assertEquals(testProductTypeId, cp.Product__c, 'Incorrect product type ID.');
            System.assertEquals(5, cp.Discount_Percent__c, 'Incorrect discount percentage.');
            System.assertEquals(testorderDate, cp.Order_Date_Time__c, 'Incorrect order date time.');
            System.assertEquals(testOrderCode, cp.Order_Code__c, 'Incorrect order code.');
        }
    }


    /**
    * ContactProductController getSaleId 테스트
    */
    @isTest
    private static void testGetSalesId(){
        Set<Id> testSalesId = new Set<Id>();
        List<Contact_Products__c> testContactProducts = TestDataFactory.createContactProducts(1, 5, Datetime.now());
        Set<String> testOrderCodes = new Set<String>();

        for(Contact_Products__c cp : testContactProducts){
            testOrderCodes.add('S' + cp.Order_Code__c);
        }

        Test.startTest();
        testSalesId = ContactProductController.getSaleId(testContactProducts);
        Test.stopTest();

        Id testSaleId = null;
        for(Id testsale: testSalesId){
            testSaleId = testsale;
        }

        Id SaleId = null;
        for(Sale__c sale : [SELECT Id FROM Sale__c WHERE Sales_Code__c = :testOrderCodes]){
            SaleId = sale.Id;
        }

        System.assertEquals(SaleId, testSaleId, 'Incorrect SalesId.');
    }

    /**
    * ContactProductController getCustomerTotalPurchase 
    * ContactProductController getCustomerTotalNotebookPurchase 
    * ContactProductController getCustomerTotalGeneralDevicePurchase 
    * ContactProductController getCustomerPurchaseItemList 
    * ContactProductController ContactPurchaseAmountBatch 테스트
    */
    @isTest
    private static void testGetCustomerPurchase(){
        List<Contact_Products__c> testContactProducts = TestDataFactory.createContactProducts(1, 5, Datetime.now());
        Integer testTotalCustomerPurchase = 0;
        Integer testTotalNoteBookPurchase = 0;
        Integer testTotalGeneralDevicePurchase = 0;
        String testProductName = '';

        Contact testContact = [SELECT Id, Total_Purchase_Amount__c, Due_Date_90Days__c, Total_Purchase_of_Laptops__c, Total_Purchase_of_General_Devices__c, List_of_purchased_items__c  FROM Contact WHERE Id = :testContactProducts[0].Contact__c LIMIT 1];
        //testContact.Total_Purchase_Amount__c = 1900000;
        //update testContact;

        List<Contact> testContacts = [SELECT Id, Name, Customer_Tier__c, Purchase_In_Recent_90Days__c, Total_Purchase_Amount__c, Total_Purchase_of_General_Devices__c, Total_Purchase_of_Laptops__c, List_of_purchased_items__c, Due_Date_90Days__c, Latest_Purchase_Date__c FROM Contact WHERE RecordTypeId = :Constants.CUSTOMER_RECORD_TYPE_ID];

        testContactProducts = [SELECT Id, Name, Total_Purchase__c, Total_Purchase_of_Laptops__c, Total_Purchase_of_General_Devices__c, 	Product_Name_Text__c 
                               FROM Contact_Products__c];
        System.debug('testContactProducts::' + testContactProducts);

        Test.startTest();
        testTotalCustomerPurchase = ContactProductController.getCustomerTotalPurchase(testContact);
        testTotalNoteBookPurchase = ContactProductController.getCustomerTotalNotebookPurchase(testContact);
        testTotalGeneralDevicePurchase = ContactProductController.getCustomerTotalGeneralDevicePurchase(testContact);
        testProductName = ContactProductController.getCustomerPurchaseItemList(testContact);
        ContactPurchaseAmountBatch batch = new ContactPurchaseAmountBatch();
        Database.QueryLocator queryLocator = batch.start(null);
        batch.execute(null, testContacts);
        batch.finish(null);
        System.debug('testContacts after batch execute::' + testContacts);
        Test.stopTest();
        System.debug('testTotalCustomerPurchase::' + testTotalCustomerPurchase);
        System.debug('testTotalNoteBookPurchase::' + testTotalNoteBookPurchase);
        System.debug('testTotalGeneralDevicePurchase::' + testTotalGeneralDevicePurchase);


        System.assertEquals(testTotalCustomerPurchase, testContacts[0].Total_Purchase_Amount__c, 'Incorrect Total Purchase.');
        System.assertEquals(testTotalNoteBookPurchase, testContacts[0].Total_Purchase_of_Laptops__c, 'Incorrect Total Laptop Purchase.');
        System.assertEquals(testTotalGeneralDevicePurchase, testContacts[0].Total_Purchase_of_General_Devices__c, 'Incorrect Total General Device Purchase.');
        System.assertEquals(testProductName, testContacts[0].List_of_purchased_items__c, 'Incorrect Purchase ITems .');
    }


    /**
    * ContactProductTriggerHandler.insertAndUpdateSale 
    * ContactProductController.getSalesCode 테스트 
    */
    @isTest
    private static void testUpdateSale(){
        List<Contact_Products__c> testContactProducts = TestDataFactory.createContactProducts(3, 5, Datetime.now());
        Set<String> testSalesCode = new Set<String>(); 
        
        testContactProducts = [SELECT Id, Name, 
                                      Total_Purchase__c, Total_Product_Price__c, 
                                      Total_Purchase_of_Laptops__c, Total_Purchase_of_General_Devices__c, 
                                      Product_Name_Text__c, Order_Code__c,
                                      Discount_Amount__c, Discount_Percent__c
                               FROM Contact_Products__c];

        for(Contact_Products__c cp: testContactProducts){
            testSalesCode.add('S'+ cp.Order_Code__c);
        }


        System.debug('testUpdateSale testContactProducts::' + testContactProducts);
        
        Test.startTest();
        testSalesCode = ContactProductController.getSalesCode(testContactProducts); 

        if(!testSalesCode.isEmpty()){
            ContactProductTriggerHandler.insertAndUpdateSale(testContactProducts);
        }
        Test.stopTest();
        
        Set<Id> SaleId = ContactProductController.getSaleId(testContactProducts);
        List<Sale__c> updatedSales = [SELECT Id, List_of_Purchased_Items__c, Total_Price__c, Discount_Value__c, Final_Price__c, Discount_Percent__c
                                        FROM Sale__c WHERE Id IN :SaleId];
        
        Integer testTotalPrice = 0;
        Integer testDiscountAmount = 0;
        Integer testFinalPirce = 0;
        Decimal testDiscontPercent = 0;

        for(Contact_Products__c cp : testContactProducts) {
            testTotalPrice += cp.Total_Product_Price__c.intValue();
            testDiscountAmount += cp.Discount_Amount__c.intValue();
            testFinalPirce += cp.Total_Purchase__c.intValue();
            testDiscontPercent = cp.Discount_Percent__c;
        }
        
        System.assertEquals(testTotalPrice, updatedSales[0].Total_Price__c, 'Incorrect total Price.');
        System.assertEquals(testDiscountAmount, updatedSales[0].Discount_Value__c, 'Incorrect discount Value.');
        System.assertEquals(testFinalPirce, updatedSales[0].Final_Price__c, 'Incorrect final Price.');
        System.assertEquals(testDiscontPercent, updatedSales[0].Discount_Percent__c, 'Incorrect discount percentage.');
    }
}