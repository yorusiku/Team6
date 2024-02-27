trigger ContactProductTrigger on Contact_Products__c (before insert,before update) {
    if (Trigger.isInsert) {
        if(Trigger.isBefore){
            ContactProductTriggerHandler.BeforeInsertContactProductTriggerHandler(trigger.new);
        }else if (Trigger.isAfter){

        }
    }

    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            ContactProductTriggerHandler.BeforeInsertContactProductTriggerHandler(trigger.new);
        }else if(Trigger.isAfter){

        }
    }

    if(Trigger.isDelete){
        if(Trigger.isBefore){

        }else if(Trigger.isAfter){
           
        }
    }
}