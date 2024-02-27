trigger ConsultantTrigger on Consultant__c (after insert, after update, after delete) {
    if(Trigger.isAfter) {  
        if (Trigger.isInsert || Trigger.isUpdate) {
          ConsultantTriggerHandler.updateConsultationCount(Trigger.new);
        }
        
        if (Trigger.isDelete) {
          ConsultantTriggerHandler.updateConsultationCount(Trigger.old);
      }
    }
}