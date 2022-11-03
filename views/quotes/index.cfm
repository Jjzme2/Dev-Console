<cfoutput>
    <div class="inner-page">
        <div class="pageHeaderShell">

        </div>
        
        <div class="mid-page">
            <div class="mid-page-body">
                <div class="table-sm">
                    <!--- Quote Table --->
                    <table id="quotesTable" class="display quote-table">
                        <thead>
                            <tr>
                                <th class="quote-header">Author</th>
                                <th class="quote-header">Content</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop array=#rc.quotes# item="quote">
                                <tr class="quote-row" value="#quote.intQuoteID#" onclick="openPersonalQuote(this)">
                                    <!--- Author --->
                                    <td class="quote-col" value='#quote.vcQuoteAuthor#'>#quote.vcQuoteAuthor#</td>
                                    <!--- Content --->
                                    <td class="quote-col" value='#quote.vcQuoteText#'>
                                        <!--- Check if the reminder value has too many characters or not. --->
                                        <cfif len(quote.vcQuoteText) GT 50>
                                            #Mid( quote.vcQuoteText, 1, 50 )#...
                                        <cfelse>
                                            #quote.vcQuoteText#
                                        </cfif>
                                    </td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                </div>
    
                <div class="vertical-button-area w-20 centered">
                    <!--- Open Change Favorites Modal --->
                    <button type="button" name="changeFavorites" class="btn btn-primary" value='#session.LoggedInID#'>
                        Change Favorites
                    </button>
                </div>
            </div>
        </div>

    <!---     Quote Modal         --->
    <div class="modal personal-quote-modal" name="personalQuoteModal" id="personalQuoteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title centered" id="modalTitle">Modal title</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body centered">
                    <!--- This works, but I would like it to display only a reminder/view, that determines whether we are adding by having a variable. --->
                    <cfinclude template=#prc.personalQuoteTemplate#>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    </div>
</cfoutput>