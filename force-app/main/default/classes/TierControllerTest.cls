@isTest
private class TierControllerTest {

    /**
    * TierController AssignTier 테스트
    */
    @isTest
    private static void testAssignTier() {
        Tier__c testTier = TestDataFactory.createTier(Constants.B_TIER, 2000000, 4999999);
    
        Test.startTest();
        Tier__c tc = TierController.assignTier(Constants.B_TIER);
        Test.stopTest();

        System.assertEquals(tc.Name, testTier.Name, 'Tier names do not match');
        System.assertEquals(tc.Minimum_Purchase__c, testTier.Minimum_Purchase__c, 'Minimum Purchase do not match');
        System.assertEquals(tc.Maximum_Purchase__c, testTier.Maximum_Purchase__c , 'Maximum Purchase do not match');
    }
}