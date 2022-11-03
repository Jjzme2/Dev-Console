/**
 * I am a new interceptor
 */
component {

	property name="userService" inject="Services/UserService";

	/**
	 * Configure the interceptor
	 */
	void function configure ()
	{
	}

	public any function preLayoutRender (
		 event
		,interceptData
		,buffer
		,rc
		,prc
	)
	{
		prc.xeh.homepage = "user.homepage";
		prc.xeh.logout   = "user.logout";

		prc.xeh.messages = "messages.index";
		prc.xeh.reminder = "reminder.index";
		prc.xeh.quotes   = "quotes.index";
		prc.xeh.bookmarks= "bookmarks.index";
		prc.xeh.notes    = "notes.index";

		// Admin
		if( structKeyExists( session, "LoggedInID" ) && session.LoggedInID > 0 )
		{
			prc.showNav = true;
			user = userService.get( session.LoggedInID );
			prc.user.IsAdmin = user.intIsAdmin;
			
			// Admin XEH
			prc.xeh.quotesAdmin = "quotes.admin";
			prc.xeh.bookmarksAdmin  = "bookmarks.admin";
		}else {
			prc.showNav = false
			prc.user.IsAdmin = false;
		}
	}

}
