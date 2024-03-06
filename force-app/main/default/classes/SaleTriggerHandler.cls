public with sharing class SaleTriggerHandler {
    /**
    * 판매 레코드가 만들어졌을 때 고객유형을 업데이트 하는 method
    */
    public static void updateCustomerTypeToPurchase(List<Sale__c> saleList) {
        Set<Id> contactIds = new Set<Id>();
        Set<Id> saleIds = new Set<Id>();
        List<Contact>contactToUpdate = new List<Contact>();
        

        for(Sale__c sc : saleList){
            contactIds.add(sc.Customer__c);
            saleIds.add(sc.Id);
        }

        for(Sale__c sc : saleList){
            for(Contact con : [SELECT Id, Name, Type__c, Total_Purchase_Amount__c 
                               FROM Contact
                               WHERE RecordTypeId = :Constants.CUSTOMER_RECORD_TYPE_ID
                               AND Id IN :contactIds]){  
                                
                // 판매레코드에 환불이 체크되어 있지 않을때, 고객유형이 상담이고 구매금액이 있으면 구매로 전환                 
                if(!sc.Is_Refund__c){
                    if(con.Type__c == Constants.CONTACT_TYPE_COUNSELING && 
                        con.Total_Purchase_Amount__c != null){
                        con.Type__c = Constants.CONTACT_TYPE_PURCHASE;
                        contactToUpdate.add(con);
                    }
                } 
            }
        }

        if(contactToUpdate.size() > 0) {
            update contactToUpdate;
        }
    }

    /**
    * 고객제품주문 Sale__c를 업데이트하는 method
    */
    public static void updateContactProductSalesId(List<Sale__c> saleList) {
        Id salesId;
        List<Contact_Products__c> contactProductToUpdate = new List<Contact_Products__c>();
        Set<String> OrderCode = new Set<String>();
        

        for(Sale__c sc : saleList){
            OrderCode.add((sc.Sales_Code__c).substringAfter('S'));
            salesId = sc.Id;
        }

        for(Contact_Products__c cp : [SELECT Id, Name, Sale__c
                                      FROM Contact_Products__c  
                                      WHERE Order_Code__c IN :OrderCode]){                            
            if(cp.Sale__c == null){
                cp.Sale__c = salesId;
                contactProductToUpdate.add(cp);
            }
        }

        if(contactProductToUpdate.size() > 0) {
            update contactProductToUpdate;
        }
    }

    // Refund 생기는 시점에 따라 수정 필요
    // Sales -> Sales Product 이후 ?
    // 고객제품 / 판매 / 판매된 제품에도 상태 업데이트/
    public static void createRefundAndUpdateStatusToRefunded(List<Sale__c> saleList){
        Boolean firstrun = true;

        List<Refund__c> refundListToInsert = new List <Refund__c>();
        List<Contact_Products__c> ContactProductsToUpdate = new List <Contact_Products__c>();
        Set<Id> saleIds = new Set<Id>(); 

        for(Sale__c sc : saleList){
            saleIds.add(sc.Id);
        }
        
        for(Contact_Products__c cp : [SELECT Id, Name, Sale__c, Status__c
                                      FROM Contact_Products__c  
                                      WHERE Sale__c IN :saleIds ]){   
            for(sale__c sc : saleList) {
                if(sc.Is_Refund__c){
                    if(cp.Status__c == Constants.CONTACT_PRODUCT_STATUS_PURCHASED){
                    cp.Status__c = Constants.CONTACT_PRODUCT_STATUS_REFUNDED;
                        ContactProductsToUpdate.add(cp);
                    }
                if(firstrun){
                    Refund__c re = new Refund__c();
                    re.Sale__c = sc.Id;
                    re.Date_Refund__c = Date.today();
                    // 판매된 제품도 추가해야함
                    refundListToInsert.add(re);
                    }
                    firstrun = false; 
                }
           }   
        }   

        if(refundListToInsert.size() > 0) {
            insert refundListToInsert;
        }

        if(ContactProductsToUpdate.size() > 0) {
            update ContactProductsToUpdate;
        }
    }
}