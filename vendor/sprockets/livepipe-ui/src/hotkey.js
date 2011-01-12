/**
 * @author Ryan Johnson <http://syntacticx.com/>
 * @copyright 2008 PersonalGrid Corporation <http://personalgrid.com/>
 * @package LivePipe UI
 * @license MIT
 * @url http://livepipe.net/extra/hotkey
 * @require prototype.js, livepipe.js
 */

/*global document, Prototype, Class, Event, $ */

if(typeof(Prototype) == "undefined") {
    throw "HotKey requires Prototype to be loaded."; }
if(typeof(Object.Event) == "undefined") {
    throw "HotKey requires Object.Event to be loaded."; }

var HotKey = Class.create({
    initialize: function(letter,callback,options){
        letter = letter.toUpperCase();
        HotKey.hotkeys.push(this);
        this.options = Object.extend({
            element: false,
            shiftKey: false,
            altKey: false,
            ctrlKey: true,
            bubbleEvent : true,
            fireOnce : false // Keep repeating event while key is pressed?
        },options || {});
        this.letter = letter;

        // All custom hotkey events should stop after their custom actions.
        this.callback = function (event) {
            if (!(this.options.fireOnce && this.fired) && Object.isFunction(callback)) { 
                callback(event); 
            }
            if (!this.options.bubbleEvent) { event.stop(); }
            this.fired = true;
        };

        this.element = $(this.options.element || document);
        this.handler = function(event){
            if(!event || (
                (Event['KEY_' + this.letter] || this.letter.charCodeAt(0)) == event.keyCode &&
                ((!this.options.shiftKey || (this.options.shiftKey && event.shiftKey)) &&
                    (!this.options.altKey || (this.options.altKey && event.altKey)) &&
                    (!this.options.ctrlKey || (this.options.ctrlKey && event.ctrlKey))
                )
            )){
                if(this.notify('beforeCallback',event) === false) {
                    return; }
                this.callback(event);
                this.notify('afterCallback',event);
            }
        }.bind(this);
        this.enable();
    },
    trigger: function(){
        this.handler();
    },
    enable: function(){
        this.element.observe('keydown',this.handler);
    },
    disable: function(){
        this.element.stopObserving('keydown',this.handler);
    },
    destroy: function(){
        this.disable();
        HotKey.hotkeys = HotKey.hotkeys.without(this);
    }
});
Object.extend(HotKey,{
    hotkeys: []
});
Object.Event.extend(HotKey);

// Alternate HotKey syntax:
// HotKey.addBehavior({
//   'shift ctrl t': function(e) {
//      ....
//   },
//   'p': function(e) {
//      ...
//   },
//   '#search_field': {
//     'return': function(e) {
//        ...
//     }
//   }
// })

HotKey.addBehavior = function(keys) {
  if (document.loaded)
    HotKey.registerBehavior(keys)
  else
    document.observe('dom:loaded', function() {
      HotKey.registerBehavior(keys)
    })
}

HotKey.registerBehavior = function(keys,element) { 
  for (var selector in keys) {
    if (m = selector.match(/^#(.*)$/)) {
      element_id = m[1]
      HotKey.registerBehavior(keys[selector],$(element_id))
    } else {
      selector_split = selector.split(/\s+/)
      options = { ctrlKey: false, shiftKey: false, altKey: false }
      if (element)
        options['element'] = element
      while (word = selector_split.shift()) {
        if (['ctrl','shift','alt'].include(word))
          options[word + 'Key'] = true
        else if (word != '')
          new HotKey(word, keys[selector], options)
      } // for word
    } // if typeof
  } // for selector
}
