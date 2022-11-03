/**
 * This will get the needed information to serve from Reminder.
 *
 * @Author  Jj Zettler
 * @date    9/20/2022
 * @version 0.1
 */
component singleton accessors="true" {

	property name = "populator"       inject = "wirebox:populator";
	property name = "reminderGateway" inject = "Gateways/ReminderGateway";


	ReminderService function init ()
	{
		return this;
	}

	/**
	 * Returns an array of all Reminders
	 */
	Array function list ()
	{
		qry        = reminderGateway.list();
		aReminders = [];

		for ( row in qry )
		{
			ArrayAppend( aReminders, row );
		}

		return aReminders;
	}

	/**
	 * Returns an array of all Reminders by a user
	 */
	Array function listUserReminders ( required numeric ID )
	{
		qry        = reminderGateway.listUserReminders( ID );
		aReminders = [];

		for ( row in qry )
		{
			ArrayAppend( aReminders, row );
		}

		return aReminders;
	}

	/**
	 * Returns all overdue Reminders Given a specific User ID
	 *
	 * @ID The User ID we want to search for overdue Reminders.
	 */
	Array function getOverdue ( required numeric ID )
	{
		qry        = reminderGateway.listUserReminders( ID );
		aReminders = [];

		for ( row in qry )
		{
			if( row.vcDueDate <= now() )
			{
				//The intProcess of 5 "IsCompleted"
				if(row.intProcess != 5) {
					ArrayAppend( aReminders, row );
				}
			}
		}

		return aReminders;
	}

	/**
	 * Checks if a reminder exists, given a Unique ID
	 *
	 * @idToCheckFor The ID we want to check for in the database.
	 */
	boolean function exists ( required number idToCheckFor )
	{
		aReminders = ListAll();
		pass       = false;

		for ( reminder in aReminders )
		{
			if ( reminder.intReminderID == idToCheckFor )
			{
				WriteDump( label = "ReminderService/exists", var = "#idToCheckFor# exists." );
				pass = true;
			}
		}
		return pass;
	}

	/**
	 * Checks if a reminder exists, given a Reminder Value
	 *
	 * @reminderValue The value we want to check for in the database.
	 */
	boolean function hasReminder ( required string reminderValue )
	{
		aStoredReminders = List();

		for ( storedReminder in aStoredReminders )
		{
			if ( storedReminder.vcReminderValue == ReminderValue )
			{
				return true;
			}
		}
		return false;
	}

	/**
	 * Adds a specific reminder to the database
	 *
	 * @data The data we want to add to the database
	 */
	void function add ( required any data )
	{
		reminderGateway.add( data );
	}

	/**
	 * Updates a given reminder in the database with new data
	 *
	 * @idToChange The ID of the Reminder we want to modify
	 * @data       The data we want to add to the database
	 */
	void function update ( required number idToChange, required any data )
	{
		reminderGateway.update( idToChange, data );
	}

	/**
	 * Deletes a given reminder in the database
	 *
	 * @idToDelete The ID of the Reminder we want to delete
	 */
	void function delete ( required number idToDelete )
	{
		reminderGateway.delete( idToDelete );
	}

}
