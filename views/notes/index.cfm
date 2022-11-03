<cfoutput>
    <div class="inner-Page">
        <div class="pageHeaderShell">
            <div class="pageHeader">
                <h1 class="tableTitle">My Notes</h1>
                <button type="button" name="AddNote" class="btn btn-primary" onclick="openNote(this)" value='0'>
                    +
                </button>
            </div>
        </div>

        <!--- Note Table --->
        <div class="table">
            <table id="notesTable" class="display" style="width:100%">
                <thead>
                    <tr>
                        <th class="data-header">Title</th>
                        <th class="data-header">Content</th>
                        <th class="data-header">Details</th>
                        <th class="data-header" hidden>Update</th>
                        <th class="data-header" hidden>Delete</th>
                    </tr>
                </thead>

                <tbody>
                    <cfloop array=#rc.notes# item="Note">
                        <tr class="data-row" value="#Note.intNoteID#">
                            <!--- vcNoteTitle --->
                            <td class="data-col" onclick="openNote( this )" value='#Note.vcNoteTitle#'>#Note.vcNoteTitle#</td>
                            <!--- vcNoteValue --->
                            <td class="data-col" onclick="openNote( this )" value='#Note.vcNoteValue#'>
                                <!--- Check if the reminder value has too many characters or not. --->
                                <cfif len(Note.vcNoteValue) GT 50>
                                    #Mid( Note.vcNoteValue, 1, 50 )#...
                                <cfelse>
                                    #Note.vcNoteValue#
                                </cfif>
                            </td>
                            <!--- vcNoteReferenceSite --->
                            <td class="data-col" value='#Note.vcNoteReferenceSite#' onclick="openNote( this )">
                                <!--- Check if we have a value for vcNoteReferenceSite --->
                                <cfif len(Note.vcNoteReferenceSite)>
                                    <!--- Check if the reminder value has too many characters or not. --->
                                    <cfif len(Note.vcNoteReferenceSite) GT 50>
                                        #Mid( Note.vcNoteReferenceSite, 1, 50 )#...
                                    <cfelse>
                                        #Note.vcNoteReferenceSite#
                                    </cfif>
                                </cfif>
                            </td>
                            
                            <!--- Update --->
                            <td class="btn-col" onclick="openNote( this )" id="updateData"  name="updateData">
                                <button type="button" name="updateNote" class="btn btn-primary">
                                    Update
                                </button>
                            </td>
                            <!--- Delete --->
                            <td class="btn-col" onclick="openNote( this )" id="deleteData"  name="deleteData">
                                <button type="button" name="deleteNote" class="btn btn-danger">
                                    <i class="bi bi-trash-fill"></i> 
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
    <div class="modal" name= "NoteModal" id="NoteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalTitle">Modal title</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <!--- This works, but I would like it to display only a reminder/view, that determines whether we are adding by having a variable. --->
                    <cfinclude template=#prc.viewNoteTemplate#>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" id="submitFormButton" form="noteForm" value="add" class="btn btn-primary">Submit</button> <!--- This is what will actually be sending the Message. --->
                </div>
            </div>
        </div>
    </div>
</cfoutput>