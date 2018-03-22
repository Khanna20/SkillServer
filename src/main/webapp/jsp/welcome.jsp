<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<title>Welcome ${firstname}</title>
<!-- JavaScript specific to this application that is not related to API
     calls -->
<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script  src="https://apis.google.com/js/platform.js"  async defer></script>
<meta name="google-signin-client_id"
	content="440843964870-ri5i1dbm8ukje4e93b56ivqbl2kgk6h1.apps.googleusercontent.com"></meta>
</head>
<body>

	<h1>Account Linking</h1>
	<div id="gConnect">
		<div id="signin-button"></div>
	</div>
	<div id="authOps" style="display: none">
		<h2>User is now signed in to the app using Google+</h2>
		<button id="signOut" onclick="auth2.signOut()">Sign Out</button>


		<!--     <p>If the user chooses to disconnect, the app must delete all stored
    information retrieved from Google for the given user.</p>
    <button id="disconnect" >Disconnect your Google account from this app</button>

    <h2>User's profile information</h2>
    <div id="profile"></div>

    <h2>User's friends that are visible to this app</h2>
    <div id="visiblePeople"></div>

    <h2>Authentication Logs</h2>
    <pre id="authResult"></pre>
 -->

	</div>
	<div id="loaderror">
		This section will be hidden by jQuery. If you can see this message,
		you may be viewing the file rather than running a web server.<br />
		The sample must be run from http or https. See instructions at <a
			href="https://developers.google.com/+/quickstart/javascript">
			https://developers.google.com/+/quickstart/javascript</a>.
	</div>
	<script type="text/javascript">
var auth2 = {};
var helper = (function() {
  return {
    /**
     * Hides the sign in button and starts the post-authorization operations.
     *
     * @param {Object} authResult An Object which contains the access token and
     *   other authentication information.
     */
    onSignInCallback: function(authResult) {
      $('#authResult').html('Auth Result:<br/>');
      for (var field in authResult) {
	  if(field == "j8") {
		$('#authResult').append(' ' + field + ': ' +
            authResult[field] + '<br/>');
		$('#authResult').append(gapi.auth2.getAuthInstance().currentUser.get().getAuthResponse().access_token);
		
	  }
        
      }
      if (authResult.isSignedIn.get()) {
        $('#authOps').show('slow');
        $('#gConnect').hide();
        helper.profile();
        helper.people();        
      } else {
          if (authResult['error'] || authResult.currentUser.get().getAuthResponse() == null) {
            // There was an error, which means the user is not signed in.
            // As an example, you can handle by writing to the console:
            console.log('There was an error: ' + authResult['error']);
          }
          $('#authResult').append('Logged out');
          $('#authOps').hide('slow');
          $('#gConnect').show();
      }

      console.log('authResult', authResult);
    },

	
	
    /**
     * Calls the OAuth2 endpoint to disconnect the app for the user.
     */
    disconnect: function() {
      // Revoke the access token.
      auth2.disconnect();
    },

    /**
     * Gets and renders the list of people visible to this app.
     */
    people: function() {
      gapi.client.plus.people.list({
        'userId': 'me',
        'collection': 'visible'
      }).then(function(res) {
        var people = res.result;
        $('#visiblePeople').empty();
        $('#visiblePeople').append('Number of people visible to this app: ' +
            people.totalItems + '<br/>');
        for (var personIndex in people.items) {
          person = people.items[personIndex];
          $('#visiblePeople').append('<img src="' + person.image.url + '">');
        }
      });
    },

    /**
     * Gets and renders the currently signed in user's profile data.
     */
    profile: function(){
      gapi.client.plus.people.get({
        'userId': 'me'
      }).then(function(res) {
        var profile = res.result;
		var emailId;
        $('#profile').empty();
        $('#profile').append(
            $('<p><img src=\"' + profile.image.url + '\"></p>'));
        $('#profile').append(
            $('<p>Hello ' + profile.displayName + '!<br />Tagline: ' +
            profile.tagline + '<br />About: ' + profile.aboutMe + '</p>'));
        if (profile.emails) {
		  console.log('profile',profile.emails);
          $('#profile').append('<br/>Emails: ');
          for (var i=0; i < profile.emails.length; i++){
			emailId = profile.emails[i].value;
            $('#profile').append(profile.emails[i].value).append(' ');
          }
		  
          $('#profile').append('<br/>');
        }
		
		console.log('profile1 email',emailId);
		var obj = JSON.stringify({
        accessToken: gapi.auth2.getAuthInstance().currentUser.get().getAuthResponse().access_token ,
            username : "${username}", emailID: emailId
           })
                
        $.ajax({
            type: 'POST',
			headers: { 
        		'Accept': 'application/json',
        		'Content-Type': 'application/json' 
    		},
            url: 'http://localhost:8080/SkillServer/Skill/UpdateAccessToken',
            data: obj,
            dataType: 'json',
            success: function(data) {
                successmessage = 'Success';
                console.log('successmessage', successmessage);
            },
            error: function(data) {
            	errormessage = 'Error';
                console.log('errormessage', errormessage);
            }
        });

		
        if (profile.cover && profile.coverPhoto) {
          $('#profile').append(
              $('<p><img src=\"' + profile.cover.coverPhoto.url + '\"></p>'));
        }
      }, function(err) {
        var error = err.result;
		console.log('error',error)
        $('#profile').empty();
        $('#profile').append(error.message);
      });
    }
  };
})();

/**
 * jQuery initialization
 */
$(document).ready(function() {
  $('#disconnect').click(helper.disconnect);
  $('#loaderror').hide();
  if ($('meta')[0].content == 'YOUR_CLIENT_ID') {
    alert('This sample requires your OAuth credentials (client ID) ' +
        'from the Google APIs console:\n' +
        '    https://code.google.com/apis/console/#:access\n\n' +
        'Find and replace YOUR_CLIENT_ID with your client ID.'
    );
  }
});

/**
 * Handler for when the sign-in state changes.
 *
 * @param {boolean} isSignedIn The new signed in state.
 */
var updateSignIn = function() {
  console.log('update sign in state');
  if (auth2.isSignedIn.get()) {
    console.log('signed in');
    helper.onSignInCallback(gapi.auth2.getAuthInstance());
  }else{
    console.log('signed out');
    helper.onSignInCallback(gapi.auth2.getAuthInstance());
  }
}

/**
 * This method sets up the sign-in listener after the client library loads.
 */
function startApp() {
  gapi.load('auth2', function() {
    gapi.client.load('plus','v1').then(function() {
      gapi.signin2.render('signin-button', {
          scope: 'https://www.googleapis.com/auth/plus.login',
          fetch_basic_profile: true });
      gapi.auth2.init({fetch_basic_profile: true,
          scope:'https://www.googleapis.com/auth/plus.login'}).then(
            function (){
              console.log('init');
              auth2 = gapi.auth2.getAuthInstance();
              auth2.isSignedIn.listen(updateSignIn);
              auth2.then(updateSignIn);
            });
    });
  });
}
</script>
	<script
		src="https://apis.google.com/js/client:platform.js?onload=startApp"></script>
</body>
</html>