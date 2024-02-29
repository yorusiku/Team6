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
    //   @track laptopRow = [];
      @track laptopQuantity = 0;
      @track generalDevice = '';
      @track generalDevices = [];
      @track generalDeviceQuantity = 0;
    //   @track generalDeviceRow = [];
      @track orderDateTime;
      @track discount = 0;
      @track recordId;
      @track account;
      @track products=[];
    //   @track accounts = ['', '', ''];
      keyIndex = 0;
        @track laptopRows = [
            {
                id: 0

            }
        ];

        @track generalDeviceRows = [
            {

                id:0
            }
        ];


    //   addRow(event) {
    //     const key = event.target.accessKey;
    //     const index = event.target.id;
    //     if (key === 'laptop') {
    //         this.addNewLaptopRow(index);
    //     } else if (key === 'generalDevice') {
    //         this.addNewGeneralDeviceRow(index);
    //     }
    // }
  
      // 페이지 로드 시 contactId 값에 값을 recordId 할당.
      connectedCallback() {
          this.contactId = this.recordId;
      }
  

    addNewLaptopRow(index) {
        this.laptopRows.push({ id: this.generateId()});
        console.log(laptopRows)
    }
    
    addNewGeneralDeviceRow(index) {
        this.generalDeviceRows.push({ id: this.generateId() });
        console.log(generalDeviceRows)
    }

    deleteLastLaptopRow() {
        if(this.laptopRows.length > 1){
            this.laptopRows.pop();
            console.log(laptopRows)
        }else {
            this.dispatchEvent(
            new ShowToastEvent({
                title: 'warning',
                message: '1줄은 있어야 합니다', 
                variant: 'warning'
            }))
        }
    }
    
    deleteLastGeneralDeviceRow() {
        if(this.generalDeviceRows.length >1) {
            this.generalDeviceRows.pop();
            console.log(generalDeviceRows)
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'warning',
                    message: '1줄은 있어야 합니다', 
                    variant: 'warning'
                }))
        }
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
  


      addToProducts(type, productId, quantity) {
        addToProducts('laptop', this.laptop, this.laptopQuantity);
        addToProducts('generalDevice', this.generalDevice, this.generalDeviceQuantity);
        if (productId && quantity) {
            this.products.push({
                type: type,
                productId: productId,
                quantity: quantity
            });
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

        // 선택한 주변기기 수량 값을 가져옴 
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
    //    // 노트북 정보 추가
    //    this.laptop.forEach(row => {
    //     if (row.laptop && row.laptopQuantity) {
    //         products.push({
    //             type: 'laptop', 
    //             productId: row.laptop, 
    //             quantity: row.laptopQuantity, 
    //         });
    //     }
    //     console.log(products[0])

    // });
    
    // // 주변기기 정보 추가
    // this.generalDevice.forEach(row => {
    //     if (row.generalDevice && row.generalDeviceQuantity) {
    //         products.push({
    //             type: 'device', 
    //             productId: row.generalDevice, 
    //             quantity: row.generalDeviceQuantity, 
    //         });
    //     }
    //     console.log(products[0])
    // });
        
        // 주문 처리
        console.log(products[0],products[1],products[2])

        if (products.length > 0) {
            // 주변기기와 노트북에 대한 정보를 모두 반복하여 처리
            const promises = products.map(product  => {
                return addContactProducts({
                    contactId: this.contactId,
                    accountId: this.account,
                    orderDateTime: this.orderDateTime,
                    discount: this.discount,

                    laptopId: products.type === 'laptop' ? product.productId : '',
                    laptopQuantity: products.type === 'laptop' ? product.quantity : 0, 
                    generalDeviceId: products.type === 'device' ? product.productId : '',
                    generalDeviceQuantity: products.type === 'device' ? product.quantity : 0
                });
            });
        
            // 모든 주문을 처리하는 Promise
            Promise.all(promises)
                .then(() => {
                    // 주문이 성공적으로 완료된 경우
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: '주문이 성공적으로 접수되었습니다. 감사합니다 :)',
                            variant: 'success'
                        })
                    );
                })
                .catch(error => {
                    // 주문 생성 중 오류가 발생한 경우
                    console.error('Error creating records:', error);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
        } else {
            // 주문할 제품이 없는 경우
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Warning',
                    message: '주문할 제품을 선택하세요.',
                    variant: 'warning'
                })
            );
        }
        
    }
  }