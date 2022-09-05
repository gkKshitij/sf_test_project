public with sharing class AccountContactService {
    public static void updateActiveContacts(Set<Id> accountIds) {
        // get aggregate results of all accounts
        List<AggregateResult> results = [
            SELECT AccountId, COUNT(Id) totalContacts 
            FROM Contact 
            WHERE Active__c=True and AccountId IN : accountIds
            GROUP BY AccountId
            ];
        // build final list of accounts to update
        Map<Id, Account> accountsToUpdate = new Map<Id, Account>();
        for(AggregateResult result:results){
            // get accountId and number of active contacts
            String accId = String.valueOf(result.get('AccountId'));
            Integer totalContacts = Integer.valueOf(result.get('totalContacts'));
            // make sure to use Id field n account to update
            Account acc = new Account(Id=accId, Active_Contacts__c=totalContacts);
            // update acc;
            accountsToUpdate.put(accId, acc);
        }
        // uodate account with zero active contacts
        for(Id accId : accountIds ){
            if(!accountsToUpdate.containsKey(accId)){
                accountsToUpdate.put(accId, new Account(Id=accId, Active_Contacts__c=0));

            }
        

            //another way to do without account/acc variable
            // accountsToUpdate.add(new Account(Id=accId, Active_Contacts__c=totalContacts));
        }
        update accountsToUpdate.values();
    }
}
