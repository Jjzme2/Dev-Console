<cfoutput>
    <div class="inner-page">
        <div class="pageHeaderShell">
            <div class="subtitle quote">
                <p><strong>#rc.randomQuote.vcQuoteText#</strong></p>
                <p><em>-#rc.randomQuote.vcQuoteAuthor#</em></p>
            </div>
        </div>
        <div class="mid-page">
            <div class="mid-page-body">
                <div class="pageHeaderShell">
                    <div class="greeting">
                        <h1 id=#session.LoggedInID#><span name="greetingText" id="greetingText"><!--- Set in dateTime.js ---></span> #rc.user#</h1>
                        <p name="dayOfWeekText" id="dayOfWeekText"><!--- Set in dateTime.js ---></p>                       
                        <p name="monthDayText" id="monthDayText"><!--- Set in dateTime.js ---></p>                      
                        <p name="timeText" id="timeText"><!--- Set in dateTime.js ---></p>
                    </div>
                </div>

                <cfif len(rc.overdueReminders)>
                    <div> 
                        <!--- Reminder Table --->
                        <div class="homepage-reminders">
                            <h3 id="reminderTitle" name="reminderTitle" class="text-centered bounce-in">Overdue Reminders</h3>
                            <div class="warning-table">
                                <table id="overdueReminderTable" name="overdueReminderTable" class="display" style="width:100%">
                                    <thead>
                                        <tr>
                                            <th class="warning-header">Priority</th>
                                            <th class="warning-header">Reminder</th>
                                            <th class="warning-header">Source</th>
                                            <th class="warning-header">Process</th>
                                            <th class="warning-header">Due Date</th>
                                        </tr>
                                    </thead>
                    
                                    <tbody>
                                        <cfloop array=#rc.overdueReminders# item="reminder">
                                            <tr     id="intReminderID"   name="intReminderID"   class="warning-row" value='#reminder.intReminderID#' onmouseenter="changeText('#reminder.vcReminderValue#', 'reminderMessage', true)" onmouseout="changeText('', 'reminderMessage', false)">
                                                <td id="vcPriorityValue" name="vcPriorityValue" class="warning-col" value='#reminder.intPriority#' onclick="populateRemindModal(this)">#reminder.vcPriorityValue#</td>
                                                <td id="vcReminderValue" name="vcReminderValue" class="warning-col" value='#reminder.vcReminderValue#' onclick="populateRemindModal(this)">
                                                    <!--- Check if the reminder value has too many characters or not. --->
                                                    <cfif len(reminder.vcReminderValue) GT 50>
                                                        #Mid( reminder.vcReminderValue, 1, 50 )#...
                                                    <cfelse>
                                                        #reminder.vcReminderValue#
                                                    </cfif>
                                                </td> <!--- Gets the string's first 50 characters --->
                                                <td id="vcSourceValue"   name="vcSourceValue"   class="warning-col" value='#reminder.intSource#' onclick="populateRemindModal(this)">#reminder.vcSourceValue#</td>
                                                <td id="vcProcessValue"  name="vcProcessValue"  class="warning-col" value='#reminder.intProcess#' onclick="populateRemindModal(this)">#Mid( reminder.vcProcessValue, 3, 50 ) #</td> <!--- In the Database, each item is called isSomething, to clean this up, we remove the first two characters. --->
                                                <cfif reminder.vcDueDate LTE '2999-12-31'>
                                                    <td id="vcDueDate"   name="vcDueDate" class="warning-col" value='#reminder.vcDueDate#'>#dateFormat(reminder.vcDueDate, "MMMM dd, yyyy")#</td>
                                                <cfelse>
                                                    <td id="vcDueDate"   name="vcDueDate" class="warning-col" value='#reminder.vcDueDate#'>N/A</td>
                                                </cfif>
                                            </tr>
                                        </cfloop>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
    
                    <div id="reminderMessage" hidden class="bounce-anim"></div>
                <cfelse>
                    <h1 class="">You're all caught up!</h1>
                </cfif>

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
        </div>
    </div>
</cfoutput>