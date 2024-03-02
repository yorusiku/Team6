public with sharing class TierController {

    /**
    * Name에 따라서 tier을 정해주는 method 
    */
    public static Tier__c assignTier(String tierName){
        Tier__c tier = [SELECT Id, Name, Minimum_Purchase__c, Maximum_Purchase__c 
                        FROM Tier__c WHERE Name =:tierName]; 
        
        return tier;
    }
}