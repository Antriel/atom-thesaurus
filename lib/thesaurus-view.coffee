{SelectListView} = require 'atom-space-pen-views'

module.exports =
class ThesaurusView extends SelectListView
  initialize: (@editor, @synonyms, @marker) ->
    super
    @addClass('synonyms popover-list') #no idea what's this good for - seems to make UI work well somehow
    @attach()

  attach: ->
    @setItems(@synonyms)
    @overlayDecoration = @editor.decorateMarker(@marker, type: 'overlay', item: this)

  attached: ->
    @storeFocusedElement()
    @focusFilterEditor()

  confirmed: (synonym) ->
    @cancel()
    return unless synonym
    @editor.transact =>
      @editor.setSelectedBufferRange(@marker.getRange())
      @editor.insertText(synonym)
  cancelled: ->
    @overlayDecoration.destroy()
    @restoreFocus()

  selectNextItemView: ->
    super
    false

  selectPreviousItemView: ->
    super
    false

  viewForItem: (word) ->
    element = document.createElement('li')
    element.textContent = word
    element

  destroy: ->
    @cancel()
    @remove()
