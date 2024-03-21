import { LightningElement, api, wire } from 'lwc';
import createVOCRecord from '@salesforce/apex/VOCController.createVOCRecord';

export default class VOCRecordCreation extends LightningElement {
    @api salesProductId;

    // VOC 레코드 생성을 위한 메소드
    createVOC() {
        createVOCRecord({ salesProductId: this.salesProductId })
            .then(result => {
                // 성공적으로 레코드가 생성되었을 때의 처리
            })
            .catch(error => {
                // 오류가 발생했을 때의 처리
            });
    }
}