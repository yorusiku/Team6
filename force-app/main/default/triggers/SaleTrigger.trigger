trigger SaleTrigger on Sale__c (before insert, after insert, before update) {
    if(Trigger.isInsert) {
        if(Trigger.isBefore){
            SaleTriggerHandler.updateCustomerType(Trigger.new);
        }
        if(Trigger.isAfter){
            SaleTriggerHandler.updateContactProductSalesId(Trigger.new);
        }
    }

    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            SaleTriggerHandler.updateCustomerType(Trigger.new);
            SaleTriggerHandler.createRefundAndUpdateStatusToRefunded(Trigger.new);
        }
    }
}