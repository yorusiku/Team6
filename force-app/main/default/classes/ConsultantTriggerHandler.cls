public with sharing class ConsultantTriggerHandler {
    public static void updateConsultationCount(List<Consultant__c> triggerNew) {
        Set<Id> contactIds = new Set<Id>();


        for (Consultant__c c : triggerNew) {
            contactIds.add(c.CustomerName__c);
        }
        List<Contact> contactsToUpdate = new List<Contact>();
        Integer consultantCount = [SELECT COUNT() 
                                   FROM Consultant__c 
                                   WHERE CustomerName__c = :contactIds];

        for(Id contactId : contactIds){
            contactsToUpdate.add(new Contact(
                Id = contactId, 
                Consultation_Count__c = consultantCount));
        }

        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }

        ///////////이하 판매점 관련/////////////

        Set<String> storeNames = new Set<String>();
        for (Consultant__c c : triggerNew) {
            storeNames.add(c.Account__c);
        }
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for (String storeName : storeNames) {
            Integer accountConsultantCount = [SELECT COUNT() 
                                              FROM Consultant__c 
                                              WHERE Account__c = :storeName];

            accountsToUpdate.add(new Account(Id = storeName, 
            Total_Consultation_Count__c = accountConsultantCount));
        } ////for문 밖에서 쿼리 처리 할 수 있도록 수정하기
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}