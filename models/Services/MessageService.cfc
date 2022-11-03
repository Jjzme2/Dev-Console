/**
 * This will get the needed information to serve Message.
 *
 * @Author  Jj Zettler
 * @date    9/20/2022
 * @version 0.1
 */
component singleton accessors="true" {

	property name = "populator"      inject = "wirebox:populator";
	property name = "messageGateway" inject = "Gateways/MessageGateway";



	MessageService function init ()
	{
		return this;
	}

	// Acquisition
	/**
	 * Returns an array of all Messages
	 */
	Array function list ( intMessageID )
	{
		qry       = messageGateway.listUserMessages( intMessageID );
		aMessages = [];

		for ( row in qry )
		{
			ArrayAppend( aMessages, row );
		}

		return aMessages;
	}

	/**
	 *  Gets an empty Message Object.
	 */
	Message function getEmpty ()
	{
		return new models.objects.Message();
	}

	/**
	 * Gets a Message's data and returns it as a struct.
	 *
	 * @id The unique ID we want to use to get a message's information.
	 */
	struct function get ( required numeric id )
	{
		aStoredMessages = List();
		messageData     = {};

		qry = messageGateway.get( messageID );

		for ( storedMessage in aStoredMessages )
		{
			if ( storedMessage.intMessageID == id )
			{
				messageData = Populate( "struct", storedMessage );

				// {
				// 	 "intMessageID"     : storedMessage.intMessageID
				// 	,"vcMessageSubject" : storedMessage.vcMessageSubject
				// 	,"vcMessageContent" : storedMessage.vcMessageContent
				// 	,"intReceiverID"    : storedMessage.intReceiverID
				//  ,"intSenderID"      : storedMessage.intSenderID
				// 	,"intIsRead"        : storedMessage.intIsRead
				// }
			}
		}
		return messageData;
	}


	// CRUD and Friends.
	/**
	 * Populates an empty Message with given data
	 *
	 * @type What type of file are we populating from? (XML, JSON, Query, Struct)
	 * @data The data we are using to populate the empty object.
	 */
	Message function populate ( required string type, required any data )
	{
		switch ( type )
		{
			case LCase( "struct" ):
				return populator.populateFromStruct( target = GetEmpty(), memento = data )
				break;
			case LCase( "query" ):
				return populator.populateFromQuery( target = GetEmpty(), qry = data )
				break;
			case LCase( "json" ):
				return populator.populateFromJSON( target = GetEmpty(), JSONString = data )
				break;
			case LCase( "xml" ):
				return populator.populateFromXML( target = GetEmpty(), xml = data )
				break;
			default:
				// What are we populating from?
				return;
		}
	}

	/**
	 * Adds a message to the database.
	 *
	 * @insertType The way we want to insert the data into the database (Object/Message, json, xml)
	 * @data       The data we want to add to the database
	 */
	void function add ( required string insertType, required any data )
	{
		switch ( insertType )
		{
			case LCase( "object" ):
			case LCase( "message" ):
				messageGateway.add( data );
				break;
			case LCase( "json" ):
				WriteDump( "Not implemented yet." );
				break;
			case LCase( "xml" ):
				WriteDump( "Not implemented yet." );
				break;
			default:
				// What insertType
				return;
		}
	}


	void function delete ( required number messageID )
	{
		messageGateway.delete( messageID );
	}

}


Message function populate ( required string type, required any data )
{
	switch ( type )
	{
		case LCase( "struct" ):
			return populator.populateFromStruct( target = GetEmpty(), memento = data )
			break;
		case LCase( "query" ):
			return populator.populateFromQuery( target = GetEmpty(), qry = data )
			break;
		case LCase( "json" ):
			return populator.populateFromJSON( target = GetEmpty(), JSONString = data )
			break;
		case LCase( "xml" ):
			return populator.populateFromXML( target = GetEmpty(), xml = data )
			break;
		default:
			// What are we populating from?
			return;
	}
}
