global class SetFunctionalArea implements Database.Batchable<sObject>
{

    public String version;

    public Map<String,String> configureMap = MetadataParser.populateFunctionalMap();   

	global Database.QueryLocator start(Database.BatchableContext BC)
	{
        String query = 'SELECT Id,buildArtifact__c FROM MetaDataUpload__c';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<MetaDataUpload__c> scope)
    {
        for ( MetaDataUpload__c mdu : scope)
        {
            mdu.category__c = configureMap.get(mdu.BuildArtifact__c);
        }
        update scope;
    }  

    global void finish(Database.BatchableContext BC)
    {
    }
}