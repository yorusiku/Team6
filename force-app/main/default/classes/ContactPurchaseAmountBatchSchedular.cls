/**
    *  ContactPurchaseAmountBatch를 실행시켜주는 Schedular class
  */
global class ContactPurchaseAmountBatchSchedular implements System.Schedulable{
    global void execute(SchedulableContext sc) {
        ContactPurchaseAmountBatch cpb = new ContactPurchaseAmountBatch(); 
        Database.executeBatch(cpb);
     }
}