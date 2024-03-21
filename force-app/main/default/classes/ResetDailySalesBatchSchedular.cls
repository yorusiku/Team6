global class ResetDailySalesBatchSchedular implements System.Schedulable{
        global void execute(SchedulableContext SC) {
            ResetDailySalesBatch batchJob = new ResetDailySalesBatch();
            Database.executeBatch(batchJob);
        }
}