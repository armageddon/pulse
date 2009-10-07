$(document).ready(function() {

  // misc rails specific stuff
  $.ajaxSetup({ 'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")} });
  
  if ($.jqm) {
    $("#dialog").jqm({ajax: '@data-href', modal: true});
    $("#dialog").jqmAddTrigger('.add_to_favorites, .add_event, .add_activity, .invite_a_friend');
  }

  $(document).ajaxSend(function(event, request, settings) {
    if (typeof(AUTH_TOKEN) == "undefined") return;
    settings.data = settings.data || "";
    settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
  });

  $(".people_unfavorite").live('click',function() {
    $.ajax({
      type: "DELETE",
      url: "/account/favorites/delete",
	  data: {"friend_id" : $(this).attr("friend_id")},
      success: function(p) {
        alert('deleted friend');
      },
      error: function(p) {
		alert("error");
	  },
   })
   return false;
  })

  $(".people_favorite").live('click',function() {
    $.ajax({
      type: "POST",
      url: "/account/favorites",
 	  data: {"friend_id" : $(this).attr("friend_id")},
      success: function(p) {
        alert('added friend');
      },
      error: function(p) {
	    alert("error");
	  },
  	})
    return false;
  })

  $(".remove_place").live('click',function() {
     $.ajax({
       type: "DELETE",
       url: "/account/activities/delete",
	   data: {"place_id" : $(this).attr("place_id")},
       success: function(p) {
         alert('deleted place');
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



});

