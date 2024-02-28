public with sharing class ContactProductTriggerHandler {
    public static boolean firstRun = true;
    // REQ-11
    public static void UpdatePurchaseStoreAndDateInContact(List<Contact_Products__c> triggerNew) {
        List<Contact> contactProductToUpdate = new List<Contact>(); 
        Set<Id> contactIds = new Set<Id>();
        
        // Contact_Products__c에서 Contact__c 필드를 추출하여 contactIds 세트에 추가
        for (Contact_Products__c c : triggerNew) {
            contactIds.add(c.Contact__c);
        }
        // Contact에서 고객 제품 주문과 일치하는 id, 이름, 고객 유형, 첫 구매 매장, 최근 구매 매장을 조회해서 contactList에 담아줌
        List<Contact> contactList = [SELECT Id, Name, Type__c, First_Purchase_Store__c, Latest_Purchase_Store__c
                                    FROM Contact
                                    WHERE Id IN :contactIds];
            Map<Id, Contact_Products__c> contactProductMap = new Map<Id, Contact_Products__c>();
            for (Contact_Products__c cp : triggerNew) {
                contactProductMap.put(cp.Contact__c, cp); // 마지막 Contact_Products__c 레코드로 맵 업데이트
            }
            // Latest_Purchase_Date__c = contact의 최근구매일 , Order_Date_Time__c = 고객제품주문(Date/Time)
            // 예제: DateTime 타입의 값을 Date 타입으로 변환하여 할당
    
            for(Contact c : contactList) {
                Contact_Products__c cp = contactProductMap.get(c.Id);
                if(c.First_Purchase_Store__c == null && cp != null) {
                    //첫 구매상점 , 최근 구매상점 업데이트
                    c.First_Purchase_Store__c = cp.Account__c;
                    c.Latest_Purchase_Store__c = cp.Account__c;
                    // Order_Date_Time__c (DateTime 타입)에서 Date 객체로 변환
                    DateTime dtValue = cp.Order_Date_Time__c; // DateTime 값을 추출
                    Date dateValue = dtValue.date(); // DateTime에서 Date로 변환
                    c.Latest_Purchase_Date__c = dateValue; // 최근 구매일 수정
                    contactProductToUpdate.add(c);
                } else if (cp != null) {
                    //최근 구매상점 업데이트
                    c.Latest_Purchase_Store__c = cp.Account__c;
                    // Order_Date_Time__c (DateTime 타입)에서 Date 객체로 변환
                    DateTime dtValue = cp.Order_Date_Time__c; // DateTime 값을 추출
                    Date dateValue = dtValue.date(); // DateTime에서 Date로 변환
                    c.Latest_Purchase_Date__c = dateValue; // 최근 구매일 수정
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
    public static void insertAndUpdateSale(List<Contact_Products__c> contactProduct) {
        List<String> ProductNameList = new List<String>(); 
        String ProductName = '';
        List<Sale__c> saleToInsert = new List<Sale__c>();
        List<Sale__c> saleToUpdate = new List<Sale__c>();
        Set<String> SalesCode = ContactProductController.getSalesCode(contactProduct);
        System.debug('insertAndUpdateSale에서의 SalesCode:' + SalesCode);

  
        Set<String> OrderCode = new Set<String>();
        for(Contact_Products__c cp : contactProduct){
            OrderCode.add(cp.Order_Code__c);
            ProductNameList.add(cp.Product_Name_Text__c);
        } 
    
        for(String pd : ProductNameList){
                ProductName += pd + '\n';
        }
        
        AggregateResult[] TotalPriceResults = [SELECT SUM(Total_Purchase__c) totalPrice 
                                                        FROM Contact_Products__c 
                                                        WHERE Order_Code__c = :OrderCode];
        Decimal TotalPrice = (Decimal)TotalPriceResults[0].get('totalPrice'); 
        
        if(SalesCode.isEmpty()){
            System.debug('SalesCode가 비워져있을 떄 ');
            for(Contact_Products__c cp : [SELECT Account__c, Contact__c, Order_Date_Time__c, Discount_Percent__c, Order_Code__c
                                              FROM Contact_Products__c 
                                              WHERE Order_Code__c = :OrderCode]){
                Decimal DiscountAmount = (TotalPrice * cp.Discount_Percent__c / 100); 
                Decimal FinalPrice = TotalPrice - DiscountAmount; 
                Sale__c sc = new Sale__c();
                sc.Account__c = cp.Account__c;
                sc.Customer__c = cp.Contact__c;
                sc.Date_of_sale__c = cp.Order_Date_Time__c;
                sc.List_of_Purchased_Items__c = ProductName;
                sc.Total_Price__c = TotalPrice.intValue();
                sc.Discount_Value__c = DiscountAmount.intValue();
                sc.Discount_Percent__c = cp.Discount_Percent__c;
                sc.Final_Price__c = FinalPrice.intValue();
                sc.Sales_Code__c = 'S'+ cp.Order_Code__c;
                saleToInsert.add(sc);
                System.debug('제품 1개 일떄 sales값::' + sc);
            }     
        }else if(!SalesCode.isEmpty()){
            System.debug('SalesCode가 채워져있을 떄 ');
            String AdditionalProductName = '';
            Set<Id> SaleId = ContactProductController.getSaleId(contactProduct);
            TotalPrice = (Decimal)TotalPriceResults[0].get('totalPrice'); 
            for(Contact_Products__c cp : contactProduct){
                ProductNameList.add(cp.Product_Name_Text__c);
            } 
        
            for(String pd : ProductNameList){
                AdditionalProductName += pd + '\n';
            }

            for(Sale__c scToUpdate : [SELECT Id, List_of_Purchased_Items__c, Total_Price__c, Discount_Value__c, Final_Price__c, Discount_Percent__c
                                      FROM Sale__C 
                                      WHERE Id IN : SaleId]){
                Decimal DiscountAmount = (TotalPrice * scToUpdate.Discount_Percent__c / 100); 
                Decimal FinalPrice = TotalPrice - DiscountAmount;
                scToUpdate.Total_Price__c = TotalPrice.intValue();
                scToUpdate.Discount_Value__c = DiscountAmount.intValue();
                scToUpdate.Final_Price__c = FinalPrice;
                scToUpdate.List_of_Purchased_Items__c += AdditionalProductName;  
                saleToUpdate.add(scToUpdate);
            }
        }

        if (!saleToInsert.isEmpty()) {
            System.debug(saleToInsert);
            insert saleToInsert;
        }

        if (!saleToUpdate.isEmpty()) {
            System.debug(saleToUpdate);
            update saleToUpdate;
        }
    }
}