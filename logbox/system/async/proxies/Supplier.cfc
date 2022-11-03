component extends="BaseProxy" {

	/**
	 * Constructor
	 *
	 * @supplier       The lambda or closure that will supply the elements
	 * @method         An optional method in case the supplier is a CFC instead of a closure
	 * @debug          Add debugging or not
	 * @loadAppContext By default, we load the Application context into the running thread. If you don't need it, then don't load it.
	 */
	function init (
		 required supplier
		,method                 = "run"
		,boolean debug          = false
		,boolean loadAppContext = true
	)
	{
		super.init( arguments.supplier, arguments.debug, arguments.loadAppContext );
		variables.method = arguments.method;
		return this;
	}

	/**
	 * Functional interface for supplier to get a result
	 * See https://docs.oracle.com/javase/8/docs/api/java/util/function/Supplier.html
	 */
	function get ()
	{
		LoadContext();
		try
		{
			lock name="#GetConcurrentEngineLockName()#" type="exclusive" timeout="60" {
				if ( IsClosure( variables.target ) || IsCustomFunction( variables.target ) )
				{
					return variables.target();
				}
				else
				{
					return Invoke( variables.target, variables.method );
				}
			}
		}
		catch ( any e )
		{
			// Log it, so it doesn't go to ether
			Err( "Error running Supplier: #e.message & e.detail#" );
			Err( "Stacktrace for Supplier: #e.stackTrace#" );
			rethrow;
		}
		finally
		{
			UnLoadContext();
		}
	}

}
