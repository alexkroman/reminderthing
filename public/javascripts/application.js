YAHOO.util.Event.onDOMReady(init);
YAHOO.namespace("example.calendar");

function init() {
  if (YAHOO.util.Dom.get('reminder_phone_number').value == '') {
    YAHOO.util.Dom.get('reminder_phone_number').focus();
  } else if (YAHOO.util.Dom.get('reminder_message').value == '') {
    YAHOO.util.Dom.get('reminder_message').focus();
  }

  var focusedElement = null;
  YAHOO.util.Event.addListener("cal1Container", "mouseover", function() { focusedElement = 'cal1Container' });
  YAHOO.util.Event.addListener("cal1Container", "mouseout", function() { focusedElement = null });
  YAHOO.util.Event.addListener("addressBook", "mouseover", function() { focusedElement = 'addressBook' });
  YAHOO.util.Event.addListener("addressBook", "mouseout", function() { focusedElement = null });
  YAHOO.util.Event.addListener("reminder_send_at_date", "blur", function() { if (focusedElement != 'cal1Container') { YAHOO.util.Dom.setStyle('cal1Container', 'display', 'none');}});
  YAHOO.util.Event.addListener("timeDiv", "mouseover", function() { focusedElement = 'timeDiv' });
  YAHOO.util.Event.addListener("timeDiv", "mouseout", function() { focusedElement = null });
  YAHOO.util.Event.addListener("reminder_send_at_time", "blur", function() { if (focusedElement != 'timeDiv') { YAHOO.util.Dom.setStyle('timeDiv', 'display', 'none');}});
  YAHOO.util.Event.addListener("reminder_send_at_time", "focus", showTime);
  YAHOO.util.Event.addListener("reminder_send_at_date", "focus", showCalendar);
  YAHOO.util.Event.addListener("reminder_phone_number", "focus", showAddressBook);
  YAHOO.util.Event.addListener("reminder_send_at_date", "change", updateCalendar);
  YAHOO.util.Event.addListener("reminder_phone_number", "blur", function() { if (focusedElement != 'addressBook') { YAHOO.util.Dom.setStyle('addressBook', 'display', 'none');}});

  Now = new Date();
  nice_date = YAHOO.util.Date.format(Now, {format: '%b %d, %Y'});
  nice_time = YAHOO.util.Date.format(Now, {format: '%I:%M%P'});

  if (YAHOO.util.Dom.get('reminder_send_at_date').value == '') {
    YAHOO.util.Dom.get('reminder_send_at_date').value = nice_date;
  }
  if (YAHOO.util.Dom.get('reminder_send_at_time').value == '') {
    YAHOO.util.Dom.get('reminder_send_at_time').value = nice_time;
  }

  tzOffSet = Now.getTimezoneOffset();
  tzOffSet = tzOffSet / 60;
  YAHOO.util.Dom.get('reminder_time_zone').value = tzOffSet; 
}

function setTime(time) {
  YAHOO.util.Dom.get('reminder_send_at_time').value = time;
  YAHOO.util.Dom.setStyle('timeDiv','display','none')
    return false;
}
function setPhoneNumber(number) {
  YAHOO.util.Dom.get('reminder_phone_number').value = number;
  YAHOO.util.Dom.setStyle('addressBook','display','none')
    return false;
}

function showCalendar() {
  YAHOO.util.Dom.setStyle('timeDiv','display','none')
    YAHOO.util.Dom.setStyle('cal1Container','display','block')
}

function showAddressBook() {
  YAHOO.util.Dom.get('reminder_phone_number').select();
  YAHOO.util.Dom.setStyle('addressBook','display','block')
}

function showTime() {
  YAHOO.util.Dom.get('reminder_send_at_time').focus();
  YAHOO.util.Dom.setStyle('cal1Container','display','none')
  YAHOO.util.Dom.setStyle('timeDiv','display','block')
}

function hideCalendar() {
  YAHOO.util.Dom.setStyle('cal1Container','display','none')
}

function dateToLocaleString(dt, cal) {
  var dStr = dt.getDate();
  var mStr = cal.cfg.getProperty("MONTHS_SHORT")[dt.getMonth()];
  var yStr = dt.getFullYear();
  return (mStr + " " + dStr + ", " + yStr);
}

function mySelectHandler(type,args,obj) { 
  var selected = args[0]; 
  var selDate = this.toDate(selected[0]); 
  YAHOO.util.Dom.get('reminder_send_at_date').value = dateToLocaleString(selDate, this); 
  hideCalendar();
  showTime();
}; 

function reversedMonths() {
  var shortMonthsArray = YAHOO.example.calendar.cal1.cfg.getProperty("MONTHS_SHORT");
  var longMonthsArray = YAHOO.example.calendar.cal1.cfg.getProperty("MONTHS_LONG");

  //YAHOO.log("Called getReversedMonths");
  var reversedObj = new Object;
  for (var i = 0, j = shortMonthsArray.length; i < j; i++) {
    reversedObj[shortMonthsArray[i].toLowerCase()] = i + 1; // Months start at 1 = January
  }
  for (var i = 0, j = longMonthsArray.length; i < j; i++) {
    reversedObj[longMonthsArray[i].toLowerCase()] = i + 1; // Months start at 1 = January
  }
  return reversedObj;
}

function getEnteredDate() {
  var calendars = YAHOO.example.calendar;

  str = YAHOO.util.Dom.get('reminder_send_at_date').value;
  str = str.toLowerCase();
  var regex = new RegExp("([a-z]+) ([0-9]+),? ([0-9]{4})");
  var match = regex.exec(str);
  if (match == null || match.length < 3) {
    return '';
  } else {
    var calDate = new Array();
    reversed = reversedMonths();
    calDate['month'] = reversed[match[1]];
    calDate['day'] = match[2];
    calDate['year'] = match[3];
    return calDate;
  }
}

function updateCalendar() {
  var calObj = YAHOO.example.calendar.cal1;
  var calDate = getEnteredDate();
  if (calDate) {
    calObj.cfg.setProperty("pagedate", calDate.month + '/' + calDate.year);
    // Only select the date on the first page!
    calObj.pages[0].select(calDate.month + '/' + calDate.day + '/' + calDate.year);
    calObj.render();
  } else {
    // Unrecognized date, clear the calendar.
    inputBox.value = '';
    calObj.render();
  }
}

YAHOO.example.calendar.init = function() {
  YAHOO.example.calendar.cal1 = new YAHOO.widget.CalendarGroup("cal1","cal1Container", 
      { pages:2, 
        mindate: Now
});
YAHOO.example.calendar.cal1.selectEvent.subscribe(mySelectHandler, YAHOO.example.calendar.cal1, true); 
YAHOO.example.calendar.cal1.render();
}

YAHOO.util.Event.onDOMReady(YAHOO.example.calendar.init);
