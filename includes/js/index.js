//Modal Functions
function populateRemindModal( element ) // While this works, there is a LOT of repetition, I should make this cleaner/easier to read/more fun to work with.
{
    // Open or Close Modal.
    $('#reminderModal').modal( 'toggle' );

    //Get the form we want to manipulate. 
    var form = $( '#reminderModal #reminderForm' );

     //Get each field, by ID, in the Modal we are displaying.
    var modalUpdate   = $('#reminderModal #boolUpdateSwitch');
    var modalDelete   = $('#reminderModal #boolDeleteSwitch');
    var modalID       = $('#reminderModal #intReminderID');
    var modalpriority = $('#reminderModal #intPriority');
    var modalReminder = $('#reminderModal #vcReminderValue');
    var modalsource   = $('#reminderModal #intSource');
    var modalprocess  = $('#reminderModal #intProcess');
    var modaldueDate  = $('#reminderModal #vcDueDate');

    //Get the ID, set by the value of the row we are clicking, or if we are adding(Clicking '+') we set the value as 0
    var id          = element.parentNode.getAttribute( 'value' );
    var date        = new Date();
    modalID.val( id );
    
    //If the thing we clicked passed as 'Element' doesn't have any cells, it isn't a row in our table, so is likely the add button.
    if( element.parentNode.cells == undefined ){
        modalID.val             (0);

        modalpriority.prop      ( 'disabled', false );
        modalpriority.val       ( 6 );

        modalReminder.prop      ( 'readonly', false );
        modalReminder.val       ( '' );

        modalsource.prop        ( 'disabled', false );
        modalsource.val         ( 1 );

        modalprocess.prop       ( 'disabled', false );
        modalprocess.val        ( 1 );

        modaldueDate.prop       ( 'disabled', false );
        modaldueDate.val        ( date.toJSON().slice( 0, 10 ) ); //Get today, from our Date object above. Convert to JSON for specific format, slice the first 10 chars from that string to get date.
        
        //Set the modal constant data depending on what we are doing.
        modalDelete.val( 'off' );  //Sets Delete Check, will we delete this reminder? A Hidden Checkbox.
        modalUpdate.val( 'off' );    //Sets Update Check, will we update this reminder? A Hidden Checkbox.
        modalTitle = "Create a new Reminder.";
        $('#reminderModal #submitFormButton').prop( 'hidden', false); // Submit form visibility
        submitButtonText = "Create";
    } else{
        // If it does have cells though, we know it's a row.
        var priority        = element.parentNode.cells[0].getAttribute( 'value' );
        var reminder        = element.parentNode.cells[1].getAttribute( 'value' );
        var reminderDisplay = element.parentNode.cells[1].innerHTML; //This line of code will get the information displayed to the user.
        var source          = element.parentNode.cells[2].getAttribute( 'value' );
        var process         = element.parentNode.cells[3].getAttribute( 'value' );
        var dueDate         = element.parentNode.cells[4].getAttribute( 'value' );
    

        // So we set all our inputs to the values we grabbed from the row's cells.
        modalpriority.val( priority );
        modalReminder.val( reminder );
        modalsource.val  ( source );
        modalprocess.val ( process );
        modaldueDate.val ( dueDate );


        // If we can identify the element we clicked on by ID, we know we want to delete that element.
        if( element.getAttribute( 'id' ) == 'deleteData' )      
            //Deleting
        {
            // Set bools needed for handler
            modalUpdate.val( 'off' );    //Sets Update Check, will we update this reminder? A Hidden Checkbox.
            modalDelete.val( 'on' );     //Sets Delete Check, will we delete this reminder? A Hidden Checkbox.

            // Set Readonly Values  (Forms won't submit with disabled values.)
            modalpriority.prop      ( 'disabled', true );
            modalReminder.prop      ( 'readonly', true );
            modalsource.prop        ( 'disabled', true );
            modalprocess.prop       ( 'disabled', true );
            modaldueDate.prop       ( 'disabled', true );

            form.submit(function() 
            {
                // On Submission, reset all values to enabled.
                modalpriority.prop      ( 'disabled', false );
                modalsource.prop        ( 'disabled', false );
                modalprocess.prop       ( 'disabled', false );
                modaldueDate.prop       ( 'disabled', false );
                $('#reminderModal').modal( 'hide' );
            });

            // Set modal constant data
            modalTitle = "Are you sure you want to delete this Reminder?";
            $('#reminderModal #submitFormButton').prop( 'hidden', false); // Submit form visibility
            submitButtonText = "Delete Reminder";
        } else if(element.getAttribute( 'id' ) == 'updateData' | $(location).attr('pathname') == "/user/homepage")  
            // Updating
        {
            // Set bools needed for handler
            modalUpdate.val( 'on' );    //Sets Update Check, will we update this reminder? A Hidden Checkbox.
            modalDelete.val( 'off' );   //Sets Delete Check, will we delete this reminder? A Hidden Checkbox.

            // Set Readonly Values
            modalpriority.prop      ( 'disabled', false );
            modalReminder.prop      ( 'readonly', false );
            modalsource.prop        ( 'disabled', false );
            modalprocess.prop       ( 'disabled', false );
            modaldueDate.prop       ( 'disabled', false );

            // Set the modal constant data depending on what we are doing.
            modalTitle = "Modify an existing Reminder.";
            $('#reminderModal #submitFormButton').prop( 'hidden', false); // Submit form visibility
            submitButtonText = "Save Changes";
            
        } else
            // Reading
        {
            // Set bools needed for handler
            modalUpdate.val( 'off' );    //Sets Update Check, will we update this reminder? A Hidden Checkbox.
            modalDelete.val( 'off' );    //Sets Delete Check, will we delete this reminder? A Hidden Checkbox.

            // Set Readonly Values
            modalpriority.prop      ( 'hidden', true );
            modalReminder.prop      ( 'readonly', true );
            modalsource.prop        ( 'disabled', true );
            modalprocess.prop       ( 'disabled', true );
            modaldueDate.prop       ( 'disabled', true );

            // Set the modal constant data depending on what we are doing.
            modalTitle = "Review Reminder";
            $('#reminderModal #submitFormButton').prop( 'hidden', true); // Submit form visibility
            submitButtonText = "Save Changes";
        }
    }

    // Set the header of the Modal to display something fun.
    $('#reminderModal #modalTitle').html(modalTitle);
    $('#reminderModal #submitFormButton').html(submitButtonText);
}

function openEmailModal( element )
{
    // Open or Close Modal.
    $('#writeEmailModal').modal( 'toggle' );
    var requestedEmail = element.getAttribute( 'value' );
    
    //Get the username by accessing the clicked elements grandparent(The row)'s cells, first value, which is the username.
    var userName = element.parentNode.parentNode.cells[1].innerHTML;

    //Set email, even though it is hidden to the user, we will need this to send the Email. Might not be entirely necessary, since we have RequestedEmail maybe to pass to handler on process?
    $('#writeEmailModal #emailTo').val( requestedEmail );

    // Set the header of the Modal to display something fun.
    $('#writeEmailModal #modalTitle').html("Sending an email to " + userName);
    $('#writeEmailModal #submitFormButton').html("Send Email");



}

// This has some good stuff, that needs to be added to the entire base. 'Modal value if'
function openMessage( element )
{
    // Open or Close Modal.
    $('#viewMessageModal').modal( 'toggle' ); // ID/Name of the Modal on the View for this element.
    
    //Get the form we are using. This may not be needed, but is helpful regardless.
    var form = $( '#viewMessageModal #messageForm' );

    //Get each field, by ID, in the Modal we are displaying. Each field on the form we want to submit/Modal we are displaying.
    var modalID         = $('#viewMessageModal #intMessageID');
    var modalIsRead     = $('#viewMessageModal #intIsRead');
    var modalDelete     = $('#viewMessageModal #boolDeleteSwitch');
    var modalSubject    = $('#viewMessageModal #vcMessageSubject');
    var modalMessage    = $('#viewMessageModal #vcMessageContent');

    //Get the ID, set by the value of the row we are clicking, or if we are adding we set the value as 0
    var id = 0;

    // We try to get the ID of the element by the value passed in through the parent ROW element.
    if( element.parentNode.getAttribute( 'value' ) != null )
    {
        id = element.parentNode.getAttribute( 'value' );
    }else{ //We try to get the ID of the element by the value passed in through the target element.
        console.log("Parent Element doesn't have a value attribute.");
        
        if( element.getAttribute( 'value' ) )
        {
            console.log("Attribute Value found in element.");
            id  = element.getAttribute( 'value' );
        }
    }
    
    modalID.val( id );
    if( id == 0 ){
        modalDelete.val( 'off' );  //Sets Delete Check, will we delete this reminder? A Hidden Checkbox.
        modalIsRead.val( '0' );    //Sets Modal Is Read, 0 is false. A Hidden Text Input

        // Message Receiver does need to show when writing.
        $('#viewMessageModal #intReceiverID').parent().prop( 'hidden', false );
        $('#viewMessageModal #intReceiverID').prop( 'hidden', false );

        // Modal Subject
        modalSubject.prop( 'readonly', false);
        modalSubject.val( '' );    //Sets Modal Subject, what is the subject message? A Text input.
        // Modal Content
        modalMessage.prop( 'readonly', false);
        modalMessage.val( '' );    //Sets Modal Message, what is the message content? A Text input.

        // Set the modal constant data depending on what we are doing.
        $('#viewMessageModal #vcReceiverUsername').prop( 'hidden', false );
        modalTitle = "Create a new Message.";
        $('#viewMessageModal #submitFormButton').prop( 'hidden', false );
        submitButtonText = "Create";
    }
    else{
        // If it does have an ID, we know it should have data. *The data from the row we clicked.
        var subject    = element.parentNode.cells[0].getAttribute( 'value' ); //This line of code will get the value.
        var message    = element.parentNode.cells[1].getAttribute( 'value' ); //This line of code will get the value.
        var senderID   = element.parentNode.cells[2].getAttribute( 'value' ); //This line of code will get the value.
        var intIsRead  = element.parentNode.cells[3].getAttribute( 'value' ); //This line of code will get the value.
        
        // So we set all our inputs to the values we grabbed from the row's cells.
        
        // Message Receiver doesn't need to show when reading.
        $('#viewMessageModal #intReceiverID').parent().prop( 'hidden', true );
        $('#viewMessageModal #intReceiverID').prop( 'hidden', true );

        // Message Is Read
        modalIsRead.val( '1' );    //Sets Modal Is Read, 1 is true. A Hidden Text Input

        // Modal Subject
        modalSubject.prop( 'readonly', true);
        modalSubject.val( subject );
        // Modal Content
        modalMessage.prop( 'readonly', true);
        modalMessage.val( message );

        // If we can identify the element we clicked on by ID, we know we want to delete that element.
        if( element.getAttribute( 'id' ) == 'deleteData' )
        {
            // Set the modal constant data depending on what we are doing.
            modalDelete.val( 'on' ); //Sets Delete Check, will we delete this reminder? A Hidden Checkbox.
            console.log( element.getAttribute( 'intIsRead' ) );
            modalTitle = "Are you sure you want to delete this Message?";
            $('#viewMessageModal #submitFormButton').prop( 'hidden', false );
            submitButtonText = "Delete Message";
        }
        else {
            // Set the modal constant data depending on what we are doing.
            modalDelete.val( 'off' ); //Sets Delete Check, will we delete this reminder? A Hidden Checkbox.
            modalTitle = "Message";
            $('#viewMessageModal #submitFormButton').prop( 'hidden', true );
        }
    }
    // Set the header of the Modal to display something fun.
    $('#viewMessageModal #modalTitle').html(modalTitle);
    $('#viewMessageModal #submitFormButton').html(submitButtonText);
}

// Has good stuff for neatness.
function openQuote( element )
{
    // Open or Close Modal.
    $('#QuoteModal').modal( 'toggle' );

    //Get the form we want to manipulate. 
    var form = $( '#QuoteModal #quoteForm' );

    // Switch values for delete/update
    var modalUpdate   = $('#QuoteModal #boolUpdateSwitch');

    //Get each field, by ID, in the Modal we are displaying.
    var modalID      = $('#QuoteModal #intQuoteID');
    var modalAuthor  = $('#QuoteModal #vcQuoteAuthor');
    var modalContent = $('#QuoteModal #vcQuoteText');
    var modalSite    = $('#QuoteModal #vcQuoteSite');

    // We try to get the ID of the element by the value passed in through the parent ROW element.
    if( element.parentNode.getAttribute( 'value' ) != null )
    {
        id = element.parentNode.getAttribute( 'value' );
    }else { //We try to get the ID of the element by the value passed in through the target element.
        console.log("Parent Element doesn't have a value attribute.");
        
        if( element.getAttribute( 'value' ) )
        {
            console.log("Attribute Value found in element.");
            id  = element.getAttribute( 'value' );
        }
    }

    modalID.val( id );
    console.log(id);

    
    // Creating
    //If the thing we clicked passed as 'Element' doesn't have any cells, it isn't a row in our table, so is likely the add button.
    if( id == 0 ) {
        modalAuthor.prop      ( 'readonly', false );
        modalAuthor.val       ( '' );

        modalContent.prop     ( 'readonly', false );
        modalContent.val      ( '' );

        modalSite.prop        ( 'readonly', false );
        modalSite.val         ( '' );

        //Set the modal constant data depending on what we are doing.
        modalUpdate.val( 'off' );  //Sets Delete Check, will we delete this quote? A Hidden Checkbox.
        modalTitle = "Add a quote";
        $('#QuoteModal #submitFormButton').prop( 'hidden', false); // Submit form visibility
        submitButtonText = "Submit";
    } else{
        // If it does have cells though, we know it's a row.
        var author    = element.parentNode.cells[0].getAttribute( 'value' );
        var content   = element.parentNode.cells[1].getAttribute( 'value' );
        var site      = element.parentNode.cells[2].getAttribute( 'value' );
        
        // So we set all our inputs to the values we grabbed from the row's cells.
        modalAuthor.val       ( author );
        modalContent.val      ( content );
        modalSite.val         ( site );

         
        // Updating
        if(element.getAttribute( 'id' ) == 'updateData' ) 
        {
            // Set bools needed for handler? Delete is needed
            modalUpdate.val( 'on' );    //Sets Update Check, will we update this reminder? A Hidden Checkbox.

            // Set Readonly Values
            modalAuthor.prop   ( 'readonly', false );
            modalContent.prop  ( 'readonly', false );
            modalSite.prop     ( 'readonly', false );

            // Set the modal constant data depending on what we are doing.
            modalTitle = "Modify an Existing Quote.";
            $('#QuoteModal #submitFormButton').prop( 'hidden', false); // Submit form visibility
            submitButtonText = "Save Changes";
        } else
        // Reading
        {
            modalUpdate.val( 'off' );   //Sets Update Check, will we update this reminder? A Hidden Checkbox.

            // Set Readonly Values
            modalAuthor.prop   ( 'readonly', true );
            modalContent.prop  ( 'readonly', true );
            modalSite.prop     ( 'readonly', true );

            // Set the modal constant data depending on what we are doing.
            modalTitle = "Review Quote";
            $('#QuoteModal #submitFormButton').prop( 'hidden', true); // Submit form visibility
            submitButtonText = "";
        }
    }

    // Set the header of the Modal to display something fun.
    $('#QuoteModal #modalTitle').html(modalTitle);
    $('#QuoteModal #submitFormButton').html(submitButtonText);
}

// Has good stuff for neatness.
function openBookmark( element )
{
    // Open or Close Modal.
    $('#bookmarkModal').modal( 'toggle' );

    //Get the form we want to manipulate. 
    var form = $( '#bookmarkModal #bookmarkForm' );

    // Switch values for delete/update
    var modalUpdate   = $('#bookmarkModal #boolUpdateSwitch');

    //Get each field, by ID, in the Modal we are displaying.
    var modalID         = $('#bookmarkModal #intBookmarkID');
    var modalDescription= $('#bookmarkModal #vcBookmarkDescription');
    var modalLink       = $('#bookmarkModal #vcBookmarkAddress');

    // We try to get the ID of the element by the value passed in through the parent ROW element.
    if( element.parentNode.getAttribute( 'value' ) != null )
    {
        id = element.parentNode.getAttribute( 'value' );
    }else { //We try to get the ID of the element by the value passed in through the target element.
        console.log("Parent Element doesn't have a value attribute.");
        
        if( element.getAttribute( 'value' ) )
        {
            console.log("Attribute Value found in element.");
            id  = element.getAttribute( 'value' );
        }
    }

    modalID.val( id );
    console.log( id );

    
    // Creating
    //If the thing we clicked passed as 'Element' doesn't have any cells, it isn't a row in our table, so is likely the add button.
    if( id == 0 ) {
        modalDescription.prop   ( 'readonly', false );
        modalDescription.val    ( '' );

        modalLink.prop          ( 'readonly', false );
        modalLink.val           ( '' );


        //Set the modal constant data depending on what we are doing.
        modalUpdate.val( 'off' );  //Sets Delete Check, will we delete this quote? A Hidden Checkbox.
        modalTitle = "Add a bookmark";
        $('#bookmarkModal #submitFormButton').prop( 'hidden', false); // Submit form visibility
        submitButtonText = "Submit";
    } else{
        // If it does have cells though, we know it's a row.
        var description = element.parentNode.cells[0].getAttribute( 'value' );
        var address     = element.parentNode.cells[1].getAttribute( 'value' );

        // So we set all our inputs to the values we grabbed from the row's cells.
        modalDescription.val( description );
        modalLink.val       ( address );
         
        // Updating
        if(element.getAttribute( 'id' ) == 'updateData' ) 
        {
            // Set bools needed for handler? Delete is needed
            modalUpdate.val( 'on' );    //Sets Update Check, will we update this reminder? A Hidden Checkbox.

            // Set Readonly Values
            modalDescription.prop ( 'readonly', false );
            modalLink.prop        ( 'readonly', false );

            // Set the modal constant data depending on what we are doing.
            modalTitle = "Modify an existing bookmark.";
            $('#bookmarkModal #submitFormButton').prop( 'hidden', false); // Submit form visibility
            submitButtonText = "Save Changes";
        } else
        // Reading
        {
            modalUpdate.val( 'off' );   //Sets Update Check, will we update this reminder? A Hidden Checkbox.

            // Set Readonly Values
            modalDescription.prop( 'readonly', true );
            modalLink.prop       ( 'readonly', true );

            // Set the modal constant data depending on what we are doing.
            modalTitle = "Review Bookmark";
            $('#bookmarkModal #submitFormButton').prop( 'hidden', true); // Submit form visibility
            submitButtonText = "";
        }
    }

    // Set the header of the Modal to display something fun.
    $('#bookmarkModal #modalTitle').html(modalTitle);
    $('#bookmarkModal #submitFormButton').html(submitButtonText);
}

//Created 10/12/22
function openNote( element )
{
    console.log( element );
    // Open or Close Modal.
    $('#NoteModal').modal( 'toggle' );

    //Get the form we want to manipulate. 
    var form = $( '#NoteModal #noteForm' );

    // Switch values for delete/update
    var modalDelete= $('#NoteModal #boolDeleteSwitch');
    var modalUpdate= $('#NoteModal #boolUpdateSwitch');

    //Get each field, by ID, in the Modal we are displaying.
    var modalNoteID      = $('#NoteModal #intNoteID');
    var modalNoteTitle   = $('#NoteModal #vcNoteTitle');
    var modalNoteValue   = $('#NoteModal #vcNoteValue');
    var modalNoteRefSite = $('#NoteModal #vcNoteReferenceSite');

    // We try to get the ID of the element by the value passed in through the parent ROW element.
    if( element.parentNode.getAttribute( 'value' ) != null )
    {
        id = element.parentNode.getAttribute( 'value' );
    }else { //We try to get the ID of the element by the value passed in through the target element.
        console.log("Parent Element doesn't have a value attribute.");
        
        if( element.getAttribute( 'value' ) )
        {
            console.log("Attribute Value found in element.");
            id  = element.getAttribute( 'value' );
        }
    }

    modalNoteID.val( id );
    console.log(id);

    
    // Creating
    //If the thing we clicked passed as 'Element' doesn't have any cells, it isn't a row in our table, so is likely the add button.
    if( id == 0 ) {
        modalNoteTitle.prop   ( 'readonly', false );
        modalNoteTitle.val    ( '' );

        modalNoteValue.prop   ( 'readonly', false );
        modalNoteValue.val    ( '' );

        modalNoteRefSite.prop ( 'readonly', false );
        modalNoteRefSite.val  ( '' );

        //Set the modal constant data depending on what we are doing.
        modalUpdate.val( 'off' );  //Sets Delete Check, will we delete this quote? A Hidden Checkbox.
        modalDelete.val( 'off' );   //Sets Delete Check, will we delete this reminder? A Hidden Checkbox.

        modalTitle = "Create new note";
        $('#NoteModal #submitFormButton').prop( 'hidden', false); // Submit form visibility
        submitButtonText = "Submit";
    } else{
        // If it does have cells though, we know it's a row.
        var modalNoteTitleValue   = element.parentNode.cells[0].getAttribute( 'value' );
        var modalNoteValueText    = element.parentNode.cells[1].getAttribute( 'value' );
        var modalNoteRefSiteValue = element.parentNode.cells[2].getAttribute( 'value' );

        // So we set all our inputs to the values we grabbed from the row's cells.
        modalNoteTitle.val  ( modalNoteTitleValue );
        modalNoteValue.val  ( modalNoteValueText );
        modalNoteRefSite.val( modalNoteRefSiteValue );

         
        // Updating
        if( element.getAttribute( 'id' ) == 'updateData' ) 
        {
            // Set bools needed for handler? Delete is needed
            modalUpdate.val( 'on' );    //Sets Update Check, will we update this reminder? A Hidden Checkbox.
            modalDelete.val( 'off' );   //Sets Delete Check, will we delete this reminder? A Hidden Checkbox.

            // Set Readonly Values
            modalNoteTitle.prop  ( 'readonly', false );
            modalNoteValue.prop  ( 'readonly', false );
            modalNoteRefSite.prop( 'readonly', false );

            // Set the modal constant data depending on what we are doing.
            modalTitle = "Modify note";
            $('#NoteModal #submitFormButton').prop( 'hidden', false); // Submit form visibility
            submitButtonText = "Save Changes";
        } else if( element.getAttribute( 'id' ) == 'deleteData' )
        // Deleting
        {
            // Set bools needed for handler? Delete is needed
            modalDelete.val( 'on' );    //Sets Delete Check, will we delete this reminder? A Hidden Checkbox.
            modalUpdate.val( 'off' );   //Sets Update Check, will we update this reminder? A Hidden Checkbox.

            // Set Readonly Values
            modalNoteTitle.prop  ( 'readonly', true );
            modalNoteValue.prop  ( 'readonly', true );
            modalNoteRefSite.prop( 'readonly', true );

            // Set the modal constant data depending on what we are doing.
            modalTitle = "Delete note";
            $('#NoteModal #submitFormButton').prop( 'hidden', false); // Submit form visibility
            submitButtonText = "Delete";
        }else
        // Reading
        {
            modalUpdate.val( 'off' );   //Sets Update Check, will we update this reminder? A Hidden Checkbox.
            modalDelete.val( 'off' );   //Sets Delete Check, will we delete this reminder? A Hidden Checkbox.

            // Set Readonly Values
            modalNoteTitle.prop  ( 'readonly', true );
            modalNoteValue.prop  ( 'readonly', true );
            modalNoteRefSite.prop( 'readonly', true );

            // Set the modal constant data depending on what we are doing.
            modalTitle = "Review Note";
            $('#NoteModal #submitFormButton').prop( 'hidden', true); // Submit form visibility
            submitButtonText = "";
        }
    }

    // Set the header of the Modal to display something fun.
    $('#NoteModal #modalTitle').html(modalTitle);
    $('#NoteModal #submitFormButton').html(submitButtonText);
}

//Created 10/13/22
function openPersonalQuote( element )
{
    console.log( element );
    // Open or Close Modal.
    $('#personalQuoteModal').modal( 'toggle' );

    //Get each field, by ID, in the Modal we are displaying.
    var modalAuthor    = $('#personalQuoteModal #vcQuoteAuthor');
    var modalContent   = $('#personalQuoteModal #vcQuoteText');

    // We get the ID from the element (ROW).        
    if( element.getAttribute( 'value' ) )
    {
        id  = element.getAttribute( 'value' );
    }else {
        console.log("No Value found.");
    }

    // modalQuoteID.val( id );

    //Get All values from clicked row ( element )
    var quoteAuthor  = element.cells[0].getAttribute( 'value' );
    var quoteContent = element.cells[1].getAttribute( 'value' );

    // So we set all our inputs to the values we grabbed from the row's cells.
    modalContent.text( quoteContent );

    modalTitle = quoteAuthor;

    $('#personalQuoteModal #modalTitle').html(modalTitle);
}

function changeText( newText, elementName, show )
{
    $('#' + elementName).text($('#' + elementName).text().replace( $('#' + elementName).text(), newText ));
    $('#' + elementName).prop( 'hidden', !show );
}
