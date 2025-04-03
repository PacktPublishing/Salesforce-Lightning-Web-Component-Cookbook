%dw 2.0
input records application/csv
output application/apex
---
records map(record) -> {
 Name: record.Name,
 Phone: record.Phone,
 BillingStreet: record.BillingStreet,
 BillingState: record.BillingState,
 BillingPostalCode: record.BillingPostalCode,
 BillingCountry: record.BillingCountry,
 Description: record.Description,
 AnnualRevenue: record.AnnualRevenue,
 Museum_Office__latitude__s: record.Museum_Office__latitude__s as Number,
 Museum_Office__longitude__s: record.Museum_Office__longitude__s as Number
} as Object {class: "Account"}