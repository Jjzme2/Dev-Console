<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Developer Console</title>
    <!--- Google Fonts --->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,300;0,400;0,700;0,900;1,300;1,400;1,700;1,900&family=Montserrat:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&family=Ubuntu+Mono:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">

    <!--- BootStrap     --->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css">

    <!--- Data Tables --->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.12.1/css/dataTables.bootstrap5.min.css">


    <!---  Personal CSS    --->
    <link rel="stylesheet" href="/includes/css/styles.css">
    <link rel="stylesheet" href="/includes/css/text.css">
    <link rel="stylesheet" href="/includes/css/dataTables.css">
    <link rel="stylesheet" href="/includes/css/pageStyles.css">
    <link rel="stylesheet" href="/includes/css/bootstrapMods.css">
    <link rel="stylesheet" href="/includes/css/animations.css">

    </head>
    <body>
        <cfif prc.showNav>
            <nav class="main-navbar navbar navbar-expand-lg bg-light nav">
                <div class="container-fluid">
                    <cfoutput>
                        <cfif structKeyExists(prc, "xeh")>
                            <a class="navbar-brand brand-text" href=#event.buildLink( prc.xeh.homepage )#> Developer Console </a> 
                        </cfif>
                    </cfoutput>   
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                  
                    <div class="collapse navbar-collapse" id="navbarSupportedContent">                           
                        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                            <li class="nav-item">
                                <!--- Console LI dropdown --->  
                                <li class="nav-item dropdown">
                                    <cfoutput>
                                        <a class="nav-link dropdown-toggle" href=#event.buildLink( prc.xeh.homepage )# id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> 
                                            <i class="bi bi-pc-display-horizontal"></i> My Console 
                                        </a>
                                    </cfoutput>
                                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                                        <!--- Reminders --->
                                         <cfoutput>
                                             <a class="dropdown-item" href=#event.buildLink( prc.xeh.reminder )#> <i class="bi bi-exclamation-circle"></i> Reminders </a>
                                         </cfoutput>
    
                                        <!--- Notes --->
                                        <cfoutput>
                                            <a class="dropdown-item" href=#event.buildLink( prc.xeh.notes )#> <i class="bi bi-journal"></i> Notes </a>
                                        </cfoutput>
                                         <!--- Quotes --->
                                         <cfoutput>
                                             <a class="dropdown-item" href=#event.buildLink( prc.xeh.quotes )#> <i class="bi bi-chat-left-quote"></i> Quotes </a>
                                         </cfoutput>
                                        <!--- Bookmarks --->
                                         <cfoutput>
                                             <a class="dropdown-item" href=#event.buildLink( prc.xeh.Bookmarks )#> <i class="bi bi-bookmark-heart"></i> Bookmarks </a>
                                         </cfoutput>
                
                                        <!--- Messages --->
                                         <cfoutput>
                                             <a class="dropdown-item" href=#event.buildLink( prc.xeh.messages )#> <i class="bi bi-envelope"></i> Messages </a>
                                         </cfoutput>
                                    </div>
                                </li>
                            </li>
    
                            <cfif prc.user.IsAdmin >
                                <li class="nav-item">
                                    <!--- Admin LI dropdown --->  
                                    <li class="nav-item dropdown">
                                        <cfoutput>
                                            <a class="nav-link dropdown-toggle" href=#event.buildLink( prc.xeh.homepage )# id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> 
                                                <i class="bi bi-pc-display-horizontal"></i> Admin Console 
                                            </a>
                                        </cfoutput>
                                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                                            <!--- Quotes --->
                                             <cfoutput>
                                                 <a class="dropdown-item" href=#event.buildLink( prc.xeh.quotesAdmin )#> <i class="bi bi-chat-left-quote"></i> Quotes </a>
                                             </cfoutput>
                                            <!--- Bookmark --->
                                             <cfoutput>
                                                 <a class="dropdown-item" href=#event.buildLink( prc.xeh.bookmarksAdmin )#> <i class="bi bi-bookmark-heart"></i> Bookmarks </a>
                                             </cfoutput>
                                        
                                            <!--- Reinit LI --->
                                             <cfoutput>
                                                 <a class="dropdown-item" href="#event.buildLink( prc.xeh.homepage )#?fwreinit=1"><i class="bi bi-power"></i> Run Reinit</a>
                                             </cfoutput>
                                        </div>
                                    </li>
                                </li>
                            </cfif>  
                            
                            <!---  LogOut LI   --->
                             <li class="nav-item">
                                <cfoutput>
                                    <a class="nav-link" href=#event.buildLink( prc.xeh.logout )#><i class="bi bi-box-arrow-left"></i>Log Out</a>
                                </cfoutput>
                             </li>
                        </ul>
                    </div>
                </div>
            </nav>
        </cfif>
        
        <!--- Render Page --->
        <main role="main" class="flex-container page">
            <!--- <cfdump var=#session# label="Session Variables, toggle on MainLayout RenderPage"> --->
            <cfoutput>
                #getInstance( "messagebox@cbMessageBox" ).renderit()#
                #renderView()#
            </cfoutput>
        </main>


	    <footer class="footer mt-5" >
	    	<div class="container-flex mt-3 d-flex flex-column align-items-center">
	    		<p>
	    			<a href="#"><i class="bi bi-arrow-up-circle-fill"></i> Back to top</a>
	    		</p>
	    		<p> &copy; 2022 - <cfoutput> #dateFormat(now(), 'yyyy')#</cfoutput> </p>
	    	</div>  

	    	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.datatables.net/1.12.1/js/jquery.dataTables.min.js"></script>
            <script src="https://cdn.datatables.net/1.12.1/js/dataTables.bootstrap5.min.js"></script> 

            <script src="/includes/js/dateTime.js"></script>
            <script src="/includes/js/dataTables.js"></script>
            <script src="/includes/js/index.js"></script> 
	    </footer>
    </body>
</html>
