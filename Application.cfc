/**
 * Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 */
component {

	// Application properties
	this.name              = Hash( GetCurrentTemplatePath() );
	this.sessionManagement = true;
	this.sessionTimeout    = CreateTimespan( 0, 0, 30, 0 );
	this.setClientCookies  = true;
	this.datasource        = "DeveloperConsole";

	// Java Integration
	this.javaSettings = {
		 "loadPaths"              : [ ExpandPath( "./lib" ) ]
		,"loadColdFusionClassPath": true
		,"reloadOnChange"         : false
	};

	// COLDBOX STATIC PROPERTY, DO NOT CHANGE UNLESS THIS IS NOT THE ROOT OF YOUR COLDBOX APP
	COLDBOX_APP_ROOT_PATH = GetDirectoryFromPath( GetCurrentTemplatePath() );
	// The web server mapping to this application. Used for remote purposes or static purposes
	COLDBOX_APP_MAPPING   = "";
	// COLDBOX PROPERTIES
	COLDBOX_CONFIG_FILE   = "";
	// COLDBOX APPLICATION KEY OVERRIDE
	COLDBOX_APP_KEY       = "";

	// application start
	public boolean function onApplicationStart ()
	{
		application.cbBootstrap = new coldbox.system.Bootstrap(
			 COLDBOX_CONFIG_FILE
			,COLDBOX_APP_ROOT_PATH
			,COLDBOX_APP_KEY
			,COLDBOX_APP_MAPPING
		);
		application.cbBootstrap.loadColdbox();
		application.logbox = new coldbox.system.logging.LogBox( "/coldbox/system/logging/config/CustomLogBoxConfig" );
		return true;
	}

	// application end
	public void function onApplicationEnd ( struct appScope )
	{
		arguments.appScope.cbBootstrap.onApplicationEnd( arguments.appScope );
	}

	// request start
	public boolean function onRequestStart ( string targetPage )
	{
		// Process ColdBox Request
		application.cbBootstrap.onRequestStart( arguments.targetPage );
		return true;
	}

	public void function onSessionStart ()
	{
		application.cbBootStrap.onSessionStart();
	}

	public void function onSessionEnd ( struct sessionScope, struct appScope )
	{
		arguments.appScope.cbBootStrap.onSessionEnd( argumentCollection = arguments );
	}

	public boolean function onMissingTemplate ( template )
	{
		return application.cbBootstrap.onMissingTemplate( argumentCollection = arguments );
	}

}
