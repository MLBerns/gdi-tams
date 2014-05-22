$(document).ready(function() {
  $('form.new_course').hide();
  $('form.fetch_meetup').submit(function(event) {
    event.preventDefault();
    var url = $('form.fetch_meetup input#url').val();
    $('form.fetch_meetup').hide();
    loadingThingy();
    fetchMeetup(url);
  });

  function fetchMeetup(url) {
    var url = url.split('/');
    if (url[url.length-1] === "") {
      var id = url[url.length-2];
    }
    else {
      var id = url[url.length-2];
    }
    var api_key = "50126113187c612be767a33451ac";
    $.ajax({
      url: 'https://api.meetup.com/2/event/' + id + '?key=' + api_key + '&sign=true',
      crossDomain: true,
      dataType: 'jsonp',
      type: "GET",
      success: function dataSuccess(data) {
        populateForm(data, id);
        },
      error: function(data) {
        console.log("OH NOEEESSS! SOMETHING WENT WRONG!", data);
      }
    });
  }

  function populateForm(data, id) {
    var date = dateFromSecondsSinceEpoch(data.time);
    var day = date.getDate();

    $('div.loading').remove();
    $('form.new_course').show();
    $('#course_name').val(data.name);
    $('#course_url').val(data.event_url);
    $('#course_location').val(data.venue.name + ' ' + data.venue.address_1);
    $('#course_description').val(data.description);
    $('#course_date_1i').val('2014');
    $('#course_date_2i').val(date.getMonth() + 1); // January
    $('#course_date_3i').val(day); // 1-31
    $('#course_meetup_id').val(id);
  }

  function dateFromSecondsSinceEpoch(secs) {
    var date = new Date(0);
    date.setUTCMilliseconds(secs);
    return date;
  }

  function prettyMonth(num) {
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    return months[num];
  }

  function loadingThingy() {
    $('body').append('<div class="loading"><h1>Loading!</h1></div>');
  }
});
