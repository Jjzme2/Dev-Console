/**
 * Functional interface that maps to java.util.function.BiFunction
 * See https://docs.oracle.com/javase/8/docs/api/java/util/function/BiConsumer.html
 */
component extends="BaseProxy" {

	/**
	 * Constructor
	 *
	 * @f a function to be applied to to the previous element to produce a new element
	 */
	function init ( required f )
	{
		super.init( arguments.f );
		return this;
	}

	/**
	 * Performs this operation on the given arguments.
	 * See https://docs.oracle.com/javase/8/docs/api/java/util/function/BiConsumer.html#accept-T-U-
	 */
	function accept ( required t, required u )
	{
		LoadContext();
		try
		{
			lock name="#GetConcurrentEngineLockName()#" type="exclusive" timeout="60" {
				variables.target( arguments.t, arguments.u );
			}
		}
		catch ( any e )
		{
			// Log it, so it doesn't go to ether
			Err( "Error running BiConsumer: #e.message & e.detail#" );
			Err( "Stacktrace for BiConsumer: #e.stackTrace#" );
			rethrow;
		}
		finally
		{
			UnLoadContext();
		}
	}

	function andThen ( required after )
	{
	}

}
