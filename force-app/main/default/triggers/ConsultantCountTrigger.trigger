trigger ConsultantCountTrigger on Consultant__c (after insert, after update, after delete) {
  Set<Id> contactIds = new Set<Id>();
  
  if (Trigger.isInsert || Trigger.isUpdate) {
      for (Consultant__c c : Trigger.new) {
          contactIds.add(c.CustomerName__c);
      }
  }
  
  if (Trigger.isDelete) {
      for (Consultant__c c : Trigger.old) {
          contactIds.add(c.CustomerName__c);
      }
  }

  // ContactId로 Consultation Count 업데이트
  for (Id contactId : contactIds) {
      ConsultantCountController.updateConsultationCount(contactId);
  }
}