import { LightningElement, api } from 'lwc';
import captureAccountGeolocationModal from 'c/captureAccountGeolocationModal';
import { NavigationMixin } from 'lightning/navigation';

export default class CaptureAccountGeolocationLauncher extends NavigationMixin(LightningElement) {
    @api recordId;

    @api invoke() {
        captureAccountGeolocationModal.open({
            size: 'large',
            description: 'A modal to grab the current device\'s geolocation for the specified Account.',
            content: {recordId : this.recordId},
            onsavesuccess: (event) => {
                event.stopPropagation();
                this.handleSaveSuccess(this.recordId);
            }
        })
    }

    handleSaveSuccess(id) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: id,
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
    }
}