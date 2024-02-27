public class Constants {
    /**
    * 각 Class에 사용되는 모든 상수들을 모아놓는 class
    */

    //ProductController 상수
    public static final String NOTEBOOK = 'Notebook';
    public static final String GENENRAL_DEVICE = 'General Device';

    //ContactController 상수
    public static final String CONTACT_TYPE_COUNSELING = 'Counseling';
    public static final String CONTACT_TYPE_PURCHASE = 'Purchase'; 
    public static final Id CustomerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer').getRecordTypeId();

    //ContactTierBatch 상수
    public static final String A_TIER = 'A Tier';
    public static final String B_TIER = 'B Tier';
    public static final String C_TIER = 'C Tier';
    public static final String D_TIER = 'D Tier';
}