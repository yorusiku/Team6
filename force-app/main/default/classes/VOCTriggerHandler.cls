public with sharing class VOCTriggerHandler {

    // 이 클래스는 VOC 레코드를 기반으로 연락처와 그 연락처에 연결된 계정의 VOC 카운트를 업데이트합니다. 
    //연락처 ID를 수집한 후, 
    // 해당 연락처의 계정 ID를 찾고, 각 연락처와 계정에 대해 VOC 카운트를 계산하여 
    // 최종적으로 데이터베이스 내 연락처와 계정 레코드를 업데이트합니다.

    public static void updateVOCCount(List<VOC__c> triggerNew) {
        System.debug('updateVOCCount 메소드 시작.');

        Set<Id> contactIds = new Set<Id>();
        Map<Id, Set<Id>> accountToContactsMap = new Map<Id, Set<Id>>();
        List<Contact> contactsToUpdate = new List<Contact>();
        List<Account> accountsToUpdate = new List<Account>();

        // VOC 레코드를 순회하여 Contact ID들을 수집합니다
        for (VOC__c voc : triggerNew) {
            if (voc.CustomerName__c != null && voc.CustomerName__c.getSObjectType() == Contact.sObjectType) {
                contactIds.add(voc.CustomerName__c);
                System.debug('Contact ID 추가됨: ' + voc.CustomerName__c);
            }
        }

        // Contact들을 쿼리하여 해당 Account ID들을 가져옵니다
        for (Contact con : [SELECT Id, AccountId FROM Contact WHERE Id IN :contactIds]) {
            if (con.AccountId != null) {
                if (!accountToContactsMap.containsKey(con.AccountId)) {
                    accountToContactsMap.put(con.AccountId, new Set<Id>());
                }
                accountToContactsMap.get(con.AccountId).add(con.Id);
            }
        }

        System.debug('Contact ID들과 관련 Account ID들이 수집됨.');

        // 각 Contact 및 Account에 대한 VOC 카운트를 저장할 Map을 준비합니다
        Map<Id, Integer> contactVOCCounts = new Map<Id, Integer>();
        Map<Id, Integer> accountVOCCounts = new Map<Id, Integer>();

        // CustomerName__c별로 VOC 카운트를 쿼리하여 Map들을 채웁니다
        for (VOC__c voc : [SELECT CustomerName__c FROM VOC__c WHERE CustomerName__c IN :contactIds]) {
            if (contactIds.contains(voc.CustomerName__c)) {
                Integer count = contactVOCCounts.get(voc.CustomerName__c);
                contactVOCCounts.put(voc.CustomerName__c, (count == null ? 1 : count + 1));
                System.debug('Contact ID ' + voc.CustomerName__c + '에 대한 VOC 카운트 업데이트됨: ' + contactVOCCounts.get(voc.CustomerName__c));
            }
        }

        // Contact들의 VOC 카운트를 기반으로 Account별 VOC 카운트를 집계합니다
        for (Id accountId : accountToContactsMap.keySet()) {
            Integer accountTotal = 0;
            for (Id contactId : accountToContactsMap.get(accountId)) {
                Integer contactCount = contactVOCCounts.get(contactId);
                if (contactCount != null) {
                    accountTotal += contactCount;
                }
            }
            accountVOCCounts.put(accountId, accountTotal);
            System.debug('Account ID ' + accountId + '에 대한 집계된 VOC 카운트: ' + accountTotal);
        }

        // 업데이트할 Contact 리스트를 준비합니다
        for (Id contactId : contactIds) {
            contactsToUpdate.add(new Contact(Id = contactId, VOC_Count__c = contactVOCCounts.get(contactId)));
            System.debug('업데이트를 위해 준비된 Contact: ' + contactId);
        }

        // 집계된 카운트를 바탕으로 업데이트할 Account 리스트를 준비합니다
        for (Id accountId : accountVOCCounts.keySet()) {
            accountsToUpdate.add(new Account(Id = accountId, Total_VOC_Count__c = accountVOCCounts.get(accountId)));
            System.debug('업데이트를 위해 준비된 Account: ' + accountId);
        }

        // 업데이트할 Contact가 있으면 업데이트합니다
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
            System.debug('업데이트된 Contact 수: ' + contactsToUpdate.size());
        }

        // 업데이트할 Account가 있으면 업데이트합니다
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
            System.debug('업데이트된 Account 수: ' + accountsToUpdate.size());
        }

        System.debug('updateVOCCount 메소드 완료.');
    }
}