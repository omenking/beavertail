//= require <prototype>
//= require <builder>
//= require <effects>
//= require <controls>
//= require <dragdrop>
//= require <sound>         
//= require <lowpro>

//= require <livepipe.js>
//= require <contextmenu.js>
//= require <hotkey.js>
//= require <rating.js>
//= require <selectmultiple.js>
//= require <window.js>

//= require <app.js>
//= require <search.js>
//= require <hotkeys.js>
//= require <user.js>

document.observe("dom:loaded", function() {
  Entry.initialize()
  Log.initialize()
  
  window_is_focused = true
  search_field_is_focused = false

  window.onfocus = function() {
    window_is_focused = true
    App.set_title()
  }
  window.onblur = function() {
    window_is_focused = false
    first = $('entries').down()
    while(first) {
      if (first.hasClassName('marker'))
        break
      else if (first.hasClassName('hidden')) {
        first = first.next()
        continue
      } else {
        $('entries').insert({ top: "<div class='marker'></div>" })
        break
      }
    }
    App.set_title()
  } 
})  

Event.addBehavior({
  'input[touched=false]:focus': function() {
    this.writeAttribute('touched',true)
  }
})

RegExp.escape = function(text) {
  var specials = [
    '/', '.', '*', '+', '?', '|',
    '(', ')', '[', ']', '{', '}', '\\'
  ];
  escape_re = RegExp('(\\' + specials.join('|\\') + ')', 'g')
  text =  text.replace(escape_re,'\\$1')
  text =  text.replace(/[\040]+/g,' ')
  return text.replace(/\040/g,'\\040+')
}
