User = {
  droppable: function() {
    $$('.user').each(function(o,i) {
      Droppables.remove(o)
      Droppables.add(o, {
        hoverclass: 'droppable',
        onDrop: function(draggable,droppable,e) {
          new Ajax.Request('/users/'+droppable.readAttribute('user_id'), {
            method: 'put',
            parameters: {'user[add_logs][]': [draggable.readAttribute('log_id')]}
          })
        }
      })
    })
  },
  draggable: function() {
    $$('.user_log').each(function(o,i) {
      new Draggable(o.id, {
        revert: true,
        ghosting: true
      })
    })
  },
  drag_drop: function() {
    User.droppable()
    User.draggable()
  }
}

Event.addBehavior({
  'a.user_log_link:click': function(e) {
    if (confirm(this.readAttribute('confirm_text'))) {
      user_id = this.up('.user').readAttribute('user_id')
      new Ajax.Request('/users/'+user_id, {
        method: 'put',
        parameters: {'user[remove_logs][]': [this.readAttribute('log_id')]}
      })
    }
  },
  'select.user_role_select:change': function(e) {
    user_id = this.up('.user').readAttribute('user_id')
    role = this.options[this.selectedIndex].value
    new Ajax.Request('/users/'+user_id, {
      method: 'put',
      parameters: {'user[role]': role}
    })
    this.up('.role').down('.loading').addClassName('display')
    this.hide()
  }
})