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
        fieldName: 'Status',
        label: 'Display Status',
        editable: true,
        typeAttributes : {
            label: {fieldName: 'statusLabel'},
            value: {fieldName: 'statusValue'},
            placeholder: {fieldName: 'statusPlaceholder'},
            options: {fieldName: 'statusOptions'}
        }
    },
    {
        type: 'searchColumn',
        fieldName: 'consumerName',
        label: 'Most Recent Consumer Inquiry',
        editable: true,
        typeAttributes : {
            consumerName: {fieldName: 'consumerName'},
            consumerId: {fieldName: 'consumerId'},
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