import LightningDatatable from 'lightning/datatable';
import picklistPlaceholderAccessible from './picklistPlaceholderAccessible.html';
import picklistSelectorAccessible from './picklistSelectorAccessible.html';
import consumerInquiryAccessible from './consumerInquiryAccessible.html';
import consumerEditAccessible from './consumerEditAccessible.html';

export default class PicklistDatatableAccessible extends LightningDatatable {
    static customTypes = {
        picklistColumn : {
            template : picklistPlaceholderAccessible,
            editTemplate: picklistSelectorAccessible,
            standardCellLayout: true,
            typeAttributes: ['label', 'placeholder', 'options', 'value']
        },
        searchColumn : {
            template : consumerInquiryAccessible,
            editTemplate: consumerEditAccessible,
            standardCellLayout: true,
            typeAttributes: ['label', 'placeholder', 'value']
        }
    };
}