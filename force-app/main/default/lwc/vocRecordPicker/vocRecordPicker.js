import { LightningElement } from 'lwc';

export default class VocRecordPicker extends LightningElement {

    //화면 표시 대상
    
    displayInfo = {
        primaryField: 'CustomerName__c',
        additionalFields: ['Serial_Number__c'],
    };

    //검색대상

    matchingInfo={
        primaryField: { fieldPath: 'Phone' },
        additionalFields: [{ fieldPath: 'Customer_Name__c', operator: 'LIKE' }]
    };

    // 필터걸기

    // filter = {
    //     criteria: [
            
    //         {
    //             fieldPath: 'Phone',
    //             operator: 'like',
    //             value: '%010%',
    //         },
    //     ],
    // };


}