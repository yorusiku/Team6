public with sharing class RefundTriggerHandler {
    /**
    * 환불 레코드가 만들어졌을 때 고객유형을 업데이트 하는 method
    */
    public static void updateCustomerTypeToConsultation(List<Refund__c> RefundList) {
        Set<Id> contactIds = new Set<Id>();
        Set<Id> saleIds = new Set<Id>();
        List<Contact> contactToUpdate = new List<Contact>();
        

        for(Refund__c re : [SELECT Id, Name, Sale__r.Customer__c FROM Refund__c WHERE Id IN :RefundList]){
            contactIds.add(re.Sale__r.Customer__c);
            System.debug(re.Sale__r.Customer__c);
            saleIds.add(re.Sale__c);
        }


       List<Sale__c> saleListForCompare = [SELECT Id, Customer__c, Is_Refund__c 
                                           FROM Sale__c 
                                           WHERE Customer__c IN :contactIds];

       List<Refund__c> refundListForCompare = [SELECT Id, Sale__c 
                                               FROM Refund__c 
                                               WHERE Sale__c IN: saleIds];

        
        Integer saleCount = saleListForCompare.size();
        Integer refundCount = refundListForCompare .size();
        Integer resultCount = saleCount - refundCount;

         for(Contact con : [SELECT Id, Name, Type__c, Total_Purchase_Amount__c 
                               FROM Contact
                               WHERE RecordTypeId = :Constants.CUSTOMER_RECORD_TYPE_ID
                               AND Id IN :contactIds]){              
            // 판매레코드에 환불이 체크되어 있고, 고객유형이 구매고 구매와 환불 레코드가 같으면(구매없으면) 상담으로 전환                    
            if(resultCount == 0 && con.Type__c == Constants.CONTACT_TYPE_PURCHASE){
                con.Type__c = Constants.CONTACT_TYPE_COUNSELING;
                contactToUpdate.add(con);
            }
        }

        if(contactToUpdate.size() > 0) {
            update contactToUpdate;
        }
    }
}