component name="Bookmark" accessors="true" extends="baseObject" {

    property type = "numeric"name = "intBookmarkID";
    property type = "string" name = "vcBookmarkDescription";
	property type = "string" name = "vcBookmarkAddress";


	public Bookmark function init ()
	{
		getIntBookmarkID( 0 );
		getVcBookmarkDescription( "" );
		getVcBookmarkAddress( "" );
		return this;
	}

	public function toXML()
	{
		xmlDoc = XmlNew(); // new XML document to populate
		xmlRoot = XmlElemNew( xmlDoc, "Bookmark" ); //Defines Root of xml doc Sets name of root to Bookmark
		xmlDoc.XmlRoot = xmlRoot; // set the root node of the XML document

		child = XmlElemNew( xmlDoc,"Info" ); // first child node

		description= XmlElemNew( xmlDoc,"Description" ); // child node
		address    = XmlElemNew( xmlDoc,"Address" );     // child node

		description.xmlText = getVcBookmarkDescription(); // Set value of element
		address.xmlText= getVcBookmarkAddress(); 	      // Set value of element

		child.XmlChildren.append( description );
		child.XmlChildren.append( address );

		xmlRoot.XmlChildren.append( child ); // Add Child to root

		return xmlRoot;
	}
}
