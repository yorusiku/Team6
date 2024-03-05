/**
* 공용으로 사용하는 메서드들을 모아놓는 Class입니다
* 
*/
public with sharing class Utility {

    // Tier Id를 이름별로 return하는 메서드
    public static Id getTierId(String TierName){
        List<Tier__c> tierId = [SELECT Id FROM Tier__c WHERE Name = :TierName LIMIT 1]; 
   
        if(!tierId.isEmpty()){
            return tierId[0].Id;
        } else {
            return tierId[1].Id;
        }
    }
}