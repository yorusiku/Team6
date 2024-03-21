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

    //ContactProductController , ContactPurchaseAmountBatch 상수
    public static final String TOTAL_PRICE = 'totalPrice';
    public static final String TOTAL_NOTEBOOK_PRICE = 'totalNoteBookPrice';
    public static final String TOTAL_GENERAL_DEVICE_PRICE = 'totalGeneralDevicePrice';
    public static final String TOTAL_CUSTOMER_PURCHASE = 'totalCustomerPurchase';
    public static final String TOTAL_NOTEBOOK_PURCHASE = 'totalNotebookPurchasePurchase';
    public static final String TOTAL_GENERAL_DEVICE_PURCHASE = 'totalGeneralDevicePurchase';


    //ContactTierBatch 상수
    public static final String A_TIER = 'A Tier';
    public static final String B_TIER = 'B Tier';
    public static final String C_TIER = 'C Tier';
    public static final String D_TIER = 'D Tier';

    // SalesProductController 상수
    public static final String SALES_PRODUCT_STATUS_PURCHASED = '판매';
    public static final String SALES_PRODUCT_STATUS_REFUNDED = '환불';

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