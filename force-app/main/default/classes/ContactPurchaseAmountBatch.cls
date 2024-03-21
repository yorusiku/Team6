/**
    * 고객들 구매한 금액을 관리하는 batch class 
*/
public with sharing class ContactPurchaseAmountBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc){
        String contactType = Constants.CONTACT_TYPE_PURCHASE;
        String query = 'SELECT Id, Name, Customer_Tier__c, Purchase_In_Recent_90Days__c, Total_Purchase_Amount__c, Total_Purchase_of_General_Devices__c, Total_Purchase_of_Laptops__c, List_of_purchased_items__c, Due_Date_90Days__c, Latest_Purchase_Date__c FROM Contact WHERE RecordTypeId = \'' + Constants.CUSTOMER_RECORD_TYPE_ID + '\'';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Contact> contactList){
        List<Contact> contactListToUpdate = new List<Contact>();
        Map<String,Integer> totalAmountMap = new Map<String,Integer>();

        // 최근 구매일이 90일안에 들어오는 경우 
        for(Contact con : contactList){
            if(con.Purchase_In_Recent_90Days__c){
                totalAmountMap = ContactProductController.getCustomerTotalAmount(con);

                con.Total_Purchase_Amount__c = totalAmountMap.get(Constants.TOTAL_CUSTOMER_PURCHASE);
                con.Total_Purchase_of_Laptops__c = totalAmountMap.get(Constants.TOTAL_NOTEBOOK_PURCHASE);
                con.Total_Purchase_of_General_Devices__c = totalAmountMap.get(Constants.TOTAL_GENERAL_DEVICE_PURCHASE);
  
                contactListToUpdate.add(con);
                // 최근 구매일이 90일안에 들어왔으나 구매값이 null인 경우 
                if(con.Total_Purchase_Amount__c == null){
                    con.Total_Purchase_Amount__c = 0;
                    con.Total_Purchase_of_Laptops__c = 0;
                    con.Total_Purchase_of_General_Devices__c = 0;
                    contactListToUpdate.add(con);
                }
            
            // 최근 구매일이 90일안에 들어오지 않는 경우 
            }else if(!con.Purchase_In_Recent_90Days__c){
                con.Total_Purchase_Amount__c = 0;
                con.Total_Purchase_of_Laptops__c = 0;
                con.Total_Purchase_of_General_Devices__c = 0;
                contactListToUpdate.add(con);
            }
        }

        if (!contactListToUpdate.isEmpty()) {
            update contactListToUpdate;
        }
    }

    public void finish(Database.BatchableContext bc){
    
    }
}