/************************************************************
	BlogTestHarness simply tests the comment and blog
	triggers. This is based on a rewrite of Ron Hess' code.
************************************************************/
public with Sharing class captchaController {
    
    public String status {get; set;} // Did they enter the captcha phrase right or not?
    public String apiPublicKey {get; set;} // The pub key that is a label.
    public String skin {get; set;} // how does the captcha box look?
    
    private static string reCaptchaURL = 'http://api-verify.recaptcha.net/verify'; // The endpoint we're scraping. 
    
    //Constructor - just sets a few things.
    public captchaController() {
        status = '';
        skin = System.Label.reCaptcha_skin;
        apiPublicKey = System.Label.reCaptcha_apiPublicKey;
    }
    
    public static Boolean checkCaptcha(String recaptcha_challenge_field, String recaptcha_response_field) { 
		String apiSecret = System.Label.reCaptcha_apiSecret;
        HttpResponse r = makeRequest(  reCaptchaUrl ,  'privatekey='+ apiSecret + '&remoteip=' + remoteHost + '&challenge=' + recaptcha_challenge_field + '&response=' + recaptcha_response_field + '&error=incorrect-captcha-sol' );
        Boolean correctResponse = false;
		
		if ( r != null ) {
			correctResponse = ( r.getBody().contains('true') );
		} 
        
        return correctResponse;
    }
    
    public static HttpResponse makeRequest(string url, string body)  {
		HttpRequest req = new HttpRequest();   
		HttpResponse response = null;
		req.setEndpoint( url );
		req.setMethod('POST');
		req.setBody ( body);

		try {
			Http http = new Http();
			response = http.send(req);
		} catch( System.Exception e) {
			System.debug('ERROR: '+ e);
  		}

		return response;
	}   
        
	public static String remoteHost { 
		get { 
			string ret = '127.0.0.1';
			map<string , string> hdrs = ApexPages.currentPage().getHeaders();
			if ( hdrs.get('x-original-remote-addr') != null)
				ret =  hdrs.get('x-original-remote-addr');
			else if ( hdrs.get('X-Salesforce-SIP') != null)
				ret =  hdrs.get('X-Salesforce-SIP');
			return ret;
    	} 
	}
	
	static testmethod void test_1() {
		captchaController re = new captchaController();
		System.assert(re.status == '');
		System.assert(!CaptchaController.checkCaptcha('foo', 'foo'));
	}
	
	
}