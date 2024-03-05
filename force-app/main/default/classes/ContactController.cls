public with sharing class ContactController {
    
    /**
    * 모든 구매유형 고객들을 불러오는 method 
    */
    @AuraEnabled(cacheable=true)
    public static List<Contact> getPurchaseCustomers() {
        return [SELECT Id, Name 
                FROM Contact
                WHERE Type__c = :Constants.CONTACT_TYPE_PURCHASE
                WITH SECURITY_ENFORCED
                ORDER BY Name];
    }

}