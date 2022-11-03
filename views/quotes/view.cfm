<cfoutput>
  <!--- Quote Modification form --->
   <form id="quoteForm" action=#event.buildLink( prc.xeh.process )# method="POST">
       <!--- Update Switch --->
       <input type="checkbox" hidden id="boolUpdateSwitch" name="boolUpdateSwitch" checked=""> <!--- This value is set in the JS class PopulateReminderModal --->
       <!--- intQuoteID --->
       <input type="text" hidden id="intQuoteID" name="intQuoteID">  <!--- This value is set in the JS class PopulateReminderModal --->

       <!---   vcQuoteAuthor  --->
       <div class="mb-3">
          <label for="vcQuoteAuthor">Author</label>
          <input type="text" id="vcQuoteAuthor" name="vcQuoteAuthor">  <!--- This value is set in the JS class PopulateReminderModal --->
       </div>

       <!---   vcQuoteText  --->
       <div class="mb-3">
        <label for="vcQuoteText">Content</label>
        <textarea class="form-control" id="vcQuoteText" name="vcQuoteText" rows=3></textarea> <!--- This value is set in the JS class PopulateReminderModal --->
       </div>

       <!---   vcQuoteSite  --->
       <div class="mb-3">
          <label for="vcQuoteSite">Site</label>
          <textarea class="form-control" id="vcQuoteSite" name="vcQuoteSite"></textarea> <!--- This value is set in the JS class PopulateReminderModal --->
       </div>

  </form>
</cfoutput>