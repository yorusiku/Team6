import { api, LightningElement } from 'lwc';

const TILE_WRAPPER_SELECTED_CLASS = 'tile-wrapper selected';
const TILE_WRAPPER_UNSELECTED_CLASS = 'tile-wrapper';

export default class ProductTile extends LightningElement {
    @api product;
    @api notebookProduct;
    @api generalDeviceProduct;
    @api selectedProductId;
    @api selectedNotebookProductId;
    @api selectedGeneralDeviceProductId;

    get backgroundStyle() {
        let backgroundImageUrl;
        if (this.product) {
            backgroundImageUrl = this.product.Image__c;
        } else if (this.notebookProduct) {
            backgroundImageUrl = this.notebookProduct.Image__c;
        } else if (this.generalDeviceProduct) {
            backgroundImageUrl = this.generalDeviceProduct.Image__c;
        }
        return 'background-image:url(' + backgroundImageUrl + ')';
    }
    
    get tileClass() {
        if (this.product && this.product.Id === this.selectedProductId) {
            return TILE_WRAPPER_SELECTED_CLASS;
        } else if (this.notebookProduct && this.notebookProduct.Id === this.selectedNotebookProductId) {
            return TILE_WRAPPER_SELECTED_CLASS;
        } else if (this.generalDeviceProduct && this.generalDeviceProduct.Id === this.selectedGeneralDeviceProductId) {
            return TILE_WRAPPER_SELECTED_CLASS;
        }
        return TILE_WRAPPER_UNSELECTED_CLASS;
    }
    
    selectProduct() {
        let displayedProduct;

        if (this.product && this.product.Id === this.selectedProductId) {
            this.selectedProductId = null;
            displayedProduct = this.product;
        } else if (this.product) {
            this.selectedProductId = this.product.Id;
            displayedProduct = this.product;
        }
    
        if (this.notebookProduct && this.notebookProduct.Id === this.selectedNotebookProductId) {
            this.selectedNotebookProductId = null;
            displayedProduct = this.notebookProduct;
        } else if (this.notebookProduct) {
            this.selectedNotebookProductId = this.notebookProduct.Id;
            displayedProduct = this.notebookProduct;
        }
    
        if (this.generalDeviceProduct && this.generalDeviceProduct.Id === this.selectedGeneralDeviceProductId) {
            this.selectedGeneralDeviceProductId = null;
            displayedProduct = this.generalDeviceProduct;
        } else if (this.generalDeviceProduct) {
            this.selectedGeneralDeviceProductId = this.generalDeviceProduct.Id;
            displayedProduct = this.generalDeviceProduct;
        }
    
        const productselect = new CustomEvent('productselect', {
            detail: {
                productId: this.selectedProductId,
                notebookProductId: this.selectedNotebookProductId,
                generalDeviceProductId: this.selectedGeneralDeviceProductId 
            }
        });
    
        this.dispatchEvent(productselect);
    }

    handleProductSelect() {
        this.selectProduct();
    }

    handleNotebookProductSelect() {
        this.selectProduct();
    }

    handleGeneralDeviceProductSelect() {
        this.selectProduct();
    }
}