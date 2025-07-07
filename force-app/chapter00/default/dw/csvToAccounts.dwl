%dw 2.0
input records application/csv
output application/apex
---
records map(record) -> {
 Name: record.Name,
 Phone: record.phone,
 BillingStreet: record.billingStreet,
 BillingCity: record.billingCity,
 Description: record.description,
 AnnualRevenue: record.annualRevenue as Number,
 Museum_Office__latitude__s: record.Museum_Office__latitude__s as Number,
 Museum_Office__longitude__s: record.Museum_Office__longitude__s as Number
} as Object {class: "Account"}