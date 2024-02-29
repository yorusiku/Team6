/**
    * 고객들 구매한 금액을 관리하는 batch class 
*/
public with sharing class ContactPurchaseAmountBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc){
        String contactType = Constants.CONTACT_TYPE_PURCHASE;
        String query = 'Id, Name, Customer_Tier__c, Purchase_In_Recent_90Days__c, Total_Purchase_Amount__c, Total_Purchase_of_General_Devices__c, Total_Purchase_of_Laptops__c, List_of_purchased_items__c, Due_Date_90Days__c FROM Contact WHERE RecordTypeId = \'' + Constants.CustomerRecordTypeId + '\'';
        return Database.getQueryLocator(query);
    }
    
    /**
    * 최근 구매일이 90일안에 들어오는 경우 
    * 
    */
    public void execute(Database.BatchableContext bc, List<Contact> contactList){
        List<Contact>contactListToUpdate = new List<Contact>();
        
        Integer customerTotalPurchase = ContactProductController.getCustomerTotalPurchase(contactList);
        Integer customerTotalNotebookPurchase = ContactProductController.getCustomerTotalNotebookPurchase(contactList);
        Integer customerTotalGeneralDevicePurchase = ContactProductController.getCustomerTotalGeneralDevicePurchase(contactList);
        String customerPurchasedItems = ContactProductController.getCustomerPurchaseItemList(contactList);
        
        for(Contact con : contactList){
            if(con.Purchase_In_Recent_90Days__c){
                con.Total_Purchase_Amount__c = customerTotalPurchase;
                con.Total_Purchase_of_Laptops__c = customerTotalNotebookPurchase;
                con.Total_Purchase_of_General_Devices__c = customerTotalGeneralDevicePurchase;
                con.List_of_purchased_items__c = customerPurchasedItems;
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