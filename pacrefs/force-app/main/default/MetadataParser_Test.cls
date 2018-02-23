@IsTest
public with sharing class MetadataParser_Test {

    @IsTest public static void parseSingleField ()
    {
        String REPORT_TYPE_SAMPLE = './reportTypes/Account_with_Applications.reportType:            <field>Agency__c.ACCL__Geolocation__Latitude__s</field>';
        MetadataParser mdp = new MetadataParser();
        MetaDataUpload__c mdu = mdp.parse(REPORT_TYPE_SAMPLE)[0];
        System.assertEquals('            <field>Agency__c.ACCL__Geolocation__Latitude__s</field>',mdu.rawText__c);

        System.assertEquals('reportType',mdu.metadataType__c);
        System.assertEquals('Account_with_Applications',mdu.buildArtifact__c);
        System.assertEquals('Agency__c',mdu.packageComponentParent__c);
        System.assertEquals('ACCL__Geolocation__Latitude__s',mdu.packageComponent__c);
        System.assert(!mdu.ignore_in_reports__c);

    }

    @IsTest public static void parseMultiple ()
    {
        String REPORT_TYPE_SAMPLE = './pages/TPM_CreatePromotion.page:                    <apex:outputLabel value="{!$ObjectType.ACCL__Promotion__c.Fields.ACCL__Promotion_Template__c.Label}"';

        MetadataParser mdp = new MetadataParser();
        MetaDataUpload__c mdu = mdp.parse(REPORT_TYPE_SAMPLE)[0];
        System.assertEquals('page',mdu.metadataType__c);
        System.assertEquals('TPM_CreatePromotion',mdu.buildArtifact__c);
        System.assertEquals('ACCL__Promotion__c',mdu.packageComponent__c);

        mdu = mdp.parse(REPORT_TYPE_SAMPLE)[1];
        System.assertEquals('page',mdu.metadataType__c);
        System.assertEquals('TPM_CreatePromotion',mdu.buildArtifact__c);
        System.assertEquals('ACCL__Promotion_Template__c',mdu.packageComponent__c);
    }

    @IsTest public static void splitByPrefix ()
    {
        String s = '<apex:outputLabel value="{!$ObjectType.ACCL__Promotion__c.Fields.ACCL__Promotion_Template__c.Label}"';
        List<String> split = MetadataParser.splitByPrefix(s, 'ACCL');
        System.assertEquals('ACCL__Promotion__c.Fields.', split[0]);
        System.assertEquals('ACCL__Promotion_Template__c.Label}"', split[1]);
    }

    @IsTest public static void stripToReference ()
    {
        String s = 'ACCL__Promotion_Template__cxyz"';
        String terminator = '__c';
        String stripped = MetadataParser.stripToReference(s, terminator);
        System.assertEquals('ACCL__Promotion_Template__c', stripped);
    }

    @IsTest public static void stripToFirstReference ()
    {
        String s = 'ACCL__Promotion_Template__cxyz"';
        String[] terminators = new String[] {'__c','zumba'};
        String stripped = MetadataParser.stripToFirstReference(s, terminators);
        System.assertEquals('ACCL__Promotion_Template__c', stripped);
    }

    @IsTest public static void ignore ()
    {
        String REPORT_TYPE_SAMPLE = './classes/TPM_MyPromotionRomoteActionExt_2_Test.cls:            ACCL__Product__c productid2 = TPM_Testdatafactory.createProduct(prodtemp);';
        MetadataParser mdp = new MetadataParser();
        MetaDataUpload__c mdu = mdp.parse(REPORT_TYPE_SAMPLE)[0];

        System.assert(mdu.ignore_in_reports__c);
    }


    

}
