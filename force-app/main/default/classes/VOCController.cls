public with sharing class VOCController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> searchCustomers(String phoneNumber) {
        // 전화번호에서 숫자만 남기고 공백 제거
        String formattedPhoneNumber = phoneNumber.replaceAll('\\D', '');
        String phoneNumberPattern = formattedPhoneNumber + '%';

        List<Contact> query = new List<Contact>();

        if (formattedPhoneNumber.length() >= 10) { // 최소 10자리 이상
            query = [SELECT Id, Name, Phone, Email, Type__c FROM Contact WHERE Phone LIKE :phoneNumberPattern AND Type__c = 'Purchase'];
            System.debug(query);
        }

        return query;
    }
}