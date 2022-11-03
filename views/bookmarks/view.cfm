<cfoutput>
  <!--- bookmark Modification form --->
   <form id="bookmarkForm" action=#event.buildLink( prc.xeh.process )# method="POST">
       <!--- Update Switch --->
       <input type="checkbox" hidden id="boolUpdateSwitch" name="boolUpdateSwitch" checked=""> <!--- This value is set in the JS class PopulateReminderModal --->
       
       <!--- intbookmarkID --->
       <input type="text" hidden id="intBookmarkID" name="intBookmarkID">  <!--- This value is set in the JS class PopulateReminderModal --->

       <!---   vcbookmarkDescription  --->
       <div class="mb-3">
          <label for="vcBookmarkDescription">Description</label>
          <textarea class="form-control" id="vcBookmarkDescription" name="vcBookmarkDescription" rows=2></textarea> <!--- This value is set in the JS class PopulateReminderModal --->
         </div>

       <!---   vcbookmarkAddress  --->
       <div class="mb-3">
        <label for="vcBookmarkAddress">Address</label>
        <input type="text" id="vcBookmarkAddress" name="vcBookmarkAddress">  <!--- This value is set in the JS class PopulateReminderModal --->
       </div>
  </form>
</cfoutput>