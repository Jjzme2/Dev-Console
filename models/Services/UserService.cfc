/**
 * This will get the needed information to serve from User.
 *
 * @Author  Jj Zettler
 * @date    9/20/2022
 * @version 0.1
 */
component singleton accessors="true" extends="BaseService"{

	UserService function init ()
	{
		return this;
	}

	// User Acquisition
	/**
	 * Returns an array of all Users
	 */
	Array function list ()
	{
		qry    = userGateway.all();
		aUsers = [];

		for ( row in qry )
		{
			ArrayAppend( aUsers, row );
		}

		return aUsers;
	}

	/**
	 *  Gets an empty User Object.
	 */
	User function getEmpty ()
	{
		return new models.objects.User();
	}

	/**
	 * Gets a user's data and returns it as a struct.
	 *
	 * @id The unique ID we want to use to get a user's information.
	 */
	struct function get ( required numeric id )
	{
		aStoredUsers = List();
		userData     = {};

		for ( storedUser in aStoredUsers )
		{
			if ( storedUser.intUserID == id )
			{
				userData =
				{
					"intUserID"        : storedUser.intUserID
					,"vcUsername"      : storedUser.vcUsername
					,"vcUserEmail"     : storedUser.vcUserEmail
					,"vcPassword"      : storedUser.vcPassword
					,"dataJoinDate"    : storedUser.dateJoinDate
					,"vcLikedQuotes"   : storedUser.vcLikedQuotes
					,"vcLikedBookmarks": storedUser.vcLikedBookmarks
					,"intIsAdmin"      : storedUser.intIsAdmin
				}
			}
		}
		return userData;
	}

	//Bookmark Acquisition
	Array function likedBookmarks( required string userID )
	{
		user = get( userID );
		likedBookmarks = listToArray( user.vcLikedBookmarks, ',' );

		aLikedBookmarks = userGateway.getLikedBookmarks( likedBookmarks );
		return aLikedBookmarks;
	}
	

	/**
	 * Takes a username as parameter and returns the value of that user's ID.
	 *
	 * @username The username we want to use to get a unique ID.
	 */
	numeric function getID ( required string username )
	{
		aStoredUsers = List();
		id           = -1;

		for ( storedUser in aStoredUsers )
		{
			if ( storedUser.vcUsername == username )
			{
				id = storedUser.intUserID;
			}
		}
		return id;
	}

	// Validation
	/**
	 * Checks to see if a username exists within the database.
	 *
	 * @userName The username to search for.
	 */
	boolean function hasUser ( required string userName )
	{
		aStoredUsers = List();

		for ( storedUser in aStoredUsers )
		{
			if ( storedUser.vcUsername == userName )
			{
				return true;
			}
		}
		return false;
	}

	/**
	 * Checks to see if an email exists within the database.
	 *
	 * @email The email to search for.
	 */
	boolean function hasEmail ( required string email )
	{
		aStoredUsers = List();

		for ( storedUser in aStoredUsers )
		{
			if ( storedUser.vcUserEmail == email )
			{
				return true;
			}
		}
		return false;
	}

	/**
	 * Checks if a user exists, given a Unique ID
	 *
	 * @idToCheckFor The ID we want to check for in the database.
	 */
	boolean function exists ( required number idToCheckFor )
	{
		aStoredUsers = List();
		pass         = false;

		for ( storedUsers in aStoredUsers )
		{
			if ( storedUsers.intUserID == idToCheckFor )
			{
				WriteDump( label = "UserService/exists", var = "#idToCheckFor# exists." );
				pass = true;
			}
		}
		return pass;
	}

	// CRUD and Friends.
	/**
	 * Populates an empty user with given data
	 *
	 * @type What type of file are we populating from? (XML, JSON, Query, Struct)
	 * @data The data we are using to populate the empty object.
	 */
	User function populate ( required string type, required any data )
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
	 * Adds a specific user to the database
	 *
	 * @insertType The way we want to insert the data into the database (Object/User, json, xml)
	 * @data       The data we want to add to the database
	 */
	void function add ( required string insertType, required any data )
	{
		switch ( insertType )
		{
			case LCase( "object" ):
			case LCase( "user" ):
				userGateway.CreateFromObject( data );
				break;
			case LCase( "json" ):
				userGateway.CreateFromObjectJSON( data );
				break;
			case LCase( "xml" ):
				userGateway.CreateFromObjectXML( data );
				break;
			default:
				// What insertType
				
				return;
		}
	}

	//Liked Bookmarks
	void function addLikedBookmark( required numeric bookmarkID )
	{
		userGateway.addLikedBookmark(bookmarkID );
	}

	void function removeLikedBookmark( required numeric bookmarkID )
	{
		userGateway.removeLikedBookmark(bookmarkID )
	}
}
