/**
 * This will handle all the User events
 */
component extends="BaseHandler" {

	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only      = "";
	this.prehandler_except    = "login,logout,register,processLogin,processRegistration";
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
	 * This will display all the users in a listed table.
	 */
	function index ( event, rc, prc )
	{
		// Modal Information to send a user an email.
		prc.userTemplate = "../user/sendEmail.cfm";
		prc.xeh.process  = "user.sendEmail";
		rc.sender        = userService.get( session.loggedInID ).vcUsername;
	}

	/**
	 * homepage
	 */
	function homepage ( event, rc, prc )
	{
		// Developer submitted content
		prc.xeh.users     = "user.index";
		prc.xeh.reminders = "reminder.index";
		
		rc.overdueReminders = reminderService.getOverdue( session.LoggedInID );
		
		// User submitted content
		rc.user = userService.get( session.loggedInID ).vcUsername;

		rc.randomQuote = quoteService.GetRandomQuote( session.LoggedInID );


		//Maybe not the best place, repetition.
		prc.viewReminderTemplate = "../reminder/view.cfm";
		rc.listReminders         = reminderService.listUserReminders( session.LoggedInID );
		rc.Priorities            = helperService.listPriorities();
		rc.Sources               = helperService.listSources();
		rc.Processes             = helperService.listProcesses();
		prc.xeh.process          = "reminder.process";

		rc.users = userService.list();
	}

	/**
	 * This will display the login page.
	 */
	function login ( event, rc, prc )
	{
		// I don't think I had this problem yesterday. I should look into why I needed to have this when the page loaded after daily system start. (10-6-22)
		if ( StructKeyExists( session, "loggedInID" ) )
		{
			if ( session.loggedInID > 0 )
			{
				Relocate( "user.homepage" );
			}
		}
		prc.xeh.login = "user.processLogin";
	}

	/**
	 * This will process the logout action, and reset the session variables we need
	 */
	function logout ( event, rc, prc )
	{
		if ( session.LoggedInID > 0 )
		{
			messageBox.success( "User has been logged out successfully." );
		}
		session.LoggedInID = -1;
		Relocate( "user.login" );
	}

	/**
	 * Displays the form for the user to see upon Registration request.
	 */
	function register ( event, rc, prc )
	{
		prc.xeh.process = "user.processRegistration"
	}

	/**
	 * Processes the registration for new users.
	 */
	function processRegistration ( event, rc, prc )
	{
		// writeDump(rc);abort;
		var validationResult = validate
		(
			target      = rc,
			constraints =
				{
				 "vcUsername": {
					 "required": true
					,"regex"   : "[A-Za-z0-9]{3,16}"
					,udf       : function ( value, target, metadata )
					{
						if ( userService.hasUser( value ) )
						{
							return false;
						}
						else
						{
							return true;
						}
					}
				}
				,"vcUserEmail": {
					 "required": true
					,"regex"   : "[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+"
					,udf       : function ( value, target, metadata )
					{
						if ( userService.hasEmail( value ) )
						{
							return false;
						}
						else
						{
							return true;
						}
					}
				}
				,"vcPassword": {
					 "required": true
					,"regex"   : "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[+?!@$ %^&*-]).{8,}"
					,udf       : function ( value, target, metadata )
					{
						if ( rc.passConfirmation == value )
						{
							return true;
						}
						else
						{
							return false;
						}
					}
				}
			}
		)

		if ( !validationResult.hasErrors() )
		{
			// No Errors
			newUser = userService.populate( "struct", rc );
			userService.add( "object", newUser );
			messageBox.success( "You've successfully been registered!" );
			Relocate( "user.login" );
		}
		else
		{
			errors = validationResult.getAllErrors();
			WriteDump( errors );
			abort;
			messageBox.error( "We were unable to register you with the given data. Please try again." );
			Relocate( "user.login" );
		}
	}

	/**
	 * edit
	 */
	function edit ( event, rc, prc )
	{
	}

	/**
	 * Processes the login action
	 */
	function processLogin ( event, rc, prc )
	{
		var validationResult = validate
		(
			target      = rc,
			constraints =
				{
				 "vcUsername": {
					 "required": true
					,udf       : function ( value, target, metadata )
					{
						if ( userService.hasUser( value ) )
						{
							return true;
						}
						else
						{
							return false;
						}
					}
				}
				,"vcPassword": {
					 "required": true
					,udf       : function ( value, target, metadata )
					{
						// Get User ID, from supplied username.
						userData = userService.get( userService.getID( rc.vcUsername ) );

						if ( StructKeyExists( userData, "vcPassword" ) )
						{
							if ( userData.vcPassword == value )
							{
								return true;
							}
						}
						return false;
					}
				}
			}
		)

		if ( !validationResult.hasErrors() )
		{
			userData = userService.get( userService.getID( rc.vcUsername ) );
			userService.Populate( "struct", userData ).login();
			Relocate( "user.homepage" );
		}
		else
		{
			if ( devLog.canError() )
			{
				errors = validationResult.getAllErrors();
				devLog.Error( message = "Login Error.", extrainfo = server );
			}
			messageBox.error( "Invalid Credentials entered. Please try again, or <a href='#event.buildLink( "user.register" )#'>register</a>. " );
			Relocate( "user.login" );
		}
	}

	/**
	 * This will be what will send the email, from information we recieve from the Modal, with the help of JS.
	 */
	function sendEmail ( event, rc, prc )
	{
		WriteDump(
			 var   = "I thought, after adding Emails, I might not want to give this as an option in development, so here we are. If you remove this line though, it will send emails."
			,label = "user.sendEmail"
		);
		abort;
		email = NewMail(
			 to        : rc.emailTo
			,from      : "john.zettler@mind-over-data.com"
			,subject   : rc.emailSubject
			,type      : "html"
			,bodyTokens: { "sender": rc.emailSender, "body": rc.emailBody }
		).setBody( "<p>Sent by: @sender@ </p> <div>@body@</div>" )
			.send()
			.onSuccess( function ( result, mail )
			{
				messageBox.success( "Email sent successfully!" );
			} )
			.onError( function ( result, mail )
			{
				if ( devLog.canError() )
				{
					devLog.Error( message = "There was an error sending mail.", extraInfo = result.messages );
				}
				messageBox.error( "There was an error sending the email." );
			} );
		Relocate( "user.index" );
	}

}
