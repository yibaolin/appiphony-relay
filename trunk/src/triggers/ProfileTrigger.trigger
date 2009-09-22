trigger ProfileTrigger on UserProfile__c (before insert, before update) {

	// If there is a profile that is already marked to this use and the id's don't match (update), throw an error.
	// Easiest checking solution is to creat a map of profiles by UserId.
	List<UserProfile__c> profileList  = [SELECT Name, Id, OwnerId FROM UserProfile__c ];
	
	Map<Id, UserProfile__c> profilesByUserMap = new Map<Id, UserProfile__c>();
	for (UserProfile__c loopProfile : profileList) {
		profilesByUserMap.put(loopProfile.OwnerId, loopProfile);
	}

	for (UserProfile__c loopProfile : Trigger.new) {
		
		// Since all profiles will have an owner, this'll come back not null.
		UserProfile__c hashedProfile = profilesByUserMap.get(loopProfile.OwnerId);
		
		if ((Trigger.isInsert && hashedProfile != null) || // If there is a profile for a user already, don't add another one...
			(Trigger.isUpdate && (hashedProfile != null && hashedProfile.id != loopProfile.Id) ) // if there is a profile, but the Id's are different, don't add.
		) {
			Trigger.new[0].addError('A profile already exists for this user. Only one profile per user is allowed.');
		}
		
	}
	
}