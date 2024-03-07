trigger SalesProductTrigger on Sales_Product__c (after insert, after update) {
  if(Trigger.isAfter)
      if(Trigger.isInsert){
        //SalesProductTriggerHandler.updateSerialNumbers(Trigger.new);
      }
  }




// trigger SalesProductTrigger on Sales_Product__c (before insert) {
//   if (Trigger.isBefore && Trigger.isInsert) {
//       SalesProductController.mapOrderCodeToSerialNumber(Trigger.new);
//   }
// }