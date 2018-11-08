<cfset startTime = getTickCount() />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<title>YubiKey OTP Test</title>
	<style type="text/css">body {font-family:Tahoma,Verdana,sans-serif;font-size:80%;color:#666}.yubikeyInput{background: white url(http://demo.yubico.com/php-yubico/yubiright_16x16.gif) no-repeat 2px 2px;height: 18px;padding-left: 20px;width: 250px;border:1px solid #666;}</style>
</head>
<body>
<h1 style="margin-top:100px">YubiKey OTP Test</h1>
<cfif structKeyExists(form,"yubiKeyOTP")>
	<!--- form post back --->
	
	<!--- create the object --->
	<cfset yubicoObj = createObject("Component","cbYubiKey.models.yubicoAuthClient").init() />
	
	<!--- authenticate the OTP --->	
	<cfset retVal = yubicoObj.authenticate(form.yubiKeyOTP) />
	
	<!--- output based on return --->
	<cfif retVal.status eq "ok">
		<h2 style="color:green">OTP Passed Ok</h2>
	<cfelse>
		<h2 style="color:red">OTP Failed!</h2>
		<cfoutput><pre>#retVal.status#</pre></cfoutput>
	</cfif>
</cfif>

<form name="yubiKeyTest" method="post">
	<input type="text" name="yubiKeyOTP" id="yubiKeyOTP" class="yubikeyInput" />
	<input type="submit" name="testOTP" value="Test OTP" />
</form>

<cfset endTime = getTickCount() />
<cfset runTime = endTime - startTime />
<cfoutput><p>(Processed in #runTime#ms)</p></cfoutput> 
</body>
</html>