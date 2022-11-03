<cfoutput>
    <!--- Personal bookmark Viewer --->  

    <h3>All Bookmarks</h3>            
        <!--- bookmark Table --->
        <div class="table">
         <table id="bookmark-modal-Table" class="display" style="width:100%">
             <thead>
                 <tr>
                     <th class="data-header">Description</th>
                     <th class="data-header" hidden>Add</th>
                 </tr>
             </thead>

             <tbody>
                 <cfloop array=#rc.allBookmarks# item="bookmark">
                     <tr class="data-row">

                         <!--- Description --->
                         <td class="data-col" onclick="openBookmark( this )" value='#bookmark.vcbookmarkDescription#'>
                             <cfif len(bookmark.vcbookmarkDescription) GT 50>
                                 #Mid( bookmark.vcbookmarkDescription, 1, 50 )#...
                             <cfelse>
                                 #bookmark.vcbookmarkDescription#
                             </cfif>
                         </td>

                         <!--- Liked --->
                         <td class="btn-col">
                           <button type="button" name="likedBookmark" class="btn btn-primary" value="#bookmark.intbookmarkID#">
                              <a href=#event.buildLink( prc.xeh.like & bookmark.intbookmarkID )#><i class="bi bi-bookmark-plus"></i></a>
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
</cfoutput>