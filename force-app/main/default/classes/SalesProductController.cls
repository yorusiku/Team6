public with sharing class SalesProductController {
    
    // sObject에서 필드 값을 추출하는 메서드
    public static String extractFieldValues(SObject sb, String fieldAPIName){
        String fvalue = '';
        if(fieldAPIName.contains('.')){
            List<String> splitedFields = fieldAPIName.split('\\.');
            try{
                for(Integer i = 0; i < splitedFields.size() - 1; i++){
                    sb = sb.getSobject(splitedFields[i]);   
                }
                fvalue = String.valueOf(sb.get(splitedFields[splitedFields.size() - 1]));
            }catch(Exception ex){
                System.debug('관계 ' + fieldAPIName + '의 필드 값을 가져오는 중 예외 발생. 값이 없습니다. ' + ex.getMessage()); 
                fvalue = '';
            }
            
        } else if(sb.get(fieldAPIName) != null){
            fvalue = String.valueOf(sb.get(fieldAPIName));
        }
        return fvalue;
    }

    // Sales_Product__c 레코드의 시리얼 번호를 업데이트하는 메서드
    public static void updateSerialNumbers(List<Sales_Product__c> salesProducts){
        Set<Id> existingSalesProductIds = new Set<Id>(); // 기존 Sales_Product__c 레코드의 ID를 추적하기 위한 세트
    

        List<Sales_Product__c> salesProductListToUpdate = new List<Sales_Product__c>(); 
        
        // 주문 코드를 기반으로 시리얼 번호 생성 및 Sales_Product__c 레코드 업데이트
        for(Sales_Product__c sp : salesProducts){
            if(existingSalesProductIds.contains(sp.Id)) {
                // 연관된 Contact_Products__c 레코드에서 주문 코드를 추출합니다.
                String orderCode = extractFieldValues(sp.Contact_Products__r, 'Order_Code__c');
                System.debug('주문 코드 추출: ' + orderCode);
                
                if(orderCode != null) {
                    String orderCode_1 = 'S' + orderCode;
                    Integer i = 1; // 일련번호 초기화
                    
                    // 새로운 시리얼 번호 생성
                    String serialNumber = orderCode_1 + i;
                    System.debug('시리얼 번호: ' + serialNumber);

                    // Sales_Product__c 레코드를 업데이트하기 위한 객체 생성
                    Sales_Product__c salesProduct = new Sales_Product__c();
                    salesProduct.Id = sp.Id; // 업데이트할 레코드의 ID 설정
                    salesProduct.Serial_Number__c = serialNumber;
                    // 다른 필드 값도 설정할 수 있음
                    // 예: salesProduct.Sales_Code__c = sp.Sales_Code__c
                    System.debug('업데이트된 시리얼 번호: ' + salesProduct.Serial_Number__c);

                    i++;
                    salesProductListToUpdate.add(salesProduct); // 업데이트할 Sales_Product__c 레코드를 리스트에 추가
                }
            }
        }

        // Sales_Product__c 레코드를 업데이트
        if (!salesProductListToUpdate.isEmpty()) {
            update salesProductListToUpdate;
        }
    }
}