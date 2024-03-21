trigger SaleTrigger on Sale__c (before insert, after insert, before update) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            SaleTriggerHandler.updateContactProductSalesId(Trigger.new);
            //SaleTriggerHandler.insertSalesProduct(Trigger.new);
        }
    }

    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            SaleTriggerHandler.updateCustomerTypeToPurchase(Trigger.new);
            SaleTriggerHandler.createRefundAndUpdateStatusToRefunded(Trigger.new);
        }
        if(Trigger.isInsert){
            SaleTriggerHandler.updateCustomerTypeToPurchase(Trigger.new);
        }
    }
}