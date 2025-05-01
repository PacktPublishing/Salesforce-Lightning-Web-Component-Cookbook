import LightningDatatable from 'lightning/datatable';
import picklistPlaceholder from './picklistPlaceholder.html';
import picklistSelector from './picklistSelector.html';
import consumerInquiry from './consumerInquiry.html';
import consumerEdit from './consumerEdit.html';

export default class PicklistDatatable extends LightningDatatable {
    static customTypes = {
        picklistColumn : {
            template : picklistPlaceholder,
            editTemplate: picklistSelector,
            standardCellLayout: true,
            typeAttributes: ['label', 'placeholder', 'options', 'value']
        }, //chapter 10:
        searchColumn : {
            template : consumerInquiry,
            editTemplate: consumerEdit,
            standardCellLayout: true,
            typeAttributes: ['label', 'placeholder', 'value']
        }
    };
}