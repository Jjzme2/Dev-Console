component {

	function configure ()
	{
		// Set Full Rewrites
		SetFullRewrites( true );

		/**
		 * --------------------------------------------------------------------------
		 * App Routes
		 * --------------------------------------------------------------------------
		 *
		 * Here is where you can register the routes for your web application!
		 * Go get Funky!
		 *
		 */

		// A nice healthcheck route example
		Route( "/healthcheck", function ( event, rc, prc )
		{
			return "Ok!";
		} );

		// A nice RESTFul Route example
		Route( "/api/echo", function ( event, rc, prc )
		{
			return { "error": false, "data": "Welcome to my awesome API!" };
		} );

		// Conventions based routing
		Route( ":handler/:action?" ).end();
	}

}
