public class Constants {
    /**
    * 각 Class에 사용되는 모든 상수들을 모아놓는 class
    */

    //공용 
    public static final String BLANK_STRING = ' ';

    //ProductController 상수
    public static final String NOTEBOOK = 'Notebook';
    public static final String GENENRAL_DEVICE = 'General Device';

    //ContactController 상수
    public static final String CONTACT_TYPE_COUNSELING = 'Counseling';
    public static final String CONTACT_TYPE_PURCHASE = 'Purchase'; 
    public static final Id CUSTOMER_RECORD_TYPE_ID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
    public static final Id STAFF_RECORD_TYPE_ID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Staff').getRecordTypeId();

    //ContactTierBatch 상수
    public static final String A_TIER = 'A Tier';
    public static final String B_TIER = 'B Tier';
    public static final String C_TIER = 'C Tier';
    public static final String D_TIER = 'D Tier';

    // 
    //public static final Id A_TIER_ID = [SELECT Id FROM Tier__c WHERE Name = 'A Tier' LIMIT 1][0].Id;
    //public static final Id B_TIER_ID = [SELECT Id FROM Tier__c WHERE Name = 'B Tier' LIMIT 1][0].Id;
    //public static final Id C_TIER_ID = [SELECT Id FROM Tier__c WHERE Name = 'C Tier' LIMIT 1][0].Id;
    //public static final Id D_TIER_ID = [SELECT Id FROM Tier__c WHERE Name = 'D Tier' LIMIT 1][0].Id;

    // ContactPrdouctController 상수 
    public static final String CONTACT_PRODUCT_STATUS_PURCHASED = 'Purchased';
    public static final String CONTACT_PRODUCT_STATUS_REFUNDED = 'Refunded';

    // AccountControllerTest 상수
    public static final String TESTGETACCOUNTS_ACCOUNT_ASSERTION_MESSAGE = 'Account names do not match';


    //CounsultantTriggerHander 상수
    public static final String CONTACT_TOTAL_COUNT_ASSERTION_MESSAGE = 'Incorrect contact total consultation';
    public static final String ACCOUNT_TOTAL_COUNT_ASSERTION_MESSAGE = 'Incorrect account total consultation.';

    //ContactControllerTest 상수
    public static final String CONTACT_NAME_ASSERTION_MESSAGE = 'Contact names do not match';
}