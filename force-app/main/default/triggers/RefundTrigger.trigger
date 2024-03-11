trigger RefundTrigger on Refund__c (after insert) {
    if(Trigger.isAfter){
        if (Trigger.isInsert) {
            RefundTriggerHandler.updateCustomerTypeToConsultation(Trigger.new);
        }
    }
}