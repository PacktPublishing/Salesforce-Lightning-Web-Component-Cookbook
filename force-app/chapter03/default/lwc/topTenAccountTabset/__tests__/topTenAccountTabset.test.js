import { createElement } from 'lwc';
import TopTenAccountTabset from 'c/topTenAccountTabset';
import { returnAccountWrapperList } from '@salesforce/apex/TopAccountsController.returnAccountWrapperList';

const ACCOUNT_WRAPPER_STRING = `[
  {
    "Id": "accountId",
    "Name": "Test Account",
    "Phone": "123-456-7890",
    "BillingCity": "Denver",
    "BillingState": "CO",
    "BillingCountry": "USA",
    "AnnualRevenue": "1000000.00"
  }
]`;

jest.mock(
    '@salesforce/apex/TopAccountsController.returnAccountWrapperList',
    ()=>{
        const { createApexTestWireAdapter } = require("@salesforce/sfdx-lwc-jest");
        return {
            default: createApexTestWireAdapter(jest.fn()),
        };
    },
    {virtual: true}
);

describe('c-top-ten-account-tabset', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('should test wire function', () => {
        const element = createElement('c-top-ten-account-tabset', {
            is: TopTenAccountTabset
        });
        document.body.appendChild(element);

        returnAccountWrapperList.emit(ACCOUNT_WRAPPER_STRING);

        return Promise.resolve().then(() => {
            const tabs = element.shadowRoot.querySelectorAll('lightning-tab');
            expect(tabs.length).toBe(1);
            expect(tabs[0].label).toBe('Test Account');
        });
    });
});