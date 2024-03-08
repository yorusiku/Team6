trigger SalesProductTrigger on Sales_Product__c (after insert, after update, before insert){
  if(Trigger.isAfter)
     if(Trigger.isInsert){
        SalesProductTriggerHandler.updateIsSalesProductCheckedToTrue(Trigger.new);
        //SalesProductTriggerHandler.updateSerialNumbers(Trigger.new);
      }
  if(Trigger.isBefore){
    if(Trigger.isInsert){
      
    }
  }
}




// trigger SalesProductTrigger on Sales_Product__c (before insert) {
//   if (Trigger.isBefore && Trigger.isInsert) {
//       SalesProductController.mapOrderCodeToSerialNumber(Trigger.new);
//   }
// }