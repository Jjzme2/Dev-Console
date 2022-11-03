/**
 * This will get the needed information to serve data from bookmark.
 *
 * @Author  Jj Zettler
 * @date    10/10/2022
 * @version 0.1
 */
component singleton accessors="true" {

	property name = "bookmarkGateway" inject = "Gateways/BookmarkGateway";


	bookmarkService function init ()
	{
		return this;
	}

	/**
	 * Get all  bookmarks
	 *
	 */
	Array function List ()
	{
		qry    = bookmarkGateway.list();
		abookmarks = [];

		for ( row in qry )
		{
			ArrayAppend( abookmarks, row );
		}

		return abookmarks;
	}

	/**
	 * Check to see if the  bookmark already exists in the database.
	 *
	 * @bookmarkAddress The Address we want to find a match for.
	 */
	boolean function hasbookmark ( required string bookmarkAddress )
	{
		aStoredbookmarks = List();

		for ( storedbookmark in aStoredbookmarks )
		{
			if ( storedbookmark.vcbookmarkAddress == bookmarkAddress )
			{
				return true;
			}
		}
		return false;
	}

	/**
	 * CRUD Add
	 *
	 * @data Is the data we want to add to the db
	 */
	void function add ( required struct data )
	{
		bookmarkGateway.add( data );
	}

	/**
	 * CRUD Update
	 *
	 * @data Is the data we want to update in the db
	 */
	void function update ( required struct data )
	{
		bookmarkGateway.update( data );
	}

}
