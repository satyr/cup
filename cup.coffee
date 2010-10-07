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
self.warn = (er) -> print er, 'em'
self.p = (xs...) -> say (JSON.stringify x, null, 1 for x in xs).join '\n'

$ = (id) -> document.getElementById id
code = $ 'code'
ctrl = $ 'ctrl'
pout = $ 'pout'
btns = {}
poem = code.value
kick = ->
  code.focus()
  {value} = code
  location.hash = @id.charAt() + ':' + encodeURI value if value isnt poem
  try r = CoffeeScript[@id] value, noWrap: on
  catch e then warn e; throw e
  switch @accessKey
    when 'T'
      r = ("[#{t} #{v}]" for [t, v] in r).join(' ').replace /\n/g, '\\n'
    when 'N'
      r = r.expressions.join('').slice 1
  puts r

for key of CoffeeScript when key not in ['VERSION', 'run', 'load']
  btn = document.createElement 'button'
  btn.id = key
  btn.onclick = kick
  k = key.charAt()
  K = btn.accessKey = k.toUpperCase()
  btn.innerHTML = K + key[1..]
  btns[key] = btns[k] = ctrl.appendChild btn

for k, b of {C: eva1 = btns.eval, S: cmpl = btns.compile}
  b.innerHTML += " <small><kbd>\\#{k}-RET"
document.onkeydown = (ev) ->
  return if (ev ||= event).keyCode isnt 13 || ev.altKey || ev.metaKey
  return unless b = (ev.ctrlKey && eva1) || (ev.shiftKey && cmpl)
  b.click()
  off
setTimeout ->
  if cf = location.hash[1..]
    try cf = decodeURIComponent cf catch _
    {$1: op, rightContext: cf} = RegExp if /^([a-v]+):/.test cf
    code.value = cf
  (if op then btns[op.toLowerCase()] else eva1).click()

CoffeeScript.VERSION += '+'
CoffeeScript.TREE = 'f90f1ef8e0fc9a720520e3747bf8beb3c42b2edf'
