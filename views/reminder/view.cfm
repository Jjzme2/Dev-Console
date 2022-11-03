<cfoutput>
    <!--- Reminder Addition form --->
     <form id="reminderForm" action=#event.buildLink( prc.xeh.process )# method="POST">
         <!--- Update Switch --->
         <input type="checkbox" hidden id="boolUpdateSwitch" name="boolUpdateSwitch" checked=""> <!--- This value is set in the JS class PopulateReminderModal --->
         <!--- Delete Switch --->
         <input type="checkbox" hidden id="boolDeleteSwitch" name="boolDeleteSwitch" checked=""> <!--- This value is set in the JS class PopulateReminderModal --->
         <!--- vcReminderID --->
         <input type="text" hidden id="intReminderID" name="intReminderID">  <!--- This value is set in the JS class PopulateReminderModal --->
         <!--- vcReminderValue --->
         <div class="mb-3">
            <label for="vcReminderValue" class="form-label">Reminder</label>
            <textarea class="form-control" id="vcReminderValue" name="vcReminderValue" rows=6></textarea> <!--- This value is set in the JS class PopulateReminderModal --->
            <!--- <input type="text" class="form-control" id="vcReminderValue" name="vcReminderValue">  --->
         </div>

         <!---   Priority  --->
         <div class="mb-3">
            <label for="intPriority">Priority</label>
            <select class="form-select"name="intPriority" id="intPriority"> <!--- This value is set in the JS class PopulateReminderModal --->
                <cfloop array="#rc.Priorities#" item="priority">
                    <option value=#priority.intPriorityID#>#priority.vcPriorityValue#</option>
                </cfloop>
            </select>
         </div>

         <!---   source  --->
         <div class="mb-3">
            <label for="intSource">Source</label>
            <select class="form-select"name="intSource" id="intSource"> <!--- This value is set in the JS class PopulateReminderModal --->
                <cfloop array="#rc.Sources#" item="source">
                    <option value=#source.intSourceID#>#source.vcSourceValue#</option>
                </cfloop>
            </select>
         </div>

         <!---   Process  --->
         <div class="mb-3">
            <label for="intProcess">Process</label>
            <select class="form-select"name="intProcess" id="intProcess"> <!--- This value is set in the JS class PopulateReminderModal --->
                <cfloop array="#rc.Processes#" item="process">
                    <option value=#process.intProcessID#>#process.vcProcessValue#</option>
                </cfloop>
            </select>
         </div>
        
         <!---   Due Date --->
         <div>
            <label for="vcDueDate">Due Date</label>
            <input type="date" id="vcDueDate" name="vcDueDate"> <!--- This value is set in the JS class PopulateReminderModal --->
         </div>
    </form>
</cfoutput>