/**
 * Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 */
component {

	// APPLICATION CFC PROPERTIES
	this.name                 = "ColdBoxTestingSuite";
	this.sessionManagement    = true;
	this.setClientCookies     = true;
	this.sessionTimeout       = CreateTimespan( 0, 0, 15, 0 );
	this.applicationTimeout   = CreateTimespan( 0, 0, 15, 0 );
	// Turn on/off white space management
	this.whiteSpaceManagement = "smart";
	this.enableNullSupport    = ShouldEnableFullNullSupport();

	// Create testing mapping
	this.mappings[ "/tests" ] = GetDirectoryFromPath( GetCurrentTemplatePath() );
	// Map back to its root
	rootPath                  = ReReplaceNoCase( this.mappings[ "/tests" ], "tests(\\|/)", "" );
	this.mappings[ "/root" ]  = rootPath;

	public boolean function onRequestStart ( targetPage )
	{
		// Set a high timeout for long running tests
		setting requestTimeout   ="9999";
		// New ColdBox Virtual Application Starter
		request.coldBoxVirtualApp= new coldbox.system.testing.VirtualApp( appMapping = "/root" );

		// If hitting the runner or specs, prep our virtual app
		if ( GetBaseTemplatePath().replace( ExpandPath( "/tests" ), "" ).reFindNoCase( "(runner|specs)" ) )
		{
			request.coldBoxVirtualApp.startup();
		}

		// ORM Reload for fresh results
		if ( StructKeyExists( url, "fwreinit" ) )
		{
			if ( StructKeyExists( server, "lucee" ) )
			{
				PagePoolClear();
			}
			// ormReload();
			request.coldBoxVirtualApp.restart();
		}

		return true;
	}

	public void function onRequestEnd ( required targetPage )
	{
		request.coldBoxVirtualApp.shutdown();
	}

	private boolean function shouldEnableFullNullSupport ()
	{
		var system = CreateObject( "java", "java.lang.System" );
		var value  = system.getEnv( "FULL_NULL" );
		return IsNull( value ) ? false : !!value;
	}

}
