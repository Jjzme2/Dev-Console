/**
 * Functional interface that maps to java.util.function.BiFunction
 * See https://docs.oracle.com/javase/8/docs/api/java/util/function/BiFunction.html
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
	 * Functional interface for the apply functional interface
	 * See https://docs.oracle.com/javase/8/docs/api/java/util/function/BiFunction.html#apply-T-U-
	 */
	function apply ( t, u )
	{
		LoadContext();
		try
		{
			lock name="#GetConcurrentEngineLockName()#" type="exclusive" timeout="60" {
				return variables.target(
					 IsNull( arguments.t ) ? Javacast( "null", "" ) : arguments.t
					,IsNull( arguments.u ) ? Javacast( "null", "" ) : arguments.u
				);
			}
		}
		catch ( any e )
		{
			// Log it, so it doesn't go to ether
			Err( "Error running BiFunction: #e.message & e.detail#" );
			Err( "Stacktrace for BiFunction: #e.stackTrace#" );
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
