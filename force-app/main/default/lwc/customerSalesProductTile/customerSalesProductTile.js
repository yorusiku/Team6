import { LightningElement, track, wire, api } from "lwc";
import { getRecord } from "lightning/uiRecordApi";
import getSaleProducts from "@salesforce/apex/SalesProductController.getSaleProducts";

const FIELDS = ["Contact.Name"];

export default class CustomerSalesProductTile extends LightningElement {
  @api recordId;
  @track contact;
  @track salesProducts;
  @track error;
  // @track sortedData = [];
  contactName;
  product;

  // sortDataAndExecuteLogic() {
  //   // 데이터 정렬 및 추가 로직 실행
  //   data = data?.sort((a, b) => a.Id.localeCompare(b.Id)) || undefined;
  // }

  @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
  wiredContact({ error, data }) {
    if (data) {
      this.contact = data.fields;
      this.error = undefined;
      this.contactName = this.contact.Name.value;
      console.log("연락처 이름:", this.contactName);
    } else if (error) {
      this.error = error;
      this.contact = undefined;
    }
  }

  @wire(getSaleProducts, { contactName: "$contactName" })
  wiredSalesProducts({ error, data }) {
    if (data) {
      const newData = [...data];
      newData.sort((a, b) =>
        a.Product_Name_Text__c.localeCompare(b.Product_Name_Text__c)
      );
      this.salesProducts = newData;
      console.log(JSON.parse(JSON.stringify([...this.salesProducts])));
      this.error = undefined;
      console.log("판매 제품:", this.salesProducts);
    } else if (error) {
      this.error = error;
      this.salesProducts = undefined;
      console.error("판매 제품 가져오기 오류:", error);
    }
  }

  /////////////////////////////////////////////////////////
}