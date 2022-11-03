/**
 * Functional Interface that maps to java.util.function.Function
 * but will return the native future which is expected in the result
 * of the called target
 */
component extends="Function" {

	/**
	 * Represents a function that accepts one argument and produces a result.
	 * I have to use it like this because `super` does not work on ACF in a proxy
	 */
	function apply ( t )
	{
		LoadContext();
		try
		{
			lock name="#GetConcurrentEngineLockName()#" type="exclusive" timeout="60" {
				var oFuture = variables.target( arguments.t );
				if ( IsNull( local.oFuture ) || !StructKeyExists( local.oFuture, "getNative" ) )
				{
					Throw(
						 type    = "IllegalFutureException"
						,message = "The return of the function is NOT a ColdBox Future"
					);
				}
				return local.oFuture.getNative();
			}
		}
		catch ( any e )
		{
			// Log it, so it doesn't go to ether
			Err( "Error running FutureFunction: #e.message & e.detail#" );
			Err( "Stacktrace for FutureFunction: #e.stackTrace#" );
			rethrow;
		}
		finally
		{
			UnLoadContext();
		}
	}

}
