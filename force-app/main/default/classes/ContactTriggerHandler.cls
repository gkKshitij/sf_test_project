public with sharing class ContactTriggerHandler {
    public static void afterInsertHandler(List<Contact> newContacts){
        Set<Id> accountIds = new Set<Id>();
        // for(Contact con : Trigger.new){ // to typecast (List<Contact>)Trigger.new
        for(Contact con : newContacts){ // to typecast (List<Contact>)Trigger.new
            if(String.isNotBlank(con.AccountId)){
                accountIds.add(con.AccountId); 
            }
        }
        AccountContactService.updateActiveContacts(accountIds);

    }



    public static void afterUpdateHandler(List<Contact> newContacts, Map<Id, Contact> oldContactsMap){
        Set<Id> accountIds = new Set<Id>();
        for(Contact con : newContacts){ //Trigger.new
            // check for change of active status
            if(String.isNotBlank(con.AccountId) && oldContactsMap.get(con.Id).Active__c!=con.Active__c){
                //automation logic here
                accountIds.add(con.AccountId); 
            } else if(oldContactsMap.get(con.Id).AccountId!= con.AccountId){
                accountIds.add(con.AccountId);
                accountIds.add(oldContactsMap.get(con.Id).AccountId);
            }
        }
        AccountContactService.updateActiveContacts(accountIds);

    }

}
