@isTest
public class espritApexControllerTest {
    @testSetUp()
    public static void testSetUp() {
        Account testAccount = new Account(Name = 'TestAccount');
        insert testAccount;
        Opportunity testOpp = new Opportunity(StageName = 'Prospecting',AccountId = testAccount.Id,CloseDate = System.today()+90,Name='Test Opportunity');
        insert testOpp;
        
    }
    @isTest
    static void testOppData() {
        List<espritApexController.OpportunityWrapper> allOpps = espritApexController.fetchOpportunity();
        Assert.isNotNull(allOpps);
    }
    @isTest
    static void testOppUpdateData() {
         Opportunity oldOpp = [Select id,StageName from Opportunity];
        List<String> oppIds = new List<String>();
        oppIds.add(oldOpp.Id);
        espritApexController.fetchOpportunityToUpdate(oppIds,'Closed Won');
        Opportunity newOpp = [Select id,StageName from Opportunity];
        System.assertEquals('Closed Won', newOpp.StageName);
    }

}