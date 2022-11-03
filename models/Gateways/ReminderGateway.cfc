<cfcomponent persistent="true">
	<cffunction name="list">
		<cfquery name="qry" result="res">
			SELECT
				intReminderID
				,intPriority
				,intProcess
				,intSource
				,intUserID
				,vcDueDate
				,vcCreationDate
				,rPriority.vcPriorityValue
				,rProcess.vcProcessValue
				,rSource.vcSourceValue
				,vcReminderValue
			FROM tblReminder AS Reminder
			INNER JOIN tblPriority AS rPriority ON  Reminder.intPriority = rPriority.intPriorityID
			INNER JOIN tblProcess AS rProcess ON Reminder.intProcess = rProcess.intProcessID
			INNER JOIN tblSource AS rSource ON Reminder.intSource = rSource.intSourceID
		</cfquery>
		<cfreturn qry>
	</cffunction>

	<cffunction name="listUserReminders">
		<cfargument name="ID">

		<cfquery name="qry" result="res">
			SELECT
				intReminderID
				,intPriority
				,intProcess
				,intSource
				,intUserID
				,vcDueDate
				,vcCreationDate
				,rPriority.vcPriorityValue
				,rProcess.vcProcessValue
				,rSource.vcSourceValue
				,vcReminderValue
			FROM tblReminder AS Reminder
			INNER JOIN tblPriority AS rPriority ON  Reminder.intPriority = rPriority.intPriorityID
			INNER JOIN tblProcess AS rProcess ON Reminder.intProcess = rProcess.intProcessID
			INNER JOIN tblSource AS rSource ON Reminder.intSource = rSource.intSourceID
			WHERE intUserID = <cfqueryparam cfsqltype="CF_SQL_INT" value=#ID#>
		</cfquery>
		<cfreturn qry>
	</cffunction>

	<cffunction name="add">
		<cfargument name="data">

		<cfquery name="qry" result="res">
			INSERT INTO tblReminder
			(
				intPriority
				,intSource
				,intProcess
				,intUserID
				,vcReminderValue
				,vcDueDate
				,vcCreationDate
			)
			VALUES
			(
				<cfqueryparam cfsqltype="CF_SQL_INT" value=#Trim( data.intPriority )#>
				,<cfqueryparam cfsqltype="CF_SQL_INT" value=#Trim( data.intSource )#>
				,<cfqueryparam cfsqltype="CF_SQL_INT" value=#Trim( data.intProcess )#>
				,<cfqueryparam cfsqltype="CF_SQL_INT" value=#Trim( data.intUserID )#>
				,<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value=#Trim( data.vcReminderValue )#>
				<cfif data.vcDueDate EQ "">
					,'9999-12-31'
				<cfelse>
					,<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value=#Trim( data.vcDueDate )#>
				</cfif>
				,<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value=#dateFormat( now(), 'yyyy-mm-dd' )#>

			)
		</cfquery>
	</cffunction>

	<cffunction name="update">
		<cfargument name="id">
		<cfargument name="data">

		<cfquery name="qry" result="res">
			UPDATE tblReminder
			SET
				intPriority = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value=#data.intPriority#>
				,intSource = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value=#data.intSource#>
				,intProcess = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value=#data.intProcess#>
				,vcReminderValue = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value=#data.vcReminderValue#>
				<cfif data.vcDueDate EQ "">
					,vcDueDate = '9999-12-31'
				<cfelse>
					,vcDueDate = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value=#Trim( data.vcDueDate )#>
				</cfif>
			WHERE intReminderID = '#id#';
		</cfquery>
	</cffunction>

	<cffunction name="delete">
		<cfargument name="id">

		<cfquery name="qry" result="res">
			DELETE
			FROM tblReminder
			WHERE intReminderID = '#id#';
		</cfquery>
	</cffunction>
</cfcomponent>
