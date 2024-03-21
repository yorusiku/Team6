public class VOCTriggerHandler {
    // VOC 카운트 업데이트 메서드
    public static void updateVOCCount(List<VOC__c> triggerNew, Map<Id, VOC__c> triggerOldMap) {
        Set<Id> contactIds = new Set<Id>();

        // 새로 추가되거나 업데이트된 VOC 레코드에서 연락처 ID 수집
        for (VOC__c voc : triggerNew) {
            if (voc.CustomerName__c != null) {
                contactIds.add(voc.CustomerName__c);
            }
        }

        // 연락처 ID를 통해 계정 ID 찾기
        Map<Id, Id> contactToAccountMap = getContactToAccountMap(contactIds);

        // 계정별 VOC 카운트 업데이트
        updateAccountVOCCounts(new Set<Id>(contactToAccountMap.values()));

        // 연락처별 VOC 카운트 업데이트
        updateContactVOCCounts(contactIds);
        
    }

    // VOC 카운트 삭제 시 업데이트 메서드
    public static void updateVOCCountOnDeleteTrigger(List<VOC__c> triggerOld, Map<Id, VOC__c> triggerOldMap) {
        Set<Id> contactIds = new Set<Id>();

        // 삭제될 VOC 레코드에서 연락처 ID 수집
        for (VOC__c voc : triggerOld) {
            if (voc.CustomerName__c != null) {
                contactIds.add(voc.CustomerName__c);
            }
        }

        // 연락처 ID를 통해 계정 ID 찾기
        Map<Id, Id> contactToAccountMap = getContactToAccountMap(contactIds);

        // 계정별 VOC 카운트 업데이트
        updateAccountVOCCounts(new Set<Id>(contactToAccountMap.values()));

        // 연락처별 VOC 카운트 업데이트
        updateContactVOCCounts(contactIds);
    }

    // 연락처 ID를 통해 계정 ID를 매핑하는 메서드
    private static Map<Id, Id> getContactToAccountMap(Set<Id> contactIds) {
        Map<Id, Id> contactToAccountMap = new Map<Id, Id>();
        for (Contact contact : [SELECT Id, AccountId FROM Contact WHERE Id IN :contactIds]) {
            if (contact.AccountId != null) {
                contactToAccountMap.put(contact.Id, contact.AccountId);
            }
        }
        return contactToAccountMap;
    }

    // 계정별 VOC 카운트를 업데이트하는 메서드
    private static void updateAccountVOCCounts(Set<Id> accountIds) {
        // 각 계정에 대한 현재 VOC 카운트 조회
        Map<Id, Integer> accountIdToVocCountMap = new Map<Id, Integer>();
        for (AggregateResult ar : [SELECT CustomerName__r.AccountId accId, COUNT(Id) cnt FROM VOC__c WHERE CustomerName__r.AccountId IN :accountIds GROUP BY CustomerName__r.AccountId]) {
            Id accId = (Id)ar.get('accId');
            Integer cnt = (Integer)ar.get('cnt');
            accountIdToVocCountMap.put(accId, cnt);
        }

        // 계정 레코드 업데이트 준비
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : accountIds) {
            // 해당 계정에 대한 현재 VOC 카운트를 가져오거나, 없는 경우 0으로 설정
            Integer vocCount = accountIdToVocCountMap.get(accountId) != null ? accountIdToVocCountMap.get(accountId) : 0;
            accountsToUpdate.add(new Account(Id = accountId, Total_VOC_Count__c = vocCount));
        }

        update accountsToUpdate;
    }

    // 연락처별 VOC 카운트를 업데이트하는 메서드
    private static void updateContactVOCCounts(Set<Id> contactIds) {
        // 각 연락처에 대한 현재 VOC 카운트 조회
        Map<Id, Integer> contactIdToVocCountMap = new Map<Id, Integer>();
        for (AggregateResult ar : [SELECT CustomerName__c conId, COUNT(Id) cnt FROM VOC__c WHERE CustomerName__c IN :contactIds GROUP BY CustomerName__c]) {
            Id conId = (Id)ar.get('conId');
            Integer cnt = (Integer)ar.get('cnt');
            contactIdToVocCountMap.put(conId, cnt);
        }

        // 연락처 레코드 업데이트 준비
        List<Contact> contactsToUpdate = new List<Contact>();
        for (Id contactId : contactIds) {
            // 해당 연락처에 대한 현재 VOC 카운트를 가져오거나, 없는 경우 0으로 설정
            Integer vocCount = contactIdToVocCountMap.get(contactId) != null ? contactIdToVocCountMap.get(contactId) : 0;
            contactsToUpdate.add(new Contact(Id = contactId, VOC_Count__c = vocCount));
        }

        update contactsToUpdate;
    }
}