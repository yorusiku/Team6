public with sharing class ConsultantTriggerHandler {
    public static void updateConsultationCount(List<Consultant__c> triggerNew) {
        Set<Id> contactIds = new Set<Id>();

        for (Consultant__c c : triggerNew) {
            contactIds.add(c.CustomerName__c);
        }
        // 상담 횟수 업데이트
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
    }
}