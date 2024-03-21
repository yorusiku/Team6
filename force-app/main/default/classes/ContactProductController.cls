public with sharing class ContactProductController {
    
    /**
    * 고객이 주문한 제품을 추가하는 method 
    */
    @AuraEnabled
    public static void addContactProducts(String contactId, String accountId, 
                                          String laptopId, Integer laptopQuantity,
                                          String generalDeviceId, Integer generalDeviceQuantity, 
                                          Datetime orderDateTime, Integer discount) {
        List<Contact_Products__c> laptopProducts = new List<Contact_Products__c>();
        List<Contact_Products__c> generalDeviceProducts = new List<Contact_Products__c>();
            // 노트북 제품만 구매할 경우 
                // 추가적인 노트북 제품을 구매할 경우                               
        if(laptopQuantity > 0 && generalDeviceQuantity == 0){
            laptopProducts = newContactProduct(laptopQuantity,contactId,accountId,laptopId,discount,orderDateTime); 
                // 주변 기기만 구매할 경우
                // 추가적인 주변기기를 구매할 경우
        }else if(laptopQuantity == 0 && generalDeviceQuantity > 0){
            generalDeviceProducts = newContactProduct(generalDeviceQuantity,contactId,accountId,generalDeviceId,discount,orderDateTime); 
                // 노트북 및 주변 기기 모두다 구매할 경우 
                // 서로다른 개수의 노트북 및 주변기기를 구매할 경우
        }else if(laptopQuantity > 0 && generalDeviceQuantity > 0){
            laptopProducts = newContactProduct(laptopQuantity,contactId,accountId,laptopId,discount,orderDateTime); 
            generalDeviceProducts = newContactProduct(generalDeviceQuantity,contactId,accountId,generalDeviceId,discount,orderDateTime); 
        }
        try{
            if(!laptopProducts.isEmpty()){
                insert laptopProducts;
            }

            if(!generalDeviceProducts.isEmpty()){
                insert generalDeviceProducts;
            }
        } catch (Exception e) {
            throw new AuraHandledException('An error occurred while creating Contact Products: ' + e.getMessage());
        }
    }

    /**
    * 고객주문제품 record를 List에 생성해서 return하는 method 
    */ 
    public static List<Contact_Products__c> newContactProduct(Integer recordSize,
                                         String contactId, String accountId,
                                         String productTypeId, Integer discount, 
                                         Datetime orderDateTime){
        List<Contact_Products__c> contactProductsToInsert = new List<Contact_Products__c>(); 
        
        for (Integer i = 0; i < recordSize; i++) {
            contactProductsToInsert.add(new Contact_Products__c(
                Contact__c = contactId,
                Account__c = accountId,
                Product__c = productTypeId,
                Discount_Percent__c = discount,
                Order_Date_Time__c = orderDateTime
            ));
        }
        return contactProductsToInsert;
    }

    // 고객주문제품코드에서 판매코드를 return하는 method 
    public static Set<String> getSalesCode(List<Contact_Products__c> contactProduct){
        Set<String> salesCode = new Set<String>(); 
        Set<String> OrderCode = new Set<String>();
        for(Contact_Products__c cp : contactProduct){
            OrderCode.add('S'+ cp.Order_Code__c);
        } 

        List<sale__c> saleList = [SELECT Id , name, Sales_Code__c
                               FROM sale__c
                               WHERE Sales_Code__c IN : OrderCode];
        for(sale__c sc : saleList){
            salesCode.add(sc.Sales_Code__c);
        }

        if (salesCode.isEmpty()) {
            System.debug('Sales Code는 null');
        }
        
        return salesCode;
    }

    // 고객주문제품코드에서 Sale의 Id를 return하는 method 
    public static Set<Id> getSaleId(List<Contact_Products__c> contactProduct){
        Set<Id> salesId = new Set<Id>(); 
        String salesCode; 
        Set<String> OrderCode = new Set<String>();
        for(Contact_Products__c cp : contactProduct){
            OrderCode.add('S'+ cp.Order_Code__c);
        }
        
        for(sale__c sc : [SELECT Id, name, Sales_Code__c
        FROM sale__c
        WHERE Sales_Code__c IN : OrderCode]){
            salesId.add(sc.Id);
        }     
        return salesId;
    }

     // 고객주문제품에서 고객의 총 판매액을 구해서 계산하는 method 
    public static Integer getCustomerTotalPurchase(Contact con){
        Integer totalCustomerPurchase = 0;
        
        AggregateResult[] totalPriceResults = [SELECT SUM(Total_Purchase__c)totalPrice 
                                                FROM Contact_Products__c 
                                                WHERE Contact__c = :con.Id
                                                AND Status__c = :Constants.CONTACT_PRODUCT_STATUS_PURCHASED
                                                AND Order_Date_Time__c >= :con.Due_Date_90Days__c 
                                                AND Order_Date_Time__c <= Today];
        Decimal totalPrice = (Decimal)totalPriceResults[0].get('totalPrice'); 

        if(totalPrice == null){
            return 0;
        }

        return totalCustomerPurchase = totalPrice.intValue();
    }

    // 고객주문제품에서 고객의 총 노트북 구매 금액을 계산하는 메서드
    public static Integer getCustomerTotalNotebookPurchase(Contact con){
        Integer totalNotebookPurchasePurchase = 0;
   
        AggregateResult[] totalPriceResults = [SELECT SUM(Total_Purchase_of_Laptops__c)totalNoteBookPrice 
                                                FROM Contact_Products__c 
                                                WHERE Contact__c = :con.Id
                                                AND Status__c = :Constants.CONTACT_PRODUCT_STATUS_PURCHASED
                                                AND Order_Date_Time__c >= :con.Due_Date_90Days__c 
                                                AND Order_Date_Time__c <= Today];

        Decimal totalNoteBookPrice = (Decimal)totalPriceResults[0].get('totalNoteBookPrice'); 
       
        if(totalNoteBookPrice == null){
            return 0;
        }
        return totalNotebookPurchasePurchase = totalNoteBookPrice.intValue();
    }

    // 고객주문제품에서 고객의 총 주변기기 구매 금액을 계산하는 메서드
    public static Integer getCustomerTotalGeneralDevicePurchase(Contact con){
        Integer totalGeneralDevicePurchase = 0;
   
        AggregateResult[] totalPriceResults = [SELECT SUM(Total_Purchase_of_General_Devices__c)totalGeneralDevicePrice 
                                                FROM Contact_Products__c 
                                                WHERE Contact__c = :con.Id
                                                AND Status__c = :Constants.CONTACT_PRODUCT_STATUS_PURCHASED
                                                AND Order_Date_Time__c >= :con.Due_Date_90Days__c 
                                                AND Order_Date_Time__c <= Today];
                                                
        Decimal totalGeneralDevicePrice = (Decimal)totalPriceResults[0].get('totalGeneralDevicePrice'); 

        if(totalGeneralDevicePrice == null){
            return 0;
        }
        return totalGeneralDevicePurchase = totalGeneralDevicePrice.intValue();
    }


    // 고객주문제품에서 고객의 총 구매제품을 담아주는 메서드
    public static String getCustomerPurchaseItemList(Contact con){
        String ProductName = '';

        for(Contact_Products__c cp : [SELECT Id, name, Product_Name_Text__c
                                      FROM Contact_Products__c 
                                      WHERE Contact__c = :con.Id
                                      AND Status__c = :Constants.CONTACT_PRODUCT_STATUS_PURCHASED
                                      AND Order_Date_Time__c >= :con.Due_Date_90Days__c 
                                      AND Order_Date_Time__c <= Today]){
            ProductName += cp.Product_Name_Text__c + '\n';
        }

        return ProductName;
    }
    

    // 총 구매금액, 총 주변기기금액, 총 노트북구매금액을 구해주는 메서드 
    public static Map<String,Integer> getCustomerTotalAmount(Contact con){
        Map<String,Integer> totalAmountMap = new Map<String,Integer>(); 
        Integer totalCustomerPurchase = 0;
        Integer totalNotebookPurchasePurchase = 0;
        Integer totalGeneralDevicePurchase = 0;
        AggregateResult[] totalAmountResults = [SELECT SUM(Total_Purchase__c)totalPrice, SUM(Total_Purchase_of_Laptops__c)totalNoteBookPrice, SUM(Total_Purchase_of_General_Devices__c)totalGeneralDevicePrice 
                                    FROM Contact_Products__c 
                                    WHERE Contact__c = :con.Id
                                    AND Status__c = :Constants.CONTACT_PRODUCT_STATUS_PURCHASED
                                    AND Order_Date_Time__c >= :con.Due_Date_90Days__c 
                                    AND Order_Date_Time__c <= Today];
        Decimal totalPrice = (Decimal)totalAmountResults[0].get(Constants.TOTAL_PRICE); 
        Decimal totalNoteBookPrice = (Decimal)totalAmountResults[0].get(Constants.TOTAL_NOTEBOOK_PRICE); 
        Decimal totalGeneralDevicePrice = (Decimal)totalAmountResults[0].get(Constants.TOTAL_GENERAL_DEVICE_PRICE); 
        
        if(totalPrice == null){
            totalPrice = 0;
            totalNoteBookPrice = 0;
            totalGeneralDevicePrice = 0;
        }
        
        totalCustomerPurchase = totalPrice.intValue();
        totalNotebookPurchasePurchase = totalNoteBookPrice.intValue();
        totalGeneralDevicePurchase = totalGeneralDevicePrice.intValue();
        
        totalAmountMap.put(Constants.TOTAL_CUSTOMER_PURCHASE , totalCustomerPurchase);
        totalAmountMap.put(Constants.TOTAL_NOTEBOOK_PURCHASE , totalNotebookPurchasePurchase);
        totalAmountMap.put(Constants.TOTAL_GENERAL_DEVICE_PURCHASE, totalGeneralDevicePurchase);
        
        return totalAmountMap;
    }


    //구매고객을 불러와서 주문코드로 검색하는 메서드 
    @AuraEnabled(cacheable=true scope='global')
    public static List<Contact_Products__c> searchContactProductsByOrderCode(String searchTerm) {
        searchTerm = searchTerm.trim();
        if (searchTerm == '') {
            return getAllPurchasedContactProducts();
        }
        
        searchTerm = '%' + searchTerm + '%';

        return [SELECT Id, Name,  Product_Name_Text__c, Contact__r.name, Order_Code__c 
                FROM Contact_Products__c 
                WHERE Status__c = 'Purchased'
                AND Is_SaleProduct_Created__c = false
                AND Order_Code__c LIKE :searchTerm 
                ORDER BY CreatedDate DESC ];
    }

    @AuraEnabled(cacheable=true scope='global')
    public static List<Contact_Products__c> getAllPurchasedContactProducts() {
        return [
            SELECT Id, Name, Product_Name_Text__c, Contact__r.name, Order_Code__c 
            FROM Contact_Products__c 
            WHERE Is_SaleProduct_Created__c = false
            AND Status__c = 'Purchased'
            ORDER BY CreatedDate DESC
            LIMIT 10
        ];
    }

    //검색한 주문코드로 판매된 제품을 등록하는 메서드 
    @AuraEnabled
    public static void addSalesProduct(String orderCode){
        List<Sales_Product__c> salesProductsToInsert = new List<Sales_Product__c>(); 
    
        for (Contact_Products__c cp : [SELECT Id, Order_Code__c 
                                        FROM Contact_Products__c
                                        WHERE Order_Code__c = :orderCode]) {
            Sales_Product__c sp = new Sales_Product__c();  
            sp.Serial_Number__c = generateRandomString(16); 
            sp.Contact_Products__c = cp.Id;
            salesProductsToInsert.add(sp);
        }
        
        if (!salesProductsToInsert.isEmpty()) {
            insert salesProductsToInsert;
        }
    }

     // 고유한 랜덤 문자열 생성하는 메서드 
     public static String generateRandomString(Integer length) {
        String allowedCharacters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        String randomString = '';
        while (randomString.length() < length) {
            Integer randomInt = Math.mod(Math.abs(Crypto.getRandomInteger()), allowedCharacters.length());
            randomString += allowedCharacters.substring(randomInt, randomInt + 1);
        }
        return randomString;
    }
}