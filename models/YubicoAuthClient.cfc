/* 

	Version:	0.1.0
	Updated:	12/22/2010
	
	Description:
	YubiKey Web Services API Client


	Original Author:	rdudley robert@xset.co.uk
	Original Created:	12/22/2010

	Rewrite: Akitogo 8th Nov 2018
		
	TODO:
	
	* Add HMAC-SHA-1 support for signing
	* Add nonce to request
	* Add additional request fields
		timestamp
		sl
		timeout
	* Test against 3rd party API servers
	
	Copyright (c) 2010 Robert Dudley

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
	
*/
/**
 * handles yubico authentication
 */
component hint="handles yubico authentication" output="false" accessors="true" {
	property name="yubiCoURL"	type="string" 	default="http://api.yubico.com/wsapi/"	hint="the URL to use for authentication";
	property name="clientId"	type="numeric"	default="16"							hint="the YubiCo Client ID to pass to the web service"  ;

	/**
	 * constructor
	 */
	public yubicoAuthClient function init(string yubiCoURL, string clientId) {
		if ( structKeyExists(arguments,"yubiCoURL") ) {
			setYubiCoURL(arguments.yubiCoURL);
		} else {
			setYubiCoURL("http://api.yubico.com/wsapi/");
		}
		if ( structKeyExists(arguments,"clientId") ) {
			setClientId(arguments.clientId);
		} else {
			setClientId(16);
		}
		return this;
	}


	/**
	 * authenticates an OTP against the YubiCo Web Service
	 */
	public struct function authenticate(required string otp)  {
		var authUrl 	= getYubiCoURL() & "verify";

		var httpService = new http( throwonerror=true, url=authUrl, method="get" );
		httpService.addParam(name = "id",  type = "url", value = getClientId() ); 
		httpService.addParam(name = "otp", type = "url", value = arguments.otp ); 
		
		var  result = httpService.send().getPrefix(); 

		if ( structKeyExists( result, "FileContent" ) ) 
			return parseAuthResponse( result.filecontent );
		
		return {};
	}

	/**
	 * parses out the response from YubiKey API and returns a struct of values
	 * response looks like e.g.
	 * h=g+E1cD7tKPB3bQsmKYtX30NCPlY= t=2018-11-08T22:30:56Z0800 status=REPLAYED_OTP
	 * or
	 * h=4C4N40BMReKfbYsElc69F22e/Sc= t=2018-11-08T22:31:27Z0182 status=OK
	 */
	private struct function parseAuthResponse(required string authResponse)  {

		var authResponseStruct = {};
		var authResponse = reReplace( arguments.authResponse, "\s",",", "all" );
		var aryAuthResp = listToArray( authResponse );

		for ( var keyValue in aryAuthResp ) {
			var keyValue = replace( keyValue ,"=","~","one");
			structInsert(
				authResponseStruct,
				listFirst(keyValue,"~"),
				listLast(keyValue,"~")
			);
		}
		return authResponseStruct;
	}


}
