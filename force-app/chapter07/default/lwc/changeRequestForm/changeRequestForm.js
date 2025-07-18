import { LightningElement, api } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';

import CHANGE_REQUEST from '@salesforce/schema/ChangeRequest'
import BUSINESS_JUSTIFICATION from '@salesforce/schema/ChangeRequest.BusinessJustification';
import BUSINESS_REASON from '@salesforce/schema/ChangeRequest.BusinessReason';
import CATEGORY from '@salesforce/schema/ChangeRequest.Category';
import DESCRIPTION from '@salesforce/schema/ChangeRequest.Description';
import SUBJECT from '@salesforce/schema/ChangeRequest.Subject';
import RISK_LEVEL from '@salesforce/schema/ChangeRequest.RiskLevel';
import PRIORITY from '@salesforce/schema/ChangeRequest.Priority';

import CHANGE_REQUEST_ITEM from '@salesforce/schema/ChangeRequestRelatedItem'
import CHANGE_REQUEST_ID from '@salesforce/schema/ChangeRequestRelatedItem.ChangeRequestId'
import ASSET_ID from '@salesforce/schema/ChangeRequestRelatedItem.AssetId'
import COMMENT from '@salesforce/schema/ChangeRequestRelatedItem.Comment'

export default class ChangeRequestForm extends LightningElement {
    @api recordId;
    changeRequestApiName = CHANGE_REQUEST;

    fields = [
        SUBJECT,
        CATEGORY,
        BUSINESS_REASON,
        BUSINESS_JUSTIFICATION,
        DESCRIPTION,
        RISK_LEVEL,
        PRIORITY
    ];

    async handleSuccess(event) {
        const fields = {};
        fields[CHANGE_REQUEST_ID.fieldApiName] = event.detail.id;
        fields[ASSET_ID.fieldApiName] = this.recordId;
        fields[COMMENT.fieldApiName] = event.detail.fields.BUSINESS_JUSTIFICATION;

        const recordInput = { apiName: CHANGE_REQUEST_ITEM.objectApiName, fields };

        await createRecord(recordInput)

        const successEvent = new CustomEvent('savesuccess', {
            bubbles: false,
            composed: false,
            detail: event.detail.id
        });

        this.dispatchEvent(successEvent);
    }
}