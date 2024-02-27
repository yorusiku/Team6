public with sharing class ContactTierBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc){
        String query;
        return Database.getQueryLocator(query);
    }
    
     public void execute(Database.BatchableContext bc, List<Contact> contList){
         for(Contact cont : contList){
                cont.FirstName = 'Batchable';
            }
    
            update contList;
    }

    public void finish(Database.BatchableContext bc){
    
    }

}