
    function reset()
    {
      $("#place").css('display','none');
      $('#activity_results').css('display','none');
      $('#activity_name').val('');
      $('#place_id').val(0);
      $('#activity_id').val(0);
      $('#day_of_week').val(0);
      $('#time_of_day').val(0);
      $('#dowdd').val('0');
      $('#toddd').val('0');
      $('#description').val('');
    }

    function reg_success(p)
    {
      if($('#user_place_activities').html().indexOf("Please add some activities") >= 0)
      {
        $('#user_place_activities').html('');
      }
      $('#user_place_activities').append(p);
      reset();
    }

    function add_success(p)
    {
      $("#dialog").jqmAddTrigger('.add_to_favorites, .add_place, .add_event, .add_activity, .invite_a_friend');
      $("#dialog").html("Successfully added to your profile");
      $('#dialog').fadeTo(2000, 0.1, function() {
        $('#dialog').jqmHide();
        $('#dialog').fadeTo(1,1);
      });
    }

    function edit_success(p)
    {
      $('#user_place_activity_'+$("#user_place_activity_id").val()).replaceWith(p);
      $("#dialog").jqmAddTrigger('.add_to_favorites, .add_place, .add_event, .add_activity, .invite_a_friend');
      $("#dialog").html("Successfully updated");
      $('#dialog').fadeTo(2000, 0.1, function() {
        $('#dialog').jqmHide();
        $('#dialog').fadeTo(1,1);
      });
    }
    
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
       $('#place_nam').css('width','270px');
      $('#place_nam').css('display','block');
      $('#place_results').css('max-height','280px');
      $('#place_results').css('overflow','auto');
    }

    function displayPopularPlaces(places)
    {
      $('#place_label').html('Choose a popular place or Search ');
      $('#place_nam').css('display','none');
      $('#place').css('display','block');
      $('#place').css('margin-left','0px');
      $('#place_nam').css('width','280px');
      $('#place_results').css('display','block');
      $('#place_results').css('border','1px');
      $('#place_results').css('border-style','solid');
      $('#place_results').css('border-color','#999999');
   
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

 function checkValidation()
    {
      //pass:   has activity id and place id (-1 is new activity and place)
      //           has activity name and place id
      //           has activity name and place name and neighborhood
      $('#add_error').html('');
      if($('#activity_id').val() == 0)
      {
        $('#add_error').html('Please ensure you have selected an activity ')
        return false;
      }
      if($('#place_id').val() == 0)
      {
        $('#add_error').html('Please ensure you have selected a place ')
        return false;
      }
      if($('#hood').val() == '0' && $('#place_id').val()==-1)
      {
        $('#add_error').html('Please ensure you have selected a neighborhood ')
        return false;
      }
      return true;
    }