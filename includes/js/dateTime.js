// Set Constant info
const dateOptions = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
const timeOptions = { hour: 'numeric', minute: 'numeric', seconds: 'none' };

// Elements we will manipulate
var greetingElement = $('#greetingText');
var dayOfWeekElement= $('#dayOfWeekText');
var monthDayElement = $('#monthDayText');
var timeElement     = $('#timeText');

// Set default DateTime data.
var date = new Date();
var usDate = date.toLocaleDateString( 'en-US', dateOptions );
var usTime = date.toLocaleTimeString( 'en-US', timeOptions );

// Set Defualt Page Element Data
var greeting = "";
var timeOfDay= usTime.slice(-2);
var dayOfWeek= usDate.split(',')[0].trim();
var monthDay = usDate.split(',')[1].trim();
var hour     = date.getHours();

console.log( dayOfWeek );
console.log( monthDay );

// Set Greeting constructor
var getTimeOfDay = function()
{
    if     ( timeOfDay == 'PM' && hour < 19){ return 'Good afternoon,'; }
    else if( timeOfDay == 'PM' && hour >= 19){ return 'Good evening'; }
    else if( timeOfDay == 'AM'){ return 'Good morning,'; }
    else{    console.log( timeOfDay + " returned an unexpected result." ); }
}

//Set Text defaults
    SetText();

//Anything we need to happen once the page is loaded.
$(document).ready( function() {
    loadReminders( greetingElement.parent().attr( 'id' ) );
} );

// Update values
setInterval(() => { // This will update the Date, usTime, and textElement values every 1000ms(1 second)
    SetText();
}, 1000);

function loadReminders ( userID ) 
{
    
}

function SetText()
{
    //Set Text defaults
    date = new Date();
    usDate = date.toLocaleDateString( 'en-US', dateOptions );
    usTime = date.toLocaleTimeString( 'en-US', timeOptions );

    greetingElement.text( getTimeOfDay() );
    dayOfWeekElement.text( "Happy " + dayOfWeek + "!" );
    monthDayElement.text ( " It is " + monthDay );
    timeElement.text     ( " at " + usTime );
}
