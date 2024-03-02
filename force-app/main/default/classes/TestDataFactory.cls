/**
    * test class에서 필요한 기본 test data 및 메서드들을 위한 test utility class
    */
@isTest
public class TestDataFactory {

    // 판매점 테스팅 데이터를 만들어주는 메서드
    public static List<account> createAccount(Integer numAccts){
        List<Account> accts = new List<Account>();
            for(Integer i = 0 ; i <numAccts;i++) {
                Account a = new Account(
                Name = 'TestAccount' + i);
                accts.add(a);
            }
            insert accts;
        
        return accts;
    } 
    
    //  연락처 테스팅 데이터를 타입 , 레코드타입 별로 만들어주는 메서드
    public static List<Contact> createContact(Integer numContacts, String contactType, Id contactRecordTypeId){
        List<Contact> cons = new List<Contact>();
            for(Integer i = 0 ; i < numContacts ;i++) {
                Contact c = new Contact(
                    LastName = 'TestContact' + i, 
                    RecordTypeId = contactRecordTypeId,
                    Type__c = contactType);
                    cons.add(c);
            }
            insert cons;
        
        return cons;
    } 

    // 티어를 테스팅 하기 위한 티어 레코드를 만들어 주는 메서드
    public static Tier__c createTier(String tierName, Integer Minimum, Integer Maximum){
        Tier__c tier = new Tier__c(
            Name = tierName,
            Minimum_Purchase__c = 0,
            Maximum_Purchase__c = 0);
        insert tier;

        return tier;
    }
}