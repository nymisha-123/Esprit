public class OpportunitySelector {
   	public static List<String> oppStage = new List<String>{'Closed Won','Closed Lost'};
    public static List<Opportunity> fetchAllOpportunity(String condition) {
        List<Opportunity> allOpportunities = new List<Opportunity>();
        String oppQuery = 'Select Id,Account.Name,Name,StageName from Opportunity';
        if(String.isNotBlank(condition)) {
            oppQuery += ' where '+condition;
        } 
        allOpportunities = Database.query(oppQuery);
        return allOpportunities;
    }

}