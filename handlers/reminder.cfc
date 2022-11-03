/**
 * This will handle all the reminder events.
 *
 * @Author  Jj Zettler
 * @date    09/20/2022
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
	 * List all the reminders in a data table
	 */
	function index ( event, rc, prc )
	{
		prc.xeh.view             = "reminder.view";
		prc.xeh.process          = "reminder.process";
		prc.xeh.delete           = "reminder.delete";
		prc.viewReminderTemplate = "../reminder/view.cfm";
		rc.listReminders         = reminderService.listUserReminders( session.LoggedInID );
		rc.Priorities            = helperService.listPriorities();
		rc.Sources               = helperService.listSources();
		rc.Processes             = helperService.listProcesses();
	}

	/**
	 * Displays the view for the reminder modification modal.
	 */
	// function view ( event, rc, prc )
	// {
	// 	prc.xeh.process = "reminder.process";
	// 	// prc.currentReminder = reminder.populate(  )

	// 	rc.Priorities = helperService.listPriorities();
	// 	rc.Sources    = helperService.listSources();
	// 	rc.Processes  = helperService.listProcesses();
	// }

	/**
	 * Processes the Reminder Form submission.
	 */
	function process ( event, rc, prc )
	{
		var aMessages = [];

		var validationResult = validate
		(
			target = rc, constraints =
				{
				 "vcDueDate"      : { "required": false }
				,"intPriority"    : { "required": true }
				,"intProcess"     : { "required": true }
				,"intSource"      : { "required": true }
				,"vcReminderValue": {
					 "required": true
					// ,"regex"   : "[A-Z a-z0-9.?!@$%^&*:()<>/;\-,'`]+"
					,udf       : function ( value, target, metaData )
					{
						if ( rc.intReminderID == 0 )
						{
							// Creating a new Reminder. If this reminder exists already...
							if ( reminderService.hasReminder( value ) )
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
							// Modifying an existing reminder.
							return true;
						}
					}
				}
			}
		)

		if ( !validationResult.hasErrors() )
		{
			newReminder =
				{
				 "intPriority"    : rc.intPriority
				,"intSource"      : rc.intSource
				,"intProcess"     : rc.intProcess
				,"intUserID"      : session.LoggedInID
				,"vcReminderValue": rc.vcReminderValue
				,"vcDueDate"      : rc.vcDueDate
			}

			if ( rc.intReminderID == 0 ) // Creating a new Reminder
			{
				reminderService.add( newReminder );
				ArrayAppend( aMessages, "Reminder has been added!" );
			}
			else if ( rc.boolUpdateSwitch == "on" ) // Modifying an existing Reminder
			{
				reminderService.update( rc.intReminderID, newReminder );
				ArrayAppend( aMessages, "Reminder has been updated!" );
			}
			else if ( rc.boolDeleteSwitch == "on" ) // Deleting a reminder
			{
				reminderService.delete( rc.intReminderID );
				ArrayAppend( aMessages, "Reminder Successfully deleted." );
			}
			messageBox.success( aMessages );
			Relocate( "reminder.index" );
		}
		else
		{
			errors = validationResult.getAllErrors();
			// WriteDump( errors );
			// WriteDump( rc );
			// abort;
			messageBox.error( "We were unable to modify the reminder with the given input." );
			if ( devLog.canError() )
			{
				errors = validationResult.getAllErrors();
				devLog.Error( message = "Create Reminder Error", extrainfo = errors );
			}
			Relocate( "reminder.index" );
		}
	}

}
