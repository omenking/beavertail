Entry = {
  initialize: function(){
    if ($$('.entry').length > 0) {
      entry = $$('.entry')[0]
      while (entry && (entry.hasClassName('marker') || entry.hasClassName('hidden'))) 
        entry = entry.next()
      entry.addClassName('selected')
    }
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