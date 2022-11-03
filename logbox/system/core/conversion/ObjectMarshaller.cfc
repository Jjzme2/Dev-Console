/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * Allows you to serialize/deserialize objects
 */
component accessors="true" {

	/**
	 * Constructor
	 */
	function init ()
	{
		return this;
	}

	/**
	 * Serialize an object and optionally save it into a file.
	 *
	 * @target   The complex object, such as a query or CFC, that will be serialized.
	 * @filePath The path of the file in which to save the serialized data.
	 *
	 * @return Binary data
	 */
	function serializeObject ( required any target, string filePath )
	{
		var binaryData = SerializeWithObjectSave( arguments.target );

		// Save to File?
		if ( !IsNull( arguments.filePath ) )
		{
			FileWrite( arguments.filePath, binaryData );
		}

		return binaryData;
	}


	/**
	 * Deserialize an object using a binary object or a filepath
	 *
	 * @target   The binary object to inflate
	 * @filePath The location of the file that has the binary object to inflate
	 *
	 * @return Loaded Object
	 */
	function deserializeObject ( any binaryObject, string filePath )
	{
		// Read From File?
		if ( !IsNull( arguments.filePath ) )
		{
			arguments.binaryObject = FileRead( arguments.filePath );
		}

		return DeserializeWithObjectLoad( arguments.binaryObject );
	}

	/**
	 * Serialize via objectSave()
	 *
	 * @target The complex object, such as a query or CFC, that will be serialized.
	 */
	function serializeWithObjectSave ( any target )
	{
		return ToBase64( ObjectSave( arguments.target ) );
	}

	/**
	 * Deserialize via ObjectLoad
	 *
	 * @binaryObject The binary object to inflate
	 */
	function deserializeWithObjectLoad ( any binaryObject )
	{
		// check if string
		if ( not IsBinary( arguments.binaryObject ) )
		{
			arguments.binaryObject = ToBinary( arguments.binaryObject );
		}

		return ObjectLoad( arguments.binaryObject );
	}

	/**
	 * Serialize via generic Java
	 *
	 * @target The binary object to inflate
	 */
	function serializeGeneric ( any target )
	{
		var byteArrayOutput = CreateObject( "java", "java.io.ByteArrayOutputStream" ).init();
		var objectOutput    = CreateObject( "java", "java.io.ObjectOutputStream" ).init( byteArrayOutput );

		// Serialize the incoming object.
		objectOutput.writeObject( arguments.target );
		objectOutput.close();

		return ToBase64( byteArrayOutput.toByteArray() );
	}

	/**
	 * Serialize via generic Java
	 *
	 * @target The binary object to inflate
	 */
	function deserializeGeneric ( any binaryObject )
	{
		var byteArrayInput = CreateObject( "java", "java.io.ByteArrayInputStream" ).init(
			 ToBinary( arguments.binaryObject )
		);
		var ObjectInput = CreateObject( "java", "java.io.ObjectInputStream" ).init( byteArrayInput );
		var obj         = "";

		obj = objectInput.readObject();
		objectInput.close();

		return obj;
	}

}
