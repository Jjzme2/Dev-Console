/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This is a LogBox configuration object.  You can use it to configure a LogBox instance.
 **/
component accessors="true" {

	// The log levels enum as a public property
	this.logLevels    = new logbox.system.logging.LogLevels();
	// Internal Utility object
	variables.utility = new logbox.system.core.util.Util();
	// Instance private scope
	instance          = StructNew();
	// Startup the configuration
	Reset();

	/**
	 * Constructor
	 *
	 * @CFCConfig     The logBox Data Configuration CFC
	 * @CFCConfigPath The logBox Data Configuration CFC path to use
	 */
	function init ( any CFCConfig, string CFCConfigPath )
	{
		// Test and load via Data CFC Path
		if ( StructKeyExists( arguments, "CFCConfigPath" ) )
		{
			arguments.CFCConfig = CreateObject( "component", arguments.CFCConfigPath );
		}

		// Test and load via Data CFC
		if ( StructKeyExists( arguments, "CFCConfig" ) and IsObject( arguments.CFCConfig ) )
		{
			// Decorate our data CFC
			arguments.CFCConfig.getPropertyMixin = variables.utility.getMixerUtil().getPropertyMixin;
			// Execute the configuration
			arguments.CFCConfig.configure();
			// Get Data
			var logBoxDSL = arguments.CFCConfig.getPropertyMixin( "logBox", "variables", StructNew() );
			// Load the DSL
			LoadDataDSL( logBoxDSL );
		}

		// Just return, most likely programmatic config
		return this;
	}

	/**
	 * Reset the configuration
	 */
	LogBoxConfig function reset ()
	{
		// Register appenders
		instance.appenders  = StructNew();
		// Register categories
		instance.categories = StructNew();
		// Register root logger
		instance.rootLogger = StructNew();
		return this;
	}

	/**
	 * Load a data configuration CFC data DSL
	 *
	 * @rawDSL The data configuration DSL structure
	 */
	LogBoxConfig function loadDataDSL ( required struct rawDSL )
	{
		var logBoxDSL = arguments.rawDSL;

		// Register Appenders
		for ( var key in logBoxDSL.appenders )
		{
			logBoxDSL.appenders[ key ].name = key;
			Appender( argumentCollection = logBoxDSL.appenders[ key ] );
		}

		// Register Root Logger
		if ( NOT StructKeyExists( logBoxDSL, "root" ) )
		{
			logBoxDSL.root = { "appenders": "*" };
		}
		Root( argumentCollection = logBoxDSL.root );

		// Register Categories
		if ( StructKeyExists( logBoxDSL, "categories" ) )
		{
			for ( var key in logBoxDSL.categories )
			{
				logBoxDSL.categories[ key ].name = key;
				Category( argumentCollection = logBoxDSL.categories[ key ] );
			}
		}

		// Register Level Categories
		if ( StructKeyExists( logBoxDSL, "debug" ) )
		{
			DEBUG( argumentCollection = variables.utility.arrayToStruct( logBoxDSL.debug ) );
		}
		if ( StructKeyExists( logBoxDSL, "info" ) )
		{
			INFO( argumentCollection = variables.utility.arrayToStruct( logBoxDSL.info ) );
		}
		if ( StructKeyExists( logBoxDSL, "warn" ) )
		{
			WARN( argumentCollection = variables.utility.arrayToStruct( logBoxDSL.warn ) );
		}
		if ( StructKeyExists( logBoxDSL, "error" ) )
		{
			ERROR( argumentCollection = variables.utility.arrayToStruct( logBoxDSL.error ) );
		}
		if ( StructKeyExists( logBoxDSL, "fatal" ) )
		{
			FATAL( argumentCollection = variables.utility.arrayToStruct( logBoxDSL.fatal ) );
		}
		if ( StructKeyExists( logBoxDSL, "off" ) )
		{
			OFF( argumentCollection = variables.utility.arrayToStruct( logBoxDSL.off ) );
		}

		return this;
	}

	/**
	 * Reset appender configuration
	 */
	LogBoxConfig function resetAppenders ()
	{
		instance.appenders = StructNew();
		return this;
	}

	/**
	 * Reset categories configuration
	 */
	LogBoxConfig function resetCategories ()
	{
		instance.categories = StructNew();
		return this;
	}

	/**
	 * Reset root configuration
	 */
	LogBoxConfig function resetRoot ()
	{
		instance.rootLogger = StructNew();
		return this;
	}

	/**
	 * Get the instance memento
	 */
	struct function getMemento ()
	{
		return instance;
	}

	/**
	 * Validates the configuration. If not valid, it will throw an appropriate exception.
	 *
	 * @throws AppenderNotFound
	 */
	LogBoxConfig function validate ()
	{
		// Check root logger definition
		if ( StructIsEmpty( instance.rootLogger ) )
		{
			// Auto register a root logger
			Root( appenders = "*" );
		}

		// All root appenders?
		if ( instance.rootLogger.appenders eq "*" )
		{
			instance.rootLogger.appenders = StructKeyList( GetAllAppenders() );
		}

		// Check root's appenders
		for ( var x = 1; x lte ListLen( instance.rootLogger.appenders ); x++ )
		{
			if ( NOT StructKeyExists( instance.appenders, ListGetAt( instance.rootLogger.appenders, x ) ) )
			{
				Throw(
					 message = "Invalid appender in Root Logger"
					,detail  = "The appender #ListGetAt( instance.rootLogger.appenders, x )# has not been defined yet. Please define it first."
					,type    = "AppenderNotFound"
				);
			}
		}

		// Check all Category Appenders
		for ( var key in instance.categories )
		{
			// Check * all appenders
			if ( instance.categories[ key ].appenders eq "*" )
			{
				instance.categories[ key ].appenders = StructKeyList( GetAllAppenders() );
			}

			for ( var x = 1; x lte ListLen( instance.categories[ key ].appenders ); x++ )
			{
				if ( NOT StructKeyExists( instance.appenders, ListGetAt( instance.categories[ key ].appenders, x ) ) )
				{
					Throw(
						 message = "Invalid appender in Category: #key#"
						,detail  = "The appender #ListGetAt( instance.categories[ key ].appenders, x )# has not been defined yet. Please define it first."
						,type    = "AppenderNotFound"
					);
				}
			}
		}

		return this;
	}

	/**
	 * Add an appender configuration
	 *
	 * @name       A unique name for the appender to register. Only unique names can be registered per instance
	 * @class      The appender's class to register. We will create, init it and register it for you
	 * @properties The structure of properties to configure this appender with.
	 * @layout     The layout class path to use in this appender for custom message rendering.
	 * @levelMin   The default log level for the root logger, by default it is 0 (FATAL). Optional. ex: config.logLevels.WARN
	 * @levelMax   The default log level for the root logger, by default it is 4 (DEBUG). Optional. ex: config.logLevels.WARN
	 */
	LogBoxConfig function appender (
		 required name
		,required class
		,struct properties = {}
		,layout            = ""
		,levelMin          = 0
		,levelMax          = 4
	)
	{
		// Convert Levels
		ConvertLevels( arguments );

		// Check levels
		LevelChecks( arguments.levelMin, arguments.levelMax );

		// Register appender
		instance.appenders[ arguments.name ] = arguments;

		return this;
	}

	/**
	 * Add an appender configuration
	 *
	 * @appenders A list of appenders to configure the root logger with. Send a * to add all appenders
	 * @levelMin  The default log level for the root logger, by default it is 0 (FATAL). Optional. ex: config.logLevels.WARN
	 * @levelMax  The default log level for the root logger, by default it is 4 (DEBUG). Optional. ex: config.logLevels.WARN
	 *
	 * @throws InvalidAppenders
	 */
	LogBoxConfig function root ( required appenders, levelMin = 0, levelMax = 4 )
	{
		// Convert Levels
		ConvertLevels( arguments );

		// Check levels
		LevelChecks( arguments.levelMin, arguments.levelMax );

		// Verify appender list
		if ( NOT ListLen( arguments.appenders ) )
		{
			Throw(
				 message = "Invalid Appenders"
				,detail  = "Please send in at least one appender for the root logger"
				,type    = "InvalidAppenders"
			);
		}

		// Add definition
		instance.rootLogger = arguments;

		return this;
	}

	/**
	 * Get the root logger definition
	 */
	struct function getRoot ()
	{
		return instance.rootLogger;
	}

	/**
	 * Add a new category configuration with appender(s).  Appenders MUST be defined first, else this method will throw an exception
	 *
	 * @name      A unique name for the appender to register. Only unique names can be registered per instance
	 * @levelMin  The default log level for the root logger, by default it is 0 (FATAL). Optional. ex: config.logLevels.WARN
	 * @levelMax  The default log level for the root logger, by default it is 4 (DEBUG). Optional. ex: config.logLevels.WARN
	 * @appenders A list of appender names to configure this category with. By default it uses all the registered appenders
	 */
	LogBoxConfig function category (
		 required name
		,levelMin  = 0
		,levelMax  = 4
		,appenders = "*"
	)
	{
		// Convert Levels
		ConvertLevels( arguments );

		// Check levels
		LevelChecks( arguments.levelMin, arguments.levelMax );

		// Check * all appenders
		if ( appenders eq "*" )
		{
			appenders = StructKeyList( GetAllAppenders() );
		}

		// Add category registration
		instance.categories[ arguments.name ] = arguments;

		return this;
	}

	/**
	 * Get a specified category definition
	 *
	 * @name The category name
	 */
	struct function getCategory ( required name )
	{
		return instance.categories[ arguments.name ];
	}

	/**
	 * Check if a category definition exists
	 *
	 * @name The category name
	 */
	boolean function categoryExists ( required name )
	{
		return StructKeyExists( instance.categories, arguments.name );
	}

	/**
	 * Get the configured categories
	 */
	struct function getAllCategories ()
	{
		return instance.categories;
	}

	/**
	 * Get all the configured appenders
	 */
	struct function getAllAppenders ()
	{
		return instance.appenders;
	}

	/**
	 * Add categories to the DEBUG level. Send each category as an argument.
	 */
	LogBoxConfig function debug ()
	{
		for ( var key in arguments )
		{
			Category( name = arguments[ key ], levelMax = this.logLevels.DEBUG );
		}
		return this;
	}

	/**
	 * Add categories to the INFO level. Send each category as an argument.
	 */
	LogBoxConfig function info ()
	{
		for ( var key in arguments )
		{
			Category( name = arguments[ key ], levelMax = this.logLevels.INFO );
		}
		return this;
	}

	/**
	 * Add categories to the WARN level. Send each category as an argument.
	 */
	LogBoxConfig function warn ()
	{
		for ( var key in arguments )
		{
			Category( name = arguments[ key ], levelMax = this.logLevels.WARN );
		}
		return this;
	}

	/**
	 * Add categories to the ERROR level. Send each category as an argument.
	 */
	LogBoxConfig function error ()
	{
		for ( var key in arguments )
		{
			Category( name = arguments[ key ], levelMax = this.logLevels.ERROR );
		}
		return this;
	}

	/**
	 * Add categories to the FATAL level. Send each category as an argument.
	 */
	LogBoxConfig function fatal ()
	{
		for ( var key in arguments )
		{
			Category( name = arguments[ key ], levelMax = this.logLevels.FATAL );
		}
		return this;
	}

	/**
	 * Add categories to the OFF level. Send each category as an argument.
	 */
	LogBoxConfig function off ()
	{
		for ( var key in arguments )
		{
			Category( name = arguments[ key ], levelMin = this.logLevels.OFF, levelMax = this.logLevels.OFF );
		}
		return this;
	}

	/**
	 * Convert levels from an incoming structure of data
	 *
	 * @target The structure to look for elements: LevelMin and LevelMax
	 */
	private struct function convertLevels ( required target )
	{
		// Check levelMin
		if ( StructKeyExists( arguments.target, "levelMIN" ) and NOT IsNumeric( arguments.target.levelMin ) )
		{
			arguments.target.levelMin = this.logLevels.lookupAsInt( arguments.target.levelMin );
		}
		// Check levelMax
		if ( StructKeyExists( arguments.target, "levelMax" ) and NOT IsNumeric( arguments.target.levelMax ) )
		{
			arguments.target.levelMax = this.logLevels.lookupAsInt( arguments.target.levelMax );
		}
		// For chaining
		return arguments.target;
	}

	/**
	 * Level checks on incoming levels
	 *
	 * @levelMin
	 * @levelMax
	 *
	 * @throws InvalidLevel
	 */
	private function levelChecks ( required levelMin, required levelMax )
	{
		if ( !this.logLevels.isLevelValid( arguments.levelMin ) )
		{
			Throw( message = "LevelMin #arguments.levelMin# is not a valid level.", type = "InvalidLevel" );
		}
		else if ( !this.logLevels.isLevelValid( arguments.levelMax ) )
		{
			Throw( message = "LevelMin #arguments.levelMax# is not a valid level.", type = "InvalidLevel" );
		}
	}

}
