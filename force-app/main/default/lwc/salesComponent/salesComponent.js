import { LightningElement, wire, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
import getLaptopProducts from '@salesforce/apex/ProductController.getLaptopProducts';
import getGeneralDeviceProducts from '@salesforce/apex/ProductController.getGeneralDeviceProducts';
import addContactProducts from '@salesforce/apex/ContactProductController.addContactProducts';

export default class SalesComponent extends LightningElement {


      @api recordId;
      @track contactId;
      @track account = '';
      @track accounts = [];
      @track laptop = '';
      @track laptops = [];
      @track generalDevice = '';
      @track generalDevices = [];
      @track laptopQuantity = 0;
      @track generalDeviceQuantity = 0;
      @track orderDateTime;
      @track discount = 0;
      @track recordId;
      @track account;
    //   @track accounts = ['', '', ''];
    //   @track laptopRows = [];
      keyIndex = 0;
      @track laptopRows = [
        {
            id: 0
        }
    ];

      addRow(event) {
        const key = event.target.accessKey;
        const index = event.target.id;
        if (key === 'laptop') {
            this.addNewLaptopRow(index);
        } else if (key === 'generalDevice') {
            this.addNewGeneralDeviceRow(index);
        }
    }
  
      // 페이지 로드 시 contactId 값에 값을 recordId 할당.
      connectedCallback() {
          this.contactId = this.recordId;
      }
  
      addNewLaptopRow(index) {
        this.laptopRows.splice(index + 1, 0, { id: this.generateId() });
    }

    addNewGeneralDeviceRow(index) {
        this.generalDeviceRows.splice(index + 1, 0, { id: this.generateId() });
    }

    generateId() {
        return Math.random().toString(36)
    }
    
      // 모든 판매점을 데이터를 가져옴
      @wire(getAccounts)
      wiredAccounts({ error, data }) {
          if (data) {
              this.accounts = data.map(account => ({
                  label: account.Name,
                  value: account.Id
              }));
          } else if (error) {
              console.error('Error fetching accounts:', error);
          }
      }
  
      // 모든 노트북 제품 데이터를 가져옴 
      @wire(getLaptopProducts)
      wiredLaptops ({ error, data }) {
          if (data) {
              this.laptops = data.map(laptop => ({
                  label: laptop.Name,
                  value: laptop.Id
              }));
          } else if (error) {
              console.error('Error fetching accounts:', error);
          }
      }
  
      // 모든 주변기기 제품 데이터를 가져옴 
      @wire(getGeneralDeviceProducts)
      wiredGeneralDevices({ error, data }) {
          if (data) {
              this.generalDevices = data.map(generalDevice => ({
                  label: generalDevice.Name,
                  value: generalDevice.Id
              }));
          } else if (error) {
              console.error('Error fetching accounts:', error);
          }
      }
  
      // 선택한 판매점의 값을 가져옴 
      handleAccountSelection(event) {
          this.account = event.detail.value;
      }
  
      // 선택한 노트북 제품 값을 가져옴 
      handleLaptopSelection(event) {
          this.laptop = event.detail.value;
      }
  
      // 선택한 노트북 수량 값을 가져옴 
      handleLaptopQuantityCountChange(event) {
          this.laptopQuantity = parseInt(event.target.value, 10);
      }
  
      // 선택한 주변기기 제품 값을 가져옴 
      handleGeneralDeviceSelection(event){
          this.generalDevice = event.detail.value;
      }
  
       // 선택한 노트북 수량 값을 가져옴 
       handleGeneralDeviceQuantityCountChange(event) {
          this.generalDeviceQuantity = parseInt(event.target.value, 10);
      }
  
      // 선택한 주문 날짜 값을 가져옴 
      handleOrderDateTimeSelection(event){
          const selectedDateTimeString = event.target.value;
          this.orderDateTime = new Date(selectedDateTimeString).toISOString();
      }
  
      // 선택한 할인율을 가져옴 
      handleDiscountRateChange(event){
          this.discount= event.detail.value;
      }
  
      // 고객 제품 주문 생성 
      addContactProducts() {
          console.log(addContactProducts);
          if (!this.account || !this.contactId) return;
  
          addContactProducts({ contactId: this.contactId,  accountId: this.account, 
                              laptopId: this.laptop, laptopQuantity: this.laptopQuantity,
                              generalDeviceId: this.generalDevice, generalDeviceQuantity: this.generalDeviceQuantity,
                              orderDateTime: this.orderDateTime, discount: this.discount })
              .then(() => {
                  if(this.laptop && !this.generalDevice){
                      this.dispatchEvent(
                          new ShowToastEvent({
                              title: 'Success',
                              message: `${this.laptop}: ${this.laptopQuantity}개 주문이 접수되었습니다. 감사합니다 :)`,
                              variant: 'success'
                          })
                      );
                  }else if(!this.laptop && this.generalDevice){
                      this.dispatchEvent(
                          new ShowToastEvent({
                              title: 'Success',
                              message: `${this.generalDevice}: ${this.generalDeviceQuantity}개 주문이 접수되었습니다. 감사합니다 :)`,
                              variant: 'success'
                          })
                      );
                  }else if(this.laptop && this.generalDevice){
                      this.dispatchEvent(
                          new ShowToastEvent({
                              title: 'Success',
                              message: `${this.laptop}: ${this.laptopQuantity}개, ${this.generalDevice}: ${this.generalDeviceQuantity}개 주문이 접수되었습니다. 감사합니다 :)`,
                              variant: 'success'
                          })
                      );
                  }
              })
              .catch(error => {
                  console.error('Error creating records:', error);
                  this.dispatchEvent(
                      new ShowToastEvent({
                          title: 'Error',
                          message: error.body.message,
                          variant: 'error'
                      })
                  );
              });
      }







  }