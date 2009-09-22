public with sharing class lookupCommentsByEntryIdController {

	public String controllerValue { get;
		set {
			controllerValue = lookupCommentsByAnEntryId(value);
		}
	}
	
	public String lookupCommentsByAnEntryId(String id) {
		List<Id> CommentList = new List<Id>();
		try {
		for (Comment__c c : [SELECT Id FROM Comment__c WHERE Entry__c =: id]) {
			CommentList.add(c.Id);
		}
		}
		catch (Exception e) {
			//do nothing size will be 0
		}
		String returnVal;
		returnVal = (CommentList.size() == 1) ? CommentList.size() + ' Comment' : CommentList.size() + ' Comments';
		return returnVal;		
	}

	static testmethod void testLookUpEntryComment() {
		
		lookupCommentsByEntryIdController lua = new lookupCommentsByEntryIdController();
		lua.controllerValue = '';
	}
	
	
}