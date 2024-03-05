import { LightningElement, wire, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
import getLaptopProducts from '@salesforce/apex/ProductController.getLaptopProducts';
import getGeneralDeviceProducts from '@salesforce/apex/ProductController.getGeneralDeviceProducts';
import addContactProducts from '@salesforce/apex/ContactProductController.addContactProducts';

export default class SalesComponent extends LightningElement {

    @api recordId;
    @track recordId;
    @track contactId;
    @track account = '';
    @track accounts = [];
    @track laptop = '';
    @track laptops = [];
    @track laptopQuantity = 0;
    @track generalDevice = '';
    @track generalDevices = [];
    @track generalDeviceQuantity = 0;
    @track orderDateTime;
    @track discount = 0;
    @track products = [];
    @track rowIndex = '';

    @track totalPrice = {
        originalTotalPrice: 0,
        laptopTotalPrice: 0,
        generalDeviceTotalPrice: 0,
        discountAmount: 0,
        discountedPrice: 0
    };

//   @track accounts = ['', '', ''];
    keyIndex = 0;
    @track laptopRows = [
        {
            id: 0,
            quantity :0
        }
    ];

    @track generalDeviceRows = [
        {

            id:0,
            quantity:0
        }
    ];




    // 페이지 로드 시 contactId 값에 값을 recordId 할당.
    connectedCallback() {
        this.contactId = this.recordId;


        // const existingLaptopRow = this.laptopRows[0];
        // if (existingLaptopRow) {
        //     existingLaptopRow.id = this.generateId();
        //     this.currentLaptopRowId = existingLaptopRow.id;
        // }
    
        // // 주변기기 로우에 ID 부여
        // const existingGeneralDeviceRow = this.generalDeviceRows[0];
        // if (existingGeneralDeviceRow) {
        //     existingGeneralDeviceRow.id = this.generateId();
        //     this.currentGeneralDeviceRowId = existingGeneralDeviceRow.id;
        // }
    }


    addNewLaptopRow(index) {
        const newRowId = this.generateId();
        this.laptopRows.push({ id: newRowId });
        this.updateProduct('laptop', '', 1);
    }

    addNewGeneralDeviceRow(index) {
        const newRowId = this.generateId();
        this.generalDeviceRows.push({ id: newRowId });
        this.updateProduct('generalDevice', '', 1);
    }
    


    ////행 삭제와 함께 추가된 물품 삭제

    removeProductByRowId(rowId) {
        this.products = this.products.filter(item => item.rowId !== rowId);
    }

    deleteLastLaptopRow() {
        if (this.laptopRows.length > 1) {
            const lastRowId = this.laptopRows.pop().id;
            this.laptop = '';  
            this.laptopQuantity = 0;
            this.removeProductByRowId(lastRowId);
            console.log(this.laptopRows);
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'warning',
                    message: '1줄은 있어야 합니다',
                    variant: 'warning'
                })
            );
        }
    }
    
    deleteLastGeneralDeviceRow() {
        if (this.generalDeviceRows.length > 1) {
            const lastRowId = this.generalDeviceRows.pop().id;
            this.generalDevice = '';  
            this.generalDeviceQuantity = 0;
            this.removeProductByRowId(lastRowId);
            console.log(this.generalDeviceRows);
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'warning',
                    message: '1줄은 있어야 합니다',
                    variant: 'warning'
                })
            );
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
                value: laptop.Id,
                price: laptop.Price__c
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
                value: generalDevice.Id,
                price: generalDevice.Price__c
            }));
        } else if (error) {
            console.error('Error fetching accounts:', error);
        }
    }

        // 노트북 로우의 제품 가격을 찾는 함수
    getLaptopRowPrice(productId) {
        const filteredLaptop = this.laptops.find(item => item.value === productId);
        return filteredLaptop ? filteredLaptop.price : 0; 
    }

    // 주변기기 로우의 제품 가격을 찾는 함수
    getGeneralDeviceRowPrice(productId) {
        const filteredGeneralDevice = this.generalDevices.find(item => item.value === productId);
        return filteredGeneralDevice ? filteredGeneralDevice.price : 0;
    }





    // totalPrice 계산 메서드
    calculateTotalPrice() {
        // 각 값이 존재하는지 확인
        if (this.laptops && this.generalDevices && (this.discount !== undefined && this.discount !== null)) {
            let laptopTotalPrice = 0;
            let generalDeviceTotalPrice = 0;
    
            // 노트북 제품 가격 계산
            if (this.products.some(product => product.type === 'laptop')) {
                laptopTotalPrice = this.products.reduce((total, product) => {
                    if (product.type === 'laptop') {
                        const laptop = this.laptops.find(item => item.value === product.productId);
                        return total + (laptop ? laptop.price : 0) * product.quantity;
                    }
                    return total;
                }, 0);
            }
    
            // 주변기기 제품 가격 계산
            if (this.products.some(product => product.type === 'generalDevice')) {
                generalDeviceTotalPrice = this.products.reduce((total, product) => {
                    if (product.type === 'generalDevice') {
                        const generalDevice = this.generalDevices.find(item => item.value === product.productId);
                        return total + (generalDevice ? generalDevice.price : 0) * product.quantity;
                    }
                    return total;
                }, 0);
            }
    
            const originalTotalPrice = laptopTotalPrice + generalDeviceTotalPrice;
            const discount = this.discount || 0;
            const discountAmount = originalTotalPrice * (discount / 100);
            const discountedPrice = originalTotalPrice - discountAmount;
    
            this.totalPrice = {
                originalTotalPrice,
                laptopTotalPrice,
                generalDeviceTotalPrice,
                discountAmount,
                discountedPrice
            };
    
        }
    }
    

    get totalPrices() {
        return this.calculateTotalPrice();
    }
    




    
    
    updateProduct(type, productId, quantity) {
        const existingProductIndex = this.products.findIndex(item => productId === item.productId);
    
        if (existingProductIndex !== -1) {
            // 이미 존재하면 업데이트
            if (this.products[existingProductIndex].quantity) {
                this.products[existingProductIndex].quantity = quantity;
            } else if (this.products[existingProductIndex].productId !== productId) {
                this.products[existingProductIndex].productId = productId;
            }
        } else {
            // 존재하지 않으면 추가
            const selectedProductIndex = this.products.findIndex(item => item.productId === productId && item.type === type);
    
            if (selectedProductIndex !== -1) {
                // 이미 선택된 경우 기존 제품 업데이트
                if (this.products[selectedProductIndex].productId !== productId || this.products[selectedProductIndex].quantity) {
                    this.products[selectedProductIndex].productId = productId;
                    this.products[selectedProductIndex].quantity = quantity;
                }
            } else {
                // 새로운 제품 추가
                if (productId) {
                    this.products.push({
                        type: type,
                        productId: productId,
                        quantity: quantity,
                    });
                }
            }
        }
    
        // 배열에서 기존 제품 제거 후 다시 추가
        if (existingProductIndex !== -1 && this.products[existingProductIndex].productId !== productId) {
            const removedProduct = this.products.splice(existingProductIndex, 1)[0];
            this.products.push(removedProduct);
        }
    
        console.log(JSON.parse(JSON.stringify(this.products)));
        this.calculateTotalPrice();
    }
    
    
    
    
    
    
    
    
    
    
        
            
    
    

    // 선택한 판매점의 값을 가져옴 
    handleAccountSelection(event) {
        this.account = event.detail.value;
    }

    
    // 선택한 노트북 값 가져옴
    handleLaptopSelection(event) {
        const newLaptop = event.detail.value;
        this.laptop = newLaptop;
        // this.updateProduct('laptop', newLaptop, this.laptopQuantity);
    }
    

    // 선택한 노트북 수량 값을 가져옴 
    handleLaptopQuantityCountChange(event) {
        this.laptopQuantity = isNaN(parseInt(event.target.value, 10)) ? 0 : parseInt(event.target.value, 10);
        this.updateProduct('laptop', this.laptop, this.laptopQuantity);
        this.calculateTotalPrice();    
    }
    

      // 선택한 주변기기 제품 값을 가져옴 
      handleGeneralDeviceSelection(event) {
        const newGeneralDevice = event.detail.value;
        this.generalDevice = newGeneralDevice
        // this.updateProduct('generalDevice', newGeneralDevice, this.generalDeviceQuantity);
    }

    // 선택한 주변기기 수량 값을 가져옴 
    handleGeneralDeviceQuantityCountChange(event) {
        this.generalDeviceQuantity = isNaN(parseInt(event.target.value, 10)) ? 0 : parseInt(event.target.value, 10);
        this.updateProduct('generalDevice', this.generalDevice, this.generalDeviceQuantity);
        this.calculateTotalPrice();  
    }
    

    // 선택한 주문 날짜 값을 가져옴 
    handleOrderDateTimeSelection(event){
        const selectedDateTimeString = event.target.value;
        this.orderDateTime = new Date(selectedDateTimeString).toISOString();
    }

      // 선택한 할인율을 가져옴 
      handleDiscountRateChange(event){
           this.discount = parseInt(event.target.value, 10);

           if(event.target.value > 20) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'warning',
                    message: '할인율 20 이상 불가',
                    variant: 'warning'
                })
                
            );
           }
          this.calculateTotalPrice();  
      }  


      // 고객 제품 주문 생성 
    addContactProducts() {
    const uniqueProducts = this.products.reduce((acc, current) => {
        const isDuplicate = acc.some(item => item.type === current.type && item.productId === current.productId);
        if (!isDuplicate) {
            return acc.concat(Array.from({ length: current.quantity }, () => ({ ...current })));
        } else {
            return acc;
        }
    }, []);

    // 주문 처리
    if (uniqueProducts.length > 0) {
        const promises = uniqueProducts.map(product => {
            return addContactProducts({
                contactId: this.contactId,
                accountId: this.account,
                orderDateTime: this.orderDateTime,
                discount: this.discount,
                laptopId: product.type === 'laptop' ? product.productId : '',
                laptopQuantity: product.type === 'laptop' ? 1 : 0,  
                generalDeviceId: product.type === 'generalDevice' ? product.productId : '',
                generalDeviceQuantity: product.type === 'generalDevice' ? 1 : 0  
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
                // location.reload();
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

        //   addRow(event) {
    //     const key = event.target.accessKey;
    //     const index = event.target.id;
    //     if (key === 'laptop') {
    //         this.addNewLaptopRow(index);
    //     } else if (key === 'generalDevice') {
    //         this.addNewGeneralDeviceRow(index);
    //     }
    // }


        // addToProducts(type, productId, quantity) {
    //     const existingProductIndex = this.products.findIndex(item => item.type === type && item.productId === productId);

    //     if (existingProductIndex === -1 && productId) {
    //         this.products = [...this.products, {
    //             type: type,
    //             productId: productId,
    //             quantity: quantity
    //         }];
    //     }
    // }