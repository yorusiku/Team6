public with sharing class SalesProductController {
    public static void updateSerialNumbers(List<Sales_Product__c> salesProducts){
        Set<Id> existingSalesProductIds = new Set<Id>(); // 기존 Sales_Product__c 레코드의 ID를 추적하기 위한 세트
        // Sales_Product__c 레코드의 ID를 가져오는 쿼리 실행
        for(Sales_Product__c sp : [SELECT Id, Contact_Products__r.Order_Code__c FROM Sales_Product__c WHERE Id IN :salesProducts]) {
            existingSalesProductIds.add(sp.Id); // Sales_Product__c 레코드의 ID를 세트에 추가
            System.debug(sp.Contact_Products__r.Order_Code__c);
        }
        
        List<Sales_Product__c> salesProductListToUpdate = new List<Sales_Product__c>(); 
        
        // 주문 코드를 기반으로 시리얼 번호 생성 및 Sales_Product__c 레코드 업데이트
        for(Sales_Product__c sp : salesProducts){
            if(existingSalesProductIds.contains(sp.Id)) {
                String orderCode = 'S' + sp.Contact_Products__r.Order_Code__c;
                Integer i = 1; // 일련번호 초기화
                i++;
                String serialNumber = orderCode + i;
                System.debug(serialNumber);

                // Sales_Product__c 레코드 업데이트를 위한 객체 생성
                Sales_Product__c salesProduct = new Sales_Product__c();
                salesProduct.Id = sp.Id; // 업데이트할 레코드의 ID 설정
                salesProduct.Serial_Number__c = serialNumber;
                // 다른 필드 값도 설정할 수 있음
                // 예: salesProduct.Sales_Code__c = sp.Sales_Code__c
                System.debug(salesProduct.Serial_Number__c);
                salesProductListToUpdate.add(salesProduct); // 업데이트할 Sales_Product__c 레코드를 리스트에 추가

                system.debug(salesProduct);
            }
        }

        // Sales_Product__c 레코드를 업데이트
        if (!salesProductListToUpdate.isEmpty()) {
            update salesProductListToUpdate;
        }
    }
}