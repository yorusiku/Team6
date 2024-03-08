public with sharing class SalesProductTriggerHandler {
    // 판매된제품 입력되고 나서 고객주문제품에 	Is_SaleProduct_Created__c true로 바꿔주고 업데이트해주는 trigger 만들기
    public static void updateIsSalesProductCheckedToTrue(List<Sales_Product__c> salesProducts){
        System.debug('updateIsSalesProductCheckedToTrue 실행::');
        Set<String> orderCode = new Set<String>();
        List<contact_Products__c> contactProductsToUpdate = new List<Contact_Products__c>();
        
        for(sales_Product__c pc : [SELECT Id, Contact_Products__r.Order_Code__c FROM Sales_Product__c WHERE Id IN :salesProducts]){
            orderCode.add(pc.Contact_Products__r.Order_Code__c);
        }
        System.debug('orderCode::' + orderCode);

        for(contact_Products__c cp : [SELECT Id, Order_Code__c, Is_SaleProduct_Created__c
                                      FROM Contact_Products__c 
                                      WHERE Order_Code__c IN :orderCode]){
            cp.Is_SaleProduct_Created__c = true;
            contactProductsToUpdate.add(cp);
            System.debug('contactProductsToUpdate::' + contactProductsToUpdate);
        }

        if(contactProductsToUpdate.size() > 0) {
            System.debug('contactProductsToUpdate::' + contactProductsToUpdate);
            update contactProductsToUpdate;
        }
    }
}




//     public static void updateSerialNumbers(List<Sales_Product__c> salesProducts){
//         Set<Id> salesProductIds = new Set<Id>(); // 기존 Sales_Product__c 레코드의 ID를 추적하기 위한 세트
//         String query='';

//         // Sales_Product__c 레코드의 ID를 가져오는 쿼리 실행
//         for(Sales_Product__c sp : [SELECT Id, Contact_Products__r.Order_Code__c FROM Sales_Product__c WHERE Id IN :salesProducts]) {
//             salesProductIds.add(sp.Id); // Sales_Product__c 레코드의 ID를 세트에 추가
//             System.debug(sp.Contact_Products__r.Order_Code__c);
//             query = sp.Contact_Products__r.Order_Code__c;
//         }

//         List<Sales_Product__c> salesProductListToUpdate = new List<Sales_Product__c>();

//         // 주문 코드를 기반으로 시리얼 번호 생성 및 Sales_Product__c 레코드 업데이트
        
//         for(Sales_Product__c sp : salesProducts){
//             if(salesProductIds.contains(sp.Id)) {
//                 String orderCode = 'Serial : ' + query + 'i' ;
//                 System.debug('orderCode :'+ orderCode);
//                 String serialNumber = orderCode;
//                 salesProductListToUpdate.add(
//                     new Sales_Product__c(
//                         Id = sp.Id,
//                         Serial_Number__c = serialNumber
//                     )
//                 );
//             }
//         }

//         // Sales_Product__c 레코드를 업데이트
//         if (!salesProductListToUpdate.isEmpty()) {
//             update salesProductListToUpdate;
//         }
//     }
// }

// 용재님 코드!!!

// public with sharing class SalesProductController {
//     public static void updateSerialNumbers(List<Sales_Product__c> salesProducts){
//         Boolean firstrun = true;

//         Set<Id> existingSalesProductIds = new Set<Id>(); // 기존 Sales_Product__c 레코드의 ID를 추적하기 위한 세트
//         // Sales_Product__c 레코드의 ID를 가져오는 쿼리 실행
//         String query;
//         for(Sales_Product__c sp : [SELECT Id, Contact_Products__r.Order_Code__c FROM Sales_Product__c WHERE Id IN :salesProducts]) {
//             existingSalesProductIds.add(sp.Id); // Sales_Product__c 레코드의 ID를 세트에 추가
//             query = sp.Contact_Products__r.Order_Code__c;
//         }
//         System.debug('query:'+ query);
//         List<Sales_Product__c> salesProductListToUpdate = new List<Sales_Product__c>();
//         // 주문 코드를 기반으로 시리얼 번호 생성 및 Sales_Product__c 레코드 업데이트
//         if(firstrun){
//             for(Sales_Product__c sp : salesProducts){
//                 if(existingSalesProductIds.contains(sp.Id)) {
//                     String orderCode = 'S' + query;
//                     System.debug('orderCode'+ orderCode);
//                     Integer i = 1; // 일련번호 초기화
//                     i++;
//                     String serialNumber = orderCode + i;
//                     salesProductListToUpdate.add(
//                         new Sales_Product__c(
//                             Id = sp.Id,
//                             Serial_Number__c = serialNumber)); // 업데이트할 Sales_Product__c 레코드를 리스트에 추가
//                     System.debug('serialNumber::' + serialNumber);
//                     System.debug('serialNumber::' +salesProductListToUpdate);
//                 }
//             }
//             firstrun = false; 
//         }

//         // Sales_Product__c 레코드를 업데이트
//         if (!salesProductListToUpdate.isEmpty()) {
//             update salesProductListToUpdate;
//         }
//     }
//}



// public with sharing class SalesProductController {
//     private static Integer serialNumberCounter = 1; // 일련번호 생성을 위한 카운터 변수
    
//     // Contact_Products__c 부모 객체의 필드 값을 동적으로 추출하여 Sales_Product__c 자식 객체의 Serial_Number__c 필드에 매핑하고 시리얼 넘버를 생성하는 메서드
//     public static void mapOrderCodeToSerialNumber(List<Sales_Product__c> salesProducts) {
//         // 부모 객체의 필드 API 이름 목록과 자식 객체의 이름 설정
//         List<String> parentFieldAPINamesList = new List<String>{'Id', 'Order_Code__c'};
//         String childObjectName = 'Sales_Product__c';

//         // 부모 객체의 필드 값을 추출하여 매핑하기 위한 쿼리문 생성
//         String qString = 'SELECT ' + String.join(parentFieldAPINamesList, ',') + ' FROM Contact_Products__c';
//         List<SObject> queriedRecords = Database.query(qString);

//         // 부모 객체의 필드 값을 매핑하기 위한 맵 생성
//         Map<String, String> parentFieldValuesMap = new Map<String, String>();
//         for (SObject record : queriedRecords) {
//             // 부모 객체의 필드 값을 동적으로 추출하여 매핑
//             String parentId = String.valueOf(record.get('Id'));
//             String orderCode = String.valueOf(record.get('Order_Code__c'));

//             // 추출한 값들을 맵에 저장
//             parentFieldValuesMap.put(parentId, orderCode);
//         }

//         // 자식 객체의 레코드를 가져와서 부모 객체의 값을 매핑하고 시리얼 넘버를 생성합니다.
//         for(Sales_Product__c salesProduct : salesProducts) {
//             // Sales_Product__c 레코드에 매핑된 부모 객체(Contact_Products__c)의 Id를 가져옵니다.
//             String parentId = salesProduct.Contact_Products__c;
            
//             // 부모 객체의 필드 값을 가져와서 자식 객체에 매핑합니다.
//             if (parentFieldValuesMap.containsKey(parentId)) {
//                 String orderCode = parentFieldValuesMap.get(parentId);
                
//                 // 시리얼 넘버 생성
//                 String serialNumber = generateSerialNumber(orderCode);
//                 salesProduct.Serial_Number__c = serialNumber;
//             }
//         }
//     }

//     // 시리얼 넘버를 생성하는 메서드
//     private static String generateSerialNumber(String orderCode) {
//         // 시리얼 넘버 생성
//         String serialNumber = 'Serial' + orderCode + serialNumberCounter;
//         // 카운터 변수 증가
//         serialNumberCounter++;
//         return serialNumber;
//     }
// }