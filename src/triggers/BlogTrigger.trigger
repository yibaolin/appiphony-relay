trigger BlogTrigger on Blog__c (before delete, before insert, before update) {

	if (Trigger.isInsert || Trigger.isUpdate) {
		// Lookup blogs and see if there is a blog that is already marked as "Default".
		Id defaultBlogId = null;
		try { 
			defaultBlogId = [SELECT Id, Default__c FROM Blog__c WHERE Default__c = true LIMIT 1].Id;
		} catch (Exception e) {
			// If there aren't defualt blogs, we just keep the null value... Do Nothing.
		}

		if (defaultBlogId != null && defaultBlogId != Trigger.new[0].Id) {
			if (Trigger.new[0].Default__c == true) {
				try {
						Trigger.new[0].addError('A  blog marked "Default" already exists. Only one is allowed.');			
					
					}
					catch (Exception e) {
						ApexPages.addMessages(e);
					}
				}
				if (Trigger.new[0].Default__c == true) {
					Trigger.new[0].Default__c = false;
				}
			}
		} 



	if (Trigger.isDelete) {
		List<id> entryIds = new List<id>();
	
		for(Integer j = 0; j < Trigger.old.size(); j++) {
	
			for(List<Entry__c> entryList : [SELECT Id FROM Entry__c WHERE Blog__c = :Trigger.old[j].Id]) {
				for (Entry__c thisEntry : entryList) {
					entryIds.add(thisEntry.Id);
				}
		
				System.debug('***************** entryIds: ' + entryIds.size());
	
				for(List<Comment__c> commentList : [SELECT Id From Comment__c WHERE Entry__c IN :entryIds]) {
					delete commentList;
				}
			}
		}
	}
}