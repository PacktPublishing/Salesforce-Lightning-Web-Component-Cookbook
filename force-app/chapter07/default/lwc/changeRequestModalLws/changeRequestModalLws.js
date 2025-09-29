import { api } from 'lwc';
import LightningModal from 'lightning/modal';
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

export default class ChangeRequestModal extends LightningModal {
    @api content;
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
        fields[ASSET_ID.fieldApiName] = this.content.recordId;
        fields[COMMENT.fieldApiName] = event.detail.fields.BUSINESS_JUSTIFICATION.value;

        const recordInput = { apiName: CHANGE_REQUEST_ITEM.objectApiName, fields };

        await createRecord(recordInput);

        
        const recordCreatedEvent = new CustomEvent("recordcreated", {
            detail: event.detail.id
        });
        this.dispatchEvent(recordCreatedEvent);
        
        this.close();
    }
}