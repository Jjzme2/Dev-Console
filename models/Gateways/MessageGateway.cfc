<cfcomponent persistent="true">
	<!--- List All a given user's messages. --->
	<cffunction name="listUserMessages">
		<cfargument name="userID">
		<cfquery name="qry" result="res">
				SELECT
					intMessageID
					,intReceiverID
					,intSenderID
					,intIsRead
					,vcMessageSubject
					,vcMessageContent
				FROM tblUserMessages
				where intReceiverID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value=#userID#>
		</cfquery>
		<cfreturn qry>
	</cffunction>

	<!--- Get a given Message by its ID --->
	<cffunction name="get">
		<cfargument name="messageID">
		<cfquery name="qry" result="res">
				SELECT
					intMessageID
					,intReceiverID
					,intIsRead
					,intSenderID
					,vcMessageSubject
					,vcMessageContent
				FROM tblUserMessages
				where intMessageID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value=#messageID#>
		</cfquery>
	</cffunction>

	<!--- Get a given Message by its ID --->
	<cffunction name="delete">
		<cfargument name="messageID">
		<cfquery name="qry" result="res">
			DELETE
			FROM tblUserMessages
			where intMessageID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value=#messageID#>
		</cfquery>
	</cffunction>

	<!--- Get a message with given data --->
	<cffunction name="add">
		<cfargument name="messageObject">
		<cfquery name="qry" result="res">
			INSERT INTO tblUserMessages
			(
				vcMessageSubject
				,vcMessageContent
				,intReceiverID
				,intIsRead
				,intSenderID
			)
			VALUES
			(
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value=#messageObject.getVcMessageSubject()#>
				,<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value=#messageObject.getVcMessageContent()#>
				,<cfqueryparam cfsqltype="CF_SQL_NUMERIC" value=#messageObject.getIntReceiverID()#>
				,<cfqueryparam cfsqltype="CF_SQL_NUMERIC" value=#messageObject.getIntIsRead()#>
				,<cfqueryparam cfsqltype="CF_SQL_NUMERIC" value=#messageObject.getIntSenderID()#>
			)
		</cfquery>
	</cffunction>
</cfcomponent>
