search_timer = false
Event.addBehavior({
  'input#search_field:keyup': function() {
    if (search_timer)
      clearTimeout(search_timer)
      
    search_timer = setTimeout(function() { Search.update(true) },Search.interval)
  },
  'input#search_field:focus': function() {
    search_field_is_focused = true
  },
  'input#search_field:blur':function() {
    search_field_is_focused = false
  }
})

Search = {
  interval: 800,
  clear: function(close) {
    matches = $$('span.search_match')
    while (o = matches.shift())
      o.replace(o.innerHTML)
    $$('.entry').invoke('removeClassName','has_search_results')
    $$('.entry').invoke('removeClassName','has_no_search_results')
    if (close)
      $$('.entry').invoke('removeClassName','expanded')
  },
  update: function(close) {
    search_timer = false
    Search.clear(close)
    search_text = $('search_field').getValue()
    if (search_text == '' || search_text.replace(/[\040]+/g,' ').length < 3)
      return
    
    search_escaped = RegExp.escape(search_text)
    search_escaped = search_escaped.replace(/&/,'&amp;')
    search_escaped = search_escaped.replace(/</,'&lt;')
    search_escaped = search_escaped.replace(/>/,'&gt;')
    search_re = new RegExp(search_escaped,'i')
    replace_re = new RegExp("(" + search_escaped + ")",'ig')
    entries = []
    matches = $$('.entry div,.entry span,.entry a')
    while (o = matches.shift()) {
      if (o.innerHTML.indexOf('<') == -1 && o.innerHTML.indexOf('>') == -1) {
        if (o.innerHTML.match(search_re)) {
          entry = o.up('.entry')
          if (!entry)
            return true
          o.innerHTML = o.innerHTML.replace(replace_re,'<span class="search_match">$1</span>')
          entry.addClassName('expanded')
          entry.addClassName('has_search_results')
        }        
      }
    }
    
    matches = $$('.entry')
    while (o = matches.shift()) {
      if (!o.hasClassName('has_search_results'))
        o.addClassName('has_no_search_results')
    }
  },
  reset: function() {
    $('search_field').setValue('')
    Search.clear(true)
    $('search_field').blur()
    window.focus()
  }
}