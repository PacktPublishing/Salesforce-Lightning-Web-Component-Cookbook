import LightningDatatable from 'lightning/datatable';
import picklistPlaceholderInaccessible from './picklistPlaceholderInaccessible.html';
import picklistSelectorInaccessible from './picklistSelectorInaccessible.html';
import consumerInquiryInaccessible from './consumerInquiryInaccessible.html';
import consumerEditInaccessible from './consumerEditInaccessible.html';

export default class PicklistDatatableinaccessible extends LightningDatatable {
    static customTypes = {
        picklistColumn : {
            template : picklistPlaceholderInaccessible,
            editTemplate: picklistSelectorInaccessible,
            standardCellLayout: true,
            typeAttributes: ['label', 'placeholder', 'options', 'value']
        },
        searchColumn : {
            template : consumerInquiryInaccessible,
            editTemplate: consumerEditInaccessible,
            standardCellLayout: true,
            typeAttributes: ['label', 'placeholder', 'value']
        }
    };
}