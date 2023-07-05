import { LightningElement,track,wire } from 'lwc';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity'
import STAGENAME_FIELD from '@salesforce/schema/Opportunity.StageName'
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import fetchOpportunity from '@salesforce/apex/espritApexController.fetchOpportunity';
import fetchOpportunityToUpdate from '@salesforce/apex/espritApexController.fetchOpportunityToUpdate';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class EspritSetOpportunities extends LightningElement {
    
    updateOpportunities = {objectApiName : OPPORTUNITY_OBJECT}
    @track allOpportunities = [];
    showSpinner = false;
    @track listUpdateOpportunities = [];
    pageSizeOptions = [{label:"10",value:"10"},{label:"20",value:"20"},{label:"40",value:"40"},{label:"80",value:"80"}]; //Page size options
    records = []; //All records available in the data table
    columns = []; //columns information available in the data table
    totalRecords = 0; //Total no.of records
    pageSize; //No.of records to be displayed per page
    totalPages; //Total no.of pages
    pageNumber = 1; //Page number    
    recordsToDisplay = [];
    @track wiredOpportunityList = []; 
    disableUpdateButton = false;

    @wire(getObjectInfo,{objectApiName:OPPORTUNITY_OBJECT})
    opportunityInfo;

    get bDisableFirst() {
        return this.pageNumber == 1;
    }
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }
    //fetch all opportunities
    @wire(fetchOpportunity) wiredOppotunities (result) {
        this.wiredOpportunityList = result;
        if (result.data) {

            this.allOpportunities = result.data;
            this.totalRecords = result.data.length; // update total records count    
            this.pageSize = this.pageSizeOptions[0].value; //set pageSize with default value as first option
            this.paginationHelper();
        } else if (result.error) {
            console.error('error',result.error);

        }}
       
        previousPage() {
            this.pageNumber = this.pageNumber - 1;
            this.paginationHelper();
        }
        nextPage() {
            this.pageNumber = this.pageNumber + 1;
            this.paginationHelper();
        }
        firstPage() {
            this.pageNumber = 1;
            this.paginationHelper();
        }
        lastPage() {
            this.pageNumber = this.totalPages;
            this.paginationHelper();
        }
        // JS function to handel pagination logic 
        paginationHelper() {
            this.recordsToDisplay = [];
            // calculate total pages
            this.totalPages = Math.ceil(this.totalRecords / parseInt(this.pageSize));
            // set page number 
            if (this.pageNumber <= 1) {
                this.pageNumber = 1;
            } else if (this.pageNumber >= this.totalPages) {
                this.pageNumber = this.totalPages;
            }
            // set records to display on current page 
            for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
                if (i === this.totalRecords) {
                    break;
                }
                this.recordsToDisplay.push(this.allOpportunities[i]);
            }
        }
    
    // fetch stage picklist values 
    @wire(getPicklistValues , {recordTypeId: '$opportunityInfo.data.defaultRecordTypeId',fieldApiName: STAGENAME_FIELD}) 
    stageNameValues;

    get pageSizeSelected() {
        
        return this.pageSize;

    }
    //handle all the input changes in Ui
    onChangeInput(event){
        let name = event.target.name; // fetch the name of the event called
        switch(name) {
            case 'stageName':
                this.stageName = event.target.value;
                this.disableUpdateButton = this.disableUpdate();
                break;

            case 'selectOpportunity': 
                if(event.target.checked) {
                    let test = event.currentTarget.dataset.id;
                    this.listUpdateOpportunities.push(test.toString());
                } else {
                    let test = event.currentTarget.dataset.id;
                    let index2 = this.listUpdateOpportunities.indexOf(test.toString());
                        if (index2 > -1) { // only splice array when item is found
                        this.listUpdateOpportunities.splice(index2, 1); // 2nd parameter means remove one item only
                        }
                }
                this.disableUpdateButton = this.disableUpdate();
                break;

                case 'pageSize':
                    this.pageSize = event.target.value;
                    this.paginationHelper();
                    break;
               

        }
    }
    onUpdateOpportunites(event) {
         this.showSpinner = true;
        fetchOpportunityToUpdate({oppIds:this.listUpdateOpportunities,stageName:this.stageName})
        .then(data => {
                location.reload() // load entire page
                this.showSpinner = false;
                //toast message when update of Opportunities is succesful
                const evt = new ShowToastEvent({
                    title: 'Toast Success',
                    message: 'Opportunities Updated sucessfully',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
            
        })
        .catch(error =>
            {               this.listUpdateOpportunities = [];

                const evt = new ShowToastEvent({
                    title: 'Toast Error',
                    message: 'Some unexpected error',
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                this.showSpinner = false;
                console.error('error',JSON.stringify(error));
            })
        
        
    }
    disableUpdate() {
        return !this.stageName || this.listUpdateOpportunities.length === 0;
    }

}