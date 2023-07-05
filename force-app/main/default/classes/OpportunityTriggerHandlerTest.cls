@isTest
public class OpportunityTriggerHandlerTest {
    @testSetUp()
    public static void testSetUp() {
        Account testAccount = new Account(Name = 'TestAccount');
        insert testAccount;
        Opportunity testOpp = new Opportunity(StageName = 'Prospecting',AccountId = testAccount.Id,CloseDate = System.today()+90,Name='Test Opportunity');
        insert testOpp;
        
    }
    @isTest static void TestTaskOpportunity() {
        Opportunity opp = [Select Id,StageName from Opportunity];
        opp.StageName = 'Closed Won';
        // Perform test
        Test.startTest();
        Database.SaveResult result = Database.Update(opp, false);
        Test.stopTest();
        Task taskOpp = [Select Id from Task];
        Assert.isNotNull(taskOpp);
        
    }

}