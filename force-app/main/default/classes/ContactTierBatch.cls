/**
    * 고객들의 등급을 구매금액에 맞게 업데이트 해주는 batch class 
  */
public with sharing class ContactTierBatch implements Database.Batchable<sObject> {
    
    /**
    * 레코드타입이 고객인 Contact들 하는 쿼리
    */
    public Database.QueryLocator start(Database.BatchableContext bc){
        String contactType = Constants.CONTACT_TYPE_PURCHASE;
        String query = 'SELECT Id, Name, Customer_Tier__c, Purchase_In_Recent_90Days__c, Total_Purchase_Amount__c FROM Contact WHERE RecordTypeId = \'' + Constants.CUSTOMER_RECORD_TYPE_ID + '\'';
        return Database.getQueryLocator(query);
    }
    
       
    /**
    * 최근 구매일이 90일안에 들어오는 경우와 안들어올 경우  
    * A등급(500만원 이상), B등급(200만원 이상), C등급(200만원 미만), D등급(미구매)
    */
    public void execute(Database.BatchableContext bc, List<Contact> contactList){
        List<Contact>contactListToUpdate = new List<Contact>();
        
        // TierController에서 Name에 따라서 tier을 정해주는 method을 불러와서 A,B,C,D등급 Tier의 값들을 할당해줌.
        Tier__c A = TierController.assignTier(Constants.A_TIER);
        Tier__c B = TierController.assignTier(Constants.B_TIER);
        Tier__c C = TierController.assignTier(Constants.C_TIER);
        Tier__c D = TierController.assignTier(Constants.D_TIER);

        for(Contact con : contactList){
            // 최근 90일에 구매가 있을 경우 
            if(con.Purchase_In_Recent_90Days__c){
                // 고객의 총 구매 금액이 A등급의 최소금액인 500만원 이상일 경우
                if(con.Total_Purchase_Amount__c >= A.Minimum_Purchase__c){
                    con.Customer_Tier__c = A.Id;
                    contactListToUpdate.add(con);
                // 고객의 총 구매 금액이 B등급의 최소금액인 200만원 이상 최대금액인 499만원 이하일 경우
            }else if (con.Total_Purchase_Amount__c >= B.Minimum_Purchase__c && con.Total_Purchase_Amount__c <= B.Maximum_Purchase__c){
                con.Customer_Tier__c = B.Id;
                contactListToUpdate.add(con);
                // 고객의 총 구매 금액이 C등급의 최소금액인 1만원 이상 최대금액인 199만원 이하일 경우
                }else if (con.Total_Purchase_Amount__c >= C.Minimum_Purchase__c && con.Total_Purchase_Amount__c <= C.Maximum_Purchase__c ){
                    con.Customer_Tier__c = C.Id;
                    contactListToUpdate.add(con);
                }else{
                // 기타 D 등급
                    con.Customer_Tier__c = D.Id;
                    contactListToUpdate.add(con);
                }
                // 최근 90일에 구매가 없을 경우 
            }else if(!con.Purchase_In_Recent_90Days__c){
                // 총 구매금액이 0 이거나 총 구매 금액이 없을 경우 D 등급
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