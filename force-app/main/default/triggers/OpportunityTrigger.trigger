trigger OpportunityTrigger on Opportunity (after insert ,after update) {
    OpportunityTriggerHandler opp_handler = OpportunityTriggerHandler.getInstance();
    if(Trigger.isAfter) {
        if(Trigger.isUpdate) {
            opp_handler.createTask(Trigger.new,Trigger.oldMap);
        }
        if(Trigger.isInsert) {
             opp_handler.createTask(Trigger.new);
        }
    }

}