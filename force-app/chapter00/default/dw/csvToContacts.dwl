%dw 2.0
input records application/csv
output application/apex
---
records map(record) -> {
 firstname: record.firstname,
 lastname: record.lastname,
 email: record.email,
 phone: record.phone,
 mailingStreet: record.mailingStreet,
 mailingCity: record.mailingCity,
 mailingState: record.mailingState,
 mailingPostalCode: record.mailingPostalCode,
 mailingCountry: record.mailingCountry,
 title: record.title,
 description: record.description
} as Object {class: "Contact"}