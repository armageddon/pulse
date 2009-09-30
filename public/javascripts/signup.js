$(document).ready(function() {
  // File input hiding voodoo
  var over = false;
  var box  = false;

  $('#add_photo').mouseover(function(e) {
    over = true;
  });

  $(document).mousemove(function(e) {
    var box = $('#add_photo').offset();
    if ((e.pageX > box.left) &&
        (e.pageX < (box.left + $('#add_photo').width())) &&
        (e.pageY > box.top) &&
        (e.pageY < (box.top + $('#add_photo').height()))
        ) {
          $('#upload_container').show();
          $('#user_icon').css({
            left: e.pageX -770 ,
            top: e.pageY -220,
            cursor: 'pointer',
			opacity: 0,
			
          })

    } else {
      over = false;
      $('#upload_container').hide();
    }
  });

  // Add new image to gallery
  $("#user_icon").change(function(e) {
    $("#photo_upload").ajaxSubmit({
      iframe: true,
      extraData: { 'iframe': 'true' },
      dataType: "js",
      success: function(response) {
        if (response.length > 0) {
          var img = $('<img src="' + response + '" />')
          $("#add_photo").html(img[0]);
          $("#add_photo").css({
            textAlign: 'center'
          })
        }
      },
    })
  });
  
  $('.word_count').charCounter(140, {
    container: "<div></div>"
  })

  $('#place_name').focus(function() {
    if ( !$.data(this, 'initialized') ) {
      $(this).val('');
      $("#place_name").autocomplete(
        "/places/autocomplete",
        {
          delay:10,
          minChars:1,
          matchSubset:1,
          autoFill:true,
          maxItemsToShow:10,
          mustMatch: true,
          onItemSelect: function(e) {
            var extra = $(e).attr('extra');
            if (extra.length > 0) {
              $("#place_id").val(extra[0])
            } else {
              $("#place_id").val('')
            }
          },
        }
      );
      $.data(this, 'initialized', true);
      $(this).blur();
      $(this).focus();
    }
  });

	$("#finished").click(function() {
		window.location="/account";
		return false;
	});

  $("#pa_select").submit(function() {
    $('.invalid').removeClass('invalid');
    var error = false;
    $('#activity_error').removeClass("show");
    $('#activity_error').removeClass("hidden_value");
    if ($('#place_id').val() == '') {
      $('#place_name').addClass('invalid');
      error = true;
    }
    if($('#pa_description').val() == 'Tell us everything important about it in less than a text message' ||
      $('#pa_description').val() == ''
    ) {
      $('#pa_description').addClass('invalid');
      error = true
    }
    if (error) {
      return false;
    }
	$.ajax({
        type: "POST",
        url: '/account/activities',
        data: $(this).serialize(),
        success: function(p) {
 			if($('#user_activities').html().indexOf("Please add some activities") >= 0)
			{
				$('#user_activities').html('');
			}
			$('#user_activities').append(p);
        },
		error: function(p)
		{
			$('#activity_error').addClass('show');
				$('#activity_error').addClass('invalid');
			$('#activity_error').val(p.responseText);			
		}
      })
      return false;
  })

  $('#pa_name').focus(function() {
    if ($(this).val() == 'Add a place or activity') {
      $(this).val('');
    }
  }).blur(function(){
    if ($(this).val() == '') {
      $(this).val('Add a place or activity');
    }
  })

  $('#pa_description').focus(function() {
    if ($(this).text() == 'Tell us everything important about it in less than a text message') {
      $(this).text('');
    }
  });

  $('#user_description').focus(function() {
    if ($(this).val() == 'Tell us about yourself') {
      $(this).val('');
    }
  });


  $('#password_holder, #password_confirmation_holder').focus(function() {
    $(this).hide();
    $(this).next('input').show();
    $(this).next('input').focus();
    return false;
  });

  $('#user_email,#user_postcode, #user_first_name, #user_username').focus(function() {
    $(this).val('');
    return false;
  });

  $('#user_email').blur(function() {
    if ($(this).val() == '')
      $(this).val('Email address');
  })

  $('#postcode').blur(function() {
    if ($(this).val() == '')
      $(this).val('Post code');
  })

  $('#user_first_name').blur(function() {
    if ($(this).val() == '')
      $(this).val('First name');
  });

  $('#user_username').blur(function() {
    if ($(this).val() == '')
      $(this).val('Username');
  })

  $('#user_password').blur(function() {
    if ($(this).val() == '') {
      $(this).hide();
      $('#password_holder').show();
    }
  })

  $('#user_password_confirmation').blur(function() {
    if ($(this).val() == '') {
      $(this).hide();
      $('#password_confirmation_holder').show();
    }
  })


  $('#new_user').submit(function() {
    var first_name = $('#user_first_name');
    var username = $('#user_username');
    var password = $('#user_password');
    var password_confirm = $('#user_password_confirmation');
    var email = $('#user_email');
    var location = $('#user_location_id');
    var error = false;

    if (email.val() == '' || email.val() == 'Email address') {
      email.addClass('invalid');
      email.nextAll('span.error').text('Please enter a valid email address.');
      error = true;
    };

    if (username.val() == '' || username.val() == 'Username') {
      username.addClass('invalid');
      username.nextAll('span.error').text('Please enter a valid user name')
      error = true;
    }

    if (first_name.val() == '' || first_name.val() == 'First name') {
      first_name.addClass('invalid');
      first_name.nextAll('span.error').text('Please enter your first name');
      error = true;
    }

    if ((password.val() == '' || password_confirm.val() == '') || password.val() == 'Password' || password_confirm.val() == 'Password confirmation') {
      $('#password_holder, #password_confirmation_holder').addClass('invalid');
      password.addClass('invalid');
      password_confirm.addClass('invalid');
      password.nextAll('span.error').text('Please enter a valid password');
      error = true;
    } else if ((password.val() != password_confirm.val())) {
      $('#password_holder, #password_confirmation_holder').addClass('invalid');
      password.addClass('invalid');
      password_confirm.addClass('invalid');
      password.nextAll('span.error').text('Your password and password confirmation do not match.');
      error = true;
    }
    
    var postcode = $('#user_postcode');
	regexString = /^([A-PR-UWYZ0-9][A-HK-Y0-9][AEHMNPRTVXY0-9]?[ABEHMNPRVWXY0-9]? {1,2}[0-9][ABD-HJLN-UW-Z]{2}|GIR 0AA)$/
	if (postcode.val() == '' || postcode.val() == 'Post code' || regexString.test(postcode.val().toUpperCase()) != true) {
		
		postcode.addClass('invalid');
	    postcode.nextAll('span.error').text('Please enter a valid post code.');
	    error = true;
	};

    if (error) {
      return false;
    } else {
      $('.error').text('');
      $('.invalid').removeClass('invalid');
      $.ajax({
        type: "POST",
        url: $(this).attr('action'),
        data: $(this).serialize(),
        success: function(msg) {
			$('#step_1').fadeOut();
	        $('#step_2').fadeIn();
			$('#step_1_text').fadeOut();
			$('#step_2_text').fadeIn();   
        },
        error: function(xhr) {
          var errors = $.httpData(xhr, 'json');
          $.each(errors, function(i,error) {
            var field = error[0]
            var message = error[1];
            switch (field) {
              case 'email':
                $('#user_email').addClass('invalid');
                $('#user_email').nextAll('span.error').text("Email address " + message);
                break;

              case 'first_name':
                $('#user_first_name').addClass('invalid');
                $('#user_first_name').nextAll('span.error').text("First name " + message);
                break;

              case 'password':
              case 'password_confirmation':
                $('#user_password, #user_password_confirmation').addClass('invalid');
                $('#user_password').nextAll('span.error').text("Password " + message);
                break;

              case 'username':
                $('#user_username').addClass('invalid');
                $('#user_username').nextAll('span.error').text("Username " + message);
                break;
            }
          })
        }
      })
      return false;
    }
  })

  $("#details_update").submit(function() {
    $('.invalid').removeClass('invalid');
    var error = false;
    var user_desc = $('#user_description');
    var user_sex  = $('#user_sex');
    var user_age  = $('#user_age');
    var user_sex_preference = $('#user_sex_preference');
    var user_age_preference = $('#user_age_preference');

    if (user_desc.val() == '' || user_desc.val() == 'Tell us about yourself') {

      user_desc.addClass('invalid');
      user_desc.nextAll('span.error').text('Please fill in your description');
      error = true;
    }

    if (user_sex.val() == '') {
      user_sex.parent().addClass('invalid');
      error = true;
    }

    if (user_age.val() == '') {
      user_age.parent().addClass('invalid');
      error = true;
    }

    if (user_sex_preference.val() == '') {
      user_sex_preference.parent().addClass('invalid');
      error = true;
    }

    if (user_age_preference.val() == '') {
      user_age_preference.parent().addClass('invalid');
      error = true;
    }

    if (error) {
      return false;
    } else {
      $.ajax({
        type: "POST",
        url: $(this).attr('action'),
        data: $(this).serialize(),
        success: function() {
		  	$('#step_2').fadeOut();
	        $('#step_3').fadeIn();
			$('#step_2_text').fadeOut();
			$('#step_3_text').fadeIn();
      },
      });
      return false;
    }
  });
});