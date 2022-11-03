<cfcomponent persistent="true">
	<cffunction name="list">
		<cfquery name="qry" result="res">
			SELECT
				intbookmarkID
				,vcbookmarkDescription
				,vcbookmarkAddress
			FROM tblBookmarks
		</cfquery>
		<cfreturn qry>
	</cffunction>

	<!--- Add a bookmark to the bookmarks database --->
	<cffunction name="add">
		<cfargument name="bookmarkData">

		<cfquery name="qry" result="res">
			INSERT INTO tblBookmarks
			(
				vcbookmarkDescription
				,vcbookmarkAddress
			)
			VALUES
			(
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#bookmarkData.vcbookmarkDescription#">
				,<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#bookmarkData.vcbookmarkAddress#">
			);
		</cfquery>

		<cfreturn qry>
	</cffunction>

	<!--- Add a quote to the users preferred quotes - Not Done --->
	<cffunction name="update">
		<cfargument name="bookmarkData">

		<cfquery name="qry" result="res">

			UPDATE tblBookmarks
			SET
				vcbookmarkDescription = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#bookmarkData.vcbookmarkDescription#">
				,vcbookmarkAddress    = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#bookmarkData.vcbookmarkAddress#">
			WHERE intbookmarkID       = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#bookmarkData.intbookmarkID#">;
		</cfquery>

		<cfreturn qry>
	</cffunction>
</cfcomponent>
