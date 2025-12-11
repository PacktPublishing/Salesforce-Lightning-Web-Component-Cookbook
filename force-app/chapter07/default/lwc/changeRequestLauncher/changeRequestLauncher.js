import { LightningElement, api } from 'lwc';
import lwsEnabled from "@salesforce/customPermission/LWS_Enabler";
import changeRequestModal from 'c/changeRequestModal';
import changeRequestModalLws from 'c/changeRequestModalLws';
import { NavigationMixin } from 'lightning/navigation';

export default class ChangeRequestLauncher extends NavigationMixin(LightningElement) {
    @api recordId;

    @api invoke() {
        if(lwsEnabled) {
            console.log('LWS Permission Set Assigned');

            changeRequestModalLws.open({
                size: 'large',
                description: 'An LWS only modal to insert a new Change Request for the specified Asset.',
                content: {recordId : this.recordId},
                onrecordcreated: (event) => {
                    event.stopPropagation();
                    this.handleSaveSuccess(event.detail);
                }
            })
        } else {
            console.log('Lightning Locker Compatible');

            changeRequestModal.open({
                size: 'large',
                description: 'A modal to insert a new Change Request for the specified Asset.',
                content: {recordId : this.recordId}
            }).then((result) => {
                if(result) {
                    this.handleSaveSuccess(result.navId);
                }
            })
        }
    }

    handleSaveSuccess(id) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: id,
                objectApiName: 'ChangeRequest',
                actionName: 'view'
            }
        });
    }
}