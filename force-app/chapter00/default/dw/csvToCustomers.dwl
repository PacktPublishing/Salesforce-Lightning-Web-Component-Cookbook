%dw 2.0
input records application/csv
output application/apex
---
records map(record) -> {
 Name: record.Name,
 TotalLifeTimeValue: record.TotalLifeTimeValue as Number
} as Object {class: "Customer"}