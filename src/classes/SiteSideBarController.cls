public without sharing class SiteSideBarController { // THis is specifically marked as without sharing so that we can read the orgName.

	public SiteSideBarController() {
		if (lastUpdate == null || lastUpdate.addMinutes(10) < Datetime.now()) {
			organizationName = [SELECT Name FROM Organization].Name;
			blogList = [SELECT Id, Name FROM Blog__c ORDER By Sort_id__c]; // query to find all blogs.
			lastUpdate = Datetime.now();
		}
	}
	
	public static List<Blog__c> blogList { get; set; }
	public static String organizationName  { get; set; }
	public static DateTime lastUpdate { get; set; }

	static testmethod void TestSideBarController() {
		//
	}
	
}