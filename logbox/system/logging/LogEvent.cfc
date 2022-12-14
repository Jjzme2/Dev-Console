/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This resembles a logging event within LogBox
 **/
component accessors="true" {

	/**
	 * The category to log messages under
	 */
	property name = "category" default = "";

	/**
	 * The timestamp of the log
	 */
	property name = "timestamp";

	/**
	 * The message to log
	 */
	property name = "message" default = "";

	/**
	 * The severity to log with
	 */
	property name = "severity" default = "";

	/**
	 * Any extra info to log
	 */
	property name = "extrainfo" default = "";

	/**
	 * Constructor
	 *
	 * @message   The message to log.
	 * @severity  The severity level to log.
	 * @extraInfo Extra information to send to the loggers.
	 * @category  The category to log this message under.  By default it is blank.
	 */
	function init (
		 required message
		,required severity
		,extraInfo = ""
		,category  = ""
	)
	{
		// Init event
		variables.timestamp    = Now();
		// converters
		variables.xmlConverter = new logbox.system.core.conversion.XMLConverter();

		for ( var key in arguments )
		{
			if ( IsSimpleValue( arguments[ key ] ) )
			{
				arguments[ key ] = Trim( arguments[ key ] );
			}
			variables[ key ] = arguments[ key ];
		}
		return this;
	}

	/**
	 * Get the extra info as a string representation
	 */
	function getExtraInfoAsString ()
	{
		// Simple value, just return it
		if ( IsSimpleValue( variables.extraInfo ) )
		{
			return variables.extraInfo;
		}

		// Convention translation: $toString();
		if ( IsObject( variables.extraInfo ) AND StructKeyExists( variables.extraInfo, "$toString" ) )
		{
			return variables.extraInfo.$toString();
		}

		// Component XML conversion
		if ( IsObject( variables.extraInfo ) )
		{
			return variables.xmlConverter.toXML( variables.extraInfo );
		}

		// Complex values, return serialized in json
		return SerializeJSON( variables.extraInfo );
	}

}
