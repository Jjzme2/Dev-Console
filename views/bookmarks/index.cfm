<cfoutput>
    <div class="inner-page">
        <div class="pageHeaderShell">
        </div>
        
        <div class="mid-page">
            <div class="mid-page-body">
                <div class="table-sm">
                    <!--- Bookmark Table --->
                    <table id="bookmarkTable" class="display bookmark-table">
                        <thead>
                            <tr>
                                <th class="bookmark-header">Description</th>
                                <th class="bookmark-header">Address</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop array=#rc.Bookmarks# item="Bookmark">
                                <tr class="bookmark-row" value="#Bookmark.intBookmarkID#">
                                    <!--- Description --->
                                    <td class="bookmark-col" value='#Bookmark.vcBookmarkDescription#' onclick="openBookmark(this)">#Bookmark.vcBookmarkDescription#</td>
                                    <!--- Address --->
                                    <td class="bookmark-col" value='#Bookmark.vcBookmarkAddress#'>
                                        <!--- Check if the reminder value has too many characters or not. --->
                                        <cfif len(Bookmark.vcBookmarkAddress) GT 50>
                                            <a href=#Bookmark.vcBookmarkAddress# target="_blank">#Mid( Bookmark.vcBookmarkAddress, 1, 50 )#...</a>
                                        <cfelse>
                                            <a href=#Bookmark.vcBookmarkAddress# target="_blank">#Bookmark.vcBookmarkAddress#</a>
                                        </cfif>
                                    </td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                </div>
    
                <div class="vertical-button-area w-20 centered">
                    <!--- Open Change Bookmarks Modal --->
                    <button type="button" name="changeBookmarks" class="btn btn-primary">
                        <a href=#event.buildLink( prc.xeh.personalBookmarks )#>Change Bookmarks</a>
                    </button>
                </div>
            </div>
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
</cfoutput>