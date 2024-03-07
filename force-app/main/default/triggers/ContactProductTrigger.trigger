trigger ContactProductTrigger on Contact_Products__c (before insert,before update, after insert, after update) {
    if (Trigger.isInsert) {
        if(Trigger.isBefore){
            ContactProductTriggerHandler.UpdatePurchaseStoreAndDateInContact(Trigger.new);
        }else if (Trigger.isAfter){
            ContactProductTriggerHandler.insertAndUpdateSale(Trigger.new);
            ContactProductTriggerHandler.InsertAccountSalesInformationSale(Trigger.new);
        }
    }
    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            ContactProductTriggerHandler.UpdatePurchaseStoreAndDateInContact(Trigger.new);
        }else if(Trigger.isAfter){
            ContactProductTriggerHandler.UpdateAccountSalesInformationRefund(Trigger.new);
        }
    }

    if(Trigger.isDelete){
        //if(Trigger.isBefore){

        //}else if(Trigger.isAfter){
           
        //}
    }
}