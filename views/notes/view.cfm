<cfoutput>
    <!--- Note Modification form --->
     <form id="noteForm" action=#event.buildLink( prc.xeh.process )# method="POST">
         <!--- Delete Switch --->
         <input type="checkbox" hidden id="boolDeleteSwitch" name="boolDeleteSwitch" checked=""> <!--- This value is set in the JS class PopulateReminderModal --->
         <!--- Update Switch --->
         <input type="checkbox" hidden id="boolUpdateSwitch" name="boolUpdateSwitch" checked=""> <!--- This value is set in the JS class PopulateReminderModal --->
         <!--- intNoteID --->
         <input type="text" hidden id="intNoteID" name="intNoteID">  <!--- This value is set in the JS class PopulateReminderModal --->
  
         <!--- vcNoteTitle --->
         <div class="mb-3">
            <label for="vcNoteTitle">Title</label>
            <input type="text" id="vcNoteTitle" name="vcNoteTitle" value="">  <!--- This value is set in the JS class PopulateReminderModal --->
         </div>
  
         <!--- vcNoteValue --->
         <div class="mb-3">
          <label for="vcNoteValue">Content</label>
          <textarea class="form-control" id="vcNoteValue" name="vcNoteValue" rows=3 value=""></textarea> <!--- This value is set in the JS class PopulateReminderModal --->
         </div>
  
         <!--- vcNoteReferenceSite --->
         <div class="mb-3">
            <label for="vcNoteReferenceSite">Details</label>
            <textarea class="form-control" id="vcNoteReferenceSite" name="vcNoteReferenceSite" value=""></textarea> <!--- This value is set in the JS class PopulateReminderModal --->
         </div>
    </form>
  </cfoutput>