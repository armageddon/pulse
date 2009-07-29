$(document).ready(function() {

  // misc rails specific stuff
  $.ajaxSetup({ 'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")} });

  $(document).ajaxSend(function(event, request, settings) {
    if (typeof(AUTH_TOKEN) == "undefined") return;
    settings.data = settings.data || "";
    settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
  });

  if ($.jqm) {
    $("#dialog").jqm({ajax: '@data-href', modal: true});
    $("#dialog").jqmAddTrigger('.add_to_favorites, .add_event, .add_activity, .invite_a_friend');
  }

  $('.paginator').live('click', function() {
    var link = $(this);
    link.hide();
    $('#page_loading').show();
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

