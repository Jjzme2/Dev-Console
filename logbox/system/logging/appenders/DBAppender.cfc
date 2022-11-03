/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * A simple DB appender for MySQL, MSSQL, Oracle, PostgreSQL
 *
 * Properties:
 * - dsn : the dsn to use for logging
 * - table : the table to store the logs in
 * - schema : which schema the table exists in (Optional)
 * - columnMap : A column map for aliasing columns. (Optional)
 * - autocreate : if true, then we will create the table. Defaults to false (Optional)
 * - ensureChecks : if true, then we will check the dsn and table existence.  Defaults to true (Optional)
 *
 * The columns needed in the table are
 *
 * - id : UUID
 * - severity : string
 * - category : string
 * - logdate : timestamp
 * - appendername : string
 * - message : string
 * - extrainfo : string
 *
 * If you are building a mapper, a column that is not in the map will use the default column name.
 **/
component accessors="true" extends="logbox.system.logging.AbstractAppender" {

	// Default column names
	variables.DEFAULT_COLUMNS = [
		 "id"
		,"severity"
		,"category"
		,"logdate"
		,"appendername"
		,"message"
		,"extrainfo"
	];

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

		// UUID generator
		variables.uuid = CreateObject( "java", "java.util.UUID" );

		// Verify properties
		if ( NOT PropertyExists( "dsn" ) )
		{
			Throw( message = "No dsn property defined", type = "DBAppender.InvalidProperty" );
		}
		if ( NOT PropertyExists( "table" ) )
		{
			Throw( message = "No table property defined", type = "DBAppender.InvalidProperty" );
		}
		if ( NOT PropertyExists( "autoCreate" ) OR NOT IsBoolean( GetProperty( "autoCreate" ) ) )
		{
			SetProperty( "autoCreate", false );
		}
		if ( NOT PropertyExists( "defaultCategory" ) )
		{
			SetProperty( "defaultCategory", arguments.name );
		}
		if ( NOT PropertyExists( "ensureChecks" ) )
		{
			SetProperty( "ensureChecks", true );
		}
		if ( NOT PropertyExists( "rotate" ) )
		{
			SetProperty( "rotate", true );
		}
		if ( NOT PropertyExists( "rotationDays" ) )
		{
			SetProperty( "rotationDays", 30 );
		}
		if ( NOT PropertyExists( "rotationFrequency" ) )
		{
			SetProperty( "rotationFrequency", 5 );
		}
		if ( NOT PropertyExists( "schema" ) )
		{
			SetProperty( "schema", "" );
		}

		// DB Rotation Time
		variables.lastDBRotation = "";
		return this;
	}

	/**
	 * Runs on registration
	 */
	function onRegistration ()
	{
		if ( GetProperty( "ensureChecks" ) )
		{
			// Table Checks
			EnsureTable();
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
		var category = GetProperty( "defaultCategory" );

		// Check Category Sent?
		if ( NOT arguments.logEvent.getCategory() eq "" )
		{
			category = arguments.logEvent.getCategory();
		}

		QueueMessage( {
			 "severity" : SeverityToString( arguments.logEvent.getseverity() )
			,"category" : Left( category, 100 )
			,"timestamp": arguments.logEvent.getTimestamp()
			,"message"  : arguments.logEvent.getMessage()
			,"extraInfo": arguments.logEvent.getExtraInfoAsString()
		} );

		return this;
	}

	/**
	 * Rotation checks
	 */
	function rotationCheck ()
	{
		// Verify if in rotation frequency
		if (
			!GetProperty( "rotate" ) OR (
				IsDate( variables.lastDBRotation ) AND DateDiff( "n", variables.lastDBRotation, Now() ) LTE GetProperty(
					 "rotationFrequency"
				)
			)
		)
		{
			return;
		}

		// Rotations
		this.doRotation();

		// Store last profile time
		variables.lastDBRotation = Now();
	}

	/**
	 * Do the rotation
	 */
	function doRotation ()
	{
		var qLogs      = "";
		var cols       = GetColumnNames();
		var targetDate = DateAdd( "d", "-#GetProperty( "rotationDays" )#", Now() );

		QueryExecute(
			 "DELETE
				FROM #GetTable()#
				WHERE #ListGetAt( cols, 4 )# < :datetime
			"
			,{
				 "datetime": {
					 "cfsqltype": "#GetDateTimeDBType()#"
					,"value"    : "#DateFormat( targetDate, "mm/dd/yyyy" )#"
				}
			}
			,{ "datasource": GetProperty( "dsn" ) }
		);

		return this;
	}

	/**
	 * Fired once the listener starts queue processing
	 *
	 * @queueContext A struct of data attached to this processing queue thread
	 */
	function onLogListenerStart ( required struct queueContext )
	{
	}

	/**
	 * Fired once the listener will go to sleep
	 *
	 * @queueContext A struct of data attached to this processing queue thread
	 */
	function onLogListenerSleep ( required struct queueContext )
	{
		this.rotationCheck();
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
		var cols = GetColumnNames();

		// Insert into table
		QueryExecute(
			 "INSERT INTO #GetTable()# (#cols#)
				VALUES (
					:uuid,
					:severity,
					:category,
					:timestamp,
					:name,
					:message,
					:extraInfo
				)
			"
			,{
				 "uuid"     : { "cfsqltype": "cf_sql_varchar", "value": "#variables.uuid.randomUUID().toString()#" }
				,"severity" : { "cfsqltype": "cf_sql_varchar", "value": "#arguments.data.severity#" }
				,"category" : { "cfsqltype": "cf_sql_varchar", "value": "#arguments.data.category#" }
				,"timestamp": { "cfsqltype": "cf_sql_timestamp", "value": "#arguments.data.timestamp#" }
				,"name"     : { "cfsqltype": "cf_sql_varchar", "value": "#Left( GetName(), 100 )#" }
				,"message"  : { "cfsqltype": "cf_sql_varchar", "value": "#arguments.data.message#" }
				,"extraInfo": { "cfsqltype": "cf_sql_varchar", "value": "#arguments.data.extraInfo#" }
			}
			,{ "datasource": GetProperty( "dsn" ) }
		);
		return this;
	}

	/**
	 * Fired once the listener stops queue processing
	 *
	 * @queueContext A struct of data attached to this processing queue thread
	 */
	function onLogListenerEnd ( required struct queueContext )
	{
	}

	/************************************************ PRIVATE ************************************************/

	/**
	 * Return the table name with the schema included if found.
	 */
	private function getTable ()
	{
		if ( Len( GetProperty( "schema" ) ) )
		{
			return GetProperty( "schema" ) & "." & GetProperty( "table" );
		}
		return GetProperty( "table" );
	}

	/**
	 * Verify or create the logging table
	 */
	private function ensureTable ()
	{
		var dsn        = GetProperty( "dsn" );
		var qTables    = 0;
		var tableFound = false;
		var qCreate    = "";
		var cols       = GetColumnNames();

		if ( GetProperty( "autoCreate" ) )
		{
			// Get Tables on this DSN
			cfdbinfo( datasource = "#dsn#", name = "qTables", type = "tables" );

			for ( var thisRecord in qTables )
			{
				if ( thisRecord.table_name == GetProperty( "table" ) )
				{
					tableFound = true;
					break;
				}
			}

			if ( NOT tableFound )
			{
				QueryExecute(
					 "CREATE TABLE #GetTable()# (
						#ListGetAt( cols, 1 )# VARCHAR(36) NOT NULL,
						#ListGetAt( cols, 2 )# VARCHAR(10) NOT NULL,
						#ListGetAt( cols, 3 )# VARCHAR(100) NOT NULL,
						#ListGetAt( cols, 4 )# #GetDateTimeColumnType()# NOT NULL,
						#ListGetAt( cols, 5 )# VARCHAR(100) NOT NULL,
						#ListGetAt( cols, 6 )# #GetTextColumnType()#,
						#ListGetAt( cols, 7 )# #GetTextColumnType()#,
						PRIMARY KEY ( #ListGetAt( cols, 1 )# )
					)"
					,{}
					,{ "datasource": GetProperty( "dsn" ) }
				);
			}
		}
	}

	/**
	 * Get db specific date time column type
	 */
	private function getDateTimeDBType ()
	{
		var qResults = "";

		cfdbinfo( type = "Version", name = "qResults", datasource = "#GetProperty( "dsn" )#" );

		switch ( qResults.database_productName )
		{
			case "PostgreSQL": {
				return "cf_sql_timestamp";
			}
			case "MySQL": {
				return "cf_sql_timestamp";
			}
			case "Microsoft SQL Server": {
				return "cf_sql_date";
			}
			case "Oracle": {
				return "cf_sql_timestamp";
			}
			default: {
				return "cf_sql_timestamp";
			}
		}
	}

	/**
	 * Get db specific text column type
	 */
	private function getTextColumnType ()
	{
		var qResults = "";

		cfdbinfo( type = "Version", name = "qResults", datasource = "#GetProperty( "dsn" )#" );

		switch ( qResults.database_productName )
		{
			case "PostgreSQL": {
				return "TEXT";
			}
			case "MySQL": {
				return "LONGTEXT";
			}
			case "Microsoft SQL Server": {
				return "TEXT";
			}
			case "Oracle": {
				return "LONGTEXT";
			}
			default: {
				return "TEXT";
			}
		}
	}

	/**
	 * Get db specific text column type
	 */
	private function getDateTimeColumnType ()
	{
		var qResults = "";

		cfdbinfo( type = "Version", name = "qResults", datasource = "#GetProperty( "dsn" )#" );

		switch ( qResults.database_productName )
		{
			case "PostgreSQL": {
				return "TIMESTAMP";
			}
			case "MySQL": {
				return "DATETIME";
			}
			case "Microsoft SQL Server": {
				return "DATETIME";
			}
			case "Oracle": {
				return "DATE";
			}
			default: {
				return "DATETIME";
			}
		}
	}

	/**
	 * Return a list of the column names for the database, this is affected by the `columnMap` property.
	 */
	private string function getColumnNames ()
	{
		var columnNames = variables.DEFAULT_COLUMNS;

		if ( PropertyExists( "columnMap" ) )
		{
			var columnMap = GetProperty( "columnMap" );
			columnNames   = variables.DEFAULT_COLUMNS.map( function ( thisColumn )
			{
				return columnMap.keyExists( arguments.thisColumn ) ? columnMap[ arguments.thisColumn ] : arguments.thisColumn;
			} );
		}

		return ArrayToList( columnNames );
	}

}
