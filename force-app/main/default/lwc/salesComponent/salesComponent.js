import { LightningElement, wire, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { RefreshEvent } from 'lightning/refresh';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
import getLaptopProducts from '@salesforce/apex/ProductController.getLaptopProducts';
import getGeneralDeviceProducts from '@salesforce/apex/ProductController.getGeneralDeviceProducts';
import addContactProducts from '@salesforce/apex/ContactProductController.addContactProducts';

export default class SalesComponent extends LightningElement {

    @api recordId;
    @track showMessage = false;
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
    @track productRecordId= '';

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
        this.orderDateTime = new Date().toISOString();
        this.contactId = this.recordId;
        this.generalDeviceRows = [];
        this.laptopRows = [];


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
        this.updateProduct('laptop', '', 0);

    }

    addNewGeneralDeviceRow(index) {
        const newRowId = this.generateId();
        this.generalDeviceRows.push({ id: newRowId });
        this.updateProduct('generalDevice', '', 0);
    }
    


    ////행 삭제와 함께 추가된 물품 삭제
    removeLatestProductByType(type) {
        console.log("Before removal:", JSON.parse(JSON.stringify(this.products)));
    
        // 해당 타입의 제품들 중에서 제일 마지막에 있는 값을 찾아서 삭제
        const indexToRemove = this.products.reduceRight((latestIndex, current, currentIndex, array) => {
            if (current.type === type && currentIndex > latestIndex) {
                return currentIndex;
            } else {
                return latestIndex;
            }
        }, -1);
    
        // 최신값을 제외한 새로운 배열 생성
        if (indexToRemove !== -1) {
            this.products.splice(indexToRemove, 1);
        }
    
        console.log("After removal:", JSON.parse(JSON.stringify(this.products)));
    }
    
    
    
    


    deleteLastLaptopRow() {
        if (this.laptopRows.length > -1) {
            const lastRowId = this.laptopRows.pop().id;
            this.laptop = '';  
            this.laptopQuantity = 0;
            this.removeLatestProductByType('laptop'); // laptop에 해당하는 행 제거
            console.log(this.laptopRows);
            this.calculateTotalPrice();
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
        if (this.generalDeviceRows.length > -1) {
            const lastRowId = this.generalDeviceRows.pop().id;
            this.generalDevice = '';  
            this.generalDeviceQuantity = 0;
            this.removeLatestProductByType('generalDevice'); // generalDevice에 해당하는 행 제거
            console.log(this.generalDeviceRows);
            this.calculateTotalPrice();
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
                price: laptop.Price__c,
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
    
            const formattedOriginalTotalPrice = originalTotalPrice.toLocaleString();
            const formattedDiscountAmount = discountAmount.toLocaleString();
            const formattedDiscountedPrice = discountedPrice.toLocaleString();
            const formattedLaptopTotalPrice = laptopTotalPrice.toLocaleString();
            const formattedGeneralDeviceTotalPrice = generalDeviceTotalPrice.toLocaleString();

            this.totalPrice = {
                formattedOriginalTotalPrice,
                formattedGeneralDeviceTotalPrice,
                formattedLaptopTotalPrice,
                formattedDiscountAmount,
                formattedDiscountedPrice
            };
    
        }
    }
    

    get totalPrices() {
        return this.calculateTotalPrice();
    }
    




    
    
    updateProduct(type, productId, quantity) {
        // 새로운 제품 추가
        if (productId && quantity) {
            const newProduct = {
                type: type,
                productId: productId,
                quantity: quantity,
            
            };
    
            // 중복된 productId를 가진 오래된 배열 찾기
            const oldProducts = this.products.filter(item => item.productId === productId);
    
            // 이전 값이 존재하면 해당 배열에서 제거
            if (oldProducts.length > 0) {
                const updatedProducts = oldProducts.map(product => {
                    // 원하는 조건에 맞는 경우에만 수정
                    if (product.productId === productId && product.type === type) {
                        return {
                            ...product,
                            productId: productId,
                            quantity: quantity
                        };
                    }
                    // 조건에 맞지 않으면 그대로 반환
                    return product;
                });
    
                // 기존 배열에서 수정된 항목을 제외하고, 새로운 제품 추가
                this.products = this.products.filter(item => item.productId !== productId).concat(updatedProducts);
            } else {
                // 새로운 제품 추가
                this.products.push(newProduct);
            }
        }
    
        console.log(JSON.parse(JSON.stringify(this.products)));
        this.calculateTotalPrice();
    }
    
    

    // 선택한 판매점의 값을 가져옴 
    handleAccountSelection(event, rowid) {
        this.account = event.detail.value;

    }

    // 선택한 노트북 값 가져옴
    handleLaptopSelection(event, rowid) {
        const newLaptop = event.detail.value;
        this.laptop = newLaptop;

        // this.updateProduct('laptop', newLaptop, this.laptopQuantity);
    }
    // 선택한 노트북 수량 값을 가져옴 
    handleLaptopQuantityCountChange(event) {
        this.laptopQuantity = isNaN(parseInt(event.target.value, 10)) ? 0 : parseInt(event.target.value, 10);
        this.updateProduct('laptop', this.laptop, this.laptopQuantity);
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
    }
    

    // 선택한 주문 날짜 값을 가져옴 
    handleOrderDateTimeSelection(event){
        const selectedDateTimeString = event.target.value;
        // console.log(JSON.parse(JSON.stringify(event.target.value)));
        console.log(JSON.parse(JSON.stringify(new Date())));

        // this.orderDateTime = new Date().toISOString();
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



      
    afterFinished() {
        this.dispatchEvent(new RefreshEvent());

        this.products = [];
        this.laptopRows = [];
        this.generalDeviceRows = [];
        this.laptops = [];
        this.generalDevices = [];            
        this.contactId;
        this.account = '';
        this.accounts = [];
        this.laptop = '';

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
        const laptopProducts = uniqueProducts.filter(product => product.type === 'laptop');
        const generalDeviceProducts = uniqueProducts.filter(product => product.type === 'generalDevice');

        // ProductId 별로 정렬
        laptopProducts.sort((a, b) => a.productId.localeCompare(b.productId));
        generalDeviceProducts.sort((a, b) => a.productId.localeCompare(b.productId));

        // 정렬된 배열 다시 합치기
        const sortedAndMergedProducts = laptopProducts.concat(generalDeviceProducts);

        const promises = sortedAndMergedProducts.map(product => {
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
                        this.dispatchEvent(
                        new ShowToastEvent({
                            title: '주문 완료',
                            message: '3초후 새로고침 됩니다',
                            variant: 'success'
                        })
                    );
                    setTimeout(() => {
                        location.reload();
                    }, 3000);
            
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
        afterFinished();
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