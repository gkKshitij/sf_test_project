public with sharing class ContactTriggerHandler {
    public static void afterInsertHandler(List<Contact> newContacts){
        Set<Id> accountIds = new Set<Id>();
        // for(Contact con : Trigger.new){ // to typecast (List<Contact>)Trigger.new
        for(Contact con : newContacts){ // to typecast (List<Contact>)Trigger.new
            if(String.isNotBlank(con.AccountId)){
                accountIds.add(con.AccountId); 
            }
        }
        List<AggregateResult> results = [
            SELECT AccountId, COUNT(Id) totalContacts 
            FROM Contact 
            WHERE Active__c=True and AccountId 
            IN : accountIds
            GROUP BY AccountId, ACtive__c
            ];
            List<Account> accountsToUpdate = new List<Account>();
        for(AggregateResult result:results){
            String accId = String.valueOf(result.get('AccountId'));
            Integer totalContacts = Integer.valueOf(result.get('totalContacts'));

            Account acc = new Account(Id=accId, Active_Contacts__c=totalContacts);
            // update acc;
            accountsToUpdate.add(acc);

            //another way to do without account variable
            // accountsToUpdate.add(new Account(Id=accId, Active_Contacts__c=totalContacts));
        }
        update accountsToUpdate;

    }



    public static void afterUpdateHandler(Listd<Contact> newContacts, Map<Id, Contact> oldContactsMap){
        Set<Id> accountIds = new Set<Id>();
            for(Contact con : newContacts){ //Trigger.new
                // check for change of active status
                if(String.isNotBlank(con.AccountId) && oldContactsMap.get(con.Id).Active__c!=con.Active__c){
                    accountIds.add(con.AccountId); 
                } else if(oldContactsMap.get(con.Id).AccountId!= con.AccountId){
                    accountIds.add(con.AccountId);
                    accountIds.add(oldContactsMap.get(con.Id).AccountId);
                }
            }
            List<AggregateResult> results = [
                SELECT AccountId, COUNT(Id) totalContacts 
                FROM Contact 
                WHERE Active__c=True and AccountId 
                IN : accountIds
                GROUP BY AccountId, ACtive__c
                ];
                List<Account> accountsToUpdate = new List<Account>();
            for(AggregateResult result:results){
                String accId = String.valueOf(result.get('AccountId'));
                Integer totalContacts = Integer.valueOf(result.get('totalContacts'));

                Account acc = new Account(Id=accId, Active_Contacts__c=totalContacts);
                // update acc;
                accountsToUpdate.add(acc);

                //another way to do without account variable
                // accountsToUpdate.add(new Account(Id=accId, Active_Contacts__c=totalContacts));
            }
            update accountsToUpdate;
    }

}
