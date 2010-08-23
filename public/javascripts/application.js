

function createCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function eraseCookie(name) {
	createCookie(name,"",-1);
}


$(document).ready(function() {



    function close()
    {
        $("#dialog").jqmHide();
    }

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
        $("#dialog").jqmAddTrigger('.add_to_favorites, .add_place, .add_event, .add_activity, .arrange_to_meet');
    }

    $('#crop').live('click',function() {
        $('#dialog').jqm({
            ajax:'/icon_crop',
            modal:true
        });
        $('#dialog').jqmShow();
        return false;
    });
	
    $('#cropp').live('click',function() {
        alert('crop');
        $("#photo_crop").ajaxSubmit({
            iframe: true,
            extraData: {
                'iframe': 'true'
            },
            dataType: "js",
            success: function(response) {
                alert('success');
            }
        })
        return false;
    });
	
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
            }
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
            }
        })
        return false;
    })
    
    $(".place_activity_people_favorite").live('click',function() {
        var link = $(this);
        $.ajax({
            type: "POST",
            url: "/account/favorites",
            data: {
                "friend_id" : $(this).attr("friend_id")
            },
            success: function(p) {
                link.css("display","none");
              
            },
            error: function(p) {
                alert("error");
            }
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
                $("#profile_people_favorite").css('display', '');
            },
            error: function(p) {
                alert("error");
            }
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
                $("#profile_people_unfavorite").css('display', '');
                $("#profile_people_favorite").css('display', 'none');
            },
            error: function(p) {
                alert("error");
            }
        })
        return false;
    })

    $(".remove_place_activity").live('click',function() {
        var link = $(this);
    
        $.ajax({
            type: "DELETE",
            url: "/user_place_activities/delete",
            data: {
                "user_place_activity_id" : $(this).attr("user_place_activity_id")
            },
            success: function(p) {
                //need to determinw which page this comes from and remove if favorites

   
                link.parent().parent().removeClass('object');
                link.parent().parent().replaceWith('');
                
                
            },
            error: function(p) {
                alert("error");
            }
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


    $('.paginator_user').live('click', function() {
        var link = $(this);
        link.hide();
        $('#user_loading').show();
        //todo: need to set type here
        $.get(link.attr('href'),$('#advanced_search_side').serialize(), function(data) {
            $('#user_loading').hide();
            link.replaceWith(data);
            $("#dialog").jqmAddTrigger('.add_to_favorites, .add_event, .add_activity');
        })
        return false;
    })
    $('.paginator_activity').live('click', function() {
        var link = $(this);
        link.hide();
        $('#activity_loading').show();
        //todo: need to set type here
        $.get(link.attr('href'),$('#advanced_search_side').serialize(), function(data) {
            $('#activity_loading').hide();
            link.replaceWith(data);
            $("#dialog").jqmAddTrigger('.add_to_favorites, .add_event, .add_activity');
        })
        return false;
    })
    $('.paginator_place').live('click', function() {
        var link = $(this);
        link.hide();
        $('#place_loading').show();
        //todo: need to set type here
        $.get(link.attr('href'),$('#advanced_search_side').serialize(), function(data) {
            $('#place_loading').hide();
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

    $('.std_dd, .inline_dd').change(function() {
        var cntrl = $(this);
        cntrl.prev().val(cntrl.selected().val());
   
 
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

    $('#activity_category_select').live('click',function() {
        $.ajax({
            type: "GET",
            dataType: "json",
            url: "/search/activity_list",
            data: {
                "activity_category_id" : $('#activity_category_id').val()
            },
            success: function(p) {
                var options = "";
                for(i=0;i<p.length;i++)
                {
                    options += '<option value=' + p[i].activity.id + '>'+p[i].activity.name + '</option>';
                }
                $('#activity_select').html(options);
                $('#activity_id').val(p[0].activity.id);
            }
        })
    });
});
