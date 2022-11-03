/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * An appender that leverages the OS file system
 *
 * Properties:
 * - filepath     : The location of where to store the log file.
 * - autoExpand   : Whether to expand the file path or not. Defaults to true.
 * - filename     : The name of the file, if not defined, then it will use the name of this appender. Do not append an extension to it. We will append a .log to it.
 * - fileEncoding : The file encoding to use, by default we use ISO-8859-1;
 **/
component accessors="true" extends="logbox.system.logging.AbstractAppender" {

	/**
	 * The log file location
	 */
	property name = "logFullpath";

	/**
	 * Constructor
	 *
	 * @name       The unique name for this appender.
	 * @properties A map of configuration properties for the appender"
	 * @layout     The layout class to use in this appender for custom message rendering.
	 * @levelMin   The default log level for this appender, by default it is 0. Optional. ex: LogBox.logLevels.WARN
	 * @levelMax   The default log level for this appender, by default it is 5. Optional. ex: LogBox.logLevels.WARN
	 *
	 * @throws FileAppender.PropertyNotFound
	 */
	function init (
		 required name
		,struct properties = {}
		,layout            = ""
		,levelMin          = 0
		,levelMax          = 4
	)
	{
		super.init( argumentCollection = arguments );

		// Setup Properties
		if ( NOT PropertyExists( "filepath" ) )
		{
			Throw( message = "Filepath property not defined", type = "FileAppender.PropertyNotFound" );
		}
		if ( NOT PropertyExists( "autoExpand" ) )
		{
			SetProperty( "autoExpand", true );
		}
		if ( NOT PropertyExists( "filename" ) )
		{
			SetProperty( "filename", GetName() );
		}
		if ( NOT PropertyExists( "fileEncoding" ) )
		{
			SetProperty( "fileEncoding", "ISO-8859-1" );
		}
		// Cleanup File Names
		SetProperty(
			 "filename"
			,ReReplaceNoCase(
				 GetProperty( "filename" )
				,"[^0-9a-z]"
				,""
				,"ALL"
			)
		);

		// Setup the log file full path
		variables.logFullpath = GetProperty( "filePath" );
		// Clean ending slash
		variables.logFullPath = ReReplaceNoCase( variables.logFullPath, "[/\\]$", "" );
		// Concatenate Full Log path
		variables.logFullPath = variables.logFullpath & "/" & GetProperty( "filename" ) & ".log";

		// Do we expand the path?
		if ( GetProperty( "autoExpand" ) )
		{
			variables.logFullPath = ExpandPath( variables.logFullpath );
		}

		return this;
	}

	/**
	 * Called upon registration
	 */
	FileAppender function onRegistration ()
	{
		// Init the log location
		InitLogLocation();

		return this;
	}

	/**
	 * Write an entry into the appender. You must implement this method yourself.
	 *
	 * @logEvent The logging event to log
	 */
	function logMessage ( required logbox.system.logging.LogEvent logEvent )
	{
		var loge      = arguments.logEvent;
		var timestamp = loge.getTimestamp();
		var message   = loge.getMessage();
		var entry     = "";

		// Message Layout
		if ( HasCustomLayout() )
		{
			entry = GetCustomLayout().format( loge );
		}
		else
		{
			// Cleanup main message
			if ( Len( loge.getExtraInfoAsString() ) )
			{
				message = message & " | ExtraInfo:" & loge.getExtraInfoAsString();
			}
			message = Replace( message, """", """""", "all" );
			message = Replace(
				 message
				,"#Chr( 13 )##Chr( 10 )#"
				,"  "
				,"all"
			);
			message = Replace( message, Chr( 13 ), "  ", "all" );

			// Entry string
			entry = """#SeverityToString( logEvent.getSeverity() )#"",""#Getname()#"",""#DateFormat( timestamp, "mm/dd/yyyy" )#"",""#TimeFormat( timestamp, "HH:mm:ss" )#"",""#loge.getCategory()#"",""#message#""";
		}

		// Queue it up
		QueueMessage( entry );

		return this;
	}

	/**
	 * Remove the log file for this appender
	 */
	FileAppender function removeLogFile ()
	{
		if ( FileExists( variables.logFullPath ) )
		{
			variables.lock(
				 body = function ()
				{
					if ( FileExists( variables.logFullPath ) )
					{
						FileDelete( variables.logFullPath );
					}
					// end double lock race condition
				}
			);
		}
		// end if

		return this;
	}

	/**
	 * Initialize the file log location if it does not exist. Please note that if exceptions are detected, then we log them in the CF facilities
	 */
	FileAppender function initLogLocation ()
	{
		if ( !FileExists( variables.logFullPath ) )
		{
			variables.lock(
				 body = function ()
				{
					if ( !FileExists( variables.logFullPath ) )
					{
						try
						{
							// Default Log Directory
							EnsureDefaultLogDirectory();
							// Create log file
							FileWrite(
								 variables.logFullPath
								,"""Severity"",""Appender"",""Date"",""Time"",""Category"",""Message""#Chr( 13 )##Chr( 10 )#"
							);
						}
						catch ( Any e )
						{
							$log(
								 "ERROR"
								,"Cannot create appender's: #GetName()# log file. File #variables.logFullpath#. #e.message# #e.detail#"
							);
						}
					}
					// end double lock race condition
				}
			);
		}

		return this;
	}

	/**
	 * Fired once the listener starts queue processing
	 *
	 * @queueContext A struct of data attached to this processing queue thread
	 */
	function onLogListenerStart ( required struct queueContext )
	{
		// Open the file to stream lines to
		arguments.queueContext.oFile         = FileOpen( variables.logFullPath, "append", this.getProperty( "fileEncoding" ) );
		// The flusing interval to disk
		arguments.queueContext.flushInterval = 1000;
	}

	/**
	 * Fired once the listener will go to sleep
	 *
	 * @queueContext A struct of data attached to this processing queue thread
	 */
	function onLogListenerSleep ( required struct queueContext )
	{
		var isFlushNeeded = ( arguments.queueContext.start + arguments.queueContext.flushInterval < GetTickCount() ) || arguments.queueContext.force;
		// flush to disk every start + 1000ms
		if (
			isFlushNeeded
				&&
				!IsSimpleValue( arguments.queueContext.oFile )
		)
		{
			// out( "LogFile for #getName()# flushed to disk at #now()# using interval: #arguments.queueContext.flushInterval#", true );
			FileClose( arguments.queueContext.oFile );
			arguments.queueContext.oFile = "";
			arguments.queueContext.start = GetTickCount();
		}
	}

	/**
	 * Processes a queue element to a destination
	 * This method is called by the log listeners asynchronously.
	 *
	 * @data         The data element the queue needs processing
	 * @queueContext The queue context in process
	 *
	 * @return ConsoleAppender
	 */
	function processQueueElement ( required data, required queueContext )
	{
		// If simple value, open it
		if ( IsSimpleValue( arguments.queueContext.oFile ) )
		{
			arguments.queueContext.oFile = FileOpen(
				 variables.logFullPath
				,"append"
				,this.getProperty( "fileEncoding" )
			);
		}

		// Write to file
		FileWriteLine( arguments.queueContext.oFile, arguments.data );

		return this;
	}

	/**
	 * Fired once the listener stops queue processing
	 *
	 * @queueContext A struct of data attached to this processing queue thread
	 */
	function onLogListenerEnd ( required struct queueContext )
	{
		if ( !IsNull( arguments.queueContext.oFile ) && !IsSimpleValue( arguments.queueContext.oFile ) )
		{
			FileClose( arguments.queueContext.oFile );
			arguments.queueContext.oFile = "";
		}
	}

	/**
	 * Process a shutdown!
	 */
	function shutdown ()
	{
		// runLogListener( force = true );
	}

	/************************************ PRIVATE ************************************/

	/**
	 * Ensures the log directory.
	 */
	private function ensureDefaultLogDirectory ()
	{
		var dirPath = GetDirectoryFromPath( variables.logFullpath );

		if ( !DirectoryExists( dirPath ) )
		{
			DirectoryCreate( dirPath );
		}

		return this;
	}

}
