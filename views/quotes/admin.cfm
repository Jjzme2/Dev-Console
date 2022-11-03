<cfoutput>
    <div class="inner-Page">
        <div class="pageHeaderShell">
            <div class="pageHeader">
                <h1 class="tableTitle">Quote List</h1>
                <button type="button" name="AddQuote" class="btn btn-primary" onclick="openQuote(this)" value='0'>
                    +
                </button>
            </div>
        </div>

        <!--- Quote Table --->
        <div class="table">
            <table id="quotesTable" class="display" style="width:100%">
                <thead>
                    <tr>
                        <th class="data-header">Author</th>
                        <th class="data-header">Content</th>
                        <th class="data-header">Site</th>
                        <th class="data-header" hidden>Update</th>
                    <!---<th class="data-header" hidden>Email</th>  --->
                    </tr>
                </thead>
                <tbody>
                    <cfloop array=#rc.quotes# item="quote">
                        <tr class="data-row" value="#quote.intQuoteID#">
                            <!--- Author --->
                            <td class="data-col" onclick="openQuote( this )" value='#quote.vcQuoteAuthor#'>#quote.vcQuoteAuthor#</td>
                            <!--- Content --->
                            <td class="data-col" onclick="openQuote( this )" value='#quote.vcQuoteText#'>
                                <!--- Check if the reminder value has too many characters or not. --->
                                <cfif len(quote.vcQuoteText) GT 50>
                                    #Mid( quote.vcQuoteText, 1, 50 )#...
                                <cfelse>
                                    #quote.vcQuoteText#
                                </cfif>
                            </td>
                            <!--- Site --->
                            <td class="data-col" value='#quote.vcQuoteSite#'>
                                <!--- Check if the reminder value has too many characters or not. --->
                                <cfif len(quote.vcQuoteSite) GT 50>
                                    <a href='#quote.vcQuoteSite#' target="_blank">#Mid( quote.vcQuoteSite, 1, 50 )#...
                                <cfelse>
                                    <a href='#quote.vcQuoteSite#' target="_blank">#quote.vcQuoteSite#
                                </cfif>
                            </td>
                            <!--- Update --->
                            <td class="btn-col" onclick="openQuote( this )" id="updateData"  name="updateData">
                                <button type="button" name="updateMessage" class="btn btn-primary">
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


    
            <!---     Quote Modal         --->
    <div class="modal" name= "QuoteModal" id="QuoteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalTitle">Modal title</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <!--- This works, but I would like it to display only a reminder/view, that determines whether we are adding by having a variable. --->
                    <cfinclude template=#prc.viewQuoteTemplate#>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" id="submitFormButton" form="quoteForm" value="add" class="btn btn-primary">Submit</button> <!--- This is what will actually be sending the Message. --->
                </div>
            </div>
        </div>
    </div>
        </div>
    </div>
</cfoutput>