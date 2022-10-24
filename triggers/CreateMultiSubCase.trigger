trigger CreateMultiSubCase on Case (after insert ) {

    if(!checkRecursive.firstcall) {
        checkRecursive.firstcall = true;

        //get the Case the fires the triger
        Case c = new Case();
        c =  trigger.new[0];

        if(c.RecordTypeId != '0128c000001Q3inAAC'){

            String multiSelectVal =c.X0000__c;
            List<String> vals = c.X0000__c.split(';');
    
            Case created = [select id from Case where 
                        id in : Trigger.newmap.Keyset() limit 1] ;
            
            List<Case> newsubCases = new List<Case>();
    
            for(String s: vals){
                Case ca= new Case(Subject = c.Subject , Case_Type__c = c.Case_Type__c, Priority='Low',Status='New' , Description = c.Description ,  
                ParentId = created.id , RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('New_Sub_Case').getRecordTypeId() , 
                Assigned_Team__c=s , Origin = c.Origin);


                newsubCases.add(ca);
            }
            insert newsubCases;
        }

    }

}