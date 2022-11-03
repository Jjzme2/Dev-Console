<cfoutput>
    <div class="inner-Page">
        <div class="pageHeaderShell">
            <div class="pageHeader">
                <h1 class="tableTitle">Bookmarks</h1>
                <button type="button" name="Addbookmark" class="btn btn-primary" onclick="openBookmark(this)" value='0'>
                    +
                </button>
            </div>
        </div>

        <!--- bookmark Table --->
        <div class="table">
            <table id="bookmarkTable" class="display" style="width:100%">
                <thead>
                    <tr>
                        <th class="data-header">Description</th>
                        <th class="data-header">Address</th>
                        <th class="data-header" hidden>Update</th>

                    <!---<th class="data-header" hidden>Email</th>  --->
                    </tr>
                </thead>
                <tbody>
                    <cfloop array=#rc.bookmarks# item="bookmark">
                        <tr class="data-row" value="#bookmark.intbookmarkID#">

                            <!--- Description --->
                            <td class="data-col" onclick="openBookmark( this )" value='#bookmark.vcbookmarkDescription#'>
                                <cfif len(bookmark.vcbookmarkDescription) GT 50>
                                    #Mid( bookmark.vcbookmarkDescription, 1, 50 )#...
                                <cfelse>
                                    #bookmark.vcbookmarkDescription#
                                </cfif>
                                
                            </td>
                            
                            
                            <!--- bookmark Address --->
                            <td class="data-col" value='#bookmark.vcbookmarkAddress#'>
                                <!--- Check if the reminder value has too many characters or not. --->
                                <cfif len(bookmark.vcbookmarkAddress) GT 50>
                                    <a href="#bookmark.vcbookmarkAddress#" target="_blank">#Mid( bookmark.vcbookmarkAddress, 1, 50 )#...</a>
                                <cfelse>
                                    <a href="#bookmark.vcbookmarkAddress#" target="_blank">#bookmark.vcbookmarkAddress#</a>
                                </cfif>
                            </td>

                            <!--- Update --->
                            <td class="btn-col" onclick="openBookmark( this )" id="updateData"  name="updateData">
                                <button type="button" name="updatebookmark" class="btn btn-primary">
                                    Update
                                </button>
                            </td>
                        </tr>
                    </cfloop>
                
                </tbody>
            
                <tfoot>
                
                </tfoot>
            </table>
        </div>


    
        <!---     Bookmark Modal         --->
         <div class="modal" name= "bookmarkModal" id="bookmarkModal" tabindex="-1">
             <div class="modal-dialog">
                 <div class="modal-content">
                     <div class="modal-header">
                         <h5 class="modal-title" id="modalTitle">Modal title</h5>
                         <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                     </div>
                 
                     <div class="modal-body">
                         <!--- This works, but I would like it to display only a reminder/view, that determines whether we are adding by having a variable. --->
                         <cfinclude template=#prc.bookmarkTemplate#>
                     </div>
                 
                     <div class="modal-footer">
                         <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                         <button type="submit" id="submitFormButton" form="bookmarkForm" value="add" class="btn btn-primary">Submit</button> <!--- This is what will actually be sending the Message. --->
                     </div>
                 </div>
             </div>
         </div>
    </div>
</div>
</cfoutput>