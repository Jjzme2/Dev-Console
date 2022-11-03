<cfcomponent persistent="true">
	<cffunction name="list">
		<cfquery name="qry" result="res">
			SELECT
				intNoteID
				,intNoteAuthorID
				,vcNoteTitle
				,vcNoteValue
				,vcNoteReferenceSite
			FROM tblNotes
		</cfquery>
		<cfreturn qry>
	</cffunction>

	<cffunction name="listUserNotes">
		<cfargument name="ID">
		<cfquery name="qry" result="res">
			SELECT
				intNoteID
				,intNoteAuthorID
				,vcNoteTitle
				,vcNoteValue
				,vcNoteReferenceSite
			FROM tblNotes
			WHERE intNoteAuthorID = <cfqueryparam cfsqltype="CF_SQL_INT" value=#ID#>
		</cfquery>
		<cfreturn qry>
	</cffunction>

	<cffunction name="get">
		<cfargument name="NoteID">

		<cfquery name="qry" result="res">
			SELECT
				intNoteID
				,intNoteAuthorID
				,vcNoteTitle
				,vcNoteValue
				,vcNoteReferenceSite
			FROM tblNotes
			WHERE intNoteID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value=#NoteID#>
		</cfquery>
		<cfreturn qry>
	</cffunction>

	<!--- CRUD --->
	<cffunction name="add">
		<cfargument name="data">

		<cfquery name="qry" result="res">
			INSERT INTO tblNotes
			(
				intNoteAuthorID
				,vcNoteTitle
				,vcNoteValue
				<cfif data.vcNoteReferenceSite NEQ "">
					,vcNoteReferenceSite
				</cfif>
			)
			VALUES
			(
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#data.intNoteAuthorID#">
				,<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#data.vcNoteTitle#">
				,<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#data.vcNoteValue#">
				<cfif data.vcNoteReferenceSite NEQ "">
					,<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#data.vcNoteReferenceSite#">
				</cfif>
			);
		</cfquery>
	</cffunction>

	<cffunction name="update">
		<cfargument name="data">

		<cfquery name="qry" result="res">
			UPDATE tblNotes
			SET
				vcNoteTitle = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#data.vcNoteTitle#">
				,vcNoteValue    = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#data.vcNoteValue#">
				<cfif vcNoteReferenceSite neq "">
					,vcNoteReferenceSite    = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#data.vcNoteReferenceSite#">
				</cfif>
			WHERE intNoteID       = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#data.intNoteID#">;
		</cfquery>

		<cfreturn qry>
	</cffunction>

	<cffunction name="delete">
		<cfargument name="ID">

		<cfquery name="qry" result="res">
			DELETE
			FROM tblNotes
			WHERE intNoteID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ID#">;
		</cfquery>

		<cfreturn qry>
	</cffunction>
</cfcomponent>
