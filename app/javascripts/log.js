Log = {
  ajax_counter: 0,
  max: 100,
  id: null,
  frozen: false,
  interval: 900,
  hidden: null,
  name: '',
  timer_id: false,
  initialize: function () {
    Log.timer_id = setTimeout(Log.update,Log.interval)
  },
  update: function() {
    if (!$$('body')[0].hasClassName('show_logs'))
      return
    Log.timer_id = false
    if (Log.frozen)
      return
    Log.ajax_counter++
    if (Log.ajax_counter > 200)
      location.href = location.href
    else {
      new Ajax.Request('/logs/'+Log.id+'/pull', {
        method: 'get',
        parameters: { max: Log.max },
        onComplete: function (a) {
          if (!Log.frozen)
            Log.timer_id = setTimeout(Log.update,Log.interval)
          if ($$('#entries > .entry').length > Log.max) {
            entries = $$('#entries > .entry')
            for (i = (Log.max - 1);i < entries.length;i++) {
              entries[i].remove()
            }
          }
          Log.check_markers()
        }
      })
    }
  },
  scroll_to_selected: function() {
    id = $$('.selected')[0].id
    Effect.ScrollTo(id,{duration: '0', offset:-241})
  },
  scroll_to_top_of_selected: function() {
    id = $$('.selected')[0].id
    Effect.ScrollTo(id,{duration: '0', offset:-41})
  },
  update_timer: function() {
    Log.update()
  },
  freeze: function() {
    Log.frozen = true
    if (Log.timer_id) {
      clearTimeout(Log.timer_id)
      Log.timer_id = false
    }
  },
  unfreeze: function() {
    Log.frozen = false
    Log.update()
  },
  scroll_to_marker: function(new_count){
    if (!window_is_focused){
      Effect.ScrollTo($$('.marker')[0],{duration:'0',offset:-500})
    }
  },
  insert_controller_action: function(controller,action) {
    action_html = '<div action="#{action}" class="action"><input class="hide_controller_action" controller_action="#{controller_action}" id="hide_#{controller}_#{action}" name="" type="checkbox" value="" /><label for="hide_#{controller}_#{action}">#{action}</label></div>'
    controller_html = '<div class="controller" controller="#{controller}"><div class="name">#{display_name}</div><div class="actions"></div></div>'
    controller_action = controller + '#' + action
    display_name = Log.controller_display_name(controller)
    if (!$$('#controllers .controller[controller="' + controller + '"]').length) {
      $('controllers').insert({ bottom: controller_html.interpolate({
        controller: controller,
        display_name: display_name})})
    }
    controller_list = $$('#controllers .controller[controller="' + controller + '"]')[0]
    if (!controller_list.down('.action[action="' + action + '"]')) {
      controller_list.down('.actions').insert({ bottom: action_html.interpolate(
        {controller_action: controller_action,
        controller: controller,
        action: action}) })
    }
  },
  controller_display_name: function(controller) {
    return controller.match(/(.*)Controller$/)[1]
  },
  previous_visible_entry: function(start) {
    start = start.previous(entry)
    while (start && start.hasClassName('hidden'))
      start = start.previous('.entry')
    return start
  },
  next_visible_entry: function(start) {
    start = start.next(entry)
    while (start && start.hasClassName('hidden'))
      start = start.next('.entry')
    return start
  },
  check_markers: function() {
    markers = $$('.marker')
    while (m = markers.shift()) {
      next_visible = m.next(':not(.hidden)')
      next = m.next()
      if (!next)
        m.remove()
      else if (!next_visible || next_visible.hasClassName('marker'))
        m.hide()
      else
        m.show()
    }
  }
}

Event.addBehavior({
  'input#log_log_path:keyup': function(e) {
    if ($('log_root_path').readAttribute('touched') == 'false') {
      if (m = this.getValue().match(/^(.*)\/log\/[a-z_0-9]+\.log/))
        $('log_root_path').setValue(m[1])
    }
  },
  'input#show_full_backtrace:click': function() {
    value = this.checked
    new Ajax.Request('/options', {
      method: 'post',
      parameters: { show_full_backtrace: value }
    })
    if (value)
      $$('.full_backtrace').invoke('show')
    else
      $$('.full_backtrace').invoke('hide')
  },
  'input#freeze_updates:click': function() {
    if (this.checked) {
      Log.freeze()
    } else {
      Log.unfreeze()
    }
  }
})