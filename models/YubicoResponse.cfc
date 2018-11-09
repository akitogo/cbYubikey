component output="false" accessors="false" {

	property name="yRequest"	    type="struct"   hint="holds all url parameters send to server";
	property name="yResponse"	    type="struct"   hint="holds server response converted to struct";

	property name="valid"	        type="boolean";
	property name="status"	        type="string"  hint="status returned from server";

	/**
	 * constructor
	 */
	public YubicoResponse function init() {
        variables.yRequest  = { };
        variables.yResponse = { };
        variables.valid     = false;

        return this;

    }

	/**
	 *
	 */
	public boolean function isValid( )  {
        return variables.valid;
	}  

	/**
	 * response must return OK
     * request.otp and response.opt must match
     * if conditions are met sets valid to true
	 */
	public YubicoResponse function validate( required struct yRequest, required struct yResponse )  {
        variables.yRequest  = arguments.yRequest;
        variables.yResponse = arguments.yResponse;

        if( structKeyExists( yResponse, 'status' )  )
            variables.status = yResponse.status;

        if( variables.status == 'ok' && RequestAndResponseMatch() )
            variables.valid = true;

        return this;

	}

	/**
     * request.otp and response.opt must match
	 */
 	private boolean function RequestAndResponseMatch( )  {
        if ( structKeyExists( variables.yRequest, 'otp' ) && structKeyExists( variables.yResponse, 'otp' )  && yRequest.otp == yResponse.otp ) 
            return true;

        return false;
    }


	/**
	 * returns more readable error message
	 */
	public string function getStatusMessage( )  {
        switch (variables.status) {
            case "OK":
                return "The OTP is valid.";
            case "BAD_OTP":
                return "The OTP is invalid format.";
            case "REPLAYED_OTP":
                return "The OTP has already been seen by the service.";
            case "BAD_SIGNATURE":
                return "The HMAC signature verification failed.";
            case "MISSING_PARAMETER":
                return "The request lacks a parameter.";
            case "NO_SUCH_CLIENT":
                return "The request id does not exist.";
            case "OPERATION_NOT_ALLOWED":
                return "The request id is not allowed to verify OTPs.";
            case "BACKEND_ERROR":
                return "Unexpected error in our server. Please contact us if you see this error.";
            case "NOT_ENOUGH_ANSWERS":
                return "Server could not get requested number of syncs during before timeout";
            case "REPLAYED_REQUEST":
                return "Server has seen the OTP/Nonce combination before";
        }

    return "";

	}  
  
}