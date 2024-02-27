public with sharing class ContactProductTriggerHandler {
    public static void BeforeInsertContactProductTriggerHandler(List<Contact_Products__c> triggerNew) {
        List<Contact> contactProductToUpdate = new List<Contact>(); 
        Set<Id> contactIds = new Set<Id>();
        // Contact_Products__c에서 Contact__c 필드를 추출하여 contactIds 세트에 추가
        for (Contact_Products__c c : triggerNew) {
            contactIds.add(c.Contact__c);
        }
        // Contact에서 id, 이름, 고객 유형, 첫 구매 매장, 최근 구매 매장을 조회
        List<Contact> contactList = [SELECT Id, Name, Type__c, First_Purchase_Store__c, Latest_Purchase_Store__c
                                    FROM Contact
                                    WHERE Id IN :contactIds];
    
        Map<Id, Contact_Products__c> contactProductMap = new Map<Id, Contact_Products__c>();
        for (Contact_Products__c cp : triggerNew) {
            contactProductMap.put(cp.Contact__c, cp); // 마지막 Contact_Products__c 레코드로 맵 업데이트
        }
    
        for(Contact c : contactList) {
            Contact_Products__c cp = contactProductMap.get(c.Id);
            if(c.First_Purchase_Store__c == null && cp != null) {
                c.First_Purchase_Store__c = cp.Account__c;
                contactProductToUpdate.add(c);
            } else if (cp != null) {
                c.Latest_Purchase_Store__c = cp.Account__c;
                contactProductToUpdate.add(c);
            }
        }
    
        if(contactProductToUpdate.size() > 0) {
            update contactProductToUpdate;
        }
    }
    

            // 최근 구매일
            // 구매생기면 Type__c고객유형 -> 구매로
    public static void insertSales(List<Contact_Products__c> contactProduct) {
        Set<String>OrderCode = new Set<String>();
        List<Sale__c> saleToInsert = new List<Sale__c>();


        for(Contact_Products__c cp : contactProduct){
            OrderCode.add(cp.Order_Code__c);
        } 

        //Integer 총값 = [SELECT ~~ WHERE Order_Code__c IN OrderCode];
        //Integer 총노트북값 = [SELECT ~~ WHERE Order_Code__c IN OrderCode];
        //Integer 총랩탑값 = [SELECT ~~ WHERE Order_Code__c IN OrderCode];
        //Integer 총랩탑값 = [SELECT ~~ WHERE Order_Code__c IN OrderCode];
        //Integer 총랩탑값 = [SELECT ~~ WHERE Order_Code__c IN OrderCode];
        //Integer 총랩탑값 = [SELECT ~~ WHERE Order_Code__c IN OrderCode];
        

        //for(Contact_Products__c cp : contactProduct){
        //    Sale__c sc = new  Sale__c();
        //    sc. ~ = cp. ~
        //    sc. ~  
        //}

        //insert saleToInsert;
    }
}