<cfoutput>
    <div class="inner-Page">
        <!--- User Registration --->
        <form action=#event.buildLink( prc.xeh.process )# method="POST">
            <!--- UserName --->
            <div class="mb-3">
                <label for="vcUsername" class="form-label">Username</label>
                <input type="text" class="form-control" id="vcUsername" name="vcUsername">
                <div id="usernameHelp" class="form-text">Alphanumeric 3-16 characters.</div>
            </div>
        
            <!--- Email --->
            <div class="mb-3">
                <label for="vcUserEmail" class="form-label">Email address</label>
                <input type="email" class="form-control" id="vcUserEmail" name="vcUserEmail" aria-describedby="emailHelp">
                <div id="emailHelp" class="form-text">We'll never share your email with anyone else.</div>
            </div>
        
            <!--- Password --->
            <div class="mb-3">
                <label for="vcPassword" class="form-label">Password</label>
                <input type="password" class="form-control" id="vcPassword" name="vcPassword">
                <div id="passwordHelp" class="form-text">Minimum eight characters, at least one upper case English letter, one lower case English letter, one number and one special character.</div>
            </div>
        
            <!--- Confirm Password --->
            <div class="mb-3">
                <label for="passConfirmation" class="form-label">Confirm Password</label>
                <input type="password" class="form-control" id="passConfirmation" name="passConfirmation">
            </div>
            
            <button type="submit" class="btn btn-primary">Submit</button>
        </form>
    </div>
</cfoutput>