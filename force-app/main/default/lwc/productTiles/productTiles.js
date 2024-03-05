import { LightningElement, track, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import { refreshApex } from '@salesforce/apex';
import getProducts from '@salesforce/apex/ProductController.getProducts';
import getLaptopProducts from '@salesforce/apex/ProductController.getLaptopProducts';
import getGeneralDeviceProducts from '@salesforce/apex/ProductController.getGeneralDeviceProducts';
import PRODUCTM from '@salesforce/messageChannel/ProductMessageChannel__c';
import LAPTOPPRODUCTM from '@salesforce/messageChannel/LaptopProductMessageChannel__c';
import GENERALPRODUCTM from '@salesforce/messageChannel/GeneralProductMessageChannel__c';

export default class ProductTiles extends LightningElement {

    @track selectedProductId;
    @track selectedNotebookProductId;
    @track selectedGeneralDeviceProductId;

    @track products;
    @track notebookProducts;
    @track generalDeviceProducts;

    @wire(MessageContext)
    messageContext;
    @wire(MessageContext)
    messageContexttwo;
    @wire(MessageContext)
    messageContextthree;

    @wire(getProducts)
    wiredProducts({ data, error }) {
        if (data) {
            this.products = data;
        } else if (error) {
            console.error('Error fetching products:', error);
        }
    }

    @wire(getLaptopProducts)
    wiredLaptopProducts({ data, error }) {
        if (data) {
            this.notebookProducts = data;
        } else if (error) {
            console.error('노트북 제품 데이터 가져오기 오류:', error);
        }
}

    @wire(getGeneralDeviceProducts)
    wiredGeneralDeviceProducts({ data, error }) {
        if (data) {
            this.generalDeviceProducts = data;
        } else if (error) {
            console.error('주변 기기 제품 데이터 가져오기 오류:', error);
        }
}

    updateSelectedTile(event) {
        this.selectedProductId = event.detail.productId;
        this.selectedNotebookProductId = event.detail.notebookProductId;
        this.selectedGeneralDeviceProductId = event.detail.generalDeviceProductId;
        this.sendMessageService(this.selectedProductId);
        this.sendNotebookMessageService(this.selectedNotebookProductId);
        this.sendGeneralDeviceMessageService(this.selectedGeneralDeviceProductId);
    }

    sendMessageService(productId) {
        publish(this.messageContext, PRODUCTM, { recordId: productId });
    }
    
    sendNotebookMessageService(notebookproductId) {
        publish(this.messageContexttwo, LAPTOPPRODUCTM, { recordId: notebookproductId });
    }
    
    sendGeneralDeviceMessageService(generaldeviceproductId) {
        publish(this. messageContextthree, GENERALPRODUCTM, { recordId: generaldeviceproductId });
    }

    notifyLoading(isLoading) {
        const loadingEvent = isLoading ? 'loading' : 'doneloading';
        this.dispatchEvent(new CustomEvent(loadingEvent));
    }

    async refresh() {
        this.notifyLoading(true);
        await Promise.all([refreshApex(this.products), refreshApex(this.notebookProducts), refreshApex(this.generalDeviceProducts)]);
        this.notifyLoading(false);
    }
}