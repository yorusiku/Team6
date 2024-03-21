public with sharing class ConsultantTriggerHandler {
    public static void updateConsultationCount(List<Consultant__c> triggerNew) {
        
        Set<Id> contactIds = new Set<Id>();
        Set<String> storeNames = new Set<String>();
        List<Contact> contactsToUpdate = new List<Contact>();
        List<Account> accountsToUpdate = new List<Account>();
        
        for (Consultant__c c : triggerNew) {
          if (c.CustomerName__c != null) {
              contactIds.add(c.CustomerName__c);
          }
          storeNames.add(c.Account__c);
      }

        Integer consultantCount = [SELECT COUNT() 
                                   FROM Consultant__c 
                                   WHERE CustomerName__c = :contactIds];
        
        for(Id contactId : contactIds){
            //  line 22 ---> contactid 없을 때 삭제 시 오류 있어서 추가, 추후 문제 시 수정
            if(contactId != null) {
                contactsToUpdate.add(new Contact(
                Id = contactId, 
                Consultation_Count__c = consultantCount));
            }
        }
        
        ///////////이하 판매점 관련/////////////

        for (String storeName : storeNames) {            
                Integer accountConsultantCount = [SELECT COUNT() 
                                                  FROM Consultant__c 
                                                  WHERE Account__c = :storeName];
                accountsToUpdate.add(new Account(Id = storeName, 
                Total_Consultation_Count__c = accountConsultantCount));
            } 

        if (!contactsToUpdate.isEmpty() ) {
          update contactsToUpdate;
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}