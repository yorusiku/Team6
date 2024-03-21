public with sharing class SalesProductTriggerHandler {
    // 판매된제품 입력되고 나서 고객주문제품에  Is_SaleProduct_Created__c true로 바꿔주어서 중복된 등록을 막고자하는 메서드 
    public static void updateIsSalesProductCheckedToTrue(List<Sales_Product__c> salesProducts){
        Set<String> orderCode = new Set<String>();
        List<contact_Products__c> contactProductsToUpdate = new List<Contact_Products__c>();
        
        for(sales_Product__c pc : [SELECT Id, Contact_Products__r.Order_Code__c FROM Sales_Product__c WHERE Id IN :salesProducts]){
            orderCode.add(pc.Contact_Products__r.Order_Code__c);
        }

        for(contact_Products__c cp : [SELECT Id, Order_Code__c, Is_SaleProduct_Created__c
                                      FROM Contact_Products__c 
                                      WHERE Order_Code__c IN :orderCode]){
            cp.Is_SaleProduct_Created__c = true;
            contactProductsToUpdate.add(cp);
        }

        if(contactProductsToUpdate.size() > 0) {
            update contactProductsToUpdate;
        }
    }
}