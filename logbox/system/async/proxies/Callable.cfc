component extends="Supplier" {

	/**
	 * Functional interface for supplier to get a result
	 * See https://docs.oracle.com/javase/8/docs/api/java/util/function/Supplier.html
	 */
	function call ()
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
			Err( "Error running Callable: #e.message & e.detail#" );
			Err( "Stacktrace for Callable: #e.stackTrace#" );
			rethrow;
		}
		finally
		{
			UnLoadContext();
		}
	}

}
