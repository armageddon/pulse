 $(document).ready(function() {
    var resultsArray;
    var selectedActivity;
    var selectedActivityIndex;
    var selectedPlace;
    var selectedPlaceIndex;
    var currentPlaceSelection;
    var currentSelection = 0;
    var search_timeout = undefined;
    var place_search_timeout = undefined;

    //events bindings
    $("#activity_name").bind('keyup',function(e){

      if(e.keyCode == 40)
      {
        navigate('down');
        return false;
      }
      if(e.keyCode == 38)
      {
        navigate('up');
        return false;
      }
      if($("#activity_name").val().length<= 2)
      {
        return false;
      }
      if(search_timeout != undefined) {
        clearTimeout(search_timeout);
      }
      var $this = this;
      search_timeout = setTimeout(function() {
        search_timeout = undefined;
        $.ajax({
          type: "GET",
          dataType: 'json',
          url: '/activities/autocomplete',
          data: {
            "q" : $('#activity_name').val()
          },
          success: function(p) {
            displayActivities(p);
          },
          error: function(p) {
            alert('An error occured');
          }
        })
      }, 500);
    });

    $("#place_nam").bind('keyup',function(e){
      if($("#place_nam").val().length<= 2) return false;
      if(search_timeout != undefined) {
        clearTimeout(place_search_timeout);
      }
      var $this = this;
      place_search_timeout = setTimeout(function() {
        place_search_timeout = undefined;
        $.ajax({
          type: "GET",
          dataType: 'json',
          url: '/places/autocomplete_new',
          data: {
            "q" : $('#place_nam').val()
          },
          success: function(p) {
            $('#place_results').css('display','block');
            resultsPlaceArray = p;
            $('#place_results').html(formatPlaceRows(p));
            bindPlaceHover()
          },
          error: function(p) {
            alert('an error occurred')
          }
        })
      }, 500);
    });

    $('#activity_name').bind('blur',function(){

    });

    $('#happening').bind('blur',function(){
      alert('blur');
    });

    $('.activity_dd').live('click',function(){
      currentSelection  = $("#activity_results ul li").index(this)
      setSelected(currentSelection);
      var act_id = $(this).attr('id');
      if(act_id == 0)
      {
        $('#activity_id').val(-1);
        $('#activity_results').css('display','none');
        displaySearchPlaces();
        return false;
      }
      else
      {
        $('#activity_id').val($(this).attr('id'));
      }
      $('#activity_name').val(getActivityFromID(act_id).name)
      $('#place_results').html('');
      $('#place_nam').val('');
      $.ajax({
        type: "GET",
        dataType: 'json',
        url: '/activity/activity_places',
        data: {
          "activity_id" : act_id
        },
        success: function(p) {
          if(p.length >1)
          {
            displayPopularPlaces(p);
          }
          else
          {
            displaySearchPlaces();
          }
          resultsPlaceArray = p;
          bindPlaceHover();
        },
        error: function(p) {
          alert('an error occured');
        }
      })
    });

    $('.place_dd').live('click',function(){
      currentPlaceSelection  = $("#place_results ul li").index(this);
      setPlaceSelected(currentPlaceSelection);
      var plc_id = $(this).attr('id');

      if(plc_id==0)
      {
        displaySearchPlaces();
        $('#place_results').css('display','none');
        $('#activity_results').css('display','none');
        $('#place_results').html('');

        return false;
      }
      if(plc_id==-1)
      {
        $('#activity_results').css('display','none');
        $('#place_results').css('display','none');
        $('#new_place').css('display','block');
        $('#place_id').val(-1);
        return false;
      }

      $('#place_nam').css('display','block');
      $('#place_nam').val(getPlaceFromID(plc_id).name);
      $('#place_id').val(plc_id);
      $('#place_results').css('display','none');
      $('#activity_results').css('display','none');
      $('#place_results').html('');
    });

    $('#place_nam').live('click',function(){
      $('#place_id').val(0);
      $(this).val('');
    });

    $('#description').live('click',function(){
      $(this).val('');
    });

    $('#activity_name').live('click',function(){
      $(this).val('');
      $("#place").css('display','none');
      $("#place_results").css('display','none');
      $("#place_nam").val('');
      $('#activity_id').val(0);
      $('#place_results').html('');
    });

    $('#add_activity').live('click',function(){
      //if activity id = 0 add activity and get activity id
      //then add UPA
      $('#add_error').html('');
      var error = false;
      if($('#activity_id').val() == 0)
      {
        error = true;
        $('#add_error').html('Please ensure you have selected an activity ')
        return false;
      }
      if($('#place_id').val() == 0)
      {
        error = true;
        $('#add_error').html('Please ensure you have selected a place ')
        return false;
      }
      $.ajax({
        type: "POST",
        url: "/user_place_activities/new_user_place_activity",
        data: {
          "activity_id" : $('#activity_id').val(),
          "activity_name" : $('#activity_name').val(),
          "place_id" :  $('#place_id').val(),
          "description" : $('#description').val(),
          "place_name" :  $('#place_nam').val(),
          "neighborhood" :  $('#hood').val(),
          "time_of_day" : $('#time_of_day').val(),
          "day_of_week" : $('#day_of_week').val()
        },
        success: function(p) {
          alert('added');
        },
        error: function(p) {
          alert("error");
        }
      });
      return false;
    });


    //methods


    function bindHover() {
      $("#activity_results ul li a").hover(function () {
        currentSelection = $("#activity_results ul li a").index(this)
        setSelected(currentSelection);
      }, function() {
        $("#activity_results ul li a").removeClass("itemhover");
        currentUrl = '';
      }
    );
    }

    function bindPlaceHover()  {
      $("#place_results ul li a").hover( function () {
        currentPlaceSelection = $("#place_results ul li a").index(this)
        setPlaceSelected(currentPlaceSelection);
      }, function() {
        $("#place_results ul li a").removeClass("itemhover");
        currentUrl = '';
      }
    );
    }

    function setSelected(index) {
      $("#activity_results ul li a").removeClass("itemhover");
      $("#activity_results ul li a").eq(index).addClass("itemhover");
    }

    function setPlaceSelected(index) {
      $("#place_results ul li a").removeClass("itemhover");
      $("#place_results ul li a").eq(index).addClass("itemhover");
    }

    function formatActivityRows(results) {
      var html = '<ul>';
      for (var i = 0; i<results.length;i++)
      {
        html += '<li class="activity_dd" id='+ results[i].id +'><a class="result_item">' + results[i].name + '&nbsp;<span style="font-size:10px">(' + results[i].count + ')</span></a></li>';
      }
      html += '</ul>';
      return html;
    }

    function formatPlaceRows(results) {
      var html = '<ul>';
      var place_class = 'place_dd';
      for (var i = 0; i<results.length;i++)
        if(results[i].id==0||results[i].id==-1)
      {
        html += '<li class=' + place_class+ ' style="font-weight:bold" id='+ results[i].id +'><a class="result_item">' + results[i].name + '&nbsp;<span style="font-size:10px">' + results[i].count + '</span></a></li>';
      }
      else
      {
        html += '<li class=' + place_class+ ' id='+ results[i].id +'><a class="result_item">' + results[i].name + '&nbsp;<span class="place_hood">'+ results[i].neighborhood +'</span>&nbsp;<span style="font-size:10px">(' + results[i].count + ')</span></a></li>';
      }
      html += '</ul>';
      return html;
    }

    function navigate(direction)
    {
      // Check if any of the menu items is selected
      if($("#activity_results ul li .itemhover").size() == 0) {
        currentSelection = -1;
      }
      if(direction == 'up' && currentSelection != -1) {
        if(currentSelection != 0) {
          currentSelection--;
        }
      } else if (direction == 'down') {
        if(currentSelection != $("#activity_results ul li").size() -1) {
          currentSelection++;
        }
      }
      setSelected(currentSelection);
    }

    function navigatePlaces(direction)
    {
      // Check if any of the menu items is selected
      if($("#place_results ul li .itemhover").size() == 0) {
        currentPlaceSelection = -1;
      }
      if(direction == 'up' && currentPlaceSelection != -1) {
        if(currentPlaceSelection != 0) {
          currentPlaceSelection--;
        }
      } else if (direction == 'down') {
        if(currentPlaceSelection != $("#place_results ul li").size() -1) {
          currentPlaceSelection++;
        }
      }
      setPlaceSelected(currentPlaceSelection);
    }

    function displayActivities(activities)
    {
      //display loading
      resultsArray = activities;
      $('#place_nam').css('display','none');
      $('#activity_results').css('display','block');
      $('#activity_results').css('overflow','auto');
      $('#activity_results').css('max-height','200px');
      $('#activity_results').html(formatActivityRows(activities));
      bindHover();

      for(var i = 0; i < $("#activity_results ul li a").size(); i++) {
        $("#activity_results ul li a").eq(i).data("number", i);
      }
    }

    function displaySearchPlaces()
    {
      $('#place_label').html('Search for a place or add a new place');
      $('#place_results').css('display','none');
      $('#place_results').css('margin-top','0px');
      $('#place').css('display','block');
      $('#place').css('margin-left','10px');
      $('#place_nam').css('display','block');
      $('#place_results').css('max-height','300px');
      $('#place_results').css('overflow','auto');
    }

    function displayPopularPlaces(places)
    {
      $('#place_label').html('Select a popular place or click search to find other places');
      $('#place_nam').css('display','none');
      $('#place').css('display','block');
      $('#place').css('margin-left','0px');
      $('#place_results').css('display','block');
      $('#place_results').css('border','1px');
      $('#place_results').css('border-style','solid');
      $('#place_results').css('border-color','#999999');
      $('#place_results').css('margin-top','10px');
      $('#place_results').html(formatPlaceRows(places));
    }

    function getActivityFromID(id)
    {
      var selItem;
      for (var i = 0; i<resultsArray.length;i++)
      {
        if(resultsArray[i].id == id)
        {
          selItem = resultsArray[i];
        }
      }
      return selItem;
    }

    function getPlaceFromID(id)
    {
      var selItem;
      for (var i = 0; i<resultsPlaceArray.length;i++)
      {
        if(resultsPlaceArray[i].id == id)
        {
          selItem = resultsPlaceArray[i];
        }
      }
      return selItem;
    }
  });