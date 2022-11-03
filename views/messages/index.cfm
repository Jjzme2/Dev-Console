<cfoutput>
    <div class="inner-Page">
        <div class="pageHeaderShell">
            <div class="pageHeader">
                <h1 class="tableTitle">Inbox</h1>
                <button type="button" name="WriteMessage" class="btn btn-primary" onclick="openMessage(this)" value='0'>
                    Compose
                </button>
            </div>
        </div>

        <!--- Message Table --->
        <div class="table">
            <table id="messageTable" class="display" style="width:100%">
                <thead>
                    <tr>
                        <th class="data-header">Subject</th>
                        <th class="data-header">Message</th>
                        <th class="data-header" hidden>Sender</th>  
                    </tr>
                </thead>
                <tbody>
                    <cfloop array=#rc.messages# item="message">
                        <tr class="data-row" value="#message.intMessageID#">
                            <td class="data-col" onclick="openMessage(this)" value="#message.vcMessageSubject#">#message.vcMessageSubject#</td>
                            <td class="data-col" onclick="openMessage(this)" value="#message.vcMessageContent#">
                                <!--- Check if the reminder value has too many characters or not. --->
                                <cfif len(message.vcMessageContent) GT 50>
                                    #Mid( message.vcMessageContent, 1, 50 )#...
                                <cfelse>
                                    #message.vcMessageContent#
                                </cfif>
                            </td>
                            <td class="data-col" onclick="openMessage(this)" hidden value="#message.intSenderID#">#message.intSenderID#</td>
                            <!---  This button should delete the message.  --->
                            <td class="btn-col" onclick="openMessage(this)" id="deleteData"  name="deleteData">
                                <button type="button" name="deleteMessage" class="btn btn-danger">
                                    <i class="bi bi-trash3"></i>
                                </button>
                            </td>
                        </tr>
                    </cfloop>
                
                </tbody>
            
                <tfoot>
                
                </tfoot>
            </table>
        </div>


    
            <!---     Message Modal         --->
    <div class="modal" name= "viewMessageModal" id="viewMessageModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalTitle">Modal title</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <!--- This works, but I would like it to display only a reminder/view, that determines whether we are adding by having a variable. --->
                    <cfinclude template=#prc.viewMessageTemplate#>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" id="submitFormButton" form="messageForm" value="add" class="btn btn-primary">Submit</button> <!--- This is what will actually be sending the Message. --->
                </div>
            </div>
        </div>
    </div>
        </div>
    </div>
</cfoutput>