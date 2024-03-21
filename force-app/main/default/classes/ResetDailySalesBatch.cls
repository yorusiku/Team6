global class ResetDailySalesBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        // 판매점 객체에 대한 쿼리
        String query = 'SELECT Id, Daily_Sales__c, LastDailyUpdate__c, Monthly_Sales__c, Annual_Sales__c, LastMonthlyUpdate__c, LastYearlyUpdate__c FROM Account';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Account> accounts) {
        List<Account> accountList = new List<Account>();
        Set<Id> processedAccountIds = new Set<Id>();
        Integer year = Date.today().year();
        Integer month = Date.today().month();
        
        for (Account acc : accounts) {
                if(acc.Id != '001IR00001pHNT2YAO') {
                // 중복 확인 및 중복 방지
                if (!processedAccountIds.contains(acc.Id)) {
                acc.Daily_Sales__c = 0;
                acc.LastDailyUpdate__c = Date.today().day();
                // 월 업데이트 확인
                if(acc.LastMonthlyUpdate__c != month) {
                    acc.Monthly_Sales__c = 0;
                    acc.LastMonthlyUpdate__c = month;
                }
                // 연 업데이트 확인
                if(acc.LastYearlyUpdate__c != year) {
                    acc.Annual_Sales__c = 0;
                    acc.LastYearlyUpdate__c = year;
                }
                
                accountList.add(acc);
                processedAccountIds.add(acc.Id); // ID를 추적하는 세트에 추가
            }
        }
        
    }
        if(!accountList.isEmpty()) {
            System.debug('Updated accountList: ' + accountList);
            update accountList; // 변경 사항 저장
        }
}
    
    global void finish(Database.BatchableContext BC) {
    }
}