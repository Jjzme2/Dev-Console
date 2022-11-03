/**
 * This will handle all the base events.
 *
 * @Author  Jj Zettler
 * @date    09/21/2022
 * @version 1
 */
component {

	property name = "messageBox"      inject = "messageBox@cbmessagebox";
	property name = "userService"     inject = "Services/UserService";
	property name = "reminderService" inject = "Services/ReminderService";
	property name = "helperService"   inject = "Services/HelperService";
	property name = "messageService"  inject = "Services/MessageService";
	property name = "quoteService"    inject = "Services/QuoteService";
	property name = "bookmarkService" inject = "Services/bookmarkService";
	property name = "noteService"     inject = "Services/NoteService";


	variables.devLog          = application.logbox.getLogger( "development" );
	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only      = "";
	this.prehandler_except    = "";
	this.posthandler_only     = "";
	this.posthandler_except   = "";
	this.aroundHandler_only   = "";
	this.aroundHandler_except = "";
	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods       = {};

	/**
	IMPLICIT FUNCTIONS: Uncomment to use

	function preHandler( event, rc, prc, action, eventArguments ){
	}
	function postHandler( event, rc, prc, action, eventArguments ){
	}
	function aroundHandler( event, rc, prc, targetAction, eventArguments ){
		// executed targeted action
		arguments.targetAction( event );
	}
	function onMissingAction( event, rc, prc, missingAction, eventArguments ){
	}
	function onError( event, rc, prc, faultAction, exception, eventArguments ){
	}
	function onInvalidHTTPMethod( event, rc, prc, faultAction, eventArguments ){
	}
	*/

	/**
	 * This is the base prehandler event, any prehandler defined in a script that inherits this baseHandler will overwrite this action.
	 *
	 */
	void function preHandler ()
	{
		if ( !StructKeyExists( session, "loggedInID" ) )
		{
			session.loggedInID = -1;
		}

		if ( session.loggedInID < 1 )
		{
			Relocate( "user.login" );
		}
	}

}
