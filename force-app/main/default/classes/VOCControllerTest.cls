@isTest
private class VOCControllerTest {

    // 일치하는 시나리오에 대한 테스트
    @isTest
    private static void testSearchCustomersWithMatch() {
        // 테스트 데이터 준비
        List<Sales_Product__c> testSalesProducts = TestDataFactory.createSalesProducts(10);

        // 일치할 전화번호 설정
        String matchingPhoneNumber = '010-1234-0200';

        // 테스트 시작
        Test.startTest();

        // 테스트할 메서드 호출
        Map<String, Object> result = VOCController.searchCustomers(matchingPhoneNumber, 1, 1);

        // 테스트 종료
        Test.stopTest();

        // 결과 검증
        System.assertNotEquals(null, result, '결과는 null이 아니어야 합니다.');
        System.assertEquals(true, result.containsKey('data'), '결과에는 데이터 키가 있어야 합니다.');
        List<Sales_Product__c> salesProducts = (List<Sales_Product__c>)result.get('data');
        System.assertEquals(1, salesProducts.size(), '전화번호와 일치하는 레코드가 하나 있어야 합니다.');
    }

}