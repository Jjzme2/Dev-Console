<cfoutput>
    <!--- Send Email form --->
    <form id="sendEmail" action=#event.buildLink( prc.xeh.process )# method="POST">
        <!--- emailSender --->
        <!--- This needs to be implemented - Use session.loggedinId to get the logged in user. --->

        <div>
            <input type="text" class="form-control" id="emailSender" name="emailSender" hidden value=#rc.sender#>
        </div>

        <!--- emailTo --->
        <div class="mb-3">
            <input type="text" class="form-control" id="emailTo" name="emailTo" hidden value=''>
        </div>

        <div class="mb-3">
            <label for="emailSubject" class="form-label">Subject</label>
            <input type="text" class="form-control" id="emailSubject" name="emailSubject" required>
        </div>

        <div class="mb-3">
            <label for="emailBody" class="form-label">Message</label>
            <textarea id="emailBody" name="emailBody" cols='30' rows='4' maxLength='2000' required></textarea>
        </div>
    </form>
</cfoutput>