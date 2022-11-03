component extends="coldbox.system.EventHandler" {

	/**
	 * Actual Default Action
	 */

	function index ( event, rc, prc )
	{
		Relocate( "user.login" );
	}

	/**
	 * Default Action (Old)
	 */
	function oldIndex ( event, rc, prc )
	{
		prc.welcomeMessage = "Welcome to ColdBox!";

		event.setView( view = "main/index", layout = "Main" );
	}

	/**
	 * Produce some restfulf data
	 */
	function data ( event, rc, prc )
	{
		return [
			 { "id": CreateUUID(), "name": "Luis" }
			,{ "id": CreateUUID(), "name": "JOe" }
			,{ "id": CreateUUID(), "name": "Bob" }
			,{ "id": CreateUUID(), "name": "Darth" }
		];
	}

	/**
	 * Relocation example
	 */
	function doSomething ( event, rc, prc )
	{
		Relocate( "main.index" );
	}

	/************************************** IMPLICIT ACTIONS *********************************************/

	function onAppInit ( event, rc, prc )
	{
	}

	function onRequestStart ( event, rc, prc )
	{
	}

	function onRequestEnd ( event, rc, prc )
	{
	}

	function onSessionStart ( event, rc, prc )
	{
	}

	function onSessionEnd ( event, rc, prc )
	{
		var sessionScope     = event.getValue( "sessionReference" );
		var applicationScope = event.getValue( "applicationReference" );
	}

	function onException ( event, rc, prc )
	{
		event.setHTTPHeader( statusCode = 500 );
		// Grab Exception From private request collection, placed by ColdBox Exception Handling
		var exception = prc.exception;
		// Place exception handler below:
	}

}
