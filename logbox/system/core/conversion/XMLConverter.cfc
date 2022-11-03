<!-----------------------------------------------------------------------
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
LICENSE
Copyright 2006 Raymond Camden
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
If you find this app worthy, I have a Amazon wish list set up (www.amazon.com/o/registry/2TCL1D08EZEYE ). Gifts are always welcome. ;)
Modifications
Luis Majano
- Adaptation to using a more advanced algortithm on type detections
- Ability to nest complex variables and still convert to XML.--->
<cfcomponent hint="A utility tool that can marshall data to XML" output="false" singleton>
	<!------------------------------------------- CONSTRUCTOR ------------------------------------------>

	<cffunction name="init" access="public" returntype="XMLConverter" output="false">
		<cfscript>
		return this;
		</cfscript>
	</cffunction>

	<!------------------------------------------- PUBLIC ------------------------------------------>

	<cffunction
		name      ="toXML"
		access    ="public"
		returntype="string"
		hint      ="Convert any type of data to XML. This method will auto-discover the type. Valid types are array,query,struct"
		output    ="false"
	>
		<cfargument name="data" type="any" required="true" hint="The data to convert to xml">
		<cfargument
			name    ="columnlist"
			type    ="string"
			required="false"
			hint    ="Choose which columns to inspect, by default it uses all the columns in the query, if using a query"
		>
		<cfargument
			name    ="useCDATA"
			type    ="boolean"
			required="false"
			default ="false"
			hint    ="Use CDATA content for ALL values. The default is false"
		>
		<cfargument
			name    ="addHeader"
			type    ="boolean"
			required="false"
			default ="true"
			hint    ="Add an xml header to the packet returned."
		>
		<cfargument
			name    ="encoding"
			type    ="string"
			required="true"
			default ="UTF-8"
			hint    ="The character encoding of the header. UTF-8 is the default"
		/>
		<cfargument
			name    ="delimiter"
			type    ="string"
			required="false"
			default =","
			hint    ="The delimiter in the list. Comma by default"
		>
		<cfargument
			name    ="rootName"
			type    ="string"
			required="true"
			default =""
			hint    ="The name of the root element, else it defaults to the internal defaults."
		/>
		<cfscript>
		var buffer = CreateObject( "java", "java.lang.StringBuilder" ).init( "" );

		// Header
		if ( arguments.addHeader )
		{
			buffer.append( "<?xml version=""1.0"" encoding=""#arguments.encoding#""?>" );
		}

		// Object Check
		if ( IsObject( arguments.data ) )
		{
			buffer.append( ObjectToXML( argumentCollection = arguments ) );
		}
		// Struct Check?
		else if ( IsStruct( arguments.data ) )
		{
			buffer.append( StructToXML( argumentCollection = arguments ) );
		}
		// Query Check?
		else if ( IsQuery( arguments.data ) )
		{
			buffer.append( QueryToXML( argumentCollection = arguments ) );
		}
		// Array Check?
		else if ( IsArray( arguments.data ) )
		{
			buffer.append( ArrayToXML( argumentCollection = arguments ) );
		}
		// Simple Value Check, treated as a simple array list?
		else if ( IsSimpleValue( arguments.data ) )
		{
			arguments.data = ListToArray( arguments.data, arguments.delimiter );
			buffer.append( ArrayToXML( argumentCollection = arguments ) );
		}

		return buffer.toString();
		</cfscript>
	</cffunction>

	<cffunction
		name      ="arrayToXML"
		returnType="string"
		access    ="public"
		output    ="false"
		hint      ="Converts an array into XML with no headers."
	>
		<cfargument name="data" type="array" required="true" hint="The array to convert">
		<cfargument
			name    ="useCDATA"
			type    ="boolean"
			required="false"
			default ="false"
			hint    ="Use CDATA content for ALL values. False by default"
		>
		<cfargument
			name    ="rootName"
			type    ="string"
			required="true"
			default =""
			hint    ="The name of the root element, else it defaults to the internal defaults."
		/>

		<cfscript>
		var buffer      = CreateObject( "java", "java.lang.StringBuilder" ).init( "" );
		var target      = arguments.data;
		var x           = 1;
		var dataLen     = ArrayLen( target );
		var thisValue   = "";
		var rootElement = "array";
		var itemElement = "item";

		// Root Name
		if ( Len( arguments.rootName ) )
		{
			rootElement = arguments.rootName;
		}

		// Create Root
		buffer.append( "<#rootElement#>" );
		</cfscript>

		<cfloop from="1" to="#dataLen#" index="x">
			<cfparam name="target[x]" default="_INVALID_">

			<cfif IsSimpleValue( target[ x ] ) AND target[ x ] EQ "_INVALID_">
				<cfset thisValue = "NULL">
			<cfelse>
				<cfset thisValue = target[ x ]>
			</cfif>

			<cfif NOT IsSimpleValue( thisValue )>
				<cfset thisValue = TranslateValue( arguments, thisValue )>
			<cfelse>
				<cfset thisValue = SafeText( thisValue, arguments.useCDATA )>
			</cfif>

			<cfset buffer.append( "<#itemElement#>#thisValue#</#itemElement#>" )>
		</cfloop>

		<cfset buffer.append( "</#rootElement#>" )>

		<cfreturn buffer.toString()>
	</cffunction>

	<cffunction
		name      ="queryToXML"
		returnType="string"
		access    ="public"
		output    ="false"
		hint      ="Converts a query to XML with no headers."
	>
		<cfargument name="data" type="query" required="true" hint="The query to convert">
		<cfargument
			name    ="CDATAColumns"
			type    ="string"
			required="false"
			default =""
			hint    ="Which columns to wrap in cdata tags"
		>
		<cfargument
			name    ="columnlist"
			type    ="string"
			required="false"
			default ="#arguments.data.columnlist#"
			hint    ="Choose which columns to include in the translation, by default it uses all the columns in the query"
		>
		<cfargument
			name    ="useCDATA"
			type    ="boolean"
			required="false"
			default ="false"
			hint    ="Use CDATA content for ALL values"
		>
		<cfargument
			name    ="rootName"
			type    ="string"
			required="true"
			default =""
			hint    ="The name of the root element, else it defaults to the internal defaults."
		/>

		<cfset var buffer = CreateObject( "java", "java.lang.StringBuilder" ).init( "" )>
		<cfset var col = "">
		<cfset var columns = arguments.columnlist>
		<cfset var value = "">
		<cfset var rootElement = "query">
		<cfset var itemElement = "row">

		<!--- Override First root --->
		<cfif Len( arguments.rootName )>
			<cfset rootElement = arguments.rootName>
		</cfif>

		<!--- Create Root --->
		<cfset buffer.append( "<#rootelement# rowCount=""#arguments.data.recordCount#"" fieldNames=""#columns#"">" )>
		<!--- Data --->
		<cfloop query="arguments.data">
			<cfset buffer.append( "<#itemElement#>" )>
			<cfloop index="col" list="#columns#">
				<cftry>
					<!--- Get Value --->
					<cfset value = arguments.data[ col ][ currentRow ]>
					<!--- Check for nested translation --->
					<cfif NOT IsSimpleValue( value )>
						<cfset value = TranslateValue( arguments, value )>
					<cfelse>
						<cfset value = SafeText( value, arguments.useCDATA )>
					</cfif>
					<!--- Check if in cdata columns --->
					<cfif arguments.useCDATA OR ListFindNoCase( arguments.cDataColumns, col )>
						<cfset value = "<![CDATA[" & value & "]]" & ">">
					</cfif>
					<cfset buffer.append( "<#col#>#value#</#col#>" )>

					<cfcatch type="any">
						<cfdump var="#cfcatch#"><cfdump var="#arguments#"><cfdump var="#currentRow#"><cfdump var="#col#"><cfabort>
					</cfcatch>
				</cftry>
			</cfloop>
			<cfset buffer.append( "</#itemElement#>" )>
		</cfloop>

		<!--- End Root --->
		<cfset buffer.append( "</#rootelement#>" )>
		<cfreturn buffer.toString()>
	</cffunction>

	<cffunction
		name      ="structToXML"
		returnType="string"
		access    ="public"
		output    ="false"
		hint      ="Converts a struct into XML with no headers."
	>
		<cfargument name="data" type="any" required="true" hint="The structure, object, any to convert.">
		<cfargument
			name    ="useCDATA"
			type    ="boolean"
			required="false"
			default ="false"
			hint    ="Use CDATA content for ALL values"
		>
		<cfargument
			name    ="rootName"
			type    ="string"
			required="true"
			default =""
			hint    ="The name of the root element, else it defaults to the internal defaults."
		/>
		<cfscript>
		var target      = arguments.data;
		var buffer      = CreateObject( "java", "java.lang.StringBuilder" ).init( "" );
		var key         = 0;
		var thisValue   = "";
		var args        = StructNew();
		var rootElement = "struct";
		var objectType  = "";

		// Root Element
		if ( Len( arguments.rootName ) )
		{
			rootElement = arguments.rootName;
		}

		// Declare Root
		if ( IsObject( arguments.data ) )
		{
			rootElement = "object";
			buffer.append( "<#rootElement# type=""#GetMetadata( arguments.data ).name#"">" );
		}
		else
		{
			buffer.append( "<#rootElement#>" );
		}

		// Content
		for ( key in target )
		{
			// Null Checks
			if ( !StructKeyExists( target, key ) || IsNull( local.target[ key ] ) )
			{
				target[ key ] = "NULL";
			}
			// Translate Value
			if ( NOT IsSimpleValue( target[ key ] ) )
			{
				thisValue = TranslateValue( arguments, target[ key ] );
			}
			else
			{
				thisValue = SafeText( target[ key ], arguments.useCDATA );
			}
			buffer.append( "<#key#>#thisValue#</#key#>" );
		}

		// End Root
		buffer.append( "</#rootElement#>" );

		return buffer.toString();
		</cfscript>
	</cffunction>

	<cffunction
		name      ="objectToXML"
		returnType="string"
		access    ="public"
		output    ="false"
		hint      ="Converts an object(entity) into XML by inspecting its properties and then calling the appropriate getters on it."
	>
		<cfargument name="data" type="any" required="true" hint="The structure, object, any to convert.">
		<cfargument
			name    ="useCDATA"
			type    ="boolean"
			required="false"
			default ="false"
			hint    ="Use CDATA content for ALL values"
		>
		<cfargument
			name    ="rootName"
			type    ="string"
			required="true"
			default =""
			hint    ="The name of the root element, else it defaults to the internal defaults."
		/>
		<cfscript>
		var target      = IsNull( arguments.data ) ? "NULL" : arguments.data;
		var buffer      = CreateObject( "java", "java.lang.StringBuilder" ).init( "" );
		var md          = GetMetadata( target );
		var rootElement = SafeText( ListLast( md.name, "." ) );
		var thisName    = "";
		var thisValue   = "";
		var	x           = 0;
		var newValue    = "";

		// Root Element Override
		if ( Len( arguments.rootName ) )
		{
			rootElement = arguments.rootName;
		}

		// Declare Root
		buffer.append( "<#rootElement# type=""#md.name#"">" );

		// if no properties to marshall, then return blank
		if ( StructKeyExists( md, "properties" ) )
		{
			// loop over properties
			for ( x = 1; x lte ArrayLen( md.properties ); x = x + 1 )
			{
				// check the property name exists and if it has a marshal annotation of false
				if (
					StructKeyExists( md.properties[ x ], "name" )
						OR NOT StructKeyExists( md.properties[ x ], "marhsal" )
						OR md.properties[ x ][ "marshal" ] EQ true
				)
				{
					thisName  = md.properties[ x ].name;
					thisValue = Invoke( target, "get#thisName#" );

					// Value Defined?
					if ( not IsDefined( "thisValue" ) )
					{
						thisValue = "";
					}

					// Translate Value
					if ( NOT IsSimpleValue( thisValue ) )
					{
						thisValue = TranslateValue( arguments, thisValue );
					}
					else
					{
						thisValue = SafeText( thisValue, arguments.useCDATA );
					}

					buffer.append( "<#thisName#>#thisValue#</#thisName#>" );
				}
				// end if property has a name, else skip
			}
			// end loop over properties
		}
		// end if no properties detected

		// End Root
		buffer.append( "</#rootElement#>" );

		return buffer.toString();
		</cfscript>
	</cffunction>

	<!------------------------------------------- PRIVATE ------------------------------------------>

	<cffunction name="translateValue" access="private" returntype="any" hint="Translate a value into XML" output="false">
		<cfargument name="args" type="struct" required="true" hint="The original argument collection">
		<cfargument name="targetValue" type="any" required="true" hint="The value to translate">
		<cfscript>
		var newArgs       = StructNew();
		newArgs.data      = arguments.targetValue;
		newArgs.useCDATA  = arguments.args.useCDATA;
		newArgs.addHeader = false;
		return ToXML( argumentCollection = newArgs );
		</cfscript>
	</cffunction>

	<!--- This line taken from Nathan Dintenfas' SafeText UDF --->
	<!--- www.cflib.org/udf.cfm/safetext --->
	<cffunction name="safeText" returnType="string" access="private" output="false" hint="Create a safe xml text">
		<cfargument name="txt" type="string" required="true">
		<cfargument
			name    ="useCDATA"
			type    ="boolean"
			required="false"
			default ="false"
			hint    ="Use CDATA content for ALL values"
		>
		<cfset var newTxt = XmlFormat( UnicodeWin1252( Trim( arguments.txt ) ) )>
		<cfif arguments.useCDATA>
			<cfreturn "<![CDATA[" & newTxt & "]]>">
		<cfelse>
			<cfreturn newTxt>
		</cfif>
	</cffunction>

	<!--- This method written by Ben Garret (http://www.civbox.com/) --->
	<cffunction
		name      ="unicodeWin1252"
		output    ="false"
		access    ="private"
		hint      ="Converts MS-Windows superset characters (Windows-1252) into their XML friendly unicode counterparts"
		returntype="string"
	>
		<cfargument name="value" type="string" required="yes">
		<cfscript>
		var string = arguments.value;
		string     = ReplaceNoCase(
			 string
			,Chr( 8218 )
			,"&##8218;"
			,"all"
		); // �
		string = ReplaceNoCase( string, Chr( 402 ), "&##402;", "all" ); // �
		string = ReplaceNoCase(
			 string
			,Chr( 8222 )
			,"&##8222;"
			,"all"
		); // �
		string = ReplaceNoCase(
			 string
			,Chr( 8230 )
			,"&##8230;"
			,"all"
		); // �
		string = ReplaceNoCase(
			 string
			,Chr( 8224 )
			,"&##8224;"
			,"all"
		); // �
		string = ReplaceNoCase(
			 string
			,Chr( 8225 )
			,"&##8225;"
			,"all"
		); // �
		string = ReplaceNoCase( string, Chr( 710 ), "&##710;", "all" ); // �
		string = ReplaceNoCase(
			 string
			,Chr( 8240 )
			,"&##8240;"
			,"all"
		); // �
		string = ReplaceNoCase( string, Chr( 352 ), "&##352;", "all" ); // �
		string = ReplaceNoCase(
			 string
			,Chr( 8249 )
			,"&##8249;"
			,"all"
		); // �
		string = ReplaceNoCase( string, Chr( 338 ), "&##338;", "all" ); // �
		string = ReplaceNoCase(
			 string
			,Chr( 8216 )
			,"&##8216;"
			,"all"
		); // �
		string = ReplaceNoCase(
			 string
			,Chr( 8217 )
			,"&##8217;"
			,"all"
		); // �
		string = ReplaceNoCase(
			 string
			,Chr( 8220 )
			,"&##8220;"
			,"all"
		); // �
		string = ReplaceNoCase(
			 string
			,Chr( 8221 )
			,"&##8221;"
			,"all"
		); // �
		string = ReplaceNoCase(
			 string
			,Chr( 8226 )
			,"&##8226;"
			,"all"
		); // �
		string = ReplaceNoCase(
			 string
			,Chr( 8211 )
			,"&##8211;"
			,"all"
		); // �
		string = ReplaceNoCase(
			 string
			,Chr( 8212 )
			,"&##8212;"
			,"all"
		); // �
		string = ReplaceNoCase( string, Chr( 732 ), "&##732;", "all" ); // �
		string = ReplaceNoCase(
			 string
			,Chr( 8482 )
			,"&##8482;"
			,"all"
		); // �
		string = ReplaceNoCase( string, Chr( 353 ), "&##353;", "all" ); // �
		string = ReplaceNoCase(
			 string
			,Chr( 8250 )
			,"&##8250;"
			,"all"
		); // �
		string = ReplaceNoCase( string, Chr( 339 ), "&##339;", "all" ); // �
		string = ReplaceNoCase( string, Chr( 376 ), "&##376;", "all" ); // �
		string = ReplaceNoCase( string, Chr( 376 ), "&##376;", "all" ); // �
		string = ReplaceNoCase(
			 string
			,Chr( 8364 )
			,"&##8364"
			,"all"
		); // �
		return string;
		</cfscript>
	</cffunction>

	<!--- Get ColdBox Util --->
	<cffunction
		name      ="getUtil"
		access    ="private"
		output    ="false"
		returntype="logbox.system.core.util.Util"
		hint      ="Create and return a util object"
	>
		<cfreturn CreateObject( "component", "logbox.system.core.util.Util" )/>
	</cffunction>
</cfcomponent>
