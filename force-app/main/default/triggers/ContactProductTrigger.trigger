trigger ContactProductTrigger on Contact_Products__c (before insert,before update, after insert, after update) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            ContactProductTriggerHandler.UpdatePurchaseStoreAndDateInContact(Trigger.new);
        }
        if(Trigger.isUpdate){
            ContactProductTriggerHandler.UpdatePurchaseStoreAndDateInContact(Trigger.new);
        }
    }

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            ContactProductTriggerHandler.insertAndUpdateSale(Trigger.new);
            ContactProductTriggerHandler.InsertAccountSalesInformationSale(Trigger.new);
        }
        if(Trigger.isUpdate){
            ContactProductTriggerHandler.UpdateAccountSalesInformationRefund(Trigger.new);
        }
    }
}