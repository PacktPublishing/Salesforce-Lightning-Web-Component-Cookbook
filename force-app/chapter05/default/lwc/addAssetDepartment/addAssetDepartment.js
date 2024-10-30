import { LightningElement, api } from 'lwc';
import returnDepartmentsWrapper from '@salesforce/apex/AddAssetController.returnDepartmentsWrapper';
import Utilities from 'c/notifUtils';
let utility;

export default class AddAssetDepartment extends LightningElement {
    selectedDepartment;
    departmentsLoaded = false;
    options = [];

    @api get departmentId() {
        return this.selectedDepartment;
    }
    
    get resetDisabled() {
        return this.departmentId === undefined;
    }

    connectedCallback() {
        utility = new Utilities(this);
        this.loadDepartments();
    }

    async loadDepartments() {
        try {
            const data = await returnDepartmentsWrapper();

            if (data) {
                let temp = JSON.parse(data);
                let departments = [];
    
                for(let tmp of temp.departments) {
                    let tmpClone = {...tmp, label:tmp.displayName, value:tmp.departmentId};
                    departments.push(tmpClone);
                }
    
                departments.sort((a, b) => {
                        return (a.value - b.value) ? 1 : -1;
                    }
                );
    
                this.options = departments;
            }
            
            this.departmentsLoaded = true;
        }
        catch(error) {
            this.options = undefined;
            utility.showNotif('There has been an error!', error, 'error');
        }
    }

    handleDeptSelect(event) {
        this.selectedDepartment = +event.detail.value;
    }

    handleReset() {
        this.selectedDepartment = undefined;
    }
}