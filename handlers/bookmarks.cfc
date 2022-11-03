/**
 * This will handle all the message events.
 *
 * @Author  Jj Zettler
 * @date    10/10/2022
 * @version 1
 */
component extends="BaseHandler" {

	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only      = "";
	this.prehandler_except    = "";
	this.posthandler_only     = "";
	this.posthandler_except   = "";
	this.aroundHandler_only   = "";
	this.aroundHandler_except = "";
	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods       = {};

	/**
	IMPLICIT FUNCTIONS: Uncomment to use

	function preHandler( event, rc, prc, action, eventArguments ){
	}
	function postHandler( event, rc, prc, action, eventArguments ){
	}
	function aroundHandler( event, rc, prc, targetAction, eventArguments ){
		// executed targeted action
		arguments.targetAction( event );
	}
	function onMissingAction( event, rc, prc, missingAction, eventArguments ){
	}
	function onError( event, rc, prc, faultAction, exception, eventArguments ){
	}
	function onInvalidHTTPMethod( event, rc, prc, faultAction, eventArguments ){
	}
	*/

	/**
	 * Displays all the info bookmarks a user liked.
	 */
	function index ( event, rc, prc )
	{
		prc.bookmarkTemplate		 = "../bookmarks/view.cfm";
		prc.xeh.process  			 = "bookmarks.process";
		prc.xeh.personalBookmarks	 = "bookmarks.personal";

		rc.bookmarks 	= userService.likedBookmarks( session.LoggedInID );
	}

	function personal (event, rc, prc )
	{
		rc.bookmarks 	= userService.likedBookmarks( session.LoggedInID );

		rc.allBookmarks = bookmarkService.list( );

		prc.xeh.like	= "bookmarks.like?Id=";
	}

	/**
	 * Displays all the info for the bookmarks Page, and the modal that shows the view.
	 */
	function admin ( event, rc, prc )
	{
		prc.bookmarkTemplate = "../bookmarks/view.cfm";
		prc.xeh.process  	 = "bookmarks.process";

		rc.bookmarks = bookmarkService.list( );
	}

	/**
	 * Processes the  bookmark.
	 */
	function process ( event, rc, prc )
	{
		// writeDump(rc);abort;
		var aMessages        = [];
		var validationResult = validate
		(
			target = rc, constraints =
			{
				"vcbookmarkDescription": { "required": true }
				,"vcbookmarkAddress"    : {
					 "required": true
					,udf       : function ( value, target, metaData )
					{
						if ( rc.intbookmarkID == 0 )
						{
							// Creating a new Quote. If this quote exists already...
							if ( bookmarkService.hasbookmark( value ) )
							{
								return false;
							}
							else
							{
								return true;
							}
						}
						else
						{
							// Modifying an existing quote.
							return true;
						}
					}
				}
			}
		)
		if ( !validationResult.hasErrors() )
		{
			newbookmark =
			{
				"intUserID"         	: session.LoggedInID
				,"intBookmarkID"        : rc.intBookmarkID
				,"vcBookmarkDescription": rc.vcBookmarkDescription
				,"vcBookmarkAddress"    : rc.vcBookmarkAddress
			}

			if ( newbookmark.intBookmarkID == 0 )
			{
				// Creating a new bookmark
				try {
					bookmarkService.add( newbookmark );
					ArrayAppend( aMessages, "Bookmark has been added!" );
				} catch (exType exName) {
					writeDump(var = exName); abort;
				}
			}
			else
			{
				// Modifying an existing bookmark
				bookmarkService.update( newbookmark );
				ArrayAppend( aMessages, "Bookmark has been updated!" );
			}

			messageBox.success( aMessages );
			Relocate( "bookmarks.admin" );
		}
		else
		{
			errors = validationResult.getAllErrors();
			// WriteDump( errors );
			// abort;
			messageBox.error( "We were unable to modify the bookmark with the given input." );
			Relocate( "bookmarks.admin" );
		}
	}

	function like( event, rc, prc )
	{
		userService.addLikedBookmark ( id );
		relocate( "bookmarks.personal" );
	}

}
