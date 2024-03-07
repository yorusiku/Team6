import { LightningElement, track } from 'lwc';
import searchCustomers from '@salesforce/apex/VOCController.searchCustomers';

const columns = [
    { label: '이름', fieldName: 'Name' },
    { label: '전화번호', fieldName: 'Phone' },
    { label: '이메일', fieldName: 'Email' },
    { label: '고객유형', fieldName: 'Type__c' }
];

export default class CustomerSearch extends LightningElement {
    @track phoneNumber = '';
    @track searchResults;
    @track selectedCustomer;
    columns = columns;

    handlePhoneChange(event) {
        this.phoneNumber = event.target.value;
    }

    searchCustomers() {
        if (this.phoneNumber.length >= 3) {
            // 검색 버튼을 클릭할 때만 검색을 실행
            searchCustomers({ phoneNumber: this.phoneNumber })
                .then(result => {
                    this.searchResults = result;
                })
                .catch(error => {
                    console.error('Error:', error);
                });
        } else {
            this.searchResults = null; // 폰 번호가 3자리 미만이면 검색 결과를 null로 설정
        }
    }

    handleRowAction(event) {
        const selectedRow = event.detail.row;
        this.selectedCustomer = selectedRow;
    }
}