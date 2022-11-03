<cfcomponent persistent="true">
	<!---
		<cffunction name="CreateUsersFromXML">
		<cfargument name="xmlPath">
		<cfquery name="qry" result="res">
		INSERT INTO tblUsers
		SELECT
		q.Quote.query('Username').value('.','varchar(256)') as vcQuoteAuthor
		,q.Quote.query('QuoteText').value('.','varchar(1024)') as vcQuoteText
		,q.Quote.query('ReferenceLink').value('.','varchar(512)') as vcQuoteSite
		FROM
		(
		SELECT cast (col as xml) FROM
		OPENROWSET(bulk '#xmlPath#', single_blob) as T(col)
		) as S(col)
		cross apply col.nodes('QuoteList/Quote') as q(Quote)
		</cfquery>
		</cffunction>
	--->

	<cffunction name="all">
		<cfquery name="qry" result="res">
			SELECT
				intUserID
				,vcUsername
				,vcUserEmail
				,vcPassword
				,dateJoinDate
				,vcLikedQuotes
				,vcLikedBookmarks
				,intIsAdmin
			FROM tblUsers
		</cfquery>
		<cfreturn qry>
	</cffunction>

	<cffunction name="CreateFromObject">
		<cfargument name="userObject">

		<cfquery name="qry" result="res">
			INSERT INTO tblUsers
			(
				vcUsername
				,vcUserEmail
				,vcPassword
			)
			VALUES
			(
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#userObject.getVcUsername()#">
				,<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#userObject.getVcUserEmail()#">
				,<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#userObject.getVcPassword()#">
			)
		</cfquery>
		<cfreturn qry>
	</cffunction>

	<cffunction name="addLikedBookmark">
		<cfargument name="bookmarkID">

	</cffunction>

	<cffunction name="removeLikedBookmark">
		<cfargument name="bookmarkID">
		
	</cffunction>

	<cffunction name="getLikedBookmarks">
		<cfargument name='likedIDs' type='ARRAY'>
		
		<cfset allRows = []>
		<cfloop array=#likedIDs# item="ID">
			<cfquery name="qry" result="res">
					SELECT
						*
					FROM 
						tblBookmarks
					WHERE intBookmarkID = #ID#

			</cfquery>
			<cfset arrayAppend(allRows, qry)>
		</cfloop>

		<cfreturn allRows>

	</cffunction>
</cfcomponent>
