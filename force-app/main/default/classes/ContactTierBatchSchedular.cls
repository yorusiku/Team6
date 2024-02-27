global class ContactTierBatchSchedular implements System.Schedulable {
    
    global void execute(SchedulableContext sc) {
        ContactTierBatch cb = new ContactTierBatch(); 
        Database.executeBatch(cb);
     }
}