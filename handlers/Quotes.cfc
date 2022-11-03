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
	 * Displays all the quotes a given user liked, should also give option to change liked quotes.
	 */
	function index ( event, rc, prc )
	{
		prc.viewQuoteTemplate 	 = "../quotes/view.cfm";
		prc.personalQuoteTemplate= "../quotes/personal.cfm";
		prc.xeh.process       	 = "quotes.process";

		rc.quotes = quoteService.list();
	}

	/**
	 * Displays all the info for the Quotes Page, and the modal that shows the view.
	 */
	function admin ( event, rc, prc )
	{
		prc.viewQuoteTemplate = "../quotes/view.cfm";
		prc.xeh.process       = "quotes.process";
		prc.xeh.convert 	  = "quotes.allToFile";

		rc.quotes = quoteService.list();
	}

	/**
	 * Processes the quote.
	 */
	function process ( event, rc, prc )
	{
		// writeDump(rc);abort;
		var aMessages        = [];
		var validationResult = validate
		(
			target = rc, constraints =
				{
				 "vcQuoteAuthor": { "required": true }
				,"vcQuoteText"  : {
					 "required": true
					,"regex"   : "[A-Z a-z0-9.?!@$%^&*()<>;:,`/-]+"
					,udf       : function ( value, target, metaData )
					{
						if ( rc.intQuoteID == 0 )
						{
							// Creating a new Quote. If this quote exists already...
							if ( quoteService.hasQuote( value ) )
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
				,"vcQuoteSite": { "required": true }
			}
		)
		if ( !validationResult.hasErrors() )
		{
			newQuote =
				{
				 "intQuoteID"   : rc.intQuoteID
				,"vcQuoteAuthor": rc.vcQuoteAuthor
				,"vcQuoteText"  : rc.vcQuoteText
				,"vcQuoteSite"  : rc.vcQuoteSite
			}
			if ( rc.intQuoteID == 0 )
			{
				// Creating a new Quote
				quoteService.add( newQuote );
				ArrayAppend( aMessages, "Quote has been added!" );
			}
			else
			{
				// Modifying an existing Quote
				quoteService.update( newQuote );
				ArrayAppend( aMessages, "Quote has been updated!" );
			}

			messageBox.success( aMessages );
			Relocate( "quotes.admin" );
		}
		else
		{
			errors = validationResult.getAllErrors();
			WriteDump( errors );
			abort;
			messageBox.error( "We were unable to modify the quote with the given input." );
			Relocate( "quotes.admin" );
		}
	}

	/**
	 * Converts all quotes to the specified Data type
	 *
	 * @dataType A String representing the dataType to generate. JSON/XML
	 */
	function allToFile ( event, rc, prc ) {
		if(lCase(rc.dataType) == "xml")
		{
			var xmlQuotes = [];
			
			file = "#expandPath("./")#generated\xml\" & "quoteList.xml";
			fileWrite(file, ""); //Create the new file, this will overwrite the previous file.

			for(quote in quoteService.list()){
				quoteObj = quoteService.populate("struct", quote);
				fileAppend(file, quoteObj.toXML());
			}
		}
		else if(lCase(rc.dataType) == "json")
		{
			var jsonQuotes = [];

			file = "#expandPath("./")#generated\json\" & "quoteList.json";
			fileWrite(file, ""); //Create the new file, this will overwrite the previous file.


			for(quote in quoteService.list()){
				quoteObj = quoteService.populate("struct", quote);
				fileAppend(file, quoteObj.toJSON());
			}
		}else{
			writeDump(var="What data type do we want to convert to?", label="Handlers/Quotes/AllQuotesTo()")
		}

		Relocate("quotes.admin");
	}
}
