trigger RefundTrigger on Refund__c (after insert) {
    if (Trigger.isInsert) {
        if(Trigger.isAfter){
            RefundTriggerHandler.updateCustomerTypeToConsultation(Trigger.new);
        }
    }
}