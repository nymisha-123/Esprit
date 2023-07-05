public class espritApexController {
//fetch all opportunities which are not closed won
@AuraEnabled(cacheable = true)
public static list<OpportunityWrapper> fetchOpportunity(){ 
    List<OpportunityWrapper> allOpportunities = new List<OpportunityWrapper>();
	List<Opportunity> opportunityRecords = OpportunitySelector.fetchAllOpportunity('StageName not in:oppStage');
    for(Opportunity singleOpp : opportunityRecords) {
        OpportunityWrapper newOpp = new OpportunityWrapper();
        newOpp.opportunityId = singleOpp.Id;
        newOpp.opportunityName = singleOpp.Name;
        newOpp.opportunityAccountName = singleOpp.Account.Name;
        newOpp.opportunityStageName = singleOpp.StageName;
        allOpportunities.add(newOpp);    
    }
    return allOpportunities;
}
//update selected opportunities
@AuraEnabled
public static void fetchOpportunityToUpdate(List<String> oppIds,String stageName){ 
    List<Opportunity> oppList = new List<Opportunity>();
    for(String oppId: oppIds) {
        Opportunity oppToUpdate = new Opportunity();
        oppToUpdate.Id = oppId;
        oppToUpdate.StageName = StageName;
        oppList.add(opptoUpdate);
    }
    try{
        update oppList;
    } catch(exception e) {
        throw new AuraHandledException(e.getMessage());
    }
}
//wrapper to get all opportunity records
public class OpportunityWrapper {
    @AuraEnabled public String opportunityId {set;get;}
    @AuraEnabled public String opportunityName {set;get;}
    @AuraEnabled public String opportunityAccountName {set;get;}
    @AuraEnabled public String opportunityStageName {set;get;}
}

}