public with sharing class ContactController {
    
    /**
    * 모든 구매유형 고객들을 불러오는 method 
    */
    @AuraEnabled(cacheable=true)
    public static List<Contact> getPurchaseCustomers() {
        return [SELECT Id, Name 
                FROM Contact
                WHERE Type__c = :Constants.PURCHASE
                WITH SECURITY_ENFORCED
                ORDER BY Name];
    }

    /**
    * 고객이 주문한 제품을 추가하는 method 
    */
    @AuraEnabled
    public static void addContactProducts(String contactId, String accountId, 
                                          String laptopId, Integer laptopQuantity,
                                          String generalDeviceId, Integer generalDeviceQuantity, 
                                          Datetime orderDateTime, Integer discount) {
        List<Contact_Products__c> laptopProducts = new List<Contact_Products__c>();
        List<Contact_Products__c> generalDeviceProducts = new List<Contact_Products__c>();
            // 노트북 제품만 구매할 경우 
                // 추가적인 노트북 제품을 구매할 경우                               
        if(laptopQuantity > 0 && generalDeviceQuantity == 0){
            laptopProducts = newContactProduct(laptopQuantity,contactId,accountId,laptopId,discount,orderDateTime); 
                // 주변 기기만 구매할 경우
                // 추가적인 주변기기를 구매할 경우
        }else if(laptopQuantity == 0 && generalDeviceQuantity > 0){
            generalDeviceProducts = newContactProduct(generalDeviceQuantity,contactId,accountId,generalDeviceId,discount,orderDateTime); 
                // 노트북 및 주변 기기 모두다 구매할 경우 
                // 서로다른 개수의 노트북 및 주변기기를 구매할 경우
        }else if(laptopQuantity > 0 && generalDeviceQuantity > 0){
            laptopProducts = newContactProduct(laptopQuantity,contactId,accountId,laptopId,discount,orderDateTime); 
            generalDeviceProducts = newContactProduct(generalDeviceQuantity,contactId,accountId,generalDeviceId,discount,orderDateTime); 
        }
        try{
            if(!laptopProducts.isEmpty()){
                insert laptopProducts;
            }

            if(!generalDeviceProducts.isEmpty()){
                insert generalDeviceProducts;
            }
        } catch (Exception e) {
            throw new AuraHandledException('An error occurred while creating Contact Products: ' + e.getMessage());
        }
    }


    
    /**
    * 고객주문제품 record를 List에 생성해서 return하는 method 
    */ 
    public static List<Contact_Products__c> newContactProduct(Integer recordSize,
                                         String contactId, String accountId,
                                         String productTypeId, Integer discount, 
                                         Datetime orderDateTime){
        List<Contact_Products__c> contactProductsToInsert = new List<Contact_Products__c>(); 
        
        for (Integer i = 0; i < recordSize; i++) {
            contactProductsToInsert.add(new Contact_Products__c(
                Contact__c = contactId,
                Account__c = accountId,
                Product__c = productTypeId,
                Discount_Percent_c__c = discount,
                Order_Date_Time__c = orderDateTime
            ));
        }
        return contactProductsToInsert;
    }
}