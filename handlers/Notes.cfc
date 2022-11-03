/**
 * This will handle all the note events.
 *
 * @Author  Jj Zettler
 * @date    10/12/2022
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
	 * Displays all the info for the Notes Page, and the modal that shows the view.
	 */
	function index ( event, rc, prc )
	{
		prc.viewNoteTemplate = "../Notes/view.cfm";
		prc.xeh.process      = "Notes.process";

		rc.Notes = NoteService.listUserNotes( session.LoggedInID );
	}

	/**
	 * Processes the Note. This will need to be worked on. Doing JS first.
	 */
	function process ( event, rc, prc )
	{
		// writeDump(rc);abort;
		var aMessages        = [];
		var validationResult = validate
		(
			target = rc, constraints =
				{
				 "vcNoteTitle": { "required": true }
				,"vcNoteValue": {
					 "required": true
					,udf       : function ( value, target, metaData )
					{
						if ( rc.intNoteID == 0 )
						{
							// Creating a new Note. If this Note exists already...
							if ( NoteService.hasNote( value ) )
							{
								return false;
							}
							else
							{
								return true;
							}
						}
						else
						{
							// Modifying an existing Note.
							return true;
						}
					}
				}
				,"vcNoteReferenceSite": { "required": false }
			}
		)
		if ( !validationResult.hasErrors() )
		{
			newNote =
				{
				 "intNoteID"          : rc.intNoteID
				,"intNoteAuthorID"    : session.LoggedInID
				,"vcNoteTitle"        : rc.vcNoteTitle
				,"vcNoteValue"        : rc.vcNoteValue
				,"vcNoteReferenceSite": rc.vcNoteReferenceSite
			}
			if ( rc.intNoteID == 0 )
			{
				// Creating a new Note
				NoteService.add( newNote );
				ArrayAppend( aMessages, "Note has been added!" );
			}
			else if ( rc.boolUpdateSwitch == "on" )
			{
				// Modifying an existing Note
				NoteService.update( newNote );
				ArrayAppend( aMessages, "Note has been updated!" );
			}
			else if ( rc.boolDeleteSwitch == "on" )
			{
				// Deleting an existing note
				NoteService.delete( newNote.intNoteID );
				ArrayAppend( aMessages, "Note has been deleted!" );
			}

			messageBox.success( aMessages );
			Relocate( "Notes.index" );
		}
		else
		{
			errors = validationResult.getAllErrors();
			// WriteDump( errors );
			// abort;
			messageBox.error( "We were unable to modify the Note with the given input." );
			Relocate( "Notes.index" );
		}
	}

}
