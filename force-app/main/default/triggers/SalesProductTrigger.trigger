trigger SalesProductTrigger on Sales_Product__c (after insert){
  if(Trigger.isAfter)
     if(Trigger.isInsert){
        SalesProductTriggerHandler.updateIsSalesProductCheckedToTrue(Trigger.new);
      }
}