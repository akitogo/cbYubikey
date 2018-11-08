# cbYubikey
YubiKey Web Services API Client

Implements the YubiCo OTP Validation Protocol as outlined at https://developers.yubico.com/yubikey-val/Validation_Protocol_V2.0.html

Sends a One Time Password (OTP) via HTTP get to the YubiCo API server and returns a struct based on the response.

This is a super quick rewrite as a coldbox module of a client orginially written by Robert Dudley. See as well http://yubikey.riaforge.org/

## Installation 
This ColdBox Module can be installed using CommandBox:

```
box install cbYubikey
```
### Use as a Coldfusion component

```
	yubicoObj = createObject("Component","cbYubiKey.models.yubicoAuthClient").init();
	
	//authenticate the OTP
	retVal = yubicoObj.authenticate(form.yubiKeyOTP);
	

	if( retVal.status eq "ok" )
    // do something
```


### ColdBox Module

```
/**
* A normal ColdBox Event Handler
*/
component{
	property name="yubiclient" inject="yubicoAuthClient@cbYubikey";
	
	function index(event,rc,prc){
		
	  //authenticate the OTP
	  var retVal = yubiclient.authenticate(rc.yubiKeyOTP);
	

	  if( retVal.status eq "ok" )
      // do something
		
	}
}
```
