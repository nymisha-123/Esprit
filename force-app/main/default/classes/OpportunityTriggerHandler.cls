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
        List<task> tasksToCreate = new List<Task>();
                for(Opportunity newOpportunity:newOpps) {
                    if(newOpportunity.StageName == 'Closed Won') {
                        //Create a new task 
                        Task oppTask = new Task();
                        // Assign task
                        oppTask.WhatID  = newOpportunity.Id;
                        oppTask.Ownerid  = newOpportunity.Ownerid;
                        oppTask.subject  = 'Validate '+newOpportunity.Name+' Closed Opportunity';
                        oppTask.Status	= 'In Progress';
                        oppTask.Description = 'Please Validate Your Closed Opportunity';
                        oppTask.IsReminderSet = true;
                        oppTask.ReminderDateTime = System.now();
                        oppTask.Priority = 'Normal';
                        tasksToCreate.add(oppTask);
                    }
                }
          createOppTasks(tasksToCreate);

    }
    // creation of task
    private void createOppTasks(List<Task> tasksToCreate) {
        
            try{
               insert tasksToCreate;    
            } catch(exception e) {
                throw new AuraHandledException(e.getMessage());
            } 
    	}
        //creates task for owner on closed won opportunities
        public void createTask(List<Opportunity> newOpps,Map<Id,Opportunity> oldOpps) {
            if(newOpps.size() > 0) {
                List<task> tasksToCreate = new List<Task>();
                for(Opportunity newOpportunity:newOpps) {
                    if(newOpportunity.StageName == 'Closed Won' && newOpportunity.StageName != oldOpps.get(newOpportunity.Id).StageName) {
                        //Create a new task 
                        Task oppTask = new Task();
                        // Assign task
                        oppTask.WhatID  = newOpportunity.Id;
                        oppTask.Ownerid  = newOpportunity.Ownerid;
                        oppTask.subject  = 'Validate '+newOpportunity.Name+' Closed Opportunity';
                        oppTask.Status	= 'In Progress';
                        oppTask.Description = 'Please Validate Your Closed Opportunity';
                        oppTask.IsReminderSet = true;
                        oppTask.ReminderDateTime = System.now();
                        oppTask.Priority = 'Normal';
                        tasksToCreate.add(oppTask);
                    }
                }
                   createOppTasks(tasksToCreate);

            }
        }
        
    }