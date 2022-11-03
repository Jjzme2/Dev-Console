<cfoutput>
    <div>
        <form id="messageForm" name="messageForm" action=#event.buildLink( prc.xeh.process )# method="POST">
        <!--- IntSenderID --->
        <input type="text" hidden id="intSenderID" name="intSenderID" value="#session.loggedInID#"> 
        <!--- IntMessageID --->
        <input type="text" hidden id="intMessageID" name="intMessageID" value=""> <!--- This value is set in the JS class PopulateReminderModal --->
        <!--- IntIsRead --->
        <input type="text" hidden id="intIsRead" name="intIsRead" value=""> <!--- This value is set in the JS class PopulateReminderModal --->
        <!--- Delete Switch --->
        <input type="checkbox" hidden id="boolDeleteSwitch" name="boolDeleteSwitch" checked=""> <!--- This value is set in the JS class PopulateReminderModal --->

        <!--- Message Receiver --->
        <!--- DropDown --->
        <div class="mb-3">
          <label for="intReceiverID" name="intReceiverID">Send to</label>
          <select class="form-select"name="intReceiverID" id="intReceiverID"> <!--- This value is set in the JS class PopulateReminderModal --->
              <cfloop array="#rc.users#" item="User">
                  <option value=#User.intUserID#>#User.vcUsername#</option>
              </cfloop>
          </select>
        </div>
        <!--- Text Input 
         <div class="mb-3">
           <input type="text" class="form-control" id="vcReceiverUsername" name="vcReceiverUsername" placeholder="Username">
         </div>
        --->

        <!--- Message Subject --->
        <div class="mb-3">
          <input type="text" class="form-control" id="vcMessageSubject" name="vcMessageSubject" placeholder="Subject" readonly=true>
        </div>

        <!--- Message Content --->
        <div class="mb-3">
          <input type="text" class="form-control" id="vcMessageContent" name="vcMessageContent" placeholder="Message" readonly=true>
        </div>
        </form>
    </div>
</cfoutput>