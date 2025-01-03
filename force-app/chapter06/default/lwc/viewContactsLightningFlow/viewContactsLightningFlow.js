import { LightningElement } from 'lwc';

export default class ViewContactsLightningFlow extends LightningElement {
    get flowInputVariables() {
        return [
            {
                name: 'AccountId',
                type: 'String',
                value: this.recordId
            },
            {
                name: 'ContactId',
                type: 'String',
                value: this.selectedContact
            }
        ];
    }

    handleFlowStatusChange(event) {
        if (event.detail.status === 'FINISHED') {
            this.selectedContact = '';
            this.addEventInactive = true;

            this.refreshPage();

            utility.showNotif('Your event has been inserted successfully!', event.detail.outputVariables[0].value, 'success');
        }
    }
}