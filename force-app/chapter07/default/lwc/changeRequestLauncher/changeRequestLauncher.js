import { LightningElement, api } from 'lwc';
import changeRequestModal from 'c/changeRequestModal';
// import changeRequestModalLws from 'c/changeRequestModalLws';
import { NavigationMixin } from 'lightning/navigation';

export default class ChangeRequestLauncher extends NavigationMixin(LightningElement) {
    @api recordId;

    @api invoke() {
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

    // @api invoke() {
    //     const result = changeRequestModalLws.open({
    //         size: 'large',
    //         description: 'A modal to insert a new Change Request for the specified Asset.',
    //         content: {recordId : this.recordId},
    //         onrecordcreated: (event) => {
    //             event.stopPropagation();
    //             this.handleSaveSuccess(event.detail);
    //         }
    //     })
    // }

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