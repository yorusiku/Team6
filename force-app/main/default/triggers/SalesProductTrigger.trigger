trigger SalesProductTrigger on Sales_Product__c (before insert , after insert) {
  if (Trigger.isInsert) {
      SalesProductController.updateSerialNumbers(Trigger.new);
  }
}