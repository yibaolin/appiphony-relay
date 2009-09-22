public with Sharing class lookupAliasById {
	public String controllerValue { get;
		set {
			controllerValue = lookupAliasByAnId(value);
		}
	}
	
	public String lookupAliasByAnId(String id) {
		MAP <Id, String> AliasList = new Map<Id, String>();
		for (User u : [SELECT Id, Name FROM User]) {
			AliasList.put(u.Id, u.Name);
		}
		
		return AliasList.get(id);		
	}

	static testmethod void testLookUpAlias() {
		lookupAliasById lua = new LookupAliasById();
		lua.controllerValue = System.Userinfo.getUserId();
	}
	
}