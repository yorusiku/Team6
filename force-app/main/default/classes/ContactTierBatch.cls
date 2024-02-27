/**
    * 고객들의 등급을 구매금액에 맞게 업데이트 해주는 class 
  */
public with sharing class ContactTierBatch implements Database.Batchable<sObject> {
    
    /**
    * 레코드타입이 고객인 Contact들 하는 쿼리
    */
    public Database.QueryLocator start(Database.BatchableContext bc){
        String contactType = Constants.CONTACT_TYPE_PURCHASE;
        String query = 'SELECT Id, Name, Customer_Tier__c, Purchase_In_Recent_90Days__c, Total_Purchase_Amount__c FROM Contact WHERE RecordTypeId = \'' + Constants.CustomerRecordTypeId + '\'';
        return Database.getQueryLocator(query);
    }
    
       
    /**
    * 최근 구매일이 90일안에 들어오는 경우와 안들어올 경우  
    * A등급(500만원 이상), B등급(200만원 이상), C등급(200만원 미만), D등급(미구매)
    */
    public void execute(Database.BatchableContext bc, List<Contact> contactList){
        List<Contact>contactListToUpdate = new List<Contact>();
        
        Tier__c A = TierController.assignTier(Constants.A_TIER);
        Tier__c B = TierController.assignTier(Constants.B_TIER);
        Tier__c C = TierController.assignTier(Constants.C_TIER);
        Tier__c D = TierController.assignTier(Constants.D_TIER);

        for(Contact con : contactList){
            if(con.Purchase_In_Recent_90Days__c){
                if(con.Total_Purchase_Amount__c >= A.Minimum_Purchase__c){
                    con.Customer_Tier__c = A.Id;
                    contactListToUpdate.add(con);
                }else if (con.Total_Purchase_Amount__c > B.Minimum_Purchase__c && con.Total_Purchase_Amount__c < B.Maximum_Purchase__c){
                    con.Customer_Tier__c = B.Id;
                    contactListToUpdate.add(con);
                }else if (con.Total_Purchase_Amount__c > C.Minimum_Purchase__c && con.Total_Purchase_Amount__c < C.Maximum_Purchase__c ){
                    con.Customer_Tier__c = C.Id;
                    contactListToUpdate.add(con);
                }else{
                    con.Customer_Tier__c = D.Id;
                    contactListToUpdate.add(con);
                }
            }else if(!con.Purchase_In_Recent_90Days__c){
                if(con.Total_Purchase_Amount__c == 0 || con.Total_Purchase_Amount__c == null){
                    con.Customer_Tier__c = D.Id;
                    contactListToUpdate.add(con);
                }
            }
        }
        
        if (!contactListToUpdate.isEmpty()) {
            update contactListToUpdate;
        }
    }

    public void finish(Database.BatchableContext bc){
    
    }
}