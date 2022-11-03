/**
 * This will get the needed information to serve data from Quotes.
 *
 * @Author  Jj Zettler
 * @date    10/07/2022
 * @version 0.1
 */
component singleton accessors="true" extends="BaseService" {

	QuoteService function init ()
	{
		return this;
	}

	/**
	 * Get all quotes
	 *
	 */
	Array function List ()
	{
		qry     = quoteGateway.list();
		aQuotes = [];

		for ( row in qry )
		{
			ArrayAppend( aQuotes, row );
		}

		return aQuotes;
	}

	// /**
	//  * Get all quotes liked by a given user
	//  *
	//  * @UserID This is the User ID who we want to get the quotes for.
	//  */
	// Array function GetUserQuotes( required number userID )
	// {
	//     qry        = quoteGateway.listUserLiked( );
	// 	aQuotes = [];

	// 	for ( row in qry )
	// 	{
	// 		ArrayAppend( aQuotes, row );
	// 	}

	// 	return aQuotes;
	// }


	/**
	 * Get a random quote liked by a given user
	 *
	 * @UserID This is the User ID who we want to get the random quote from.
	 */
	struct function GetRandomQuote ()
	{
		// Add from QRY to an array
		qry     = quoteGateway.list();
		aQuotes = [];

		for ( row in qry )
		{
			ArrayAppend( aQuotes, row );
		}

		// Set a random integer to get from that array.
		ran = RandRange( 1, Len( aQuotes ) );


		return aQuotes[ ran ];
	}

	/**
	 * Check to see if a quote already exists in the database.
	 *
	 * @quoteContent The content we want to find a match for.
	 */
	boolean function hasQuote ( required string quoteContent )
	{
		aStoredQuotes = List();

		for ( storedQuote in aStoredQuotes )
		{
			if ( storedQuote.vcQuoteText == quoteContent )
			{
				return true;
			}
		}
		return false;
	}


	/**
	 *  Gets an empty Quote Object.
	 */
	Quote function getEmpty ()
	{
		return new models.objects.Quote();
	}

	/**
	 * Populates an empty Quote with given data
	 *
	 * @type What type of file are we populating from? (XML, JSON, Query, Struct)
	 * @data The data we are using to populate the empty object.
	 */
	Quote function populate ( required string type, required any data )
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
	 * CRUD Add
	 *
	 * @data Is the data we want to add to the db
	 */
	void function add ( required struct data )
	{
		quoteGateway.add( data );
	}

	/**
	 * CRUD Update
	 *
	 * @data Is the data we want to add to the db
	 */
	void function update ( required struct data )
	{
		quoteGateway.update( data );
	}

}
