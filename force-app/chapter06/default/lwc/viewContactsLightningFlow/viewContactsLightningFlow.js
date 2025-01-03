import { LightningElement, api } from 'lwc';

export default class ViewContactsLightningFlow extends LightningElement {
    @api accountId
    @api contactId;

    get flowInputVariables() {
        return [
            {
                name: 'AccountId',
                type: 'String',
                value: this.accountId
            },
            {
                name: 'ContactId',
                type: 'String',
                value: this.contactId
            }
        ];
    }

    handleFlowStatusChange(event) {
        if (event.detail.status === 'FINISHED') {
            let updateSelectedContact = '';
            let updateAddEventInactive = true;

            const resetShellEvent = new CustomEvent('resetshell', {
                bubbles : false,
                composed : false,
                detail : {
                    selectedContact : updateSelectedContact,
                    addEventInactive : updateAddEventInactive,
                    outputVariables : event.detail.outputVariables[0].value    
                }
            });

            this.dispatchEvent(resetShellEvent);
        }
    }
}