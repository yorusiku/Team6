trigger ContactProductTrigger on Contact_Products__c (before insert,before update, after insert) {
    if (Trigger.isInsert) {
        if(Trigger.isBefore){
            ContactProductTriggerHandler.UpdatePurchaseStoreAndDateInContact(Trigger.new);
        }else if (Trigger.isAfter){
            ContactProductTriggerHandler.insertAndUpdateSale(Trigger.new);
            ContactProductTriggerHandler.UpdateAccountSalesInformation(Trigger.new);
        }
    }

    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            ContactProductTriggerHandler.UpdatePurchaseStoreAndDateInContact(Trigger.new);
        }else if(Trigger.isAfter){
            ContactProductTriggerHandler.UpdateAccountSalesInformation(Trigger.new);
        }
    }

    if(Trigger.isDelete){
        //if(Trigger.isBefore){

        //}else if(Trigger.isAfter){
           
        //}
    }
}