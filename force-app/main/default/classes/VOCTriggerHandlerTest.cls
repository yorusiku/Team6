@isTest
private class VOCTriggerHandlerTest {

    
    @isTest
    static void testUpdateVOCCount() {
        // 테스트 데이터 준비: 계정 생성
        List<Account> accounts = TestDataFactory.createAccount(1);
        Account testAccount = accounts[0];
        System.debug('계정 생성 완료: ' + testAccount);

        // 테스트 데이터 준비: 연락처 생성
        Contact testContact = new Contact(
            LastName = 'Test Contact',
            AccountId = testAccount.Id,
            Phone = '010-1234-1234'
        );

        insert testContact;
        System.debug('연락처 생성 및 계정 연결 완료: ' + testContact);

        // 테스트 데이터 준비: Sales_Product__c 레코드 생성
        List<Sales_Product__c> salesProducts = TestDataFactory.createSalesProducts(1);
        Sales_Product__c testSalesProduct = salesProducts[0];
        System.debug('판매된 제품 생성 완료: ' + testSalesProduct);

        // 테스트 데이터 준비: VOC 레코드 생성
        VOC__c testVOC = new VOC__c(
            Sales_Product__c = testSalesProduct.Id,
            CustomerName__c = testContact.Id,
            VOCType__c = '유지보수',
            Content__c = 'test content'
        );
        insert testVOC;
        System.debug('VOC 레코드 생성 완료: ' + testVOC);

        // 실행
        Test.startTest();
        VOCTriggerHandler.updateVOCCount(new List<VOC__c>{testVOC});
        Test.stopTest();
        System.debug('VOCTriggerHandler.updateVOCCount 실행 완료');

        // 검증
        testContact = [SELECT Id, VOC_Count__c FROM Contact WHERE Id = :testContact.Id];
        Account updatedAccount = [SELECT Id, Total_VOC_Count__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(1, testContact.VOC_Count__c, '연락처의 VOC 카운트가 정확하게 업데이트되어야 합니다.');
        System.assertEquals(1, updatedAccount.Total_VOC_Count__c, '관련 계정의 전체 VOC 카운트가 정확하게 업데이트되어야 합니다.');
    }
 
}