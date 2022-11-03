/**
 * This is the ColdBox Executor class which connects your code to the Java
 * Scheduling services to execute tasks on.
 *
 * The native property models the injected Java executor which can be:
 * - Fixed
 * - Cached
 * - Single
 * - Scheduled
 */
component accessors="true" singleton {

	/**
	 * The human name of this executor
	 */
	property name = "name";

	/**
	 * The native Java executor class modeled in this executor
	 */
	property name = "native";

	/**
	 * The default timeout the executor service will wait for all of it's tasks to shutdown.
	 * The default is 30 seconds. This number is in seconds.
	 */
	property name = "shutdownTimeout" type = "numeric" default = "30";

	// Prepare the static time unit class
	this.$timeUnit = new logbox.system.async.time.TimeUnit();

	/**
	 * Constructor
	 *
	 * @name            The name of the executor
	 * @executor        The native executor class
	 * @debug           Add output debugging
	 * @loadAppContext  Load the CFML App contexts or not, disable if not used
	 * @shutdownTimeout The timeout in seconds to use when gracefully shutting down the executor. Defaults to 30 seconds.
	 */
	Executor function init (
		 required name
		,required executor
		,boolean debug           = false
		,boolean loadAppContext  = true
		,numeric shutdownTimeout = 30
	)
	{
		variables.name            = arguments.name;
		variables.native          = arguments.executor;
		variables.debug           = arguments.debug;
		variables.loadAppContext  = arguments.loadAppContext;
		variables.shutdownTimeout = arguments.shutdownTimeout;

		return this;
	}

	/****************************************************************
	 * Executor Submit Tasks *
	 ****************************************************************/

	/**
	 * Submit a task into the executor which can return a result if any.
	 * The result of this call is a ColdBox FutureTask from which you can monitor,
	 * cancel, or get the result of the  the executing task.
	 *
	 * @callable THe callable closure/lambda/cfc to execute
	 * @method   The default method to execute if the runnable is a CFC, defaults to `run()`
	 *
	 * @return A ColdBox Future Task object
	 */
	FutureTask function submit ( required callable, method = "run" )
	{
		var jCallable = CreateDynamicProxy(
			 new logbox.system.async.proxies.Callable(
				 arguments.callable
				,arguments.method
				,variables.debug
				,variables.loadAppContext
			)
			,[ "java.util.concurrent.Callable" ]
		);

		// Send for execution
		return new logbox.system.async.tasks.FutureTask( variables.native.submit( jCallable ) );
	}

	/****************************************************************
	 * Executor Utility Methods *
	 ****************************************************************/

	/**
	 * Returns true if all tasks have completed following shut down.
	 */
	boolean function isTerminated ()
	{
		return variables.native.isTerminated();
	}

	/**
	 * Returns true if this executor is in the process of terminating after shutdown() or shutdownNow() but has
	 * not completely terminated.
	 */
	boolean function isTerminating ()
	{
		return variables.native.isTerminating();
	}

	/**
	 * Returns true if this executor has been shut down.
	 */
	boolean function isShutdown ()
	{
		return variables.native.isShutdown();
	}

	/**
	 * Blocks until all tasks have completed execution after a shutdown request, or the timeout occurs, or
	 * the current thread is interrupted, whichever happens first.
	 *
	 * @timeout  The maximum time to wait
	 * @timeUnit The time unit to use, available units are: days, hours, microseconds, milliseconds, minutes, nanoseconds, and seconds. The default is seconds
	 *
	 * @return true if all tasks have completed following shut down
	 *
	 * @throws InterruptedException - if interrupted while waiting
	 */
	boolean function awaitTermination ( required numeric timeout, timeUnit = "seconds" )
	{
		return variables.native.awaitTermination(
			 Javacast( "long", arguments.timeout )
			,this.$timeUnit.get( arguments.timeUnit )
		);
	}

	/**
	 * Shuts down the executor in two phases, first by calling the shutdown() and rejecting all incoming tasks.
	 * Second, calling shutdownNow() aggresively if tasks did not shutdown on time to cancel any lingering tasks.
	 *
	 * @timeout The timeout in seconds to wait for the shutdown.  By deafult we use the default on the property shutdownTimeout (30s)
	 */
	Executor function shutdownAndAwaitTermination ( numeric timeout = variables.shutdownTimeout )
	{
		var sTime = GetTickCount();
		// Disable new tasks from being submitted
		Shutdown();
		try
		{
			Out( "Executor (#GetName()#) shutdown executed, waiting for tasks to finalize..." );

			// Wait for tasks to terminate
			if ( !AwaitTermination( arguments.timeout ) )
			{
				Out( "Executor tasks did not shutdown, forcibly shutting down executor (#GetName()#)..." );

				// Cancel all tasks forcibly
				var taskList = ShutdownNow();

				Out( "Tasks waiting execution on executor (#GetName()#) -> #taskList.toString()#" );

				// Wait again now forcibly
				if ( !AwaitTermination( arguments.timeout ) )
				{
					Err( "Executor (#GetName()#) did not terminate even gracefully :(" );
					return this;
				}
			}
			Out( "Executor (#GetName()#) shutdown completed in (#NumberFormat( GetTickCount() - sTime )#ms)" );
		}
		// Catch if exceptions or interrupted
		catch ( any e )
		{
			Out( "Executor (#GetName()#) shutdown interrupted or exception thrown (#e.message & e.detail#) :)" );
			// force it down!
			ShutdownNow();
			// Preserve interrupt status
			CreateObject( "java", "java.lang.Thread" ).currentThread().interrupt();
		}
		return this;
	}

	/**
	 * Initiates an orderly shutdown in which previously submitted tasks are executed, but no new tasks will be accepted.
	 * Invocation has no additional effect if already shut down.
	 *
	 * This method does not wait for previously submitted tasks to complete execution. Use awaitTermination to do that.
	 *
	 */
	Executor function shutdown ()
	{
		variables.native.shutdown();
		return this;
	}

	/**
	 * Attempts to stop all actively executing tasks, halts the processing of
	 * waiting tasks, and returns a list of the tasks that were awaiting execution.
	 *
	 * This method does not wait for actively executing tasks to terminate. Use awaitTermination to do that.
	 *
	 * There are no guarantees beyond best-effort attempts to stop processing actively executing tasks.
	 * This implementation cancels tasks via Thread.interrupt(), so any task that fails to respond to interrupts may never
	 * terminate.
	 *
	 * @return list of tasks that never commenced execution
	 */
	any function shutdownNow ()
	{
		return variables.native.shutdownNow();
	}

	/**
	 * Returns the task queue used by this executor.
	 */
	any function getQueue ()
	{
		return variables.native.getQueue();
	}

	/**
	 * Returns the approximate number of threads that are actively executing tasks.
	 */
	numeric function getActiveCount ()
	{
		return variables.native.getActiveCount();
	}

	/**
	 * Returns the approximate total number of tasks that have ever been scheduled for execution.
	 */
	numeric function getTaskCount ()
	{
		return variables.native.getTaskCount();
	}

	/**
	 * Returns the approximate total number of tasks that have completed execution.
	 */
	numeric function getCompletedTaskCount ()
	{
		return variables.native.getCompletedTaskCount();
	}

	/**
	 * Returns the core number of threads.
	 */
	numeric function getCorePoolSize ()
	{
		return variables.native.getCorePoolSize();
	}

	/**
	 * Returns the largest number of threads that have ever simultaneously been in the pool.
	 */
	numeric function getLargestPoolSize ()
	{
		return variables.native.getLargestPoolSize();
	}

	/**
	 * Returns the maximum allowed number of threads.
	 */
	numeric function getMaximumPoolSize ()
	{
		return variables.native.getMaximumPoolSize();
	}

	/**
	 * Returns the current number of threads in the pool.
	 */
	numeric function getPoolSize ()
	{
		return variables.native.getPoolSize();
	}

	/**
	 * Our very own stats struct map to give you a holistic view of the schedule
	 * and it's executor
	 *
	 * @return struct of data about the executor and the schedule
	 */
	struct function getStats ()
	{
		return {
			 "name"              : GetName()
			,"poolSize"          : GetPoolSize()
			,"maximumPoolSize"   : GetMaximumPoolSize()
			,"largestPoolSize"   : GetLargestPoolSize()
			,"corePoolSize"      : GetCorePoolSize()
			,"completedTaskCount": GetCompletedTaskCount()
			,"taskCount"         : GetTaskCount()
			,"activeCount"       : GetActiveCount()
			,"isTerminated"      : IsTerminated()
			,"isTerminating"     : IsTerminating()
			,"isShutdown"        : IsShutdown()
		};
	}

	/**
	 * Utility to send to output to the output stream
	 *
	 * @var Variable/Message to send
	 */
	Executor function out ( required var )
	{
		CreateObject( "java", "java.lang.System" ).out.println( arguments.var.toString() );
		return this;
	}

	/**
	 * Utility to send to output to the error stream
	 *
	 * @var Variable/Message to send
	 */
	Executor function err ( required var )
	{
		CreateObject( "java", "java.lang.System" ).err.println( arguments.var.toString() );
		return this;
	}

}
