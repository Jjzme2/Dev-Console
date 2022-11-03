<cfcomponent persistent="true">
	<!--- List All Quotes --->
	<cffunction name="list">
		<cfquery name="qry" result="res">
			SELECT
				intQuoteID
				,vcQuoteAuthor
				,vcQuoteText
				,vcQuoteSite
			FROM tblQuotes
		</cfquery>
		<cfreturn qry>
	</cffunction>

	<!--- Get A specific quote by ID. --->
	<cffunction name="get">
		<cfargument name="quoteID">

		<cfquery name="qry" result="res">
			SELECT
				intQuoteID
				,vcQuoteAuthor
				,vcQuoteText
				,vcQuoteSite
			FROM tblQuotes
			WHERE intQuoteID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value=#quoteID#>
		</cfquery>
		<cfreturn qry>
	</cffunction>

	<!--- Get all quotes by a given Author --->
	<cffunction name="GetQuotesByAuthor">
		<cfargument name="AuthorName">

		<cfquery name="qry" result="res">
			SELECT
				intQuoteID
				,vcQuoteAuthor
				,vcQuoteText
				,vcQuoteSite
			FROM tblQuotes
			WHERE vcQuoteAuthor LIKE '%#AuthorName#%'
		</cfquery>

		<cfreturn qry>
	</cffunction>

	<!--- Add a quote to the quotes database --->
	<cffunction name="add">
		<cfargument name="quoteData">

		<cfquery name="qry" result="res">
			INSERT INTO tblQuotes
			(
				vcQuoteAuthor
				,vcQuoteText
				,vcQuoteSite
			)
			VALUES
			(
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#quoteData.vcQuoteAuthor#">
				,<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#quoteData.vcQuoteText#">
				,<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#quoteData.vcQuoteSite#">
			);
		</cfquery>

		<cfreturn qry>
	</cffunction>

	<!--- Add a quote to the users preferred quotes - Not Done --->
	<cffunction name="update">
		<cfargument name="quoteData">

		<cfquery name="qry" result="res">

			UPDATE tblQuotes
			SET
				vcQuoteAuthor = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#quoteData.vcQuoteAuthor#">
				,vcQuoteText  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#quoteData.vcQuoteText#">
				,vcQuoteSite  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#quoteData.vcQuoteSite#">
			WHERE intQuoteID  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#quoteData.intQuoteID#">;
		</cfquery>

		<cfreturn qry>
	</cffunction>
</cfcomponent>
