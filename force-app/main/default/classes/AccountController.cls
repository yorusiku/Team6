public with sharing class AccountController {
    
    /**
    * 모든 판매점들을 불러오는 method 
    */
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Id, Name 
                FROM Account
                WITH SECURITY_ENFORCED
                ORDER BY Name];
    }
}