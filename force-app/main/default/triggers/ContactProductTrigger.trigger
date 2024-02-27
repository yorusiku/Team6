// REQ-11
trigger ContactProductTrigger on ContactProduct (before insert,before update) {
    if (Trigger.isBefore) {
        if(Trigger.isInsert) {
            ContactProductTriggerHandler.BeforeInsertContactProductTriggerHandler();
        }
        if(Trigger.isUpdate){
            ContactProductTriggerHandler.BeforeUpdateContactProductTriggerHandler();
        }
    }
}