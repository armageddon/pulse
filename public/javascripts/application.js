$(document).ready(function() {
    $.ajaxSetup({ 
        'beforeSend': function(xhr) {
            xhr.setRequestHeader("Accept", "text/javascript")
            } 
    });
  
    if ($.jqm) {
        $("#dialog").jqm({
            ajax: '@data-href', 
            modal: true
        });
        $("#dialog").jqmAddTrigger('.add_to_favorites, .add_place, .add_event, .add_activity, .invite_a_friend');
    }

    $(document).ajaxSend(function(event, request, settings) {
        if (typeof(AUTH_TOKEN) == "undefined") return;
        settings.data = settings.data || "";
        settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
    });

    $(".people_unfavorite").live('click',function() {
        var link = $(this);
        $.ajax({
            type: "DELETE",
            url: "/account/favorites/delete",
            data: {
                "friend_id" : $(this).attr("friend_id")
                },
            success: function(p) {
                link.parent().parent().removeClass('object');
                link.parent().parent().html('');
                link.removeClass("people_unfavorite");
                link.addClass("people_favorite");
                link.html('<img class=" tooltip" width="20" title="Remove from favorites" src="/images/HPThumbUp.png" alt="Hpthumbup"/>');
		
            },
            error: function(p) {
                alert("error");
            },
        })
        return false;
    })

    $(".people_favorite").live('click',function() {
        var link = $(this);
        $.ajax({
            type: "POST",
            url: "/account/favorites",
            data: {
                "friend_id" : $(this).attr("friend_id")
                },
            success: function(p) {
                link.removeClass("people_favorite");
                link.addClass("people_unfavorite");
                link.html('<img class=" tooltip" width="20" title="Add to favorites" src="/images/HPThumbDown.png" alt="Hpthumbup"/>');
            },
            error: function(p) {
                alert("error");
            },
        })
        return false;
    })

    $(".profile_people_unfavorite").live('click',function() {
        var link = $(this);
        $.ajax({
            type: "DELETE",
            url: "/account/favorites/delete",
            data: {
                "friend_id" : $(this).attr("friend_id")
                },
            success: function(p) {
                $("#profile_people_unfavorite").css('display', 'none');
                $("#profile_people_favorite").css('display', 'block');
            },
            error: function(p) {
                alert("error");
            },
        })
        return false;
    })
    
	$(".profile_people_favorite").live('click',function() {
        var link = $(this);
        $.ajax({
            type: "POST",
            url: "/account/favorites",
            data: {
                "friend_id" : $(this).attr("friend_id")
                },
            success: function(p) {
             	$("#profile_people_unfavorite").css('display', 'block');
                $("#profile_people_favorite").css('display', 'none');
			},
            error: function(p) {
                alert("error");
            },
        })
        return false;
    })

    $(".remove_place_activity").live('click',function() {
        var link = $(this);
        var frm = $(this).parents("form:first")[0];
        $.ajax({
            type: "DELETE",
            url: "/user_place_activities/delete",
            data: {
                "place_activity_id" : $(this).attr("place_activity_id")
                },
            success: function(p) {
                //need to determinw which page this comes from and remove if favorites
                if((frm=='undefined')||(frm.id=='favorites'))
                {
                    link.parent().parent().removeClass('object');
                    link.parent().parent().replaceWith('');
                }
                else
                {
                    link.removeClass("remove_place");
                    link.html('<img class=" tooltip" width="20" title="Add to favorites" src="/images/HPThumbUp.png" alt="Hpthumbup"/>');
                }
            },
            error: function(p) {
                alert("error");
            },
        })
        return false;
    })

    $('.paginator').live('click', function() {
        var link = $(this);
        link.hide();
        $('#page_loading').show();
        //todo: need to set type here
        $.get(link.attr('href'),{}, function(data) {
            $('#page_loading').hide();
            link.replaceWith(data);
            $("#dialog").jqmAddTrigger('.add_to_favorites, .add_event, .add_activity');
        })
        return false;
    })

    $('.userpaginator').live('click', function() {
        var link = $(this);
        //todo: need to set type here
        $.get(link.attr('href'),{}, function(data) {
			
            $('#people_results').html(data);
            //$('#results_header').html(data.total_entries)

			$('#people_paging').html('Page ' + $('#user_page').val() + ' of ' + $('#user_page_count').val() );
            $("#dialog").jqmAddTrigger('.add_to_favorites, .add_event, .add_activity');
        })
        return false;
    })

    $('.fancy_select').live('click',function() {
        $('.fancy_select_options').hide();
        $(this).children('.fancy_select_options').show();
    });

    $('.fancy_select_options p').live('mouseover',function() {
        $(this).addClass('hover');
    }).live('mouseout',function() {
        $(this).removeClass('hover');
    }).live('click',function() {
        $(this).parent().prevAll('input').val($(this).find('.hidden_value').text());
        $(this).parent().prev().html($(this).html());
        $(this).parent().hide();
        return false;
    });

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
          $('#user_icon').css({
			postion: 'absolute',
            top: e.pageY  - 10  ,
            cursor: 'pointer',
			opacity: 0,
          })

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
    if($('#user_place_activity[description]').val() == 'Tell us everything important about it in less than a text message' ||
      $('#user_place_activity[description]').val() == ''
    ) {
      $('#user_place_activity[description]').addClass('invalid');
      error = true
    }
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
			 	$('#activity_id').val(0);
				$('#activity_target').text("Any activity");
				$('#user_place_activity_description').val("");
				$('#place_id').val("0");
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

  $('#pa_description').focus(function() {
    if ($(this).text() == 'Tell us everything important about it in less than a text message') {
      $(this).text('');
    }
  });


  });

function toggleSteps(step) {
	switch(step) {
		case 2: 
		  	$('#signup_header_step1').css('font-size','14px','font-weight','normal !important');
		  	$('#signup_header_step2').css('font-size','16px','font-weight','bold !important');
		  	$('#signup_header_step3').css('font-size','14px','font-weight','normal !important');
		break;
		case 3:
			$('#signup_header_step1').css('font-size','14px','font-weight','normal !important');
			$('#signup_header_step2').css('font-size','14px','font-weight','normal !important');
			$('#signup_header_step3').css('font-size','16px','font-weight','bold !important');
		
		break;
	}
}