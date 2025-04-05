import LightningDatatable from 'lightning/datatable';
import picklistPlaceholder from './picklistPlaceholder.html';
import picklistSelector from './picklistSelector.html';

export default class PicklistDatatable extends LightningDatatable {
    static customTypes = {
        picklistColumn : {
            template : picklistPlaceholder,
            editTemplate: picklistSelector,
            standardCellLayout: true,
            typeAttributes: ['label', 'placeholder', 'options', 'value', 'context', 'variant', 'name']
        }
    };
}