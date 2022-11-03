<cfoutput>
    <div class="inner-Page">
        <div class="pageHeaderShell">
            <div class="pageHeader">
                <h1 class="tableTitle">Users</h1>
            </div>
        </div>
    <!--- User Table --->
       <div class="table">
            <table id="userTable" class="display" style="width:100%">
                <thead>
                    <tr>
                        <th class="data-header">Join Date</th>
                        <th class="data-header">Username</th>
                        <th class="data-header" hidden>Email</th> 
                    </tr>
                </thead>
                <tbody>
                    <cfloop array=#rc.users# item="user">
                        <tr class="data-row">
                            <td class="data-col">#dateFormat(user.dateJoinDate, "MMMM dd, yyyy")#</td>
                            <td class="data-col">#user.vcUsername#</td>
                            <td class="data-col btn-col">
                                <button type="button" name="SendEmail" class="btn btn-primary" value=#user.vcUserEmail# onclick="openEmailModal(this)">
                                    <i class="bi bi-envelope"></i>
                                </button>
                            </td>
                        </tr>
                    </cfloop>
                
                </tbody>
            
                <tfoot>
                
                </tfoot>
            </table>
        </div>
    </div>

    <!--- Write Email Modal --->
    <div class="modal" name= "writeEmailModal" id="writeEmailModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalTitle">Modal title</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <!--- This works, but I would like it to display only a reminder/view, that determines whether we are adding by having a variable. --->
                    <cfinclude template=#prc.userTemplate#>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" id="submitFormButton" form="sendEmail" value="add" class="btn btn-primary">Add Reminder</button>
                </div>
            </div>
        </div>
    </div>
</cfoutput>