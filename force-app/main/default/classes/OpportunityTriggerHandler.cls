public class OpportunityTriggerHandler {
    private static OpportunityTriggerHandler instance = null;
    //return instance of class 
    public static OpportunityTriggerHandler getInstance() {
        if(instance == null) {
            instance = new OpportunityTriggerHandler();
        }
        return instance;
    }
    //create task for after insert 
    public void createTask(List<Opportunity> newOpps) { 
       createOppTasks(newOpps);

    }
    // creation of task
    private void createOppTasks(List<Opportunity> newOpps) {
        List<task> tasksToCreate = new List<Task>();
        for(Opportunity newOpportunity:newOpps) {
            //Create a new task 
            Task oppTask = new Task();
            // Assign task
            oppTask.WhatID  = newOpportunity.Id;
            oppTask.Ownerid  = newOpportunity.Ownerid;
            oppTask.subject  = 'Validate Closed Opportunity';
            oppTask.Status	= 'In Progress';
            oppTask.Description = 'Please Validate Your Closed Opportunity';
            oppTask.IsReminderSet = true;
			oppTask.ReminderDateTime = System.now();
            oppTask.Priority = 'Normal';
            tasksToCreate.add(oppTask);
        }
        insert tasksToCreate;    
        }
        //creates task for owner on closed won opportunities
        public void createTask(List<Opportunity> newOpps,Map<Id,Opportunity> oldOpps) {
            if(newOpps.size() > 0) {
                for(Opportunity newOpportunity:newOpps) {
                    if(newOpportunity.StageName == 'Closed Won' && newOpportunity.StageName != oldOpps.get(newOpportunity.Id).StageName) {
                        //Create a new task 
                        createOppTasks(newOpps);
                    }
                }
            }
        }
        
    }