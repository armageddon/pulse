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