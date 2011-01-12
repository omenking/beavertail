Entry = {
  initialize: function(){
    if ($$('.entry').length > 0) {
      entry = $$('.entry')[0]
      while (entry && (entry.hasClassName('marker') || entry.hasClassName('hidden'))) 
        entry = entry.next()
      entry.addClassName('selected')
    }
  },
  add: function(entries) {
    new_count = 0
    update_count = 0

    if (Log.frozen)
      return
      
    while (entry = entries.shift()) {
        entry_dom = $$('.entry[hash='+entry.hash+']')
        if (entry_dom.length == 0) {
          $('entries').insert({
            top: entry.html })
          Log.insert_controller_action(entry.controller,entry.action)
          new_count++
        } else if (entry_dom[0].readAttribute('content_hash') != entry.content_hash) {
          is_expanded = entry_dom[0].hasClassName('expanded')
          entry_dom[0].replace(entry.html)
          if (is_expanded)
            entry_dom[0].addClassName('expanded selected')
          update_count++
        }
      }
    
    if ($$('.selected').length == 0) { Entry.initialize() }
    
    if (new_count > 0)
       Log.scroll_to_marker(new_count)
      
    Event.addBehavior.reload()
  }
}

Event.addBehavior({  
  '.entry .head:click': function (e) {  
    entry = this.up('.entry')
    state = entry.hasClassName('expanded')
    $$('.entry.expanded').invoke('removeClassName','expanded')
    if (!state)
      entry.addClassName('expanded')
    $$('.selected')[0].removeClassName('selected')
    entry.addClassName('selected')
  },
  'input.hide_controller_action:click': function (e) {
    controller_action = this.readAttribute('controller_action')
    if (this.checked) {
      url = '/hidden_actions'
      method = 'post'
      $$(".entry[controller_action='" + controller_action + "']").invoke('addClassName','hidden')
    } else {
      url = '/hidden_actions/destroy'
      method = 'delete'
      $$(".entry[controller_action='" + controller_action + "']").invoke('removeClassName','hidden')
    }
    Log.check_markers()
    new Ajax.Request(url, {
      method: method,
      parameters: {
        log_id: Log.id,
        controller_action: this.readAttribute('controller_action')}
    })
  }
  
})  