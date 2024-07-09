import { LightningElement, api } from 'lwc';
import getDepartmentsWrapper from '@salesforce/apex/AssetRetrievalInterface.getDepartmentsWrapper';
import Utilities from 'c/notifUtils';
let utility;

export default class AddAssetToAccount extends LightningElement {
    @api departmentId;
    departmentsLoaded = false;
    options = [];

    get resetDisabled() {
        return this.departmentId == undefined;
    }

    connectedCallback() {
        utility = new Utilities(this);
        this.loadDepartments();
    }

    async loadDepartments() {
        try {
            const data = await getDepartmentsWrapper();

            if (data) {
                let temp = JSON.parse(data);
                let departments = [];
    
                for(let tmp of temp.departments) {
                    let tmpClone = {...tmp, label:tmp.displayName, value:tmp.departmentId};
                    departments.push(tmpClone);
                }
    
                departments.sort((a, b) => a.label - b.label);
    
                this.options = JSON.parse(JSON.stringify(departments));
                this.error = undefined;
            }
            
            this.departmentsLoaded = true;
        }
        catch(error) {
            this.error = error;
            this.accounts = undefined;
            utility.showNotif('There has been an error!', this.error, 'error');
        }
    }

    handleDeptSelect(event) {
        this.departmentId = +event.detail.value;
    }

    handleReset() {
        this.departmentId = undefined;
    }
}