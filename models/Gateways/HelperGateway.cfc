<cfcomponent persistent="true">
	<!--- Priorities --->
	<cffunction name="allPriorities">
		<cfquery name="qry" result="res">
			SELECT
				intPriorityID
				,vcPriorityValue
			FROM tblPriority
		</cfquery>
		<cfreturn qry>
	</cffunction>

	<!--- Sources --->
	<cffunction name="allSources">
		<cfquery name="qry" result="res">
			SELECT
				intSourceID
				,vcSourceValue
			FROM tblSource
		</cfquery>
		<cfreturn qry>
	</cffunction>

	<!--- Processes --->
	<cffunction name="allProcesses">
		<cfquery name="qry" result="res">
			SELECT
				intProcessID
				,vcProcessValue
			FROM tblProcess
		</cfquery>
		<cfreturn qry>
	</cffunction>
</cfcomponent>
