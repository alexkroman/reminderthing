$( document ).ready( function() {
    $('input.time_picker').time_picker();
})

$.fn.time_picker = function() {
  return this.each(function() {
    var $this = $(this)
    $this.after($.fn.time_trigger())
    $this.hide()
    $this.after($.fn.time_display())
    var $time_display = $this.next('.time_display')
    var $time_trigger = $time_display.next('.time_trigger')
    var $time_trigger_button = $time_trigger.next('.time_picker_button')
    $time_display.hide()
    $time_trigger.click( function() {
      $time_trigger.hide()
      $time_trigger_button.hide()
      $this.show()
      $this.focus()
      $time_display.show()
    })
    $('.time').click( function() {
      $this.val($(this).text())
      $this.hide()
      $time_trigger.html($this.val())
      $time_display.hide()
      $time_trigger.show()
      $time_trigger_button.show()
      return false;
    })
  });
};

$.fn.time_trigger = function() {
  return ''
  + '<a class="time_trigger" href="#">No time set</a>'
  + '<button type="button" class="time_picker_button"'
}

$.fn.time_display = function() {
  return ''
  + '<div class="time_display">'
  + '<table>'
  + '<tr><th class="am">AM</th><th>PM</th></tr>'
  + '<tr><td class="am"><a href="#" class="time">12:00am</a></td><td class="pm"><a href="#" class="time">12:00pm</a></td></tr>' 
  + '<tr><td class="am"><a href="#" class="time">1:00am</a></td><td class="pm"><a href="#" class="time">1:00pm</a></td></tr>' 
  + '<tr><td class="am"><a href="#" class="time">2:00am</a></td><td class="pm"><a href="#" class="time">2:00pm</a></td></tr>' 
  + '<tr><td class="am"><a href="#" class="time">3:00am</a></td><td class="pm"><a href="#" class="time">3:00pm</a></td></tr>' 
  + '<tr><td class="am"><a href="#" class="time">4:00am</a></td><td class="pm"><a href="#" class="time">4:00pm</a></td></tr>' 
  + '<tr><td class="am"><a href="#" class="time">5:00am</a></td><td class="pm"><a href="#" class="time">5:00pm</a></td></tr>' 
  + '<tr><td class="am"><a href="#" class="time">6:00am</a></td><td class="pm"><a href="#" class="time">6:00pm</a></td></tr>' 
  + '<tr><td class="am"><a href="#" class="time">7:00am</a></td><td class="pm"><a href="#" class="time">7:00pm</a></td></tr>' 
  + '<tr><td class="am"><a href="#" class="time">8:00am</a></td><td class="pm"><a href="#" class="time">8:00pm</a></td></tr>' 
  + '<tr><td class="am"><a href="#" class="time">9:00am</a></td><td class="pm"><a href="#" class="time">9:00pm</a></td></tr>' 
  + '<tr><td class="am"><a href="#" class="time">10:00am</a></td><td class="pm"><a href="#" class="time">10:00pm</a></td></tr>' 
  + '<tr><td class="am"><a href="#" class="time">11:00am</a></td><td class="pm"><a href="#" class="time">11:00pm</a></td></tr>' 
  + '</table>'
  + '</div>';
};
