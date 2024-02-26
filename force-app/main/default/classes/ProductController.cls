public with sharing class ProductController {
    
    /**
    * 모든 제품들을 불러오는 method 
    */
    @AuraEnabled(cacheable=true)
    public static List<Product2> getProducts() {
        return [SELECT Id, Name, ProductCode, Family, Price__c, Image__c
                FROM Product2
                WITH SECURITY_ENFORCED
                ORDER BY Name];
    }

    /**
    * 모든 노트북 제품들을 불러오는 method 
    */
    @AuraEnabled(cacheable=true)
    public static List<Product2> getLaptopProducts() {
        return [SELECT Id, Name, ProductCode, Family, Price__c, Image__c
                FROM Product2
                WHERE Family = :Constants.NOTEBOOK 
                WITH SECURITY_ENFORCED
                ORDER BY Name];
    }
    
    /**
    * 모든 주변기기 제품들을 불러오는 method 
    */
    @AuraEnabled(cacheable=true)
    public static List<Product2> getGeneralDeviceProducts() {
        return [SELECT Id, Name, ProductCode, Family, Price__c, Image__c
                FROM Product2
                WHERE Family = :Constants.GENENRAL_DEVICE  
                WITH SECURITY_ENFORCED
                ORDER BY Name];
    }
}