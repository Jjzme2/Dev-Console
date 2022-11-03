/**
 * This will handle all the message events.
 *
 * @Author  Jj Zettler
 * @date    10/5/2022
 * @version 1
 */
component extends="BaseHandler" {

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
	 * Displays all the info for the Message Page, and the modal that shows the view.
	 */
	function index ( event, rc, prc )
	{
		prc.viewMessageTemplate = "../messages/view.cfm";
		prc.xeh.process         = "messages.process";

		rc.messages = messageService.list( session.loggedInID );
		rc.users	= userService.list();
	}

	/**
	 * Processes the message.
	 */
	function process ( event, rc, prc )
	{
		if ( rc.intMessageID <= 0 )
		{
			// Creating
			// Check if there is a desired message receiver.
			// Give the User the ability to modify the empty message.
			// Get the User ID, by checking the username to get the ID in UserServices.
			// Add Message, setting the intReceiverID.

			// rc.intReceiverID = userService.getID( rc.vcReceiverUsername ); // Take the given username and determine that user's id.
			if ( rc.intReceiverID < 1 )
			{
				// Bad User
				messageBox.error( "Unable to find user #userService.get( rc.intReceiverID ).vcUsername#" );
			}
			else
			{
				messageObject = messageService.populate( "struct", rc );
				messageService.add( "message", messageObject );
				messageBox.success( "Your message has been sent successfully." );
			}
		}
		else
		{
			if ( StructKeyExists( rc, "boolDeleteSwitch" ) && rc.boolDeleteSwitch == "on" )
			{
				// Deleting.
				// writeDump(rc);abort;
				messageService.delete( rc.intMessageID );
				messageBox.success( "Your message has been deleted successfully." );
			}
			else
			{
				// Modifying.
			}
		}

		Relocate( "messages.index" );
	}

}
