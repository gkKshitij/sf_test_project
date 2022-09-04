trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete) {
    switch on Trigger.operationType {
        when AFTER_INSERT {
            ContactTriggerHandler.afterInsertHandler(Trigger.new);
        }

        when AFTER_UPDATE {
            ContactTriggerHandler.afterUpdatetHandler(Trigger.new, Trigger.oldMap);
        }
    }

}