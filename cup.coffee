self.CS = CoffeeScript
self.print = (msg, tag) ->
  return if msg is silence
  if print.last is print.last = msg
    ctrl.setAttribute 'data-x', -~ctrl.getAttribute 'data-x'
  else
    ctrl.setAttribute 'data-x', 1
    lmn = document.createElement tag || 'span'
    lmn.appendChild document.createTextNode msg + '\n'
    pout.insertBefore lmn, pout.firstChild
  silence
print.last = silence = Date()

self.clear = -> pout.innerHTML = ''
self.say = self.puts = (xs...) -> print xs.join '\n'
self.warn = (er) -> print "#{er}", 'em'
self.p = -> say (JSON.stringify x, null, 1 for x in arguments).join '\n'

$ = (id) -> document.getElementById id
code = $ 'code'
ctrl = $ 'ctrl'
pout = $ 'pout'
btns = {}
poem = '''
"#{CoffeeScript.VERSION} (#{CoffeeScript.TREE})"



###
Not to abandon the evil parts
But to embrace the good parts
'''
kick = ->
  code.focus()
  {value} = code
  location.hash = @id.charAt() + ':' + encodeURI value if value isnt poem
  try r = CS[@id] value, bare: on
  catch e then warn e; throw e
  switch @accessKey
    when 't'
      r = ("[#{t} #{v}]" for [t, v] in r).join(' ').replace /\n/g, '\\n'
    when 'n'
      r = r.expressions.join('').slice 1
  puts r

for Key in ['Tokens', 'Nodes', 'Compile', 'Eval']
  btn = document.createElement 'button'
  btn.id = key = Key.toLowerCase()
  btn.onclick = kick
  btn.innerHTML = Key
  btns[key] = btns[btn.accessKey = key.charAt 0] = ctrl.appendChild btn

for k, b of {C: eva1 = btns.eval, S: cmpl = btns.compile}
  b.innerHTML += " <small><kbd>\\#{k}-RET"
document.onkeydown = (ev) ->
  return if (ev ||= event).keyCode isnt 13 || ev.altKey || ev.metaKey
  return unless b = (ev.ctrlKey && eva1) || (ev.shiftKey && cmpl)
  b.click()
  off
setTimeout ->
  code.value = if cf = location.hash.slice 1
    try cf = decodeURIComponent cf
    {$1: op, rightContext: cf} = RegExp if /^([a-v]+):/.test cf
    cf
  else
    poem
  (if op then btns[op.toLowerCase()] else eva1).click()

CS.VERSION += '+'
CS.TREE = 'e007f69c71c137932499b52f6141b5e82cef0a38'
