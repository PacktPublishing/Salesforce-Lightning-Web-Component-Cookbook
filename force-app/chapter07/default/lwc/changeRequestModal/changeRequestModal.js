import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class ChangeRequestModal extends LightningModal {
    @api content;

    closeModal(event) {
        this.close({navId : event.detail})
    }
}