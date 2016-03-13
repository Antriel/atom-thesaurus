ThesaurusView = require './thesaurus-view'
thesaurus = require 'thesaurus'
{CompositeDisposable} = require 'atom'

module.exports = Thesaurus =
  thesaurusView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    #@thesaurusView = new ThesaurusView(state.thesaurusViewState)
    #@modalPanel = atom.workspace.addModalPanel(item: @thesaurusView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'thesaurus:run': => @run()
    @subscriptions.add atom.commands.add 'atom-workspace', 'thesaurus:open': => @open()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @thesaurusView.destroy()

  serialize: ->
    thesaurusViewState: @thesaurusView.serialize()

  run: ->
    editor  = atom.workspace.getActivePaneItem()
    pattern = editor?.getSelectedText()
    pattern = editor?.getWordUnderCursor() if pattern is ""
    return if not pattern
    range = editor.getLastCursor().getCurrentWordBufferRange()
    console.log range
    mark = editor.getBuffer().markRange(range,
        invalidate: 'touch',
        replicate: 'false',
        persistent: false,
        maintainHistory: false)
    console.log mark
    @synonymsView = new ThesaurusView(editor, thesaurus.find(pattern), mark)
    console.log "Found word #{pattern}. "
  open: ->
    console.log 'Thesaurus open is running'
    editor  = atom.workspace.getActivePaneItem()
    pattern = editor?.getSelectedText()
    pattern = editor?.getWordUnderCursor() if pattern is ""
    return if not pattern
    shell = require 'shell'
    shell.openExternal("http://www.thesaurus.com/browse/#{pattern}");
