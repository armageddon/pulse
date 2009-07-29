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
          $('#photo_uploaded_data').css({
            left: e.pageX -10 ,
            top: e.pageY -5,
            opacity: 0,
            cursor: 'pointer',
          })

    } else {
      over = false;
      $('#upload_container').hide();
    }
  });

  // Add new image to gallery
  $("#photo_uploaded_data").change(function(e) {
    $("#photo_upload").ajaxSubmit({
      iframe: true,
      extraData: { 'iframe': 'true' },
      dataType: "html",
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

  $('#pa_name').focus(function() {
    if ( !$.data(this, 'initialized') ) {
      $(this).val('');
      $("#pa_name").autocompleteArray(
        [],
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
              $("#pa_id").val(extra[0])
              $("#pa_type").val(extra[1])
            } else {
              $("#pa_id").val('')
              $("#pa_type").val('')
            }
          },
        }
      );
      $.data(this, 'initialized', true);
      $(this).blur();
      $(this).focus();
    }
  });

  $("#pa_select").submit(function() {
    $('.invalid').removeClass('invalid');
    var error = false;
    if ($('#pa_id').val() == '') {
      $('#pa_name').addClass('invalid');
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

    if ($("#pa_type").val() == 'activity') {
      var opts = {
        'url' : '/account/activities',
        'activity[id]': $("#pa_id").val(),
        'activity[description]': $('#pa_description').val(),
      }
    }

    if ($("#pa_type").val() == 'place') {
      var opts = {
        'url' : '/account/activities',
        'activity[id]': $("#pa_id").val(),
        'activity[description]': $('#pa_description').val(),
      }
    }
    $.ajax({
      url: opts['url'],
      type: "POST",
      data: opts,
      success: function() {
        $('#step_3_container').hide();
        $('#step_3_finished').fadeIn();
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

  $('#user_email, #user_first_name, #user_username').focus(function() {
    $(this).val('');
    return false;
  });

  $('#user_email').blur(function() {
    if ($(this).val() == '')
      $(this).val('Email address');
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

    if (location.val() == '' || location.val() != '2') {
      error = true;
      location.parent().addClass('invalid');
      $('#location_error span.error').text('The service is currently in beta and only serving London.');
    }

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
          $('#new_user').fadeOut();
          $('#step_1_finished').fadeIn();
          $('#step_2').fadeIn();
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
          $('#step_2_container').fadeOut();
          $('#step_2_finished').fadeIn();
          $('#step_3').fadeIn();
      },
      });
      return false;
    }
  });
});