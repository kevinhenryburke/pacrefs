public class MetadataParser {

    public MetadataParser() {
    }

    public static String PACKAGE_PREFIX = 'ACCL';
    public static String CUSTOMER_PREFIX = 'TPM';
    public static String[] TERMINATORS = new String[] {'__c',',',' ','(',')','<','$','/'};

    public String metadataType;
    public String category;
    public String rawText;
    public String buildArtifact;
    public String packageComponent;
    public String packageComponentParent;

    public List<MetaDataUpload__c> parse (String s) {
        List<MetaDataUpload__c> listmdu = new List<MetaDataUpload__c>();

        /* Split the line into the file info (first part) and the metadata file text (second part) */

        this.rawText = s.substringAfter(':');

        this.buildArtifact = s.substring(2).substringBetween('/','.');
        this.metadataType = s.substring(2).substringBetween('.',':');
        while (this.metadataType != null && this.metadataType.contains('.')) {
            this.buildArtifact += '.' + this.metadataType.substringBefore('.');
            this.metadataType = this.metadataType.substringAfter('.');
        }

        if (getMetadataTypeOverride(s, this.metadataType) != null) {
            this.metadataType = getMetadataTypeOverride(s, this.metadataType);
        }

        this.category = '';

        if (this.metadataType == 'object')
        {
            // special processing for object metadata
            if (!parseObjectMetadataType()) {
                // object metadata does not reference a package component
                MetaDataUpload__c mdu = new MetaDataUpload__c();
                mdu.rawText__c = this.rawText;
                mdu.metadataType__c = this.metadataType;
                mdu.buildArtifact__c = this.buildArtifact;
                mdu.category__c = this.category;
                mdu.ignore_in_reports__c = ignore(mdu);
                listmdu.add(mdu);
            }
        }
        else {
            // find by tag <field>
            if (this.rawText.contains('<field>')) {
                String fieldText = this.rawText.substringBetween('<field>','</field>');
                if (fieldText.contains('.')) {
                    this.packageComponentParent = fieldText.substringBefore('.');
                    this.packageComponent = fieldText.substringAfter('.');
                }
                else {
                    this.packageComponent = fieldText;
                }
                MetaDataUpload__c mdu = new MetaDataUpload__c();
                mdu.packageComponent__c = this.packageComponent;
                mdu.packageComponentParent__c = this.packageComponentParent;
                listmdu.add(mdu);
            }
            else {
            // find by PACKAGE_PREFIX
                String rawNormal = this.rawText.normalizeSpace();
                List<String> rawSplit = splitByPrefix(rawNormal, PACKAGE_PREFIX, CUSTOMER_PREFIX);
                for (String packageComponent : rawSplit)
                {
                    MetaDataUpload__c mdu = new MetaDataUpload__c();
                    mdu.packageComponent__c = stripToFirstReference(packageComponent,TERMINATORS);
                    listmdu.add(mdu);
                }
            }

            for (MetaDataUpload__c mdu : listmdu)
            {
                mdu.rawText__c = this.rawText;
                mdu.metadataType__c = this.metadataType;
                mdu.buildArtifact__c = this.buildArtifact;
                mdu.category__c = this.category;
                mdu.ignore_in_reports__c = ignore(mdu);
            }

        }



        List<MetaDataUpload__c> filtered = new List<MetaDataUpload__c>();

        for (MetaDataUpload__c mdu : listmdu)
        {
            if (!filter(mdu)) {
                filtered.add(mdu);
            }
        }

        return filtered;
    }

    public static List<String> splitByPrefix (String s, String packagePrefix, String companyPrefix)
    {
        List<String> retArray = new List<String>{};
        String remains = s.normalizeSpace();
        Boolean done = false;

        while (!done) {
            Integer packagePrefixIndex = remains.indexOf(packagePrefix);
            Integer companyPrefixIndex = remains.indexOf(companyPrefix);
            Integer firstIndex = -1; 
            
            if (packagePrefixIndex > -1){
                firstIndex = packagePrefixIndex;
            }
            if (companyPrefixIndex > -1 && (packagePrefixIndex == -1 || companyPrefixIndex < packagePrefixIndex)){
                firstIndex = companyPrefixIndex;
            }

            if (firstIndex > -1) {
                String firstPrefix = (packagePrefixIndex == firstIndex)? packagePrefix : companyPrefix;
                remains = remains.substringAfter(firstPrefix);
                retArray.add(firstPrefix + stripToFirstReference(remains,TERMINATORS));
            }
            else {
                done = true;
            }
        }

        return retArray;
    }


    public static String stripToReference (String s, String terminator) 
    {
        String retString = s.normalizeSpace();
        Integer indexTerminator = s.indexOf(terminator);
        if (indexTerminator > 0) {
            retString = s.substring(0,indexTerminator);
            if (terminator == '__c')
            {
                retString += terminator;
            }
        }
        return retString;
    }

    public static String stripToFirstReference (String s, String[] terminators)
    {
        String terminated = s;
        for (String terminator : terminators)
        {
            String iterated = stripToReference (s, terminator); 
            if (iterated.length() < terminated.length())
            {
                terminated = iterated;
            }
        }
        if (terminated != null && terminated.length() > 50)
        {
            return terminated.substring(0,50);
        }
        return terminated;
    }

    public static String getCategory (String sMetaDataType)
    {
        return null;
    }

    public static Boolean ignore (MetaDataUpload__c mdu)
    {
        Boolean retBoolean = false;    
        if (mdu.metadataType__c == 'cls' && mdu.buildArtifact__c.contains('Test'))
        {
            retBoolean = true;
        }
        return retBoolean;    
    }

    public static Boolean filter (MetaDataUpload__c mdu)
    {
        Boolean retBoolean = false;    
        // remove meta data references
        if (mdu.buildArtifact__c.contains('cls-meta') || mdu.buildArtifact__c.contains('page-meta') || mdu.buildArtifact__c.contains('trigger-meta'))
        {
            retBoolean = true;
        }
        // remove comments
        if (mdu.rawText__c.contains('//') || mdu.rawText__c.contains('*/') || mdu.rawText__c.contains('/*') || mdu.rawText__c.contains('<!-') || mdu.rawText__c.contains('-->')  )
        {
            retBoolean = true;
        }
        return retBoolean;    
    }

    public static String getMetadataTypeOverride(String s, String metadataType)
    {
        return null;
    }

    public boolean parseObjectMetadataType()
    {
        String s = this.rawText;
        String objectName = this.buildArtifact;

        if (s.contains('<errorConditionFormula>')) {
            this.buildArtifact = objectName + '.' + s.substringBetween('<errorConditionFormula>','</errorConditionFormula>');
            this.metadataType = 'validationRule'; 
        }
        if (s.contains('<customTabListAdditionalFields>')) {
            this.buildArtifact = objectName + '.' + s.substringBetween('<customTabListAdditionalFields>','</customTabListAdditionalFields>');
            this.metadataType = 'searchLayout'; 
        }
        if (s.contains('<lookupFilterFields>')) {
            this.buildArtifact = objectName + '.' + s.substringBetween('<lookupFilterFields>','</lookupFilterFields>');
            this.metadataType = 'lookupFilter'; 
        }
        if (s.contains('<searchFilterFields>')) {
            this.buildArtifact = objectName + '.' + s.substringBetween('<searchFilterFields>','</searchFilterFields>');
            this.metadataType = 'searchLayout'; 
        }
        if (s.contains('<columns>')) {
            this.buildArtifact = objectName + '.' + s.substringBetween('<columns>','</columns>');
            this.metadataType = 'listView'; 
        }
        if (s.contains('<field>')) {
            this.buildArtifact = objectName + '.' + s.substringBetween('<field>','</field>');
            this.metadataType = 'lookup'; 
        }
        if (s.contains('<fullName>')) {
            this.buildArtifact = objectName + '.' + s.substringBetween('<fullName>','</fullName>');
            this.metadataType = 'customField'; 
        }
        if (s.contains('<referenceTo>')) {
            this.buildArtifact = objectName + '.' + s.substringBetween('<referenceTo>','</referenceTo>');
            this.metadataType = 'lookup'; 
        }
        if (s.contains('<valueSetName>')) {
            this.buildArtifact = objectName + '.' + s.substringBetween('<valueSetName>','</valueSetName>');
            this.metadataType = 'picklist'; 
        }
        if (s.contains('<label>')) {
            return true;
        }
        if (s.contains('<content>')) {
            return true;
        }
        if (s.contains('<errorDisplayField>')) {
            return true;
        }
        if (s.contains('<pluralLabel>')) {
            return true;
        }


        return false;
    }

    public static Map<String,String> populateFunctionalMap () {
        Map<String,String> configureMap = new Map<String,String>();
        List<MetaDataFunctionalMap__c> listMDFM = [select CountrySpecific__c, BuildArtifact__c, FunctionalArea__c from MetaDataFunctionalMap__c];

        for (MetaDataFunctionalMap__c mdfm : listMDFM) {
            configureMap.put(mdfm.BuildArtifact__c, mdfm.FunctionalArea__c);
        }
        return configureMap;
    }


}
