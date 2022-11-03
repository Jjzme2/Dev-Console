<cfoutput>
    <div class="inner-Page">
        <div class="pageHeaderShell">
            <div class="pageHeader">
                <h1 class="tableTitle">Reminders</h1>
                <button type="button" name="AddReminder" class="btn btn-primary" onclick="populateRemindModal(this);" value='0'>
                    +
                </button>
            </div>
        </div>
        
        <div class="table">
            <table id="reminderTable" class="display" style="width:100%">
                <thead>
                    <tr>
                        <th class="data-header">Priority</th>
                        <th class="data-header">Reminder</th>
                        <th class="data-header">Source</th>
                        <th class="data-header">Process</th>
                        <th class="data-header">Due Date</th>
                        <th class="data-header">Creation Date</th>
                        <th class="data-header" hidden>Update</th>  
                        <th class="data-header" hidden>Delete</th>  
                    </tr>
                </thead>

                <tbody>
                    <cfloop array=#rc.listReminders# item="reminder">
                        <tr     id="intReminderID"   name="intReminderID"   class="data-row" value='#reminder.intReminderID#'>
                            <td id="vcPriorityValue" name="vcPriorityValue" class="data-col" value='#reminder.intPriority#' onclick="populateRemindModal(this)">#reminder.vcPriorityValue#</td>
                            <td id="vcReminderValue" name="vcReminderValue" class="data-col" value='#reminder.vcReminderValue#' onclick="populateRemindModal(this)">
                                <!--- Check if the reminder value has too many characters or not. --->
                                <cfif len(reminder.vcReminderValue) GT 50>
                                    #Mid( reminder.vcReminderValue, 1, 50 )#...
                                <cfelse>
                                    #reminder.vcReminderValue#
                                </cfif>
                            </td> <!--- Gets the string's first 50 characters --->
                            <td id="vcSourceValue"   name="vcSourceValue"   class="data-col" value='#reminder.intSource#' onclick="populateRemindModal(this)">#reminder.vcSourceValue#</td>
                            <td id="vcProcessValue"  name="vcProcessValue"  class="data-col" value='#reminder.intProcess#' onclick="populateRemindModal(this)">#Mid( reminder.vcProcessValue, 3, 50 ) #</td> <!--- In the Database, each item is called isSomething, to clean this up, we remove the first two characters. --->
                            <cfif reminder.vcDueDate LTE '2999-12-31'>
                                <td id="vcDueDate"   name="vcDueDate" class="data-col" value='#reminder.vcDueDate#'>#dateFormat(reminder.vcDueDate, "MMMM dd, yyyy")#</td>
                            <cfelse>
                                <td id="vcDueDate"   name="vcDueDate" class="data-col" value='#reminder.vcDueDate#'>N/A</td>
                            </cfif>

                            <!--- 
                                This was also added to the date, but in case I wanted a specific date, I removed it for convenience with Copy/Paste
                                onclick="populateRemindModal(this)"
                            --->
                            <td id="vcCreationDate"  name="vcCreationDate"  class="data-col" value='#reminder.vcCreationDate#' onclick="populateRemindModal(this)">#reminder.vcCreationDate#</td> <!--- In the Database, each item is called isSomething, to clean this up, we remove the first two characters. --->

                            <td id="updateData"  name="updateData"  class="btn-col" onclick="populateRemindModal(this)">
                                <button type="button" name="deleteReminder" class="btn btn-primary">
                                    Update
                                    <!--- <i class="bi bi-trash-fill"></i>  --->
                                </button>
                            </td>

                            <td id="deleteData"  name="deleteData"  class="btn-col" onclick="populateRemindModal(this)">
                                <button type="button" name="deleteReminder" class="btn btn-danger">
                                    <i class="bi bi-trash-fill"></i> 
                                </button>
                            </td>
                        </tr>
                    </cfloop>
                </tbody>
                <!---          
                <tfoot>
                
                </tfoot>
                --->
            </table>


        </div>
    </div>

    <!---  Modal  --->
    <div class="modal" name= "reminderModal" id="reminderModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalTitle" name="modalTitle">Modal title</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <cfinclude template=#prc.viewReminderTemplate#>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" id="submitFormButton" form="reminderForm" value="add" class="btn btn-primary">Add Reminder</button> <!--- This is how the form will be processed, it takes the form data from the includes. --->
                </div>
            </div>
        </div>
    </div>
</cfoutput>