public with sharing class VOCController {
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> searchCustomers(String phoneNumber, Integer pageNumber, Integer pageSize) {
        Map<String, Object> result = new Map<String, Object>();
        String phoneNumberPattern = '%' + phoneNumber + '%';
        Integer offset = (pageNumber - 1) * pageSize;

        List<Sales_Product__c> queryResult = [
            SELECT Id, Contact__c, CustomerNumber__c, Email__c, Product_Name_Text__c, Serial_Number__c, Account__c, Purchased_Date_Time_c__c, Contact_Products__r.Contact__c
            FROM Sales_Product__c
            WHERE CustomerNumber__c LIKE :phoneNumberPattern AND Status__c = '판매'
            ORDER BY Purchased_Date_Time_c__c DESC, CustomerNumber__c, Contact__c, Account__c
            LIMIT :pageSize OFFSET :offset
        ];

        result.put('data', queryResult);
        System.debug('data : ' + queryResult);
        return result;
    }


}