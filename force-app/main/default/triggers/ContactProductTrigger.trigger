trigger ContactProductTrigger on Contact_Products__c (before insert,before update, after insert) {
    if (Trigger.isInsert) {
        if(Trigger.isBefore){
            ContactProductTriggerHandler.UpdatePurchaseStoreAndDateInContact(trigger.new);
        }else if (Trigger.isAfter){
            ContactProductTriggerHandler.insertAndUpdateSale(trigger.new);
            ContactProductTriggerHandler.UpdateAccountSalesInformation(trigger.new);
        }
    }

    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            ContactProductTriggerHandler.UpdatePurchaseStoreAndDateInContact(trigger.new);
        }else if(Trigger.isAfter){
            ContactProductTriggerHandler.UpdateAccountSalesInformation(trigger.new);
        }
    }

    if(Trigger.isDelete){
        //if(Trigger.isBefore){

        //}else if(Trigger.isAfter){
           
        //}
    }
}