/**
 * 	ColdBox Integration Test
 *
 * 	The 'appMapping' points by default to the '/root ' mapping created in  the test folder Application.cfc.  Please note that this
 * 	Application.cfc must mimic the real one in your root, including ORM  settings if needed.
 *
 *	The 'execute()' method is used to execute a ColdBox event, with the  following arguments
 *	- event : the name of the event
 *	- private : if the event is private or not
 *	- prePostExempt : if the event needs to be exempt of pre post interceptors
 *	- eventArguments : The struct of args to pass to the event
 *	- renderResults : Render back the results of the event
 *
 * You can also use the HTTP executables: get(), post(), put(), path(), delete(), request()
 **/
component extends="coldbox.system.testing.BaseTestCase" appMapping="/" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll ()
	{
		super.beforeAll();
		// do your own stuff here
	}

	function afterAll ()
	{
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run ()
	{
		Describe( "user Suite", function ()
		{
			BeforeEach( function ( currentSpec )
			{
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				Setup();
			} );

			It( "index", function ()
			{
				// Execute event or route via GET http method. Spice up accordingly
				var event = Get( "user.index" );
				// expectations go here.
				Expect( false ).toBeTrue();
			} );

			It( "homepage", function ()
			{
				// Execute event or route via GET http method. Spice up accordingly
				var event = Get( "user.homepage" );
				// expectations go here.
				Expect( false ).toBeTrue();
			} );

			It( "login", function ()
			{
				// Execute event or route via GET http method. Spice up accordingly
				var event = Get( "user.login" );
				// expectations go here.
				Expect( false ).toBeTrue();
			} );

			It( "logout", function ()
			{
				// Execute event or route via GET http method. Spice up accordingly
				var event = Get( "user.logout" );
				// expectations go here.
				Expect( false ).toBeTrue();
			} );

			It( "register", function ()
			{
				// Execute event or route via GET http method. Spice up accordingly
				var event = Get( "user.register" );
				// expectations go here.
				Expect( false ).toBeTrue();
			} );

			It( "edit", function ()
			{
				// Execute event or route via GET http method. Spice up accordingly
				var event = Get( "user.edit" );
				// expectations go here.
				Expect( false ).toBeTrue();
			} );
		} );
	}

}
