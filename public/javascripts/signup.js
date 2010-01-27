$(document).ready(function() {
	
    //SIGN UP
    // File input hiding voodoo
    var over = false;
    var box  = false;
    var loading = false;
    $(".word_count").charCounter(140, {
        container: "<div></div>"
    });


    function formatResult(row) {
        return row.replace("<span style='font-size:9px'>","").replace("</span>","");
    }

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
            if(navigator.appName=="Microsoft Internet Explorer")
            {
                $('#user_icon').css({
                    postion: 'absolute',
                    top: e.pageY  - 10  ,
                    left: e.pageX  - 250  ,
                    cursor: 'pointer',
                    opacity: 0
                })
            }
            else
            {
                $('#user_icon').css({
                    postion: 'absolute',
                    top: e.pageY  - 10  ,
                    left: e.pageX  - 10  ,
                    cursor: 'pointer',
                    opacity: 0
                })
            }

        } else {
            over = false;
        //$('#upload_container').hide();
        }
    });
    
    $("#user_icon").change(function(e) {
        $('#add_photo').css('background','#F1F3F6 url(/images/loadercircles.gif) no-repeat scroll center center');
        $('#add_photo').html('Please wait - your photo may take up to a minute to load......');
        $("#photo_upload").ajaxSubmit({
            iframe: true,
            extraData: {
                'iframe': 'true'
            },
            dataType: "js",
            success: function(response) {
                if (response.length > 0) {
                    var img = $('<img src="' + response + '" />')
                    $("#add_photo").html(img[0]);
                    $("#add_photo").css({
                        textAlign: 'center'
                    })
					
						//$('#dialog').jqm({ajax:'/crop',modal:true}); 
						//$('#dialog').jqmShow(); 
                }
            }
        })
    });

    $('#place_name').focus(function() {
        if ( !$.data(this, 'initialized') ) {
            $(this).val('');
            $("#place_name").autocomplete(
                "/places/autocomplete",
                {
                    minChars: 2,
                    cacheLength: 1,
                    delay: 10,
                    autoFill:false,
                    maxItemsToShow: 20,
                    formatResult: formatResult,
                    mustMatch: false,
                    scroll: true,
                    scrollHeight: 20,
          
                    onItemSelect: function(e) {
                        var extra = $(e).attr('extra');
                        if (extra.length > 0) {
                            $("#place_id").val(extra[0])
                        } else {
                            $("#place_id").val("1")
                        }
                    }
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
        if($('#user_place_activity[description]').val() == "tell us why you socialise here and whether it's good for meeting people" )
        {
            $('#user_place_activity[description]').val("");
        }
        // if($('#user_place_activity[description]').val() == "tell us why you socialise here and whether it's good for meeting people" ||
        //     $('#user_place_activity[description]').val() == ''
        //    ) {
        //    $('#user_place_activity[description]').addClass('invalid');
        //   error = true
        //}
        if($('#place_id').val() == 0 && $('#activity_id').val() == 0)
        {
            $('#activity_error').addClass('show');
            $('#activity_error').addClass('invalid');
            $('#activity_error').val("You need to select a place or an activity");
            error = true
        }


        if (error) {
            return false;
        }
        $.ajax({
            type: "POST",
            url: '/user_place_activities/add',
            data: $(this).serialize(),
            success: function(p) {
                if (p != 'You have already added this place or activity')
                {
                    if($('#user_place_activities').html().indexOf("Please add some activities") >= 0)
                    {
                        $('#user_place_activities').html('');
                    }
                    $('#user_place_activities').append(p);
                    //reset activity
                    $('#parent_value').val(0);
                    $('#activity_category_target').text("Any category");
                    $('#activity_id').val(159);
                    $('#activity_target').text("Any activity");
                    $('#user_place_activity_description').val("");
                    $('#place_id').val("1");
                    $('#place_name').val("");
                    $('#day_of_week_target').html("Any day");
                    $('#time_of_day_target').html("Any time");
                    $('#user_place_activity_time_of_day').val(0);
                    $('#user_place_activity_time_of_day').val(0);

                }
                else
                {
                    $('#activity_error').addClass('show');
                    $('#activity_error').addClass('invalid');
                    $('#activity_error').val(p);
                }

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

    $('#user_place_activity_description').focus(function() {
        if ($(this).text() == "tell us why you socialise here and whether it's good for meeting people") {
            $(this).text('');
        }
    });

    $('#user_description').focus(function() {
        if ($(this).val() == 'Give us a line that sums you up') {
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
		var day = $('#day');
		var month = $('#month');
		var year = $('#year');
        var error = false;

        $('.invalid').removeClass('invalid');
        $('span.error').text('');

		if (day.val() == 0 || day.val() == '' )
		{
			error = true;
			$('#dob_error').text('Enter a valid date of birth');
			day.addClass('invalid');
		}
		if (month.val() == 0 || day.val() == '' )
		{
			error = true;
			$('#dob_error').text('Enter a valid date of birth');
			month.addClass('invalid');
		}
		if (year.val() == 0 || day.val() == '' )
		{
			error = true;
			$('#dob_error').text('Enter a valid date of birth');
			year.addClass('invalid');
		}
		
        if (email.val() == '' || email.val() == 'Email address') {
            email.addClass('invalid');

            email.next().text('Please enter a valid email address.');
            error = true;
        };

        if (username.val() == '' || username.val() == 'Username') {
            username.addClass('invalid');
            username.next().text('Please enter a valid user name')
            error = true;
        }

        if (first_name.val() == '' || first_name.val() == 'First name') {
            first_name.addClass('invalid');
            first_name.next().text('Please enter your first name');
            error = true;
        }

        if ((password.val() == '' || password.val() == 'Password' )) {
            $('#password_holder').addClass('invalid');
            password.addClass('invalid');
            password.next().text('Please enter a valid password');
            error = true;
        } else if ((password_confirm.val() == '') || (password_confirm.val() == 'Password confirmation')) {
            $('#password_confirmation_holder').addClass('invalid');
            password_confirm.addClass('invalid');
            password_confirm.next().text('Please enter a password confirmation');
            error = true;
        } else if ((password.val() != password_confirm.val())) {
            $('#password_holder, #password_confirmation_holder').addClass('invalid');
            password.addClass('invalid');
            password_confirm.addClass('invalid');
            password.next().text('Your password and password confirmation do not match.');
            error = true;
        } else if (password.val().length < 7) {
            password.addClass('invalid');
            password_confirm.addClass('invalid');
            password.next().text('Your passwordmust be 7 characters or more');
            error = true;
        }
        else if (password_confirm.val().length < 7) {
            password.addClass('invalid');
            password_confirm.addClass('invalid');
            password.next().text('Your passwordmust be 7 characters or more');
            error = true;
        }

        var postcode = $('#user_postcode');
        regexString = /^([A-PR-UWYZ0-9][A-HK-Y0-9][AEHMNPRTVXY0-9]?[ABEHMNPRVWXY0-9]? {1,2}[0-9][ABD-HJLN-UW-Z]{2}|GIR 0AA)$/
        if (postcode.val() == '' || postcode.val() == 'Post code' || regexString.test(postcode.val().toUpperCase()) != true) {

            postcode.addClass('invalid');
            postcode.next().text('Please enter a valid post code.');
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
                    toggleSteps(2);
                    if(navigator.appName=="Microsoft Internet Explorer")
                    {
                        $('#step_1_text').css('display','none');
                        $('#step_2_text').css('display','block');
                        $('#step_1').css('display','none');
                        $('#step_2').css('display','block');
			
                    }
                    else
                    {
                        $('#step_1').fadeOut();
                        $('#step_2').fadeIn();
                        $('#step_1_text').fadeOut();
                        $('#step_2_text').fadeIn();
                    }
                },
                error: function(xhr) {
                    var errors = $.httpData(xhr, 'json');
                    $.each(errors, function(i,error) {
                        var field = error[0]
                        var message = error[1];
                        var username_error = false;
                        switch (field) {
                            case 'email':
                                $('#user_email').addClass('invalid');
                                $('#user_email').next().text("Email address " + message);
                                break;

                            case 'first_name':
                                $('#user_first_name').addClass('invalid');
                                $('#user_first_name').next().text("First name " + message);
                                break;

                            case 'password':
                            case 'password_confirmation':
                                $('#user_password, #user_password_confirmation').addClass('invalid');
                                $('#user_password').next().text("Password " + message);
                                break;

                            case 'username':
                                if (!username_error) {
                                    $('#user_username').addClass('invalid');
                                    $('#user_username').next().text("Username " + message);
                                    username_error = true;
                                }
                                break;
							default:
								$('#simple_captcha').addClass('invalid');
								$('#simple_captcha').next().text("You entered the code incorrectly. Please try again");
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
                    toggleSteps(3);
                    if(navigator.appName=="Microsoft Internet Explorer")
                    {
				
                        $('#step_2_text').css('display','none');
                        $('#step_3_text').css('display','block');
                        $('#step_2').css('display','none');
                        $('#step_3').css('display','block');
				
                    }
                    else
                    {
                        $('#step_2').fadeOut();
                        $('#step_3').fadeIn();
                        $('#step_2_text').fadeOut();
                        $('#step_3_text').fadeIn();
                    }
                }
            });
            return false;
        }

    });


});


function toggleSteps(step) {
    switch(step) {
        case 2:
            $('#signup_header_step1').css('font-size','14px');
            $('#signup_header_step1').css('font-weight','normal');
            $('#signup_header_step2').css('font-size','16px');
            $('#signup_header_step2').css('font-weight','bold');
            $('#signup_header_step3').css('font-size','14px');
            $('#signup_header_step3').css('font-weight','normal');
            break;
        case 3:
            $('#signup_header_step1').css('font-size','14px');
            $('#signup_header_step1').css('font-weight','normal');
            $('#signup_header_step2').css('font-size','14px');
            $('#signup_header_step2').css('font-weight','normal');
            $('#signup_header_step3').css('font-size','16px');
            $('#signup_header_step3').css('font-weight','bold');

            break; 
    }
} 