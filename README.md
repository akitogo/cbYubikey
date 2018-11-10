# cbYubikey
YubiKey Web Services API Client

Implements the YubiCo OTP Validation Protocol as outlined at https://developers.yubico.com/yubikey-val/Validation_Protocol_V2.0.html

Sends a One Time Password (OTP) via HTTP get to the YubiCo API server and returns a struct based on the response. For OTP see https://developers.yubico.com/OTP/OTPs_Explained.html

A Coldbox module or stand alone cfc of a client orginially written by Robert Dudley. See as well http://yubikey.riaforge.org/

## Installation 
This ColdBox Module can be installed using CommandBox:

```bash
box install cbYubikey
```
### Use as a Coldfusion component
To do a quick test call from you browser: http://yourServer/cbYubikey/views/home/index.cfm

```js
yubicoObj = createObject("Component","cbYubiKey.models.yubicoAuthClient").init();
	
//authenticate the OTP
yr = yubicoObj.verify(form.yubiKeyOTP);

if( yr.isValid() ) {
	// match with public id attached to your user
	var matchWith = yr.getPublicId();
   // do something
} else {
	writeDump( yr.getStatusMessage() );
}

```


### ColdBox Module
To do a quick test call from you browser: http://yourServer/cbYubikey

```js
/**
* A normal ColdBox Event Handler
*/
component{
	property name="yubiclient" inject="yubicoAuthClient@cbYubikey";
	
	function index(event,rc,prc){
			
		//authenticate the OTP
		var yr = yubiclient.verify(rc.yubiKeyOTP);
		
		if( yr.isValid() ) {
			// match with public id attached to your user
			var matchWith = yr.getPublicId();		
		// do something
		} else {
			writeDump( yr.getStatusMessage() );
		}
	}
}
```

## Versions
- 0.3.0
  - added getPublicId() to YubicoResponse object, returns 12 char public id if validation before was successful
- 0.2.0 
  - renamed to authenticate() to verify()
  - verify() returns now an YubicoResponse object
  - updated to Validation Protocol Version 2.0
  - nonce is now required (will be auto generated)
- 0.1.0 
  - super quick rewrite as a coldbox module of a client orginially written by Robert Dudley
