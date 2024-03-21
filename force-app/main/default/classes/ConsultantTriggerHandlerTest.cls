@isTest
private class ConsultantTriggerHandlerTest {
    /**
    * ConsulationTriggerHandler updateConsultationCount() 테스트 
    */
    @isTest
    private static void updateConsultationCount() {
        List<Consultant__c> testConsultant = TestDataFactory.createConsultant(1);

        Test.startTest();
        ConsultantTriggerHandler.updateConsultationCount(testConsultant);
        Test.stopTest();

        Integer accountConsultationCount;
        Integer contactConsultationCount;
        

        for(contact c : [SELECT Id, Consultation_Count__c FROM Contact]){
            for (Consultant__c cc : testConsultant){
                if(c.Id == cc.CustomerName__c){
                    contactConsultationCount = (c.Consultation_Count__c).intValue();
                }
            } 
        }

        for(account a : [SELECT Id, Total_Consultation_Count__c FROM Account]){
            for (Consultant__c cc : testConsultant){
                if(a.Id == cc.Account__c){
                    accountConsultationCount = (a.Total_Consultation_Count__c).intValue();
                }
            } 
        }

        System.assertEquals(testConsultant.size(), contactConsultationCount, Constants.CONTACT_TOTAL_COUNT_ASSERTION_MESSAGE);
        System.assertEquals(testConsultant.size(), accountConsultationCount, Constants.ACCOUNT_TOTAL_COUNT_ASSERTION_MESSAGE);
    }
}