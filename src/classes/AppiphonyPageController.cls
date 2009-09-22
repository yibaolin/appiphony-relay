public class AppiphonyPageController {
	// This is a bit bogus and sad, but we have to set up independant items to 
	// take care of posting contents of entries back to the page. Not sure why...
	
	// The cases list is the body and titles of entries marked cases. 
    private List<Entry__c> cases;
	public List<Entry__c> getCases() {
		return cases;
	}
	
	private List<Entry__c> posts;
	private Entry__c post0;
	private Entry__c post1;
	private Entry__c post2;
	
	public Entry__c getPost0() {
		return posts[0];
	}
	public Entry__c getPost1() {
		return posts[1];
	}
	public Entry__c getPost2() {
		return posts[2];
	}


    public AppiphonyPageController () {
    	// IS there a way to get the latest entries off the page and into the site?
    	// Is there a way to wysiwyg the entry process?
        
       	// TODO mark as cases.
        // This just gets the relevant entries that are marked cases
    	cases = [SELECT Id, Name, CreatedById, Abstract__c, Content__c, Published__c, Published_Date__c FROM Entry__c WHERE Published__c = 'Published' AND Blog__c = 'a0b80000000dI6GAAU' ORDER BY Published_Date__c DESC limit 3];
		posts = [SELECT Id, Name FROM Entry__c WHERE Published__c = 'Published' AND Blog__c = 'a0b80000000dI6BAAU' ORDER BY Published_Date__c DESC limit 3]; 	
//		cases = new List<EntryDisplay>();
//		for (Integer i = 0; i < origCases.size(); i++) {
//			EntryDisplay entry = new EntryDisplay(origCases[i]);
//			cases.add(entry);
//		}				
    }
}