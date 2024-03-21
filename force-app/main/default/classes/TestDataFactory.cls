/**
    * test class에서 필요한 기본 test data 및 메서드들을 위한 test utility class
    */
@isTest
public class TestDataFactory {

    // 판매점 테스팅 데이터를 만들어주는 메서드
    public static List<account> createAccount(Integer numAccts){
        List<Account> accts = new List<Account>();
            for(Integer i = 0 ; i <numAccts;i++) {
                Account a = new Account(
                Name = 'TestAccount' + i);
                accts.add(a);
            }
            insert accts;
        
        return accts;
    } 
    
    //  연락처 테스팅 데이터들을 타입 , 레코드타입 별로 List로 만들어주는 메서드
    public static List<Contact> createContacts(Integer numContacts, Id contactRecordTypeId, String contactType,
                                               Id TierId, Integer TotalPurchaseAmount, 
                                                Integer TotalPurchaseGeneralDevices, Integer TotalPurchaseLaptop,
                                                Date LatestPurchaseDate) {

                                               Id TierId, Integer TotalPurchaseAmount, 
                                                Integer TotalPurchaseGeneralDevices, Integer TotalPurchaseLaptop,
                                                Date LatestPurchaseDate) {

        List<Contact> cons = new List<Contact>();

        for(Integer i = 0; i < numContacts; i++) {
         // 고유한 전화번호 중간 부분 생성
         
         
         String phoneNumberMiddle = padLeftWithZeros(String.valueOf(i), 4); // 숫자를 4자리 문자열로 변환
         // 고유한 전화번호 마지막 부분 생성 (예: i에 1000을 더함)
         String phoneNumberLast = padLeftWithZeros(String.valueOf(i + 1000), 4); // 숫자를 4자리 문자열로 변환하고 1000을 더함
 
         // 전체 전화번호 생성
         String phoneNumber = '010-' + phoneNumberMiddle + '-' + phoneNumberLast;
         System.debug('phoneNumber' + phoneNumber);
            Contact c = new Contact(
                FirstName = 'Contact' + i,
                LastName = 'Test' + i,
                RecordTypeId = contactRecordTypeId,
                Type__c = contactType,
                Customer_Tier__c = TierId,    
                Total_Purchase_Amount__c = TotalPurchaseAmount,
                Total_Purchase_of_General_Devices__c = TotalPurchaseGeneralDevices,
                Total_Purchase_of_Laptops__c  = TotalPurchaseLaptop,
                List_of_purchased_items__c = 'PurchaseItem' + i,
                Latest_Purchase_Date__c = LatestPurchaseDate,
                Consultation_Count__c = 0,
                Phone = phoneNumber // 생성된 고유한 전화번호를 Phone 필드에 할당
            );
            cons.add(c);
        }

            insert cons;

            return cons;
    }

    //전화번호 생성 메서드
    public static String padLeftWithZeros(String originalString, Integer desiredLength) {
        Integer numberOfZerosToAdd = desiredLength - originalString.length();
        String zeros = '';
        for(Integer i = 0; i < numberOfZerosToAdd; i++) {
            zeros += '0';
        }
        return zeros + originalString;
    }


            return cons;
    }

    //전화번호 생성 메서드
    public static String padLeftWithZeros(String originalString, Integer desiredLength) {
        Integer numberOfZerosToAdd = desiredLength - originalString.length();
        String zeros = '';
        for(Integer i = 0; i < numberOfZerosToAdd; i++) {
            zeros += '0';
        }
        return zeros + originalString;
    }

    // 티어를 테스팅 하기 위한 티어 레코드를 만들어 주는 메서드
    public static Tier__c createTier(String tierName, Integer Minimum, Integer Maximum){
        Tier__c tier = new Tier__c(
            Name = tierName,
            Minimum_Purchase__c = Minimum,
            Maximum_Purchase__c = Maximum);
        insert tier;

        return tier;
    }

    // 제품을 테스팅 하기 위한 제품 레코드를 만들어 주는 메서드
    public static List<Product2> createProducts(Integer numProducts, String type, Integer Price){
        List<Product2> Products = new List<Product2>();
            for(Integer i = 0 ; i < numProducts ;i++) {
                Product2 pd = new Product2(
                    Name = 'TestProduct' + i, 
                    ProductCode = 'ProductCode'+i,
                    Family = type,
                    Price__c = Price,
                    Image__c = '/resource/Products/TestProduct'+ i +'.jpg'
                    );
                    Products.add(pd);
            }
            insert Products;

            return Products;
    }

    // 판매과정을 테스팅 하기 위한 고객제품주문 레코드를 만들어 주는 메서드
    public static List<Contact_Products__c> createContactProducts(Integer recordSize,Integer discount,Datetime orderDateTime){
        List<Account> testAccounts = TestDataFactory.createAccount(1); // 판매점
        Tier__c testTierD = TestDataFactory.createTier(Constants.D_TIER, 0, 0); //고객등급
        List<Account> testAccounts = TestDataFactory.createAccount(1); // 판매점
        Tier__c testTierD = TestDataFactory.createTier(Constants.D_TIER, 0, 0); //고객등급
        List<Contact> testContacts = TestDataFactory.createContacts(1, Constants.CUSTOMER_RECORD_TYPE_ID , Constants.CONTACT_TYPE_PURCHASE,
        Utility.getTierId(Constants.D_TIER), 0 , 0 , 0 , Date.today()); //고객이름
        List<Product2> testProducts = TestDataFactory.createProducts(1, Constants.NOTEBOOK, 2000000); //제품명      

        Utility.getTierId(Constants.D_TIER), 0 , 0 , 0 , Date.today()); //고객이름
        List<Product2> testProducts = TestDataFactory.createProducts(1, Constants.NOTEBOOK, 2000000); //제품명      

        List<Contact_Products__c> cps = new List<Contact_Products__c>(); 


        for(Integer i = 0 ; i < recordSize ;i++) {
            Contact_Products__c cp = new Contact_Products__c(
                Contact__c = testContacts[0].Id,
                Account__c = testAccounts[0].Id,
                Product__c = testProducts[0].Id,
                Discount_Percent__c = discount,
                Order_Date_Time__c = orderDateTime
                );
                cps.add(cp);
        }
        insert cps;

        return cps;
    }

    // VOC을 테스팅 하기 위한 '판매된 제품' 레코드를 만들어 주는 메서드
    public static List<Sales_Product__c> createSalesProducts(Integer recordSize) {
        List<Contact_Products__c> testContactProducts = createContactProducts(1, 0, DateTime.now()); 
        List<Sales_Product__c> sps = new List<Sales_Product__c>();  

        for(Integer i = 0; i < recordSize; i++) {
            Sales_Product__c sp = new Sales_Product__c(
            Contact_Products__c = testContactProducts[0].Id);

            sps.add(sp);
        }
        insert sps;
    
        return sps;
    }
    

    // VOC을 테스팅 하기 위한 '판매된 제품' 레코드를 만들어 주는 메서드
    public static List<Sales_Product__c> createSalesProducts(Integer recordSize) {
        List<Contact_Products__c> testContactProducts = createContactProducts(1, 0, DateTime.now()); 
        List<Sales_Product__c> sps = new List<Sales_Product__c>();  

        for(Integer i = 0; i < recordSize; i++) {
            Sales_Product__c sp = new Sales_Product__c(
            Contact_Products__c = testContactProducts[0].Id);

            sps.add(sp);
        }
        insert sps;
    
        return sps;
    }
    
    
    // 상담을 테스팅 하기 위해 상담 레코드를 만들어 주는 메서드
    public static List<Consultant__c> createConsultant(Integer recordSize){
        List<Account> testAccounts = TestDataFactory.createAccount(1);
        Tier__c testTierD = TestDataFactory.createTier(Constants.D_TIER, 0, 0);
        List<Contact> testContacts = TestDataFactory.createContacts(1, Constants.CUSTOMER_RECORD_TYPE_ID , Constants.CONTACT_TYPE_PURCHASE,
        Utility.getTierId(Constants.D_TIER), 0 , 0 , 0 , Date.today());


        List<Consultant__c> ccs = new List<Consultant__c>();

        for(Integer i = 0 ; i < recordSize ;i++) {
            Consultant__c cc = new Consultant__c(
                CustomerName__c = testContacts[0].Id,
                Account__c = testAccounts[0].Id,
                VisitDate__c = Date.today(),
                Content__c = 'test content',
                IsProvided__c = true
            );
            ccs.add(cc);
            );
            ccs.add(cc);
        }
        insert ccs;

        return ccs;
    }

    // VOC를 테스팅하기 위해 VOC 레코드를 만들어 주는 메서드

    public static List<VOC__c> createVOC(Integer recordSize, String VOCType){
        List<Sales_Product__c> testSalesProducts = TestDataFactory.createSalesProducts(1);
        Tier__c testTierD = TestDataFactory.createTier(Constants.D_TIER, 0, 0);
        List<Contact> testContacts = TestDataFactory.createContacts(1, Constants.CUSTOMER_RECORD_TYPE_ID , Constants.CONTACT_TYPE_PURCHASE,
        Utility.getTierId(Constants.D_TIER), 0 , 0 , 0 , Date.today());

        List<VOC__c> vocs = new List<VOC__c>();

        for(Integer i = 0 ; i < recordSize ;i++) {
            VOC__c voc = new VOC__c(
                Sales_Product__c = testSalesProducts[0].Id,
                CustomerName__c = testContacts[0].Id,
                VOCType__c = VOCType,
                Content__c = 'test content'
                
                );
                vocs.add(voc);
        }
        insert vocs;

        return vocs;
    }



    // VOC를 테스팅하기 위해 VOC 레코드를 만들어 주는 메서드

    public static List<VOC__c> createVOC(Integer recordSize, String VOCType){
        List<Sales_Product__c> testSalesProducts = TestDataFactory.createSalesProducts(1);
        Tier__c testTierD = TestDataFactory.createTier(Constants.D_TIER, 0, 0);
        List<Contact> testContacts = TestDataFactory.createContacts(1, Constants.CUSTOMER_RECORD_TYPE_ID , Constants.CONTACT_TYPE_PURCHASE,
        Utility.getTierId(Constants.D_TIER), 0 , 0 , 0 , Date.today());

        List<VOC__c> vocs = new List<VOC__c>();

        for(Integer i = 0 ; i < recordSize ;i++) {
            VOC__c voc = new VOC__c(
                Sales_Product__c = testSalesProducts[0].Id,
                CustomerName__c = testContacts[0].Id,
                VOCType__c = VOCType,
                Content__c = 'test content'
                
                );
                vocs.add(voc);
        }
        insert vocs;

        return vocs;
    }


}