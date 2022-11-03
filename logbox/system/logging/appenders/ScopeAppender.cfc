/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * A simple Scope Appender that logs to a specified scope.
 * Properties:
 * - scope : the scope to persist to, defaults to request (optional)
 * - key   : the key to use in the scope, it defaults to the name of the Appender (optional)
 * - limit : a limit to the amount of logs to rotate. Defaults to 0, unlimited (optional)
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

		// Verify properties
		if ( NOT PropertyExists( "scope" ) )
		{
			SetProperty( "scope", "request" );
		}
		if ( NOT PropertyExists( "key" ) )
		{
			SetProperty( "key", GetName() );
		}
		if ( NOT PropertyExists( "limit" ) OR NOT IsNumeric( GetProperty( "limit" ) ) )
		{
			SetProperty( "limit", 0 );
		}

		// Scope storage
		variables.scopeStorage = new logbox.system.core.collections.ScopeStorage();
		// Scope Checks
		variables.scopeStorage.scopeCheck( Getproperty( "scope" ) );
		// UUID generator
		variables.uuid = CreateObject( "java", "java.util.UUID" );

		return this;
	}

	/**
	 * Write an entry into the appender. You must implement this method yourself.
	 *
	 * @logEvent The logging event to log
	 */
	function logMessage ( required logbox.system.logging.LogEvent logEvent )
	{
		var entry = StructNew();
		var limit = GetProperty( "limit" );
		var loge  = arguments.logEvent;

		// Verify storage
		EnsureStorage();

		// Check Limits
		var logStack = GetStorage();

		if ( limit GT 0 and ArrayLen( logStack ) GTE limit )
		{
			// pop one out, the oldest
			ArrayDeleteAt( logStack, 1 );
		}

		// Log Away
		entry.id           = variables.uuid.randomUUID().toString();
		entry.logDate      = loge.getTimeStamp();
		entry.appenderName = GetName();
		entry.severity     = SeverityToString( loge.getseverity() );
		entry.message      = loge.getMessage();
		entry.extraInfo    = loge.getextraInfo();
		entry.category     = loge.getCategory();

		// Save Storage
		ArrayAppend( logStack, entry );
		SaveStorage( logStack );

		return this;
	}

	/************************************ PRIVATE ***************************************/

	/**
	 * Get the storage
	 */
	private any function getStorage ()
	{
		lock name="#Getname()#.scopeoperation" type="exclusive" timeout="20" throwOnTimeout="true" {
			return variables.scopeStorage.get( GetProperty( "key" ), GetProperty( "scope" ) );
		}
	}

	/**
	 * Save Storage
	 *
	 * @data The data to store
	 */
	private function saveStorage ( required data )
	{
		lock name="#Getname()#.scopeoperation" type="exclusive" timeout="20" throwOnTimeout="true" {
			variables.scopeStorage.put( GetProperty( "key" ), arguments.data, GetProperty( "scope" ) );
		}
		return this;
	}

	/**
	 * Ensure the first storage in the scope
	 */
	private function ensureStorage ()
	{
		if ( NOT variables.scopeStorage.exists( GetProperty( "key" ), Getproperty( "scope" ) ) )
		{
			variables.scopeStorage.put( GetProperty( "key" ), [], GetProperty( "scope" ) );
		}
		return this;
	}

}
