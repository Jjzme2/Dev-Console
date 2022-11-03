component name="Message" accessors="true" {

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

}
