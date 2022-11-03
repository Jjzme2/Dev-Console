component name="Quote" accessors="true" extends="baseObject" {

	property type = "number" name = "intQuoteID";
	property type = "string" name = "vcQuoteAuthor";
	property type = "string" name = "vcQuoteText";
	property type = "string" name = "vcQuoteSite";


	public Quote function init ()
	{
		SetIntQuoteID( 0 );
		SetVcQuoteAuthor( "" );
		SetVcQuoteText( "" );
		SetVcQuoteSite( "" );
		return this;
	}

	public function toXML()
	{
		xmlDoc = XmlNew(); // new XML document to populate
		xmlRoot = XmlElemNew( xmlDoc, "Quote" ); //Defines Root of xml doc Sets name of root to QuoteList
		xmlDoc.XmlRoot = xmlRoot; // set the root node of the XML document

		child     = XmlElemNew( xmlDoc,"Info" ); // first child node

		author    = XmlElemNew( xmlDoc,"Author" );    // child node
		content   = XmlElemNew( xmlDoc,"Content" );   // child node
		site      = XmlElemNew( xmlDoc,"Site" ); // child node

		author.xmlText = getVcQuoteAuthor(); // Set value of element
		content.xmlText= getVcQuoteText(); 	   // Set value of element
		site.xmlText   = getVcQuoteSite();    // Set value of element

		child.XmlChildren.append( author );
		child.XmlChildren.append( content );
		child.XmlChildren.append( site );

		xmlRoot.XmlChildren.append( child ); // Add Child to root

		return xmlRoot;
	}
}
