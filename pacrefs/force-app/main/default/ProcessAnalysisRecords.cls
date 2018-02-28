
global class ProcessAnalysisRecords implements Database.Batchable<sObject>
{

    public String version;

	global Database.QueryLocator start(Database.BatchableContext BC)
	{
        String query = 'SELECT Id,fileLine__c FROM GrepLine__c where processed__c = false';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<GrepLine__c> scope)
    {
        List<MetaDataUpload__c> listmdu = new List<MetaDataUpload__c>();
        
        MetadataParser mdp = new MetadataParser();

        for ( GrepLine__c gl : scope)
        {
            listmdu.addAll(mdp.parse(gl.fileLine__c));
        }
        for ( MetaDataUpload__c mdu : listmdu)
        {
            mdu.buildVersion__c = version;
        }
        insert listmdu;
        for ( GrepLine__c gl : scope)
        {
            gl.processed__c = true;
        }
        update scope;
    }  

    global void finish(Database.BatchableContext BC)
    {
    }
}