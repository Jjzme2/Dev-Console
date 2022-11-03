<cfoutput>
    <div class="inner-Page">
        <!--- User Registration --->
        <form action=#event.buildLink( prc.xeh.login )# method="POST">
            <!--- UserName --->
            <div class="mb-3">
                <label for="vcUsername" class="form-label">Username</label>
                <input type="text" class="form-control" id="vcUsername" name="vcUsername">
            </div>

            <!--- Password --->
            <div class="mb-3">
                <label for="vcPassword" class="form-label">Password</label>
                <input type="password" class="form-control" id="vcPassword" name="vcPassword">
            </div>

            <!--- Keep logged in
            <div class="mb-3 form-check">
                <input type="checkbox" class="form-check-input" id="exampleCheck1">
                <label class="form-check-label" for="exampleCheck1">Check me out</label>
            </div>
            --->

            <button type="submit" class="btn btn-primary">Login</button>
        </form>
    </div>
</cfoutput>