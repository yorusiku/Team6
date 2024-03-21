public with sharing class SalesProductController {

    //고객별 판매된 제품들을 불러오는 method 
    @AuraEnabled(cacheable=true)
    public static List<Sales_Product__c> getSaleProducts(String contactName) {
        return [SELECT Id, Name, Product_Name_Text__c, Status__c, Serial_Number__c, Image_URL__c, Contact__c
                FROM Sales_Product__c
                WHERE Contact__c = :contactName
                AND Status__C = :Constants.SALES_PRODUCT_STATUS_PURCHASED
                ORDER BY CreatedDate desc];
    }
}