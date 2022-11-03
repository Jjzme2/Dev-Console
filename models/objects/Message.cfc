component name="Message" accessors="true" extends="baseObject"{

	property type = "number" name = "intMessageID";
	property type = "string" name = "vcMessageSubject";
	property type = "string" name = "vcMessageContent";
	property type = "number" name = "intReceiverID";
	property type = "number" name = "intIsRead";
	property type = "number" name = "intSenderID";


	public Message function init ()
	{
		SetIntMessageID( 0 );
		SetVcMessageSubject( "" );
		SetVcMessageContent( "" );
		SetIntReceiverID( 0 );
		SetIntIsRead( 0 );
		SetIntSenderID( 0 );
		return this;
	}

	public function toJSON()
	{
		return serializeJSON(this);
	}

	public function toXML()
	{
		xmlDoc = XmlNew(); // new XML document to populate
		xmlRoot = XmlElemNew(xmlDoc, "Message"); //Defines Root of xml doc Sets name of root to QuoteList
		xmlDoc.XmlRoot = xmlRoot; // set the root node of the XML document

		child     = XmlElemNew(xmlDoc,"Info"); // first child node

		subject    = XmlElemNew(xmlDoc,"Subject");    // child node
		text       = XmlElemNew(xmlDoc,"Content");    // child node
		senderID   = XmlElemNew(xmlDoc,"SenderID");   // child node
		recieverID = XmlElemNew(xmlDoc,"RecieverID"); // child node



		subject.xmlText   = getVcMessageSubject(); // Set value of element
		text.xmlText      = getVcMessageContent(); // Set value of element
		senderID.xmlText  = getIntSenderID(); 	   // Set value of element
		recieverID.xmlText= getIntReceiverID();    // Set value of element

		child.XmlChildren.append(subject);
		child.XmlChildren.append(text);
		child.XmlChildren.append(senderID);
		child.XmlChildren.append(recieverID);

		xmlRoot.XmlChildren.append(child); // Add Child to root

		return xmlRoot;
	}
}
