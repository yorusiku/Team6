import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import searchContactProductsByOrderCode from '@salesforce/apex/ContactProductController.searchContactProductsByOrderCode';
import addSalesProduct from '@salesforce/apex/ContactProductController.addSalesProduct';

export default class AddSalesProduct extends LightningElement {
    searchTerm = '';
    contactProducts;
    error;

    columns = [
        { label: '고객제품주문', fieldName: '제품명', type: 'text' },
        { label: '주문코드', fieldName: '주문코드', type: 'text' },
        { label: '주문제품', fieldName: '주문제품', type: 'text' },
        { label: '고객명', fieldName: '고객명', type: 'text' },
    ];

    @wire(searchContactProductsByOrderCode, { searchTerm: '$searchTerm' })
    wired_searchContactProductsByOrderCode(result) {
        if (result.data) {
            this.contactProducts = result.data.map(contactProduct =>
                ({
                    contactProductId: contactProduct.Id,
                    제품명: contactProduct.Name,
                    주문제품: contactProduct.Product_Name_Text__c,
                    주문코드: contactProduct.Order_Code__c,
                    고객명: contactProduct.Contact__r.Name
                })
            );
            this.error = null;
        } else if (result.error) {
            this.error = result.error;
            this.contactProducts = null;
        }
    }

    handleSearchTermChange(event) {
        window.clearTimeout(this.delayTimeout);
        const searchTerm = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.searchTerm = searchTerm.replace(/%/g, ''); // '%'를 제거한 형태로 검색어 정리
        }, 300);
    }

    get hasResults() {
        return this.contactProducts && this.contactProducts.length > 0;
    }

    handleSave() {
        if (this.searchTerm) {
            addSalesProduct({ orderCode: this.searchTerm })
                .then(() => {
                    this.showToast('등록완료', '판매제품이 성공적으로 등록되었습니다', 'success');
                })
                .catch(error => {
                    console.error('Error creating sales product: ', error);
                    this.showToast('에러', '판매 제품 등록에 문제가 있습니다', 'error');
                });
        }
    }
    
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}