import { api, LightningElement, wire, track } from "lwc";

const TILE_WRAPPER_SELECTED_CLASS = "tile-wrapper selected";
const TILE_WRAPPER_UNSELECTED_CLASS = "tile-wrapper";
import NAME_FIELD from "@salesforce/schema/Product2.Name";
import DESCRIPTION_FIELD from "@salesforce/schema/Product2.Description";
// import DESCRIPTION_FIELD from '@salesforce/schema/Product2.Description';
// import PHONE_FIELD from '@salesforce/schema/Account.Phone';
// import ANNUALREVENUE_FIELD from '@salesforce/schema/Account.AnnualRevenue';
// import ACCOUNT_OBJECT from '@salesforce/schema/Account';

export default class ProductTile extends LightningElement {
  @api product;
  @api notebookProduct;
  @api generalDeviceProduct;
  @api selectedProductId;
  @api selectedNotebookProductId;
  @api selectedGeneralDeviceProductId;
  @track objRecordId = "";
  @track fields = [NAME_FIELD];

  get backgroundStyle() {
    let backgroundImageUrl;
    if (this.product) {
      backgroundImageUrl = this.product.Image__c;
    } else if (this.notebookProduct) {
      backgroundImageUrl = this.notebookProduct.Image__c;
    } else if (this.generalDeviceProduct) {
      backgroundImageUrl = this.generalDeviceProduct.Image__c;
    }
    return "background-image:url(" + backgroundImageUrl + ")";
  }

  get tileClass() {
    if (this.product && this.product.Id === this.selectedProductId) {
      return TILE_WRAPPER_SELECTED_CLASS;
    } else if (
      this.notebookProduct &&
      this.notebookProduct.Id === this.selectedNotebookProductId
    ) {
      return TILE_WRAPPER_SELECTED_CLASS;
    } else if (
      this.generalDeviceProduct &&
      this.generalDeviceProduct.Id === this.selectedGeneralDeviceProductId
    ) {
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

    if (
      this.notebookProduct &&
      this.notebookProduct.Id === this.selectedNotebookProductId
    ) {
      this.selectedNotebookProductId = null;
      displayedProduct = this.notebookProduct;
    } else if (this.notebookProduct) {
      this.selectedNotebookProductId = this.notebookProduct.Id;
      displayedProduct = this.notebookProduct;
    }

    if (
      this.generalDeviceProduct &&
      this.generalDeviceProduct.Id === this.selectedGeneralDeviceProductId
    ) {
      this.selectedGeneralDeviceProductId = null;
      displayedProduct = this.generalDeviceProduct;
    } else if (this.generalDeviceProduct) {
      this.selectedGeneralDeviceProductId = this.generalDeviceProduct.Id;
      displayedProduct = this.generalDeviceProduct;
    }

    // fields = [
    //     Name,
    //     Family,
    //     Price__c,
    //     ProductCode
    // ]

    this.objRecordId = this.selectedProductId;
    console.log(this.objRecordId);
    const toolTipDiv = this.template.querySelector("div.ModelTooltip");
    toolTipDiv.style.opacity = 1;
    toolTipDiv.style.display = "block";

    const productselect = new CustomEvent("productselect", {
      detail: {
        productId: this.selectedProductId,
        notebookProductId: this.selectedNotebookProductId,
        generalDeviceProductId: this.selectedGeneralDeviceProductId
      }
    });

    this.dispatchEvent(new productselect());
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