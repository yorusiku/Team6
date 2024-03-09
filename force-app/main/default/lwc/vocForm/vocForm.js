import { LightningElement, track } from 'lwc';
import searchCustomers from '@salesforce/apex/VOCController.searchCustomers'; // Apex 메소드 임포트
import { NavigationMixin } from 'lightning/navigation'; // 페이지 내비게이션을 위한 믹스인

const PAGE_SIZE = 10; // 한 페이지에 표시될 결과 수

export default class CustomerSearch extends NavigationMixin(LightningElement) {
    @track phoneNumberPattern = ''; // 입력된 전화번호
    @track searchResults; // 검색 결과
    @track currentPage = 1; // 현재 페이지 번호
    @track columns = [ // 데이터 테이블에 표시될 컬럼 정의
        { label: '구매제품', fieldName: 'Product_Name_Text__c' },
        { label: '시리얼번호', fieldName: 'Serial_Number__c', type: 'button', typeAttributes: { label: { fieldName: 'Serial_Number__c' }, name: 'generateVOC', variant: 'base' } },
        { label: '고객이름', fieldName: 'Contact__c' },
        { label: '전화번호', fieldName: 'CustomerNumber__c' },
        { label: '이메일', fieldName: 'Email__c' },
        { label: '판매점', fieldName: 'Account__c' },
        { label: '판매날짜', fieldName: 'Purchased_Date_Time_c__c' },
    ];

    // 전화번호 입력 필드 변경 핸들러
    handlePhoneChange(event) {
        this.phoneNumberPattern = event.target.value;
    }

    // 검색 실행 함수
    searchCustomers() {
        this.currentPage = 1; // 새 검색시 첫 페이지로 초기화
        this.fetchData();
    }

    // Apex로부터 데이터 가져오기
    fetchData() {
        searchCustomers({ phoneNumber: this.phoneNumberPattern, pageNumber: this.currentPage, pageSize: PAGE_SIZE })
            .then(result => {
                this.searchResults = result.data; // 검색 결과 저장
            })
            .catch(error => {
                this.searchResults = undefined; // 오류 발생시 검색 결과 초기화
            });
    }

    // 검색 버튼 활성화 조건
    get isSearchDisabled() {
        return this.phoneNumberPattern.length < 3;
    }

    // 첫 페이지 여부
    get isFirstPage() {
        return this.currentPage === 1;
    }

    // 마지막 페이지 여부
    get isLastPage() {
        return !this.searchResults || this.searchResults.length < PAGE_SIZE;
    }

    // 이전 페이지로 이동
    previousPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.fetchData();
        }
    }

    // 다음 페이지로 이동
    nextPage() {
        if (!this.isLastPage) {
            this.currentPage++;
            this.fetchData();
        }
    }

    // 검색 결과 닫기
    closeResults() {
        this.searchResults = undefined;
    }

    // 데이터 테이블에서 행 동작 처리 (시리얼 번호 선택)
    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        if (action.name === 'generateVOC') {
            // 선택된 Sales_Product__c ID를 사용하여 VOC__c 레코드 생성 페이지로 이동
            this.navigateToVOCRecordPage(row.Id);
            console.log(row.Id);
        }
    }

   // VOC__c 레코드 생성 페이지로 이동
    navigateToVOCRecordPage(salesProductId) {
    
        
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'VOC__c',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: `Sales_Product__c=${salesProductId}` // Sales_Product__c 필드 값 사전 채움
            }
        });
    }
}