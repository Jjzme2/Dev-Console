/**
 * This will get the needed information to serve data from Notes.
 *
 * @Author  Jj Zettler
 * @date    10/12/2022
 * @version 0.1
 */
component singleton accessors="true" extends="BaseService"{

	NoteService function init ()
	{
		return this;
	}

	/**
	 * Get all notes
	 *
	 */
	Array function List ()
	{
		qry    = noteGateway.list();
		aNotes = [];

		for ( row in qry )
		{
			ArrayAppend( aNotes, row );
		}

		return aNotes;
	}

	/**
	 * Get all notes written by a given user
	 *
	 * @UserID This is the User ID who we want to get the notes for.
	 */
	Array function ListUserNotes ( required number userID )
	{
		qry    = noteGateway.listUserNotes( userID );
		aNotes = [];

		for ( row in qry )
		{
			ArrayAppend( aNotes, row );
		}

		return aNotes;
	}

	/**
	 * Check to see if a note already exists in the database.
	 *
	 * @noteContent The content we want to find a match for.
	 */
	boolean function hasNote ( required string noteContent )
	{
		aStoredNotes = List();

		for ( storedNote in aStoredNotes )
		{
			if ( storedNote.vcNoteValue == noteContent )
			{
				return true;
			}
		}
		return false;
	}

	/**
	 * CRUD Add
	 *
	 * @data Is the data we want to add to the db
	 */
	void function add ( required struct data )
	{
		noteGateway.add( data );
	}

	/**
	 * CRUD Update
	 *
	 * @data Is the data we want to add to the db
	 */
	void function update ( required struct data )
	{
		noteGateway.update( data );
	}

	/**
	 * CRUD Delete
	 *
	 * @ID Is the ID we want to delete from the db
	 */
	void function delete ( required numeric ID )
	{
		noteGateway.delete( ID );
	}

}
