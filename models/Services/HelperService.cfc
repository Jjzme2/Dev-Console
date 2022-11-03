/**
 * This will get the needed information to serve data from Priority, Source, and Process, as well as any other extra tables we might need access to.
 *
 * @Author  Jj Zettler
 * @date    9/21/2022
 * @version 0.1
 */
component singleton accessors="true" {

	property name = "helperGateway" inject = "Gateways/HelperGateway";


	HelperService function init ()
	{
		return this;
	}

	// Priorities
	/**
	 * Returns an array of all Priorities
	 */
	Array function listPriorities ()
	{
		qry         = helperGateway.allPriorities();
		aPriorities = [];

		for ( row in qry )
		{
			ArrayAppend( aPriorities, row );
		}

		return aPriorities;
	}

	/**
	 * Returns a specific Priority with a given ID
	 *
	 * @ID Is the ID we want to find in our database.
	 */
	struct function getPriority ( required numeric ID )
	{
		aPriorities  = ListPriorities();
		priorityData = {};

		for ( storedPriority in aPriorities )
		{
			if ( storedPriority.intPriorityID == id )
			{
				priorityData =
					{ "intPriorityID": storedPriority.intPriorityID, "vcPriorityValue": storedPriority.vcPriorityValue }
			}
		}
		return priorityData;
	}

	// Sources
	/**
	 * Returns an array of all Sources
	 */
	Array function listSources ()
	{
		qry      = helperGateway.allSources();
		aSources = [];

		for ( row in qry )
		{
			ArrayAppend( aSources, row );
		}

		return aSources;
	}

	/**
	 * Returns a specific Source with a given ID
	 *
	 * @ID Is the ID we want to find in our database.
	 */
	struct function getSource ( required numeric ID )
	{
		aSources   = ListSources();
		sourceData = {};

		for ( storedSource in aSources )
		{
			if ( storedSource.intSourceID == id )
			{
				sourceData =
					{ "intSourceID": storedSource.intSourceID, "vcSourceValue": storedSource.vcSourceValue }
			}
		}
		return sourceData;
	}

	// Processes
	/**
	 * Returns an array of all Processes
	 */
	Array function listProcesses ()
	{
		qry        = helperGateway.allProcesses();
		aProcesses = [];

		for ( row in qry )
		{
			ArrayAppend( aProcesses, row );
		}

		return aProcesses;
	}

	/**
	 * Returns a specific Process with a given ID
	 *
	 * @ID Is the ID we want to find in our database.
	 */
	struct function getProcess ( required numeric ID )
	{
		aProcesses  = ListProcesses();
		processData = {};

		for ( storedProcess in aProcesses )
		{
			if ( storedProcess.intProcessID == id )
			{
				processData =
					{ "intProcessID": storedProcess.intProcessID, "vcProcessValue": storedProcess.vcProcessValue }
			}
		}
		return processData;
	}

}
