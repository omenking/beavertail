HotKey.addBehavior({
  'esc': function(e) {
    Search.reset()
    e.stop()
  },
  'p': function(e) {
    if (search_field_is_focused)
      return
    $('freeze_updates').click()
    e.stop()
  },
  'b': function(e) {
    if (search_field_is_focused)
      return
    $('show_full_backtrace').click()
    e.stop()
  },
  'f': function(e) {
    if (search_field_is_focused)
      return
    $('search_field').focus()
    e.stop()
  },
  'h': function(e) {
    if (search_field_is_focused)
      return
    selected = $$('.selected')[0]
    c = selected.readAttribute('controller_action').split(/#/)
    $$('.controller[controller="' + c[0] + '"] .action[action="' + c[1] + '"] input')[0].click()
    
    new_selected = Log.next_visible_entry(selected)
    if (!new_selected)
      new_selected = Log.previous_visible_entry(selected)
    selected.removeClassName('expanded')
    selected.removeClassName('selected')
    new_selected.addClassName('selected')
    e.stop()
  },
  'tab': function(e) {
    if (search_field_is_focused)
      return
    selected = $$('.selected')[0]
    previous = Log.next_visible_entry(selected)

    if (previous){
      selected.removeClassName('expanded')
      selected.removeClassName('selected')
      previous.addClassName('selected expanded')    
      Log.scroll_to_top_of_selected()
    }
    e.stop()
  },
  'backspace': function(e) {
    if (search_field_is_focused)
      return
    selected = $$('.selected')[0]
    previous = Log.previous_visible_entry(selected)

    if (previous){
      selected.removeClassName('expanded')
      selected.removeClassName('selected')
      previous.addClassName('selected expanded')
      Log.scroll_to_top_of_selected()
    }
    e.stop()
  },
  'up': function(e) {
    if (search_field_is_focused)
      return
    selected = $$('.selected')[0]
    previous = Log.previous_visible_entry(selected)

    if (previous){
      selected.removeClassName('selected')
      previous.addClassName('selected')
      Log.scroll_to_selected()
    }
    e.stop()
  },
  'down': function(e) {
    if (search_field_is_focused)
      return
    selected = $$('.selected')[0]
    previous = Log.next_visible_entry(selected)

    if (previous){
      selected.removeClassName('selected')
      previous.addClassName('selected')    
      Log.scroll_to_selected()
    }  
    e.stop()
  },
  'left': function(e) {
    if (search_field_is_focused)
      return
    $$('.selected')[0].removeClassName('expanded')
    Log.scroll_to_selected()
    e.stop()
  },
  'right':function(e) {
    if (search_field_is_focused)
      return
    $$('.entry').invoke('removeClassName','expanded')
    $$('.selected')[0].removeClassName('expanded')
    $$('.selected')[0].addClassName('expanded')
    Log.scroll_to_top_of_selected()
    e.stop()
  },
  '1': function(e) {
    App.recent_log(1)
  },
  '2': function(e) {
    App.recent_log(2)
  },
  '3': function(e) {
    App.recent_log(3)
  },
  '4': function(e) {
    App.recent_log(4)
  },
  '5': function(e) {
    App.recent_log(5)
  },
  '6': function(e) {
    App.recent_log(6)
  }
})