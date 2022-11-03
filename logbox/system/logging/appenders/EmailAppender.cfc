/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * An appender that sends out emails
 *
 * Properties:
 *	- subject - Get's pre-pended with the category field.
 *	- from - required
 *	- to - required can be a ; list of emails
 *	- cc
 *	- bcc
 *	- mailserver (optional)
 *	- mailpassword (optional)
 *	- mailusername (optional)
 *	- mailport (optional - 25)
 **/
component accessors="true" extends="logbox.system.logging.AbstractAppender" {

	/**
	 * Constructor
	 *
	 * @name       The unique name for this appender.
	 * @properties A map of configuration properties for the appender"
	 * @layout     The layout class to use in this appender for custom message rendering.
	 * @levelMin   The default log level for this appender, by default it is 0. Optional. ex: LogBox.logLevels.WARN
	 * @levelMax   The default log level for this appender, by default it is 5. Optional. ex: LogBox.logLevels.WARN
	 */
	function init (
		 required name
		,struct properties = {}
		,layout            = ""
		,levelMin          = 0
		,levelMax          = 4
	)
	{
		// Init supertype
		super.init( argumentCollection = arguments );

		// Property Checks
		if ( NOT PropertyExists( "from" ) )
		{
			Throw( message = "from email is required", type = "EmailAppender.PropertyNotFound" );
		}
		if ( NOT PropertyExists( "to" ) )
		{
			Throw( message = "to email(s) is required", type = "EmailAppender.PropertyNotFound" );
		}
		if ( NOT PropertyExists( "subject" ) )
		{
			Throw( message = "subject is required", type = "EmailAppender.PropertyNotFound" );
		}
		if ( NOT PropertyExists( "cc" ) )
		{
			SetProperty( "cc", "" );
		}
		if ( NOT PropertyExists( "bcc" ) )
		{
			SetProperty( "bcc", "" );
		}
		if ( NOT PropertyExists( "mailport" ) )
		{
			SetProperty( "mailport", 25 );
		}
		if ( NOT PropertyExists( "mailserver" ) )
		{
			SetProperty( "mailserver", "" );
		}
		if ( NOT PropertyExists( "mailpassword" ) )
		{
			SetProperty( "mailpassword", "" );
		}
		if ( NOT PropertyExists( "mailusername" ) )
		{
			SetProperty( "mailusername", "" );
		}
		if ( NOT PropertyExists( "useTLS" ) )
		{
			SetProperty( "useTLS", "false" );
		}
		if ( NOT PropertyExists( "useSSL" ) )
		{
			SetProperty( "useSSL", "false" );
		}

		return this;
	}

	/**
	 * Write an entry into the appender. You must implement this method yourself.
	 *
	 * @logEvent The logging event to log
	 */
	function logMessage ( required logbox.system.logging.LogEvent logEvent )
	{
		var loge    = arguments.logEvent;
		var subject = "#SeverityToString( loge.getSeverity() )#-#loge.getCategory()#-#GetProperty( "subject" )#";
		var entry   = "";

		try
		{
			if ( HasCustomLayout() )
			{
				entry = GetCustomLayout().format( loge );
				if ( StructKeyExists( GetCustomLayout(), "getSubject" ) )
				{
					subject = GetCustomLayout().getSubject( loge );
				}
			}
			else
			{
				savecontent variable="entry" {
					WriteOutput(
						 "
						<p>TimeStamp: #loge.getTimeStamp()#</p>
						<p>Severity: #loge.getSeverity()#</p>
						<p>Category: #loge.getCategory()#</p>
						<hr/>
						<p>#loge.getMessage()#</p>
						<hr/>
						<p>Extra Info Dump:</p>
					"
					);
					WriteDump( var = loge.getExtraInfo(), top = 10 );
				}
			}

			if ( Len( GetProperty( "mailserver" ) ) )
			{
				cfmail(
					 to       = GetProperty( "to" )
					,from     = GetProperty( "from" )
					,cc       = GetProperty( "cc" )
					,bcc      = GetProperty( "bcc" )
					,type     = "text/html"
					,useTLS   = GetProperty( "useTLS" )
					,useSSL   = GetProperty( "useSSL" )
					,server   = GetProperty( "mailserver" )
					,port     = GetProperty( "mailport" )
					,username = GetProperty( "mailusername" )
					,password = GetProperty( "mailpassword" )
					,subject  = subject
				) {
					WriteOutput( entry );
				}
			}
			else
			{
				cfmail(
					 to      = GetProperty( "to" )
					,from    = GetProperty( "from" )
					,cc      = GetProperty( "cc" )
					,bcc     = GetProperty( "bcc" )
					,type    = "text/html"
					,useTLS  = GetProperty( "useTLS" )
					,useSSL  = GetProperty( "useSSL" )
					,subject = subject
				) {
					WriteOutput( entry );
				}
			}
		}
		catch ( Any e )
		{
			$log( "ERROR", "Error sending email from appender #GetName()#. #e.message# #e.detail# #e.stacktrace#" );
		}

		return this;
	}

}
