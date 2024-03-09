import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { LightningElement, api } from 'lwc';
export default class RefundButton extends LightningElement {
    @api recordId;
    
    handleRefund() {
        try {
            const fields = {};
            fields['Id'] = this.recordId;
            fields['Is_Refund__c'] = true;
            const recordInput = { fields };
            updateRecord(recordInput)
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: '환불이 정상적으로 처리되었습니다.',
                            variant: 'success'
                        })
                    );
                    // Reload the page to reflect the changes
                    location.reload();
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error updating record',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error.message,
                    variant: 'error'
                })
            );
        }
    }
}