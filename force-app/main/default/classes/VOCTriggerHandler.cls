public with sharing class VOCTriggerHandler {
    public static void updateVOCCount(List<VOC__c> triggerNew) {
        Set<Id> VOCIds = new Set<Id>();
        Set<String> storeNames = new Set<String>();
        List<Contact> contactsToUpdate = new List<Contact>();
        List<Account> accountsToUpdate = new List<Account>();
        
        // VOC 레코드에서 CustomerName__c와 Account__c 추출
        for (VOC__c voc : triggerNew) {
            VOCIds.add(voc.CustomerName__c);
            storeNames.add(voc.Account__c);
        }

        // 각 CustomerName__c에 대한 VOC 레코드 수 계산 및 Contact 업데이트
        for (Id VOCId : VOCIds) {
            Integer VOCCount = calculateVOCCountForCustomer(VOCId);
            
            // Contact 레코드를 식별하여 업데이트
            Contact contactToUpdate = [SELECT Id FROM Contact WHERE Id = :VOCId LIMIT 1];
            if (contactToUpdate != null) {
                contactToUpdate.VOC_Count__c = VOCCount;
                contactsToUpdate.add(contactToUpdate);
            }
        }

        // 각 Account__c에 대한 VOC 레코드 수 계산 및 Account 업데이트
        for (String storeName : storeNames) {
            Integer accountVOCCount = calculateVOCCountForAccount(storeName);
            
            // Account 레코드를 식별하여 업데이트
            Account accountToUpdate = [SELECT Id FROM Account WHERE Name = :storeName LIMIT 1];
            if (accountToUpdate != null) {
                accountToUpdate.Total_VOC_Count__c = accountVOCCount;
                accountsToUpdate.add(accountToUpdate);
            }
        }


        // Contact 및 Account 업데이트
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

    // CustomerName__c에 대한 VOC 레코드 수 계산
    private static Integer calculateVOCCountForCustomer(Id customerId) {
        return [SELECT COUNT() FROM VOC__c WHERE CustomerName__c = :customerId];
    }

    // Account__c에 대한 VOC 레코드 수 계산
    private static Integer calculateVOCCountForAccount(String accountName) {
        return [SELECT COUNT() FROM VOC__c WHERE Account__c = :accountName];
    }
}