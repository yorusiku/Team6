public with sharing class ContactProductTriggerHandler {
    // REQ-11
    public static void BeforeInsertContactProductTriggerHandler(List<Contact_Products__c> triggerNew) {
        List<Contact> contactProductToUpdate = new List<Contact>(); 
        Set<Id> contactIds = new Set<Id>();
        // Contact_Products__c에서 Contact__c 필드를 추출하여 contactIds 세트에 추가
        for (Contact_Products__c c : triggerNew) {
            contactIds.add(c.Contact__c);
        }
        // Contact에서 고객 제품 주문과 일치하는 id, 이름, 고객 유형, 첫 구매 매장, 최근 구매 매장을 조회해서 contactList에 담아줌
        List<Contact> contactList = [SELECT Id, Name, Type__c, First_Purchase_Store__c, Latest_Purchase_Store__c, Latest_Purchase_Date__c
                                    FROM Contact
                                    WHERE Id IN :contactIds];
    
        Map<Id, Contact_Products__c> contactProductMap = new Map<Id, Contact_Products__c>();
        for (Contact_Products__c cp : triggerNew) {
            contactProductMap.put(cp.Contact__c, cp); // 마지막 Contact_Products__c 레코드로 맵 업데이트
        }
    
        for(Contact c : contactList) {
            Contact_Products__c cp = contactProductMap.get(c.Id);
            if(c.First_Purchase_Store__c == null && cp != null) {
                //첫 구매상점 , 최근 구매상점, 구매 일 업데이트
                c.First_Purchase_Store__c = cp.Account__c;
                c.Latest_Purchase_Store__c = cp.Account__c;
                c.Latest_Purchase_Date__c = cp.Order_Date_Time__c;
                contactProductToUpdate.add(c);
            } else if (cp != null) {
                //최근 구매상점, 구매 일 업데이트
                c.Latest_Purchase_Store__c = cp.Account__c;
                c.Latest_Purchase_Date__c = cp.Order_Date_Time__c;
                contactProductToUpdate.add(c);
            }
        }
        // 구매상점 변화 발생 시 업데이트하여 넣어줌
        if(contactProductToUpdate.size() > 0) {
            update contactProductToUpdate;
        }
    }
    
     /**
    * 판매를 만들어주는 method 
    */
    public static void insertSales(List<Contact_Products__c> contactProduct) {
        Set<String> OrderCode = new Set<String>();
        List<String> ProducListName = new List<String>(); 
        List<Sale__c> saleToInsert = new List<Sale__c>();


        for(Contact_Products__c cp : contactProduct){
            OrderCode.add(cp.Order_Code__c);
            ProducListName.add(cp.Product__r.name);
        } 

        for(String pd : ProducListName){
            String ProductListName;
        }


        for(Contact_Products__c cp : contactProduct){
            AggregateResult[] TotalPriceResults = [SELECT SUM(Total_Purchase__c) totalPrice FROM Contact_Products__c
                                                WHERE Order_Code__c = :OrderCode];
            Integer TotalPrice = (Integer)TotalPriceResults[0].get('totalPrice');
            Integer DiscountAmount = (TotalPrice * cp.Discount_Percent__c / 100).intValue();
            Integer FinalPrice = TotalPrice - DiscountAmount;
            
            Sale__c sc = new Sale__c();
            sc.Account__c = cp.Account__c;
            sc.Customer__c = cp.Contact__c;
            // 판매코드
            
        }

        //insert saleToInsert;
    }
}