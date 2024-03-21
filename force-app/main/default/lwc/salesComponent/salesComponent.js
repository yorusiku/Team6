import { LightningElement, wire, track, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { RefreshEvent } from "lightning/refresh";
import getAccounts from "@salesforce/apex/AccountController.getAccounts";
import getLaptopProducts from "@salesforce/apex/ProductController.getLaptopProducts";
import getGeneralDeviceProducts from "@salesforce/apex/ProductController.getGeneralDeviceProducts";
import addContactProducts from "@salesforce/apex/ContactProductController.addContactProducts";
import { LightningElement, wire, track, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { RefreshEvent } from "lightning/refresh";
import getAccounts from "@salesforce/apex/AccountController.getAccounts";
import getLaptopProducts from "@salesforce/apex/ProductController.getLaptopProducts";
import getGeneralDeviceProducts from "@salesforce/apex/ProductController.getGeneralDeviceProducts";
import addContactProducts from "@salesforce/apex/ContactProductController.addContactProducts";

export default class SalesComponent extends LightningElement {
  @api recordId;
  @track showMessage = false;
  @track recordId;
  @track contactId;
  @track account = "";
  @track accounts = [];
  @track laptop = "";
  @track laptops = [];
  @track laptopQuantity = 0;
  @track generalDevice = "";
  @track generalDevices = [];
  @track generalDeviceQuantity = 0;
  @track orderDateTime;
  @track discount = 0;
  @track products = [];
  @track rowIndex = "";
  @track lapTopRowId = "";
  @track generalDeviceRowId = "";
  @track productRecordId = "";
  @track isloading = false;

  @track totalPrice = {
    originalTotalPrice: 0,
    laptopTotalPrice: 0,
    generalDeviceTotalPrice: 0,
    discountAmount: 0,
    discountedPrice: 0
  };
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
      isCharged: false
    }
  ];

  @track generalDeviceRows = [
    {
      id: 0,
      isCharged: false
    }
  ];

  // 페이지 로드 시 contactId 값에 값을 recordId 할당.
  connectedCallback() {
    this.orderDateTime = new Date().toISOString();
    this.contactId = this.recordId;
    this.generalDeviceRows = [];
    this.laptopRows = [];
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
    if (
      this.products.length > 0 &&
      this.products[this.products.length - 1].type !== null &&
      this.products[this.products.length - 1].quantity === 0
    ) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: "수량 없음",
          message: "수량을 입력하세요",
          variant: "warning"
        })
      );
    } else if (
      this.laptopRows.length !== 0 &&
      this.laptopRows[this.laptopRows.length - 1].isCharged === false
    ) {
      console.log("laptoprows", JSON.parse(JSON.stringify(this.laptopRows)));
      this.dispatchEvent(
        new ShowToastEvent({
          title: "모델 선택",
          message: "노트북 모델이 선택되지 않았습니다",
          variant: "warning"
        })
      );
      console.log("노트북 물품이 추가되지 않았습니다");

      return;
    } else {
      const newRowId = this.generateId();
      this.lapTopRowId = newRowId;
      this.laptopRows.push({ id: newRowId, isCharged: false });
      console.log("laptoprows", JSON.parse(JSON.stringify(this.laptopRows)));
    }
    // this.updateProduct("laptop", "temp", 1, this.lapTopRowId);
  }

  addNewGeneralDeviceRow(index) {
    if (
      this.products.length > 0 &&
      this.products[this.products.length - 1].type !== null &&
      this.products[this.products.length - 1].quantity === 0
    )
      this.dispatchEvent(
        new ShowToastEvent({
          title: "수량 입력",
          message: "수량을 입력하세요",
          variant: "warning"
        })
      );
    else if (
      this.generalDeviceRows.length !== 0 &&
      this.generalDeviceRows[this.generalDeviceRows.length - 1].isCharged === false
    ) {
      console.log("laptoprows", JSON.parse(JSON.stringify(this.generalDeviceRows)));
      this.dispatchEvent(
        new ShowToastEvent({
          title: "모델 없음",
          message: "주변기기 모델이 선택되지 않았습니다",
          variant: "warning"
        })
      );

      return;
    } else {
      const newRowId = this.generateId();
      this.generalDeviceRowId = newRowId;
      this.generalDeviceRows.push({ id: newRowId, isCharged: false });
      // this.updateProduct("generalDevice", "temp", 1, this.generalDeviceRowId);
    }
  }

  ////행 삭제와 함께 추가된 물품 삭제
  removeLatestProductByType(type) {
    console.log("Before removal:", JSON.parse(JSON.stringify(this.products)));

    // 해당 타입의 제품들 중에서 제일 마지막에 있는 값을 찾아서 삭제

    const indexToRemove = this.products.reduceRight(
      (latestIndex, current, currentIndex, array) => {
        if (current.type === type && currentIndex > latestIndex) {
          return currentIndex;
        } else {
          return latestIndex;
        }
      },
      -1
    );

    // 최신값을 제외한 새로운 배열 생성
    if (indexToRemove !== -1) {
      this.products.splice(indexToRemove, 1);
    }

    console.log("After removal:", JSON.parse(JSON.stringify(this.products)));
  }

  deleteLastLaptopRow() {
    if (this.laptopRows.length > 0) {
      const lastLaptopRow = this.laptopRows[this.laptopRows.length - 1];
      if (lastLaptopRow) {
        if (lastLaptopRow.isCharged === false) {
          console.log("laptop is uncharged");
          this.laptopRows.pop();
        } else if (lastLaptopRow.isCharged === true) {
          console.log("laptop remove");
          this.removeLatestProductByType("laptop");
          this.laptopRows.pop();
        }
        console.log(this.laptopRows);
        this.calculateTotalPrice();
      }
    }
  }

  deleteLastGeneralDeviceRow() {
    if (this.generalDeviceRows.length > 0) {
      const lastGeneralDeviceRow =
        this.generalDeviceRows[this.generalDeviceRows.length - 1];
      console.log("l.g.d.r", JSON.parse(JSON.stringify(lastGeneralDeviceRow)));
      if (lastGeneralDeviceRow) {
        if (lastGeneralDeviceRow.isCharged === false) {
          console.log("device is uncharged");
          this.generalDeviceRows.pop();
        } else if (lastGeneralDeviceRow.isCharged === true) {
          console.log("device remove");
          this.removeLatestProductByType("generalDevice");
          this.generalDeviceRows.pop();
        }
        console.log(this.generalDeviceRows);
        this.calculateTotalPrice();
      }
    }
  }

  generateId() {
    return Math.random().toString(36);
  }
  generateId() {
    return Math.random().toString(36);
  }

  // 모든 판매점을 데이터를 가져옴
  @wire(getAccounts)
  wiredAccounts({ error, data }) {
    if (data) {
      this.accounts = data.map((account) => ({
        label: account.Name,
        value: account.Id
      }));
    } else if (error) {
      console.error("Error fetching accounts:", error);
    }
  }
  // 모든 판매점을 데이터를 가져옴
  @wire(getAccounts)
  wiredAccounts({ error, data }) {
    if (data) {
      this.accounts = data.map((account) => ({
        label: account.Name,
        value: account.Id
      }));
    } else if (error) {
      console.error("Error fetching accounts:", error);
    }
  }

  // 모든 노트북 제품 데이터를 가져옴
  @wire(getLaptopProducts)
  wiredLaptops({ error, data }) {
    if (data) {
      this.laptops = data.map((laptop) => ({
        label: laptop.Name,
        value: laptop.Id,
        price: laptop.Price__c
      }));
    } else if (error) {
      console.error("Error fetching accounts:", error);
    }
  }
  // 모든 노트북 제품 데이터를 가져옴
  @wire(getLaptopProducts)
  wiredLaptops({ error, data }) {
    if (data) {
      this.laptops = data.map((laptop) => ({
        label: laptop.Name,
        value: laptop.Id,
        price: laptop.Price__c
      }));
    } else if (error) {
      console.error("Error fetching accounts:", error);
    }
  }

  // 모든 주변기기 제품 데이터를 가져옴
  @wire(getGeneralDeviceProducts)
  wiredGeneralDevices({ error, data }) {
    if (data) {
      this.generalDevices = data.map((generalDevice) => ({
        label: generalDevice.Name,
        value: generalDevice.Id,
        price: generalDevice.Price__c
      }));
    } else if (error) {
      console.error("Error fetching accounts:", error);
    }
  }
  // 모든 주변기기 제품 데이터를 가져옴
  @wire(getGeneralDeviceProducts)
  wiredGeneralDevices({ error, data }) {
    if (data) {
      this.generalDevices = data.map((generalDevice) => ({
        label: generalDevice.Name,
        value: generalDevice.Id,
        price: generalDevice.Price__c
      }));
    } else if (error) {
      console.error("Error fetching accounts:", error);
    }
  }

  // 노트북 로우의 제품 가격을 찾는 함수
  getLaptopRowPrice(productId) {
    const filteredLaptop = this.laptops.find((item) => item.value === productId);
    return filteredLaptop ? filteredLaptop.price : 0;
  }
  // 노트북 로우의 제품 가격을 찾는 함수
  getLaptopRowPrice(productId) {
    const filteredLaptop = this.laptops.find((item) => item.value === productId);
    return filteredLaptop ? filteredLaptop.price : 0;
  }

  // 주변기기 로우의 제품 가격을 찾는 함수
  getGeneralDeviceRowPrice(productId) {
    const filteredGeneralDevice = this.generalDevices.find(
      (item) => item.value === productId
    );
    return filteredGeneralDevice ? filteredGeneralDevice.price : 0;
  }

  // handleWheel(event) {
  //   if (this.isLoading) {
  //     event.preventDefault();
  //     event.preventDefault();
  //   }
  // } line 207 - 212 마우스 휠 막는 함수

  // totalPrice 계산 메서드
  calculateTotalPrice() {
    if (
      this.laptops &&
      this.generalDevices &&
      this.discount !== undefined &&
      this.discount !== null
    ) {
      let laptopTotalPrice = 0;
      let generalDeviceTotalPrice = 0;

      // 노트북 제품 가격 계산
      if (this.products.some((product) => product.type === "laptop")) {
        laptopTotalPrice = this.products.reduce((total, product) => {
          if (product.type === "laptop") {
            const laptop = this.laptops.find(
              (item) => item.value === product.productId
            );
            return total + (laptop ? laptop.price : 0) * product.quantity;
          }
          return total;
        }, 0);
      }

      // 주변기기 제품 가격 계산
      if (this.products.some((product) => product.type === "generalDevice")) {
        generalDeviceTotalPrice = this.products.reduce((total, product) => {
          if (product.type === "generalDevice") {
            const generalDevice = this.generalDevices.find(
              (item) => item.value === product.productId
            );
            return (
              total + (generalDevice ? generalDevice.price : 0) * product.quantity
            );
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
      const formattedGeneralDeviceTotalPrice =
        generalDeviceTotalPrice.toLocaleString();

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

  // 새로운 제품 추가
  updateProduct(type, productId, quantity, rowIndex) {
    if (productId || quantity || rowIndex) {
      const existingProductIndex = this.products.findIndex(
        (product) => product.productId === productId
      );

      const newProduct = {
        type: type,
        productId: productId,
        quantity: quantity,
        rowIndex: rowIndex
      };

      // 중복된 rowIndex를 가진 오래된 배열 찾기
      const oldProductsIndex = this.products.findIndex(
        (item) => item.rowIndex === rowIndex
      );

      // 이전 값이 존재하면 해당 배열에서 변경
      if (oldProductsIndex !== -1) {
        const updatedProducts = [...this.products];
        updatedProducts[oldProductsIndex] = {
          ...updatedProducts[oldProductsIndex],
          productId: productId,
          quantity: quantity
        };

        this.products = updatedProducts;
      } else {
        if (type === "laptop" && this.laptopRows.length !== 0) {
          this.laptopRows[this.laptopRows.length - 1].isCharged = true;
        }
        if (type === "generalDevice" && this.generalDeviceRows.length !== 0) {
          this.generalDeviceRows[this.generalDeviceRows.length - 1].isCharged = true;
        }
        this.products.push(newProduct);
      }
      if (productId !== "") {
        if (quantity === 0 && oldProductsIndex === -1) {
          if (existingProductIndex !== -1) {
            this.dispatchEvent(
              new ShowToastEvent({
                title: "중복 모델",
                message: "이미 선택된 모델입니다. 다시 선택해주세요",
                variant: "error"
              })
            );
          }
          return;
        }
      }
      // this.products.push(newProduct);
    }

    console.log("products", JSON.parse(JSON.stringify(this.products)));
    this.calculateTotalPrice();
  }

  // 선택한 판매점의 값을 가져옴
  handleAccountSelection(event) {
    this.account = event.detail.value;
  }

  // 선택한 노트북 값 가져옴
  handleLaptopSelection(event) {
    const newLaptop = event.detail.value;
    const rowId = event.target.dataset.rowid;
    const rowIndex = event.target.dataset.rowindex;
    console.log(JSON.parse(JSON.stringify(rowId)));
    this.laptop = newLaptop;
    this.lapTopRowId = rowId;
    this.laptopRows.isCharged = true;
    this.updateProduct("laptop", newLaptop, 0, rowId);
    console.log("products", JSON.parse(JSON.stringify(this.products)));
  }

  // 선택한 노트북 수량 값을 가져옴
  handleLaptopQuantityCountChange(event) {
    const rowId = event.target.dataset.rowid;
    console.log(JSON.parse(JSON.stringify(rowId)));
    this.laptopQuantity = isNaN(parseInt(event.target.value, 10))
      ? 0
      : parseInt(event.target.value, 10);

    if (this.laptop === "" && parseInt(event.target.value, 10) > 0) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: "모델 없음",
          message: "물품을 선택해주세요",
          variant: "error"
        })
      );
      event.target.value = 0;
      return;
    }
    this.updateProduct("laptop", this.laptop, this.laptopQuantity, rowId);
    console.log("products", JSON.parse(JSON.stringify(this.products)));
  }

  // 선택한 주변기기 제품 값을 가져옴
  handleGeneralDeviceSelection(event) {
    const newGeneralDevice = event.detail.value;
    const rowId = event.target.dataset.rowid;
    const rowIndex = event.target.dataset.rowindex;
    console.log(JSON.parse(JSON.stringify(rowId)));
    this.generalDevice = newGeneralDevice;
    this.generalDeviceRowId = rowId;
    this.generalDeviceRows.isCharged = true;
    this.updateProduct("generalDevice", newGeneralDevice, 0, rowId);
  }

  // 선택한 주변기기 수량 값을 가져옴
  handleGeneralDeviceQuantityCountChange(event) {
    const rowId = event.target.dataset.rowid;
    console.log(JSON.parse(JSON.stringify(rowId)));
    this.generalDeviceQuantity = isNaN(parseInt(event.target.value, 10))
      ? 0
      : parseInt(event.target.value, 10);
    this.updateProduct(
      "generalDevice",
      this.generalDevice,
      this.generalDeviceQuantity,
      rowId
    );
  }

  // 선택한 주문 날짜 값을 가져옴
  handleOrderDateTimeSelection(event) {
    const selectedDateTimeString = event.target.value;
    // console.log(JSON.parse(JSON.stringify(event.target.value)));
    console.log(JSON.parse(JSON.stringify(selectedDateTimeString)));
    this.orderDateTime = new Date(selectedDateTimeString).toISOString();
  }

  // 선택한 할인율을 가져옴
  handleDiscountRateChange(event) {
    this.discount = parseInt(event.target.value, 10);
  // 선택한 할인율을 가져옴
  handleDiscountRateChange(event) {
    this.discount = parseInt(event.target.value, 10);

    if (event.target.value > 20) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: "할인율 제한",
          message: "할인율은 20%를 초과할 수 없습니다",
          variant: "error"
        })
      );
      event.target.value = 20;
      this.discount = parseInt(20, 10);
    }
    this.calculateTotalPrice();
  }

  afterFinished() {
    this.products = [];
    this.laptopRows = [];
    this.generalDeviceRows = [];
    this.laptops = [];
    this.generalDevices = [];
    this.contactId;
    this.account = "";
    this.accounts = [];
    this.laptop = "";
    this.dispatchEvent(new RefreshEvent());
  }

  // 고객 제품 주문 생성
  addContactProducts() {
    this.isloading = true;

    const uniqueProducts = this.products.reduce((acc, current) => {
      const isDuplicate = acc.some(
        (item) => item.type === current.type && item.productId === current.productId
      );
      if (!isDuplicate) {
        return acc.concat(
          Array.from({ length: current.quantity }, () => ({ ...current }))
        );
      } else {
        return acc;
      }
      const isDuplicate = acc.some(
        (item) => item.type === current.type && item.productId === current.productId
      );
      if (!isDuplicate) {
        return acc.concat(
          Array.from({ length: current.quantity }, () => ({ ...current }))
        );
      } else {
        return acc;
      }
    }, []);

    if (uniqueProducts.length > 0) {
      const sortedAndMergedProducts = uniqueProducts.sort((a, b) => {
        //  type으로 정렬
        const typeComparison = a.type.localeCompare(b.type);

        // 나머지 productId로 정렬
        if (typeComparison === 0) {
          return a.productId.toLowerCase().localeCompare(b.productId.toLowerCase());
        }

        return typeComparison;
      });

      const promises = sortedAndMergedProducts.map((product) => {
        const isLaptop = product.type === "laptop";
        const isGeneralDevice = product.type === "generalDevice";

        return () =>
          addContactProducts({
            contactId: this.contactId,
            accountId: this.account,
            orderDateTime: this.orderDateTime,
            discount: this.discount,
            laptopId: isLaptop ? product.productId : "",
            laptopQuantity: isLaptop ? 1 : 0,
            generalDeviceId: isGeneralDevice ? product.productId : "",
            generalDeviceQuantity: isGeneralDevice ? 1 : 0
          });
      });

      // 모든 주문을 처리하는 Promise

      function processPromisesSequentially(promises) {
        return promises.reduce((chain, promise) => {
          return chain.then(() => promise());
        }, Promise.resolve());
      }

      processPromisesSequentially(promises)
        .then(() => {
          this.isloading = false;
          // this.dispatchEvent(
          //   new ShowToastEvent({
          //     title: "주문 완료",
          //     message: "3초후 새로고침 됩니다",
          //     variant: "success"
          //   })
          // );

          location.reload();
        })
        .catch((error) => {
          // 주문 생성 중 오류가 발생한 경우
          this.isloading = false;
          console.error("Error creating records:", error);
          this.dispatchEvent(
            new ShowToastEvent({
              title: "네트워크 오류",
              message: "오류가 발생했습니다",
              variant: "error"
            })
          );
          afterFinished();
        });
    } else {
      // 주문할 제품이 없는 경우
      this.isloading = false;
      this.dispatchEvent(
        new ShowToastEvent({
          title: "모델 없음",
          message: "주문할 제품을 선택하세요.",
          variant: "warning"
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
//     if (existingProductIndex === -1 && productId) {
//         this.products = [...this.products, {
//             type: type,
//             productId: productId,
//             quantity: quantity
//         }];
//     }
// }