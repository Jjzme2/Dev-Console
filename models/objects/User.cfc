component name="User" accessors="true" {

	property type = "number" name = "intUserID";
	property type = "string" name = "vcUsername";
	property type = "string" name = "vcUserEmail";
	property type = "string" name = "vcPassword";
	property type = "string" name = "dateJoinDate";


	public User function init ()
	{
		SetIntUserID( 0 );
		SetVcUsername( "" );
		SetVcUserEmail( "" );
		SetVcPassword( "" );
		SetDateJoinDate( "" );
		return this;
	}

	void function Login ()
	{
		session.loggedInID = intUserID;
	}

}
