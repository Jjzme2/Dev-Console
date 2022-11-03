

/**
 * This will get the needed information that might be used across many different services.
 *
 * @Author  Jj Zettler
 * @date    11/03/2022
 * @version 0.1
 */
component singleton accessors="true" {

	property name = "quoteGateway"    inject = "Gateways/QuoteGateway";
    property name = "bookmarkGateway" inject = "Gateways/BookmarkGateway";
	property name = "messageGateway"  inject = "Gateways/MessageGateway";
	property name = "userGateway"     inject = "Gateways/UserGateway";
    property name = "reminderGateway" inject = "Gateways/ReminderGateway";
    property name = "noteGateway"     inject = "Gateways/NoteGateway";

    property name = "populator"       inject = "wirebox:populator";



	BaseService function init ()
	{
		return this;
	}

    function populate ( required string type, required any data )
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
}