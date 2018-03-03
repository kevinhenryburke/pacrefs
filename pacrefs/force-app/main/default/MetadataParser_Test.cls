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

    @IsTest public static void parseSingleField_md ()
    {
        String REPORT_TYPE_SAMPLE = './customMetadata/TPM_Component_Visibility.SoCo_Banded_Pack_Approved.md:        <field>TPM_Attribute__c</field>';
        MetadataParser mdp = new MetadataParser();
        MetaDataUpload__c mdu = mdp.parse(REPORT_TYPE_SAMPLE)[0];
        System.assertEquals('        <field>TPM_Attribute__c</field>',mdu.rawText__c);

        System.assertEquals('md',mdu.metadataType__c);
        System.assertEquals('TPM_Component_Visibility.SoCo_Banded_Pack_Approved',mdu.buildArtifact__c);
        System.assertEquals('TPM_Attribute__c',mdu.packageComponent__c);
        System.assert(!mdu.ignore_in_reports__c);

    }

    @IsTest public static void parseSingleField_vd ()
    {
        String REPORT_TYPE_SAMPLE = './objects/some.object:        <errorConditionFormula>IF(TPM_Total_of_Phasing__c &lt;1, true, false)</errorConditionFormula>';
        MetadataParser mdp = new MetadataParser();
        MetaDataUpload__c mdu = mdp.parse(REPORT_TYPE_SAMPLE)[0];
        System.assertEquals('validationRule',mdu.metadataType__c);
    }

    @IsTest public static void parseSingleField_cf ()
    {
        String REPORT_TYPE_SAMPLE = './objects/some.object:        <fullName>TPM_Dummy_Custom_profile__c</fullName>';
        MetadataParser mdp = new MetadataParser();
        MetaDataUpload__c mdu = mdp.parse(REPORT_TYPE_SAMPLE)[0];
        System.assertEquals('customField',mdu.metadataType__c);
    }

    @IsTest public static void parseSingleField_pluralLabel ()
    {
        String REPORT_TYPE_SAMPLE = './objects/some.object:        <pluralLabel>TPM_Dummy_Custom_profile__c</pluralLabel>';
        MetadataParser mdp = new MetadataParser();
        List<MetaDataUpload__c> listmdu = mdp.parse(REPORT_TYPE_SAMPLE);
        System.assertEquals(0, listmdu.size());
    }

    @IsTest public static void parseSingleField_classdec ()
    {
        String REPORT_TYPE_SAMPLE = './classes/TPM_ProductFilterSchedulableBatchTest.cls:        TPM_ProductFilterSchedulable sch = new TPM_ProductFilterSchedulable();';
        MetadataParser mdp = new MetadataParser();
        MetaDataUpload__c mdu = mdp.parse(REPORT_TYPE_SAMPLE)[0];
        System.assertEquals('TPM_ProductFilterSchedulable',mdu.packageComponent__c);
        mdu = mdp.parse(REPORT_TYPE_SAMPLE)[1];
        System.assertEquals('TPM_ProductFilterSchedulable',mdu.packageComponent__c);
    }

    @IsTest public static void parseSingleField_bigger50 ()
    {
        String REPORT_TYPE_SAMPLE = './classes/TPM_ProductFilterSchedulableBatchTest.cls:        TPM_567890123456789012345678901234567890123456789012345678901234567890';
        MetadataParser mdp = new MetadataParser();
        MetaDataUpload__c mdu = mdp.parse(REPORT_TYPE_SAMPLE)[0];
        System.assertEquals('TPM_5678901234567890123456789012345678901234567890',mdu.packageComponent__c);
    }

    @IsTest public static void parseSingleField_cls_meta_xml ()
    {
        String REPORT_TYPE_SAMPLE = './classes/TPM_PromotionTriggerTest.cls-meta.xml:        <namespace>ACCL</namespace>';
        MetadataParser mdp = new MetadataParser();
        List<MetaDataUpload__c> listmdu = mdp.parse(REPORT_TYPE_SAMPLE);
        System.assertEquals(0, listmdu.size());
    }

    @IsTest public static void parseSingleField_cls_comment ()
    {
        String REPORT_TYPE_SAMPLE = './classes/TPM_PromotionTriggerTest.cls:  /* comment line */';
        MetadataParser mdp = new MetadataParser();
        List<MetaDataUpload__c> listmdu = mdp.parse(REPORT_TYPE_SAMPLE);
        System.assertEquals(0, listmdu.size());
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
        String s = '<apex:outputLabel value="{!$ObjectType.ACCL__Promotion__c.Fields.TPM__Promotion_Template__c.Label}"';
        List<String> split = MetadataParser.splitByPrefix(s, 'ACCL', 'TPM');
        System.assertEquals('ACCL__Promotion__c', split[0]);
        System.assertEquals('TPM__Promotion_Template__c', split[1]);
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
