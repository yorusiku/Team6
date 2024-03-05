@isTest
private class ProductControllerTest {

    /**
    * ProductController GetProducts() 테스트
    */
    @isTest
    private static void testGetProducts(){
        List<Product2> testProducts = TestDataFactory.createProducts(2, Constants.NOTEBOOK, 2000000);
        Test.startTest();
        List<Product2> pds = ProductController.getProducts();
        Test.stopTest();

        List<Product2> testProductsOrder = [SELECT Id, Name, ProductCode, Family, Price__c, Image__c
                                            FROM Product2
                                            ORDER BY Family];

        for (Integer i = 0; i < testProductsOrder.size(); i++) {
            System.assertEquals(pds[i].Name, testProductsOrder[i].Name, 'Product names do not match');
            System.assertEquals(pds[i].ProductCode, testProductsOrder[i].ProductCode, 'ProductCode do not match');
            System.assertEquals(pds[i].Family, testProductsOrder[i].Family, 'Product family do not match');
            System.assertEquals(pds[i].Price__c, testProductsOrder[i].Price__c, 'Product family do not match');
            System.assertEquals(pds[i].Image__c, testProductsOrder[i].Image__c, 'Product Image do not match');
        }
    } 

    /**
    * ProductController GetLaptopProducts 테스트
    */
    @isTest
    private static void testGetLaptopProducts(){
        List<Product2> testProducts = TestDataFactory.createProducts(2, Constants.NOTEBOOK, 2000000);

        Test.startTest();
        List<Product2> pds = ProductController.getLaptopProducts();
        Test.stopTest();
        
        for (Integer i = 0; i < testProducts.size(); i++) {
            System.assertEquals(pds[i].Name, testProducts[i].Name, 'Product names do not match');
            System.assertEquals(pds[i].ProductCode, testProducts[i].ProductCode, 'ProductCode do not match');
            System.assertEquals(pds[i].Family, testProducts[i].Family, 'Product family do not match');
            System.assertEquals(pds[i].Price__c, testProducts[i].Price__c, 'Product family do not match');
            System.assertEquals(pds[i].Image__c, testProducts[i].Image__c, 'Product Image do not match');
        }
    } 

    /**
    * ProductController GetGeneralDeviceProducts() 테스트
    */
    @isTest
    private static void testGetGeneralDeviceProducts(){
        List<Product2> testProducts = TestDataFactory.createProducts(2, Constants.GENENRAL_DEVICE, 2000000);

        Test.startTest();
        List<Product2> pds = ProductController.getGeneralDeviceProducts();
        Test.stopTest();
        
        for (Integer i = 0; i < testProducts.size(); i++) {
            System.assertEquals(pds[i].Name, testProducts[i].Name, 'Product names do not match');
            System.assertEquals(pds[i].ProductCode, testProducts[i].ProductCode, 'ProductCode do not match');
            System.assertEquals(pds[i].Family, testProducts[i].Family, 'Product family do not match');
            System.assertEquals(pds[i].Price__c, testProducts[i].Price__c, 'Product family do not match');
            System.assertEquals(pds[i].Image__c, testProducts[i].Image__c, 'Product Image do not match');
        }
    } 
}