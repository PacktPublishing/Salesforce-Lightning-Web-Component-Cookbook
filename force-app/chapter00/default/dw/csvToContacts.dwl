%dw 2.0
input records application/csv
output application/apex
---
records map(record) -> {
 FirstName: record.firstname,
 LastName: record.lastname,
 Email: record.email,
 Phone: record.phone,
 MailingStreet: record.mailingStreet,
 MailingCity: record.mailingCity,
 MailingState: record.mailingState,
 MailingPostalCode: record.mailingPostalCode,
 MailingCountry: record.mailingCountry,
 Title: record.title,
 Description: record.description
} as Object {class: "Contact"}