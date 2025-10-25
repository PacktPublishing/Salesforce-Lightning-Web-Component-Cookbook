export const WIDE_COLUMNS_DEFINITION = [
    {
        type: 'text',
        fieldName: 'Name',
        label: 'Name'
    },
    {
        type: 'text',
        fieldName: 'Department__c',
        label: 'Department'
    },
    {
        type: 'picklistColumn',
        fieldName: 'DisplayStatus',
        label: 'Display Status',
        editable: {fieldName : 'statusEditable'},
        typeAttributes : {
            label: {fieldName: 'statusLabel'},
            value: {fieldName: 'statusValue'},
            placeholder: {fieldName: 'statusPlaceholder'},
            options: {fieldName: 'statusOptions'}
        }
    },
    {
        type: 'searchColumn',
        fieldName: 'Consumer',
        label: 'Most Recent Consumer Inquiry',
        editable: {fieldName : 'consumerEditable'},
        typeAttributes : {
            label: {fieldName: 'consumerLabel'},
            value: {fieldName: 'consumerValue'}
        }
    }
];

export const NARROW_COLUMNS_DEFINITION = [
    {
        type: 'text',
        fieldName: 'Name',
        label: 'Name'
    },
    {
        type: 'text',
        fieldName: 'Is_Public_Domain__c',
        label: 'Public Domain?'
    }
];