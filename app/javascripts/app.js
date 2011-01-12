App = {
  title: "BeaverTail - #{name}",
  title_with_errors: "BeaverTail(#{count}) - #{name}",
  recent_log: function(n) {
    if ($$('li.recent_log_' + n).length > 0)
      location.href = $$('li.recent_log_'+n)[0].down('a').href
  },
  set_title: function() {
    unread_count = 0
    if (!window_is_focused) {
      elements = $('entries').childElements()
      while (o = elements.shift()) {
        if (o.hasClassName('marker'))
          break
        if (o.hasClassName('hidden'))
          continue
        if (o.hasClassName('errors'))
          unread_count++
      }
    }
    if (!window_is_focused && unread_count > 0) {
      document.title = App.title_with_errors.interpolate({
          count: unread_count,
          name: Log.name })
    }else {
      document.title = App.title.interpolate({
        name: Log.name})
    }
  }
}