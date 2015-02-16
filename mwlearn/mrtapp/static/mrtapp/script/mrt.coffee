window.doDebug = -> null
window.obj2str = (obj, indent=0, recursion_limit=5) ->
  if recursion_limit<0
    '...'
  else if obj? and (typeof obj=='object')
    pre = (if indent>0 then "\n" else "")
    pad = zpad('',indent," ")
    str = []

    for key,val of obj
      str.push "#{pad}#{key}:#{obj2str(val,indent+1,recursion_limit-1)}"

    pre+str.join("\n")
  else
    obj
objPath = (obj,path...) ->
  x = obj
  for el in path
    if x?
      x = x[el]
    else
      break
  x
window.getClass = (obj) -> if obj? then obj.constructor.name else null
zpad = (x,n,chr='0') -> x=chr + x while (''+x).length < n; x
extend = (obj, prop) -> obj[key]=val for key, val of prop; obj
copy = (x, deep=false) ->
  switch getClass(x)
    when 'Object'
      if deep
        y = {}
        (y[key] = copy(val,true)) for key,val of x
        y
      else
        extend {}, x
    when 'Array'
      if deep
        (copy(val,true) for val in x)
      else
        x.slice(0)
    else
      x
merge = (obj1, obj2) -> extend copy(obj1), obj2
remove = (obj, keys) -> objc = copy(obj); delete(objc[key]) for key in keys; objc
swap = (x,i1,i2) -> tmp=x[i1]; x[i1]=x[i2]; x[i2]=tmp
sum = (x,s=0,e=null) -> n=x.length; if 0<=s<n and (not e? or s<=e) then x[s] + sum(x,s+1,e ? n-1) else 0
add = (a,b) -> (a[idx]+b[idx] for idx in [0..a.length-1])
sub = (a,b) -> (a[idx]-b[idx] for idx in [0..a.length-1])
mult = (a,b) -> (a[idx]*b[idx] for idx in [0..a.length-1])
mean = (a) -> sum(a)/a.length
divide = (a,b) -> (a[idx]/b[idx] for idx in [0..a.length-1])
smult = (a,b) -> (a[idx]*b for idx in [0..a.length-1])
mod = (x,n) -> r=x%n; if r<0 then r+n else r
around = (x) -> (Math.round(e) for e in x)
window.nearest = (x,ref) ->
  df = (Math.abs(x-r) for r in ref)
  dfMin = Math.min(df...)
  return ref[i] for i in [0..ref.length-1] when df[i]==dfMin
window.randomInt = (mn,mx) -> Math.floor(Math.random() * (mx - mn + 1)) + mn
randomize = (x) ->
  iCur = x.length
  while iCur != 0
    iRnd = randomInt(0,iCur-1)
    iCur -= 1
    swap x, iCur, iRnd
pickFrom = (x) -> x[randomInt(0,x.length-1)]
rotate = (p, theta, about=[0,0]) ->
  a = Math.PI*theta/180
  cs = Math.cos a
  sn = Math.sin a
  x = p[0] - about[0]
  y = p[1] - about[1]
  p = [
    x*cs - y*sn + about[0]
    x*sn + y*cs + about[1]
  ]
window.equals = (x,y) ->
  if Array.isArray(x) and Array.isArray(y)
    if x.length==y.length
      for idx in [0..x.length-1]
        if not equals(x[idx], y[idx])
          return false
      true
    else
      false
  else
    x==y
window.find = (x,v) -> f = []; f.push(i) for e,i in x when equals(e,v); f
setdiff = (x,d) -> e for e in x when not equals(e,d)
fixAngle = (a) ->
  a = mod(a,360)
  if a>180 then a-360 else a
aan = (str) -> if str.length==0 or find("aeiou",str[0]).length==0 then 'a' else 'an'
capitalize = (str) -> str.charAt(0).toUpperCase() + str.slice(1)
contains = (x,v) ->
  for e in x
    if equals(e,v) then return true
  false
unique = (x) -> u=[]; u.push(e) for e in x when not contains(u,e); u
forceArray = (a) -> if a? then (if Array.isArray(a) then a else [a]) else a
wordCount = (str) -> str.split(' ').length
msPerT = (unit) ->
  switch unit
    when 'day'
      86400000
    when 'hour', 'hr', 'h'
      3600000
    when 'minute', 'min', 'm'
      60000
    when 'second', 'sec', 's'
      1000
    when 'millisecond', 'msec', 'ms'
      1
    when 'dayminus10minutes'
      85800000
    else
      throw 'Invalid unit'
window.convertTime = (t,unitFrom,unitTo) -> t*msPerT(unitFrom)/msPerT(unitTo)
window.time2str = (t,showms=false) ->
  hours = Math.floor(convertTime(t,'ms','hour'))
  t -= convertTime(hours,'hour','ms')

  minutes = Math.floor(convertTime(t,'ms','minute'))
  t -= convertTime(minutes,'minute','ms')

  seconds = Math.floor(convertTime(t,'ms','second'))
  t -= convertTime(seconds,'second','ms')

  strHours = if hours>0 then "#{zpad(hours,2)}:" else ''
  strMinutes = "#{zpad(minutes,2)}:"
  strSeconds = zpad(seconds,2)
  strMS = if showms then ".#{t}" else ''
  "#{strHours}#{strMinutes}#{strSeconds}#{strMS}"
window.squareGrid = (n) ->
  #pick a row/column size to optimize holding n things while staying squarish
  rc = [1..Math.max(1,Math.floor(Math.sqrt(n)))]
  cr = (Math.max(1,Math.ceil(n/x)) for x in rc)
  score = (1/((1+rc[i]*cr[i]-n)*Math.pow(1+cr[i]-rc[i],3)) for i in [0..rc.length-1])
  iMax = 0
  iMax = i for i in [1..score.length-1] when score[i]>score[iMax]
  row = Math.min(rc[iMax], cr[iMax])
  col = Math.max(rc[iMax], cr[iMax])
  [row, col]
dec2frac = (x, tolerance=0.000001) ->
  ###adapted from http://jonisalonen.com/2012/converting-decimal-numbers-to-ratios/###
  [n1, n2] = [1, 0]
  [d1, d2] = [0, 1]
  b = x

  loop
    a = Math.floor(b)

    [n1, n2] = [a*n1+n2, n1]
    [d1, d2] = [a*d1+d2, d1]

    b = 1/(b - a)

    break if Math.abs(x-n1/d1) <= x*tolerance

  [n1, d1]

window.MRT = class MRT
  _seed_default: 'i am a seed'
  _seed: null

  _background: null

  _ready: false

  default_subject: ''

  subject: null
  csrf: null

  container: null
  el: null
  im: null

  background: null

  debug: false

  constructor: (options={}) ->
    @debug = options.debug ? false

    defaults = {
      seed: @_seed_default
      container: 'experiment'
      background: 'gray'
      background_stroke: 'none'
      default_subject: if @debug then 'test' else ''
      images: []
      loadimages: true
      fixation: ["Circle", [{color:"red", r:5}]]
      run_session: not @debug
    }

    options = merge defaults, options

    @setSeed(options.seed)

    @csrf = options.csrf
    @default_subject = options.default_subject
    @container = options.container
    @background = options.background

    @im = {}

    @paper = Raphael @container

    @show = @Show()
    @input = @Input()
    @time = @Time()
    @color = @Color()
    @exec = @Exec()
    @queue = @Queue()

    @_background = @show.Rectangle
      color: @background
      width: @width()
      height: @height()
      stroke: options.background_stroke
      "stroke-width": 16

    @data = @Data()
    @session = @Session()
    @param = @Param()
    @dbg = @Debugger()

    if options.loadimages
      images = options.images
      if images.length then @LoadImages(images)

    if options.run_session then @queue.add 'session_run', => @session.run()

    @ready(true)

  width: -> @paper.width
  height: -> @paper.height
  clear: -> @paper.clear()

  ready: (state=null) ->
    if state?
      @_ready = state
      if @_ready then @queue.do()
    @_ready

  resize: ->
    document.location.reload true

  LoadImages: (images) ->
    nLoaded = 0
    p = @show.Progress "Loading Images", steps:20
    fUpdate = => p.update ++nLoaded/images.length

    for idx in [0..images.length-1]
      f = if idx==images.length-1 then (=> fUpdate()) else fUpdate

      qName = "image_#{images[idx]}"
      @queue.add qName, f, {do:false}
      @im[images[idx]] = new Image()
      @im[images[idx]].src = images[idx]
      @im[images[idx]].onload = ((name) => => @queue.do name)(qName)

  visible: (state) ->
    elements = ["\##{@container}"]

    (if state then $(el).show() else $(el).hide()) for el in elements

  getSeed: () -> @_seed
  setSeed: (seed=null) ->
    if seed?
      @_seed = if seed.length>0 then seed else @_seed_default

    Math.seedrandom(@getSeed()) #requires seedrandom.js

  MRTClass: class MRTClass
    root: null

    constructor: (root) ->
      @root = root

  Show: -> new MRTClassShow(@)
  MRTClassShow: class MRTClassShow extends MRTClass

    Stimulus: (options={}, addDefaults=true) -> new @MRTClassShowStimulus(@root, options, addDefaults)
    MRTClassShowStimulus: class MRTClassShowStimulus extends MRTClass
      element: null

      handlers: null

      auto_scale: 0

      _rotation: 0
      _scale: 1
      _translation: [0, 0]

      _defaults: {
        x: 0
        y: 0
        width: 100
        height: 100
        color: "black"
      }

      _show_state: true
      _mousedown: null
      _mouseup: null
      _mouseover: null
      _mouseout: null

      constructor: (root, options, addDefaults) ->
        super root

        @handlers = {}

        options = @parseOptions options, {}, addDefaults

        @auto_scale = options.auto_scale ? 1


        @attr(name, value) for name, value of options

      parseOptions: (options, defaults={}, addDefaults=true) ->
        def = if addDefaults then merge(@_defaults, defaults) else copy(defaults)

        if options.l? and def.x? then delete def.x
        if options.t? and def.y? then delete def.y

        merge(def, options)

      H_STRINGS: ['width','x','cx','l','cl','lc','h']
      V_STRINGS: ['height','y','cy','t','ct','tc','v']
      isH: (type) -> @H_STRINGS.indexOf(type) isnt -1
      isV: (type) -> @V_STRINGS.indexOf(type) isnt -1
      addc: (x, type) -> if type[0]=='c' then "c#{x}" else x
      type2wh: (type) -> if @isH(type) then 'width' else 'height'
      type2xy: (type) -> @addc( (if @isH(type) then 'x' else 'y') , type)
      type2lt: (type) -> @addc( (if @isH(type) then 'l' else 't') , type)
      type2hv: (type) -> if @isH(type) then 'h' else if @isV(type) then 'v' else 'other'

      x2lc: (x) -> x + @root.width()/2
      lc2x: (l) -> l - @root.width()/2
      y2tc: (y) -> y + @root.height()/2
      tc2y: (t) -> t - @root.height()/2
      x2l: (x, width=null) -> @x2lc(x) - (width ? @attr("width"))/2
      l2x: (l, width=null) -> @lc2x(l) + (width ? @attr("width"))/2
      y2t: (y, height=null) -> @y2tc(y) - (height ? @attr("height"))/2
      t2y: (t, height=null) -> @tc2y(t) + (height ? @attr("height"))/2
      xy2lt: (v, xy) -> if @isH(xy) then @x2l(v) else @y2t(v)
      lt2xy: (v, xy) -> if @isH(xy) then @l2x(v) else @t2y(v)
      xy2ltc: (v, xy) -> if @isH(xy) then @x2lc(v) else @y2tc(v)
      ltc2xy: (v, xy) -> if @isH(xy) then @lc2x(v) else @tc2y(v)

      extent: (type) ->
        switch @type2hv(type)
          when 'h'
            @root.width()
          when 'v'
            @root.height()
          else
            (@root.height() + @root.width())/2

      norm2px: (x, type) -> x*@extent(type)
      px2norm: (x, type) -> x/@extent(type)

      maxBox: ->
        wTotal = @root.width()
        hTotal = @root.height()

        wMax = wTotal - 2*Math.abs(@attr('x'))
        hMax = hTotal - 2*Math.abs(@attr('y'))

        [@auto_scale*wMax, @auto_scale*hMax]

      attr: (name, value) ->
        switch name
          when "color"
            ret = @element.attr "fill", value
          when "width", "height"
            if value?
              if value=='auto'
                @attr('box',@maxBox())
              else
                sCur = @element.attr(name)
                @element.attr(name, value)

                xy = @type2xy(name)
                @attr xy, @attr(xy) - (value - sCur)/2
            else
              ret = @element.attr name
          when "x", "y"
            lt = @type2lt(name)
            if value?
              @attr lt, @xy2lt(value, name)
            else
              ret = @lt2xy(@attr(lt), name)
          when "l", "t"
            xy = @type2xy(name)

            if value?
              @element.attr(xy, value)
            else
              ret = @element.attr(xy)
          when "cx", "cy"
            wh = @type2wh(name)

            if value?
              @element.attr name, @xy2lt(value, name) + @attr(wh)/2
            else
              ret = @lt2xy(@element.attr(name), name) - @attr(wh)/2
          when "lc", "tc"
            lt = name[0]
            wh = @type2wh(name)

            if value?
              @attr lt, value - @attr(wh)/2
            else
              ret = @attr(lt) + @attr(wh)/2
          when "mousedown", "mouseup", "mouseover", "mouseout"
            if value?
              @["_#{name}"] = value
              @element[name](value)
            else
              ret = @["_#{name}"]
          when "box"
            w = @attr "width"
            h = @attr "height"
            ret = box = [w,h]

            if value?
              if not Array.isArray(value) then value = [value, value]

              r = divide(value,box)
              if r[0] < r[1]
                @attr "width", value[0]
                @attr "height", h*r[0]
              else
                @attr "width", w*r[1]
                @attr "height", value[1]
          when "show"
            if value?
              @_show_state = value
              if value then @element.show() else @element.hide()
            else
              ret = @_show_state
          else
            ret = @element.attr(name,value)

        if value? then @ else ret

      contain: ->
          wTotal = @root.width()
          hTotal = @root.height()

          w = @attr "width"
          h = @attr "height"
          l = @attr "l"
          t = @attr "t"

          if l+w > wTotal
            @attr "box", [Math.max(0,2*(wTotal-(l+w/2))), h]
          else if l < 0
            @attr "box", [Math.max(0,2*(l+w/2)), h]

          if t+h > hTotal
            @attr "box", [w, Math.max(0,2*(hTotal-(t+h/2)))]
          else if t < 0
            @attr "box", [w, Math.max(0,2*(t+h/2))]

      _settransform: ->
        @element.transform "r#{@_rotation},s#{@_scale},t#{@_translation}"

      rotate: (a, xc=null, yc=null) ->
        if xc? or yc?
          xc = xc ? @attr "x"
          yc = yc ? @attr "y"

          xDiff = (@attr "x") - xc
          yDiff = (@attr "y") - yc
          r = Math.sqrt(Math.pow(xDiff,2) + Math.pow(yDiff,2))
          theta = Math.atan2(yDiff, xDiff)
          theta += a*Math.PI/180

          @attr "x", r*Math.cos(theta) + xc
          @attr "y", r*Math.sin(theta) + yc

        @_rotation = (@_rotation + a) % 360
        @_settransform()

      scale: (s, xc=null, yc=null) ->
        if xc? or yc?
          xc = xc ? @attr "x"
          yc = yc ? @attr "y"

          xDiff = (@attr "x") - xc
          yDiff = (@attr "y") - yc
          r = Math.sqrt(Math.pow(xDiff,2) + Math.pow(yDiff,2))
          theta = Math.atan2(yDiff, xDiff)
          r *= s

          @attr "x", r*Math.cos(theta) + xc
          @attr "y", r*Math.sin(theta) + yc

        @_scale = s*@_scale
        @_settransform()

      translate: (x=0, y=0) ->
        @_translation[0] += x
        @_translation[1] += y
        @_settransform()

      remove: -> if @element? then @element.remove(); @element = null

      mousedown: (f) -> @attr "mousedown", f
      mouseup: (f) -> @attr "mouseup", f
      mouseover: (f) -> @attr "mouseover", f
      mouseout: (f) -> @attr "mouseout", f

      show: (state=null) -> @attr "show", state

      exists: () -> @element?

    CompoundStimulus: (elements, options={}) -> new @MRTClassShowCompoundStimulus(@root,elements,options)
    MRTClassShowCompoundStimulus: class MRTClassShowCompoundStimulus extends MRTClassShowStimulus
      _defaultElement: 0

      _background: null
      _backgroundOffset: 0

      constructor: (root, elements, options) ->
        options.background = options.background ? null
        @_backgroundOffset = options.background_offset ? 1

        @element = copy (if elements instanceof MRTClassShowCompoundStimulus then elements.element else elements)

        if options.background?
          if options.background==true then options.background = root.background
          @_background = root.show.Rectangle
            color: options.background

        super root, options, false

        if options.background?
          if @element.length>0 then @_background.element.insertBefore @element[0].element
          @updateBackground(['width','height','x', 'y', 'show','mousedown','mouseup','mouseover','mouseout'])

      attr: (name, value) ->
        switch name
          when "width", "height"
            xy = @type2xy(name)

            n = @element.length
            if n==0
              sCur = 0
              pMid = 0
            else
              sAll = (el.attr(name) for el in @element)
              pAll = (el.attr(xy) for el in @element)
              pLow = Math.min (pAll[i] - sAll[i]/2 for i in [0..n-1])...
              pHigh = Math.max (pAll[i] + sAll[i]/2 for i in [0..n-1])...
              pMid = (pLow+pHigh)/2
              sCur = pHigh - pLow

            if value?
              fSize = value/sCur
              if n>0
                @element[i].attr(name, fSize*sAll[i]) for i in [0..n-1]
                @element[i].attr(xy, fSize*(pAll[i]-pMid)+pMid) for i in [0..n-1]

                @updateBackground [name, xy]
            else
              ret = sCur
          when "l", "t"
            n = @element.length
            if n==0
              ret = pCur = switch name
                when "l"
                  @root.width()/2
                when "t"
                  @root.height()/2
                else
                  throw 'wtf?'
            else
              ret = pCur = Math.min (el.attr(name) for el in @element)...

            if value?
              pMove = value - pCur
              if n>0
                el.attr(name, el.attr(name)+pMove) for el in @element
                @updateBackground name
          when "cl", "ct"
            ret = @attr "#{name[1]}c", value
          when "box", "x", "y", "cx", "cy", "lc", "tc"
            ret = super name, value
            if value? then @updateBackground name
          when "element_mousedown"
            ffEvent = (elm) -> (e,x,y) -> value(elm,x,y)
            el.attr("mousedown",ffEvent(el)) for el in @element
            if @_background?
              @_background.attr "mousedown", ffEvent(@_background)
          else
            if value?

              el.attr(name, value) for el in @element

              switch name
                when 'show', 'mousedown', 'mouseup', 'mouseover', 'mouseout'
                  @updateBackground(name)
                else
                  null
            else
              ret = if @element.length>0 then @element[@_defaultElement].attr(name) else null

        if value? then @ else ret

      _settransform: -> el._settransform() for el in @element
      rotate: (a, xc=null, yc=null) ->
        xc = xc ? @attr 'x'
        yc = yc ? @attr 'y'

        @_rotation = (@_rotation + a) % 360
        el.rotate(a,xc,yc) for el in @element
      scale: (s, xc=null, yc=null) ->
        xc = xc ? @attr 'x'
        yc = yc ? @attr 'y'

        @_scale = s*@_scale
        el.scale(s,xc,yc) for el in @element

      remove: (el=null, removeElement=true) ->
        if el?
          if not (el instanceof MRTClassShowStimulus)
            idx = el
          else
            idx = find(@element,el)[0]

          if removeElement then @element[idx].remove()
          @element.splice(idx,1)
        else
          if removeElement then (el.remove() for el in @element)
          @element = []
        if @_background? then @_background.remove()
      exists: -> @element.length > 0

      addElement: (el) ->
        @element.push el
        if not @_show_state then el.show(false)
      removeElement: (el) ->
        idx = @getElementIndex(el)
        @element[idx].remove()
        @element.splice idx, 1
      getElement: (el) -> if el instanceof MRTClassShowStimulus then el else @element[el]
      getElementIndex: (el) -> if not (el instanceof MRTClassShowStimulus) then el else find(@element,el)[0]

      updateBackground: (param) ->
        if @_background?
          for p in forceArray(param)
            switch p
              when 'width', 'height'
                @_background.attr(p,Math.max(0,@attr(p)-2*@_backgroundOffset))
              when 'box'
                @updateBackground(['width','height'])
              when 'l', 't'
                @_background.attr(p,@attr(p)+@_backgroundOffset)
              else
                @_background.attr(p,@attr(p))

    StimulusGrid: (elements, options={}) -> new MRTClassShowStimulusGrid(@root,elements,options)
    MRTClassShowStimulusGrid: class MRTClassShowStimulusGrid extends MRTClassShowCompoundStimulus
      padding: null

      _attr: null

      constructor: (root, elements, options) ->
        options.width = options.width ? root.width()
        options.height = options.height ? root.height()
        @padding = options.padding ? 8

        @_attr = {
          width: options.width
          height: options.height
        }

        super root, elements, options

      attr: (name, value) ->
        switch name
          when 'width', 'height'
            if value?
              @_attr[name] = value
              @updatePositions()
            else
              ret = @_attr[name]
          else
            super name, value

        if value? then @ else ret

      addElement: (el) -> super el; @updatePositions()
      removeElement: (el) -> super el; @updatePositions()

      updatePositions: (w=null, h=null) ->
        n = @element.length

        [rows,cols] = squareGrid(n)

        w = w ? @attr 'width'
        h = h ? @attr 'height'

        wMax = w - (cols-1)*@padding
        hMax = h - (rows-1)*@padding

        wPer = wMax/cols
        hPer = hMax/rows
        #sPer = Math.min(wPer, hPer)

        wFinal = wPer*cols + @padding*(cols-1)
        hFinal = hPer*rows + @padding*(rows-1)

        for r in [0..rows-1]
          for c in [0..cols-1]
            idx = cols*r + c

            if idx<n
              x = -(wFinal-wPer)/2 + c*(wPer+@padding)
              y = -(hFinal-hPer)/2 + r*(hPer+@padding)

              @element[idx].attr 'box', [wPer, hPer]
              @element[idx].attr 'x', x
              @element[idx].attr 'y', y

    Choice: (elements, options={}) -> new MRTClassShowChoice(@root,elements,options)
    MRTClassShowChoice: class MRTClassShowChoice extends MRTClassShowCompoundStimulus
      choiceMade: false
      choice: null
      callback: null
      callback_delay: null

      timeout: null
      _tStart: 0
      _tChoice: 0

      _choiceInclude: null
      _instruction: null
      _padx: null
      _pady: null
      _autoposition: false
      _autosize: false
      _choiceLocation: null

      constructor: (root, elements, options) ->
        ###
          elements: an array of Stimulus objects
          options:
            instruct: the instruction to give
            autoposition: true to autoposition the elements
            autosize: true to autosize the choices
            choice_location: location of the choices (for autoposition). either
                             'middle' or 'bottom'
            choice_include: an array of indices of Stimulus objects to include
                            as choices
            callback: a function that takes this object and the chosen index as
                      inputs
            callback_delay: the delay, in milliseconds, before calling the
                            callback
            timeout: number of milliseconds before the choice times out
            pad: the padding in between each choice as a percentage of the total
                 canvas size
            padx: pad specifically for horizontal padding
            pady: pad specifically for vertical padding
        ###
        super root, elements, options

        options.instruct = options.instruct ? "Choose one."
        @_autoposition = options.autoposition ? true
        @_autosize = options.autosize ? true
        @_choiceLocation = options.choice_location ? 'middle'
        options.pad = options.pad ? null
        @_padx = options.padx ? (options.pad ? 5)
        @_pady = options.pady ? (options.pad ? 10)

        @callback = options.callback ? null
        @callback_delay = options.callback_delay ? 0
        @timeout = options.timeout ? null

        options.choice_include = options.choice_include ? [0..@element.length-1]
        @_choiceInclude = (@element[idx] for idx in options.choice_include)

        for idx in [0..@_choiceInclude.length-1]
          fDown = ((i) => (e,x,y) => @choiceEvent(i))(idx)
          @_choiceInclude[idx].mousedown fDown

        #add the instructions
        if options.instruct!=false
          @_instruction = root.show.Instructions options.instruct
          @element.push @_instruction

        @autoPosition()

        @_tStart = @root.time.Now()

        if @timeout? then window.setTimeout (=> @choiceEvent(null)), @timeout

      autoPosition: ->
        hInstruct = if @_instruction? then @_instruction.attr "height" else 0

        #get the maximum final element dimensions
        nEl = @_choiceInclude.length

        wTotal = @root.width()
        hTotal = @root.height()
        padWPx = wTotal*@_padx/100
        padHPx = hTotal*@_pady/100

        wFinalMax = Math.max(10,(wTotal - (nEl+1)*padWPx)/nEl)
        hFinalMax = Math.max(10,2*(hTotal/2 - hInstruct - padHPx))

        #maximum current dimensions
        elW = (el.attr "width" for el in @_choiceInclude)
        elH = (el.attr "height" for el in @_choiceInclude)
        wMax = Math.max(elW...)
        hMax = Math.max(elH...)

        #scale the elements
        if @_autosize
          #target scale
          wScale = wFinalMax/wMax
          hScale = hFinalMax/hMax
          scale = Math.min(wScale,hScale)

          for el in @_choiceInclude
            el.attr "box", [scale*el.attr("width"), scale*el.attr("height")]

          elW = (el.attr "width" for el in @_choiceInclude)
          elH = (el.attr "height" for el in @_choiceInclude)
          wMax = Math.max(elW...)
          hMax = Math.max(elH...)


        #line up the choices
        if @_autoposition
          yChoice = switch @_choiceLocation
            when 'middle' then 0
            when 'bottom' then (hTotal-hMax)/2-padHPx
            else throw 'Invalid choice location'

          wTotal = sum(elW) + padWPx*(nEl-1) - elW[0]/2 - elW[-1..]/2
          xCur = -wTotal/2
          for el,idx in @_choiceInclude
            el.attr "x", xCur
            el.attr "y", yChoice
            xCur += elW[idx] + padWPx

        #position the instructions
        if @_instruction?
          yInstruct = switch @_choiceLocation
            when 'middle' then hMax/2+padHPx
            when 'bottom' then 0
            else throw 'Invalid choice location'

          @_instruction.attr "y", yInstruct

      choiceEvent: (idx) ->
        if not @choiceMade
          @_tChoice = @root.time.Now()
          @choiceMade = true
          @choice = idx
          if @callback? then window.setTimeout (=> @callback(@,idx)), @callback_delay

    Test: (elements, options={}) -> new MRTClassShowTest(@root,elements,options)
    MRTClassShowTest: class MRTClassShowTest extends MRTClassShowChoice
      correct: null

      constructor: (root,elements, options={}) ->
        ###
          elements: an array of Stimulus objects
          options:
            correct: the index of the correct choice / array of indices. if this
                     is unspecified, then each Stimulus object should have a
                     boolean property named "correct" the specifies whether the
                     Stimulus is a correct choice.
        ###
        @root = root

        options.correct = forceArray(options.correct ? null)

        super root, elements, options

        #record which choices are correct
        if options.correct?
          el.correct=false for el in @element
          @element[idx].correct=true for idx in options.correct

      choiceEvent: (idx) ->
        @correct = if idx? then @element[idx].correct else false
        super idx

    Dialog: (prompt,choices,options={}) -> new MRTClassShowDialog(@root,prompt,choices,options)
    MRTClassShowDialog: class MRTClassShowDialog extends MRTClassShowChoice
      _userCallback: null

      constructor: (root, prompt, choices, options) ->
        options.autosize = options.autosize ? false
        options['font-size'] = options['font-size'] ? 48

        choice = []
        for ch in choices
          choice.push root.show.Link 'javascript:void(0)', ch,
            'font-size': options['font-size']

        options.instruct = prompt
        options.choice_location = options.choice_location ? 'bottom'

        @_userCallback = options.callback
        options.callback = (choice,idx) =>
          choice.remove()
          if @_userCallback? then @runUserCallback(idx)

        super root, choice, options

      runUserCallback: (idx) -> @_userCallback(idx)

    YesNo: (prompt,options={}) -> new MRTClassShowYesNo(@root,prompt,options)
    MRTClassShowYesNo: class MRTClassShowYesNo extends MRTClassShowDialog
      constructor: (root,prompt,options) ->
        super root, prompt, ['YES','NO'], options

      runUserCallback: (idx) -> @_userCallback(idx==0)

    Ok: (prompt,options={}) -> new MRTClassShowOk(@root,prompt,options)
    MRTClassShowOk: class MRTClassShowOk extends MRTClassShowDialog
      constructor: (root,prompt,options) ->
        super root, prompt, ['OK'], options

      runUserCallback: (idx) -> @_userCallback()

    Rectangle: (options={}) -> new MRTClassShowRectangle(@root,options)
    MRTClassShowRectangle: class MRTClassShowRectangle extends MRTClassShowStimulus
      constructor: (root,options) ->
        @root = root

        options = @parseOptions options
        options.stroke = options.stroke ? "none"

        l = @x2l(options.x, options.width)
        t = @y2t(options.y, options.height)
        w = options.width
        h = options.height

        @element = root.paper.rect l, t, w, h
        options = remove options, ['width', 'height', 'x', 'y']

        super root, options, false

    Square: (options={}) -> new MRTClassShowSquare(@root,options)
    MRTClassShowSquare: class MRTClassShowSquare extends MRTClassShowRectangle
      constructor: (root,options) ->
        @root = root

        if options.width? then options.height = options.width
        if options.height? then options.width = options.height
        options = @parseOptions options

        super root, options

      attr: (name, value) ->
        switch name
          when "length", "width", "height"
            super "width", value
            super "height", value
          else
            super name, value

    Circle: (options={}) -> new MRTClassShowCircle(@root,options)
    MRTClassShowCircle: class MRTClassShowCircle extends MRTClassShowStimulus
      constructor: (root,options) ->
        @root = root

        options = @parseOptions options, {
          r: @_defaults.width/2
        }

        cl = @x2l(options.x, 2*options.r) + options.r
        ct = @y2t(options.y, 2*options.r) + options.r
        r = options.r

        @element = root.paper.circle cl, ct, r
        options = remove options, ['x', 'y', 'r', 'width', 'height']

        super root, options, false
        @element.attr "stroke", "none"

      attr: (name, value) ->
        switch name
          when "width", "height"
            if value?
              if value=='auto' then super(name, value) else super("r", value/2)
            else
              2*super("r")
          when "l", "t"
            xy = "c#{@type2xy(name)}"
            wh = @type2wh(name)

            if value?
              @element.attr(xy, value + @attr(wh)/2)
            else
              ret = @element.attr(xy) - @attr(wh)/2
          else
            super name, value

    Text: (text, options={}) -> new MRTClassShowText(@root,text,options)
    MRTClassShowText: class MRTClassShowText extends MRTClassShowStimulus
      _max_width: 0
      _max_height: 0

      constructor: (root, text, options) ->
        @root = root

        @element = root.paper.text 0,0,text

        options = @parseOptions options, {
          "font-family": "Arial"
          "font-size": 18
          "text-anchor": "middle"
          "max-width": root.width()
          "max-height": root.height()
        }

        options = remove options, ['width', 'height']

        super root, options, false

      attr: (name, value) ->
        switch name
          when "l"
            ta = @attr "text-anchor"
            switch ta
              when "middle"
                if value?
                  super(name, value + @attr('width')/2)
                else
                  ret = super(name) - @attr('width')/2
              else
                ret = super name, value
          when "t"
            if value?
              tActual = Math.min(@root.height()-@attr("height")/2,value+@attr("height")/2)
              super name, tActual
            else
              ret = super(name)-@attr("height")/2
          when "width", "height"
            if value?
              if value=='auto'
                super name, value
              else
                sCur = @attr name
                f = value / sCur

                fontSize = @attr 'font-size'
                fontSizeNew = f*fontSize

                @attr "font-size", fontSizeNew
            else
              ret = @element.getBBox()[name]
          when "font-size"
            if value?
              x = @attr "x"
              y = @attr "y"

              super name, value

              @attr "x", x
              @attr "y", y
            else
              ret = super name
          when "max-width"
            if value?
              @_max_width = value

              if @attr("width") > @_max_width then @attr("width",@_max_width)
            else
              ret = @_max_width
          when "max-height"
            if value?
              @_max_height = value

              if @attr("height") > @_max_height then @attr("height",@_max_height)
            else
              ret = @_max_height
          else
            ret = super name, value

        if value? then @ else ret

    Instructions: (text, options={}) -> new MRTClassShowInstructions(@root, text, options)
    MRTClassShowInstructions: class MRTClassShowInstructions extends MRTClassShowText
      constructor: (root, text, options) ->
        @root = root

        options = @parseOptions options, {
          "font-family": "Arial"
          "text-anchor": 'middle'
          "font-size": 36
        }

        super root, text, options

    Link: (url, text, options={}) -> new MRTClassShowLink(@root,url,text,options)
    MRTClassShowLink: class MRTClassShowLink extends MRTClassShowText
      color: null
      colorHover: null

      constructor: (root, url, text, options) ->
        options.href = url
        @color = options.color = options.color ? 'blue'
        @colorHover = options.color_hover ? 'deepskyblue'
        options.mouseover = => @attr 'color', @colorHover
        options.mouseout = => @attr 'color', @color

        super root, text, options

    Timer: (tTotal, options={}) -> new MRTClassShowTimer(@root, tTotal, options)
    MRTClassShowTimer: class MRTClassShowTimer extends MRTClassShowText
      tTotal: 0
      tTimer: null
      tGo: null

      name: null

      showms: false
      prefix: null
      suffix: null

      _timeout: null
      _initialized: false
      _intervalID: null

      _setTimer: (t) ->
        @tTimer.set t
        @render()

      constructor: (root, tTotal, options) ->
        options.initialize = options.initialize ? true

        @tTotal = tTotal
        @name = options.name ? 'timer'
        @showms = options.showms ? false
        @prefix = options.prefix ? null
        @suffix = options.suffix ? 'remaining'
        @tUpdate = options.update_interval ? (if @showms then 10 else 250)

        @_timeout = options.timeout ? null

        super root, '', options

        if options.initialize then @initialize()


      initialize: ->
        if not @_initialized
          @tTimer = @root.data.Variable "#{@name}_remaining", @tTotal,
            timeout: @_timeout
            callback: (t) => @render()

          @_initialized = true

        @render()

      remaining: ->
        if @_initialized
          Math.max(0,if @tGo? then (@tTimer.get()-(@root.time.Now()-@tGo)) else @tTimer.get())
        else
          0

      nextReset: -> @tTimer.nextReset()

      string: ->
        strTime = time2str(@remaining(),@showms)

        prefix = if @prefix? then "#{@prefix}: " else ''
        suffix = if @suffix? then " #{@suffix}" else ''
        "#{prefix}#{strTime}#{suffix}"

      render: -> @attr "text", @string()

      update: ->
        if @remaining()<=0 then @stop()
        @render()

      go: ->
        @tGo = @root.time.Now()
        @_intervalID = window.setInterval (=> @update()), @tUpdate

      stop: ->
        if @_intervalID? then clearInterval(@_intervalID)
        tRemain = @remaining()
        @tGo = null
        @_setTimer(tRemain)

    ItemList: (items={}, options={}) -> new MRTClassShowItemList(@root, items, options)
    MRTClassShowItemList: class MRTClassShowItemList extends MRTClassShowText
      _items: null

      constructor: (root, items, options) ->
        options['font-size'] = options['font-size'] ? 12

        super root, '', options

        @set items

      set: (items) ->
        @_items = items
        @render()

      add: (key, content) ->
        @_items[key] = content
        @render()

      remove: (key) ->
        delete @_items[key]
        @render()

      render: ->
        content = (val for key,val of @_items)
        t = @attr 't'
        @attr 'text', content.join("\n")
        @attr 't', t

    Path: (path, options={}) -> new MRTClassShowPath(@root, path, options)
    MRTClassShowPath: class MRTClassShowPath extends MRTClassShowStimulus
      _param: null

      constructor: (root, path, options) ->
        @root = root

        options.width = options.width ? 100
        options.height = options.height ? 100
        options['stroke-width'] = options['stroke-width'] ? 0

        bWidthAuto = options.width=='auto'
        bHeightAuto = options.height=='auto'
        bAuto = bWidthAuto or bHeightAuto

        if bWidthAuto
          if not bHeightAuto
            options.width = options.height
          else
            options.width = 100
            options.height = 100
        else if bHeightAuto
          options.height = options.width

        @_param = {
          path: path
          width: options.width
          height: options.height
          l: (root.width()-options.width)/2
          t: (root.height()-options.height)/2
          orientation: 0
        }

        @element = root.paper.path(@constructPath(null,false))

        options = remove options, ['width', 'height']
        super root, options, false

        if bAuto then @attr('width', 'auto')

      _bottomRightCorner: ->
        p = [@_param.width/2, @_param.height/2]
        rotate(p, @_param.orientation)
      _topRightCorner: ->
        p = [@_param.width/2, -@_param.height/2]
        rotate(p, @_param.orientation)
      _maxExtent: (idx) ->
        2*Math.max(Math.abs(@_bottomRightCorner()[idx]),Math.abs(@_topRightCorner()[idx]))

      rotatedWidth: -> @_maxExtent(0)
      rotatedHeight: -> @_maxExtent(1)

      attr: (name, value) ->
        switch name
          when "path", "width", "height", "l", "t", "orientation"
            if value?
              if value=='auto'
                super name, value
              else
                p = {}
                p[name] = value

                if name=='width'
                  p.l = @_param.l + (@_param.width-value)/2
                else if name=='height'
                  p.t = @_param.t + (@_param.height-value)/2

                @constructPath(p)
            else
              ret = @_param[name]
          else
            ret = super name, value

        if value? then @ else ret

      rotate: (a,xc=null,yc=null) ->
        if xc? or yc?
          xc = xc ? @attr "x"
          yc = yc ? @attr "y"

          xDiff = (@attr "x") - xc
          yDiff = (@attr "y") - yc
          r = Math.sqrt(Math.pow(xDiff,2) + Math.pow(yDiff,2))
          theta = Math.atan2(yDiff, xDiff)
          theta += a*Math.PI/180

          @attr "x", r*Math.cos(theta) + xc
          @attr "y", r*Math.sin(theta) + yc

        @attr "orientation", @attr("orientation")+a

      constructPath: (param={}, setPath=true) ->
        @_param[p]=v for p,v of param

        s = [@_param.width, @_param.height]
        offset = [@_param.l, @_param.t]

        a = @_param.orientation

        origin = add(mult(rotate([0,0],a,[0.5,0.5]),s),offset)
        path = "M" + origin

        for op in @_param.path
          path += op[0]
          if op.length>1
            for idx in [1..op.length-1] by 2
              f = rotate( op[idx..idx+1], a, [0.5,0.5] )
              p = add( mult(f,s) , offset )
              path += p + ","
        if setPath then @element.attr "path", path else path

    X: (options={}) -> new MRTClassShowX(@root, options)
    MRTClassShowX: class MRTClassShowX extends MRTClassShowPath
      constructor: (root, options) ->
        options.width = options.width ? 16
        options.height = options.height ? 16
        options['stroke-width'] = options['stroke-width'] ? 4

        path = [['M',0,0],['L',1,1],['M',0,1],['L',1,0]]
        super root, path, options

    Image: (src, options={}) -> new MRTClassShowImage(@root, src, options)
    MRTClassShowImage: class MRTClassShowImage extends MRTClassShowStimulus
      constructor: (root, src, options) ->
        @root = root

        bAutoSize = src of @root.im
        options = @parseOptions options, {
          width: if bAutoSize then @root.im[src].width else @_defaults.width
          height: if bAutoSize then @root.im[src].height else @_defaults.height
        }

        l = @x2l(options.x, options.width)
        t = @y2t(options.y, options.height)
        w = options.width
        h = options.height

        @element = @root.paper.image src, l, t, w, h
        options = remove options, ['x', 'y', 'width', 'height']

        super root, options, false

      attr: (name, value) ->
        switch name
          when "color"
            null
          else
            super name, value

    ColorMask: (src, options={}) -> new MRTClassShowColorMask(@root,src,options)
    MRTClassShowColorMask: class MRTClassShowColorMask extends MRTClassShowCompoundStimulus
      _im: null

      constructor: (root, src, options) ->
        @root = root

        bAutoSize = src of root.im
        options = @parseOptions options, {
          width: if bAutoSize then root.im[src].width else @_defaults.width
          height: if bAutoSize then root.im[src].height else @_defaults.height
        }

        if options.color != "none" then options.background = options.color

        options = remove options, ['color']

        @_im = root.show.Image src

        super root, [@_im], options

      attr: (name, value) ->
        switch name
          when "color"
            if @_background? then ret = @_background.attr name, value
          else
            ret = super name, value

        if value? then @ else ret

    Progress: (info, options={}) -> new MRTClassShowProgress(@root,info,options)
    MRTClassShowProgress: class MRTClassShowProgress extends MRTClassShowCompoundStimulus
      _steps: 0
      _width: 0

      constructor: (root, info, options) ->
        @root = root

        options = @parseOptions options, {
          width: 300
          steps: 10
          color: "red"
          r: 5
        }

        @_steps = options.steps
        @_width = options.width

        elements = [root.show.Instructions info]

        for i in [0..@_steps-1]
          bit = root.show.Circle {r: options.r}
          bit.show(false)
          elements.push(bit)

        delete options.r

        super root, elements, options

      attr: (name, value) ->
        switch name
          when "steps"
            ret = @_steps
          when "width"
            ret = Math.max(@_width, @element[0].attr "width")
          when "height"
            bottom = @element[@_steps].attr("y") + @element[@_steps].attr("height")
            top = @element[0].attr("y") - @element[0].attr("height")/2
            ret = bottom - top
          when "x"
            if value?
              @element[0].attr name, value
              @element[k].attr name, -@_width/2 + (k-1)*@_width/(@_steps-1) for k in [1..@_steps]
            else
              ret = @element[0].attr name
          when "y"
            if value?
              @element[0].attr name, value-32
              @element[k].attr name, value for k in [1..@_steps]
            else
              ret = @element[@_steps].attr name
          when "color"
            if value?
              colBase = Raphael.color(value)
              @element[k].attr "color", "rgba(#{colBase.r},#{colBase.g},#{colBase.b},#{k/@_steps})" for k in [1..@_steps]
            else
              ret = @element[@_steps].attr name
          when "r"
            if value?
              @element[k].attr "r", value for k in [1..@_steps]
            else
              ret = @element[@_steps-1].attr name
          else
            ret = super name, value

        if value? then @ else ret

      update: (f) ->
        f = Math.min(1,Math.max(0,f))
        kLast = Math.round(@_steps*f)
        if kLast>0 then @element[k].show(true) for k in [1..kLast]
        if kLast<@_steps then @element[k].show(false) for k in [kLast+1..@_steps]

        if f>=1 then @remove()

    SMFigure: (idx, options={}) -> new MRTClassShowSMFigure(@root,idx,options)
    MRTClassShowSMFigure: class MRTClassShowSMFigure extends MRTClassShowCompoundStimulus
      _unit_cube: [
        [[1,0,1],[1,1,1],[1,1,0],[1,0,0]],
        [[0,0,1],[1,0,1],[1,0,0],[0,0,0]],
        [[0,1,1],[0,0,1],[0,0,0],[0,1,0]],
        [[1,1,1],[0,1,1],[0,1,0],[1,1,0]],
        [[0,0,1],[0,1,1],[1,1,1],[1,0,1]],
        [[1,0,0],[1,1,0],[0,1,0],[0,0,0]],
      ]

      _unit_size: null

      constructor: (root, idx, options) ->
        @root = root

        options.color = options.color ? 'white'
        options['stroke-width'] = options['stroke-width'] ? 4
        options['stroke-linejoin'] = 'round'
        options.cube_size = options.cube_size ? 50
        options.theta = options.theta ? []
        options.flip = options.flip ? [false, false, false]

        options.theta.unshift ['x',180]
        options.theta.push ['z',-30]
        options.theta.push ['y',-15]

        path = @_idx2path(idx,options.theta,options.flip)

        path_options = remove(options,['cube_size','flip','theta'])

        el = (root.show.Path(p,path_options) for p in path)

        super root, el, remove(options,['color','stroke-width','stroke-linejoin','flip','theta'])

      attr: (name, value) ->
        switch name
          when "cube_size"
            if value?
              super 'box', @_unit_size*value
            else
              ret = super('box')/@_unit_size
          else
            ret = super name, value

        if value? then @ else ret

      _mmult3dRecursive: (X,M) ->
        if !Array.isArray(X[0])
          (X[0]*m[0]+X[1]*m[1]+X[2]*m[2] for m in M)
        else
          (@_mmult3dRecursive(x,M) for x in X)
      _smultRecursive: (X,s) ->
        if !Array.isArray(X[0])
          smult(X,s)
        else
          (@_smultRecursive(x,s) for x in X)
      _paddRecursive: (X,M) ->
        if !Array.isArray(X[0])
          (X[i]+M[i] for i in [0..X.length-1])
        else
          (@_paddRecursive(x,M) for x in X)
      _extentRecursive: (X, pMin=null, pMax=null) ->
        if !Array.isArray(X[0])
          if pMin?
            for idx in [0..X.length-1]
              pMin[idx] = Math.min(pMin[idx],X[idx])
              pMax[idx] = Math.max(pMax[idx],X[idx])
            [pMin, pMax]
          else
            [X.slice(0), X.slice(0)]
        else
          for x in X
            [pMin, pMax] = @_extentRecursive(x,pMin,pMax)
          [pMin, pMax]

      _cossin: (theta) ->
        a = theta*Math.PI/180
        [Math.cos(a), Math.sin(a)]
      _rotate3dX: (P,theta) ->
        [c,s] = @_cossin(theta)
        @_mmult3dRecursive(P,[[1,0,0],[0,c,-s],[0,s,c]])
      _rotate3dY: (P,theta) ->
        [c,s] = @_cossin(theta)
        @_mmult3dRecursive(P,[[c,0,s],[0,1,0],[-s,0,c]])
      _rotate3dZ: (P,theta) ->
        [c,s] = @_cossin(theta)
        @_mmult3dRecursive(P,[[c,-s,0],[s,c,0],[0,0,1]])
      _rotate3d: (P,theta) ->
        for t in theta
          P = switch t[0].toLowerCase()
            when 'x' then @_rotate3dX(P,t[1])
            when 'y','f' then @_rotate3dY(P,t[1])
            when 'z','l' then @_rotate3dZ(P,t[1])
            when 'b' then @_rotate3dY(P,-t[1])
            when 'r' then @_rotate3dZ(P,-t[1])
            else
              throw 'invalid rotation type'
        P
      _flip: (p,flip) -> ( (if flip[i] then -1 else 1)*p[i] for i in [0..p.length-1] )

      _idx2path: (idx,theta,flip) ->
        pos = @root.param.sm_figure[idx]

        fig = @_pos2figure(pos,flip)
        fig = @_rotate3d(fig,theta)
        fig = @_sortCubes(fig)
        proj = @_projectFigure(fig)
        proj = @_scaleProjection(proj)
        path = @_projection2path(proj)

        path

      _pos2cube: (p) ->
        @_paddRecursive(@_unit_cube,p)
      _pos2figure: (P,flip) ->
        (@_pos2cube(@_flip(p,flip)) for p in P)
      _sortCubes: (fig) ->
        fig = (@_sortSides(cube) for cube in fig)

        fig = ([cube,@_cubeX(cube)] for cube in fig)
        fig.sort((x,y) -> x[1]-y[1])
        (cube[0] for cube in fig)
      _sortSides: (cube) ->
        cube = ([side,@_sideX(side)] for side in cube)
        cube.sort((x,y) -> x[1]-y[1])
        (side[0] for side in cube)
      _sideX: (side) ->
        mean((edge[0] for edge in side))
      _cubeX: (cube) ->
        mean(@_sideX(side) for side in cube)
      _projectFigure: (fig) ->
        if !Array.isArray(fig[0])
          [fig[1],fig[2]]
        else
          (@_projectFigure(p) for p in fig)
      _scaleProjection: (proj) ->
        [pMin,pMax] = @_extentRecursive(proj)

        pSub = smult(pMin,-1)
        proj = @_paddRecursive(proj, pSub)

        @_unit_size = Math.max(sub(pMax,pMin)...)
        sDiv = 1/@_unit_size
        proj = @_smultRecursive(proj, sDiv)

        proj
      _projection2path: (proj) ->
        [].concat (@_cube2path(cube) for cube in proj)...
      _cube2path: (cube) ->
        (@_side2path(side) for side in cube)
      _side2path: (side) ->
        [
          ['M',1-side[0][0],side[0][1]],
          ['L',1-side[1][0],side[1][1]],
          ['L',1-side[2][0],side[2][1]],
          ['L',1-side[3][0],side[3][1]],
          ['L',1-side[0][0],side[0][1]]
        ]


  Input: -> new MRTClassInput(@)
  MRTClassInput: class MRTClassInput extends MRTClass
    _event_handlers: null

    _handler_count: 0

    constructor: (root) ->
      super root

      #initialize the object to store the handlers
      @_event_handlers = {}

      #register to handle key and mouse events
      $(document).keydown( (evt) => @_handleKey(evt,'down') )
      $("\##{@root.container}").mousedown( (evt) => @_handleMouse(evt,'down') )

    _touchHandlerType: (handlerType) ->
      if not (handlerType of @_event_handlers)
        @_event_handlers[handlerType] = {}

    _getHandlerType: (type, subType) ->
      handlerType = "#{type}_#{subType}"
      @_touchHandlerType(handlerType)
      handlerType

    _getHandlerID: (handlerType, key) -> [handlerType, key]

    _handleEvent: (evt, handlerType, fCheckHandler) ->
      handlers = @getHandler([handlerType])

      for key,handler of handlers
        #execute the handler
        if fCheckHandler(evt, handler)
          handler.f(evt)
          handler.count++

        #remove the handler if expired
        if handler.expires!=0 and handler.count>=handler.expires
          @removeHandler(@_getHandlerID(handlerType, key))

    _checkHandlerKeyMouse: (evt, handler) ->
      contains(handler.button,'any') or contains(handler.button,evt.which)

    _handleKey: (evt, subType) ->
      handlerType = @_getHandlerType('key', subType)
      @_handleEvent(evt,handlerType,@_checkHandlerKeyMouse)

    _handleMouse: (evt, subType) ->
      handlerType = @_getHandlerType('mouse', subType)
      @_handleEvent(evt,handlerType,@_checkHandlerKeyMouse)

    addHandler: (type,options=null) ->
      ###add an event handler and return an id for the handler
        type: the type of event to handle. one of the following:
          key: a keyboard event
          mouse: a mouse event
        options:
          f: a function to call when the event occurs. takes the event info as
            input
          expires:  remove the handler after <expires> events, or 0 to never
            expire
          <for key/mouse>:
            sub_type:  the subtype of event to handle. one of the following:
              down: fire handler on key/mouse down
            button: the name of the button that must be pressed for the event to
              fire, or an array of buttons, any one of which will fire the
              event, or 'any' to fire the event for any key/mouse button


      ###
      if not options? then options={}

      #common options
      options.f = options.f ? null
      options.expires = options.expires ? 0

      #type specific options
      switch type
        when 'key', 'mouse'
          options.sub_type = options.sub_type ? 'down'
          options.button = forceArray(@key2code(options.button ? 'any'))
        else
          throw "invalid handler type"

      #record of events handled
      options.count = 0

      handlerType = @_getHandlerType(type,options.sub_type)
      key = @_handler_count++

      @_event_handlers[handlerType][key] = options

      @_getHandlerID(handlerType,key)

    removeHandler: (ID) ->
      handlerType = ID[0]
      key = ID[1]
      delete @_event_handlers[handlerType][key]

    getHandler: (ID) ->
      handlerType = ID[0]
      if ID.length>1
        key = ID[1]
        @_event_handlers[handlerType][key]
      else
        @_event_handlers[handlerType]

    key2code: (key) ->
      if Array.isArray(key)
        (@key2code(k) for k in forceArray(key))
      else
        switch key
          when 'any'   then 'any'
          when 'enter' then 13
          when 'left'  then 37
          when 'up'    then 38
          when 'right' then 39
          when 'down'  then 40
          else
            if (typeof key)=='string'
              key.toUpperCase().charCodeAt(0)
            else
              key

    code2key: (code) ->
      switch code
        when 13 then 'enter'
        when 37 then 'left'
        when 38 then 'up'
        when 39 then 'right'
        when 40 then 'down'
        else
          if getClass(code)=='String'
            code
          else
            String.fromCharCode(code).toLowerCase()

    mouse2code: (button) ->
      if Array.isArray(button)
        (@mouse2code(b) for b in button)
      else
        switch button
          when 'any'    then 'any'
          when 'left'   then 1
          when 'middle' then 2
          when 'right'  then 3
          else throw "invalid button"

    code2mouse: (code) ->
      switch code
        when 1 then 'left'
        when 2 then 'middle'
        when 3 then 'right'
        else
          if getClass(code)=='String'
            code
          else
            throw 'invalid code'

  Time: -> new MRTClassTime(@)
  MRTClassTime: class MRTClassTime extends MRTClass

    Now: -> new Date().getTime()

    Pause: (ms) ->
      tStart = @Now()
      null while @Now()<tStart+ms

  Color: -> new MRTClassColor(@)
  MRTClassColor: class MRTClassColor extends MRTClass
    colors: {
      default: [
        'crimson'
        'red'
        'tomato'
        'orangered'
        'orange'
        'gold'
        'yellow'
        'chartreuse'
        'lime'
        'limegreen'
        'springgreen'
        'aqua'
        'turquoise'
        'deepskyblue'
        'blue'
        'darkviolet'
        'magenta'
        'deeppink'
      ]
    }

    constructor: (root) ->
      super root

      @colors['difficulty'] = ['blue','limegreen','gold','orange','red']

    pick: (colorSet='default', interpolate=false) ->
      if interpolate
        @blend @colors[colorSet], Math.random()
      else
        nColor = @colors[colorSet].length
        iColor = Math.floor(Math.random()*nColor)
        @colors[colorSet][iColor]

    blend: (colorSet='default', f) ->
      nColor = @colors[colorSet].length

      iBlend = Math.max(0,Math.min(nColor-1,f*(nColor-1)))
      iFrom = Math.floor(iBlend)
      iTo = Math.min(nColor-1,iFrom + 1)

      fBlend = iBlend - iFrom

      colFrom = Raphael.color(@colors[colorSet][iFrom])
      colTo = Raphael.color(@colors[colorSet][iTo])

      r = (1-fBlend)*colFrom.r + fBlend*colTo.r
      g = (1-fBlend)*colFrom.g + fBlend*colTo.g
      b = (1-fBlend)*colFrom.b + fBlend*colTo.b

      Raphael.color("rgb(#{r},#{g},#{b})")

  Exec: -> new MRTClassExec(@)
  MRTClassExec: class MRTClassExec extends MRTClass

    Sequence: (name, fStep, next, options={}) -> new MRTClassExecSequence(@root,name,fStep,next,options)
    MRTClassExecSequence: class MRTClassExecSequence extends MRTClass
      _fStep: null
      _fQueueStep: null
      _next: null

      _timer: null

      _tStart: null
      _tStep: null

      _fSequencePre: null
      _fSequencePost: null
      _fStepPre: null
      _stepWait: null
      _fStepPost: null

      name: ''
      description: ''

      time_mode: null

      sequence_pre: null
      sequence_post: null

      finished: false
      result: null

      constructor: (root, name, fStep, next, options) ->
        ###
          name: unique name for the sequence
          fStep: array specifying the function to execute at each step. each
            function takes this object and the current step index as input.
          next: array of:
            time: time to move on to the next step
            key: a key that must be down to move on
            f: a function that takes the sequence and step start times and
              returns true to move on
            ['key'/'mouse', options]: specify input event that must occur. see
              MRTClassInput.addHandler for options.
            ['event', f] specify a function that will register an event that
              will call the function to move to the next step
            ['lazy', f] specify a function that will be called after the step is
              executed, take this object and the current step index as inputs,
              and return one of the above
          options:
            description: a description of the sequence
            execute:  true to execute the sequence immediately
            time_mode: the time mode ('step', 'sequence', or 'absolute'):
              step: times are relative to the start of the step
              sequence: times are relative to the start of the sequence
              absolute: times are absolute
            sequence_pre: a function to call immediately before the first step
              executes. takes this object as input. the output is stored in
              @sequence_pre.
            sequence_post: a function to call after the sequence finishes. takes
              this object as input. the output is stored in @sequence_post.
            step_pre: an array of functions to call before each step is
              executed. each function takes this object and the current step
              index as input. the first step's function is called immediately
              after the sequence begins. other steps' functions are called
              immediately after the previous step is executed. output is stored
              in @result[i].pre.
            step_wait: an array of elements that specify what to do while
              waiting for the next stimulus step. outputs are stored in
              @result[i].wait. each element should be one of the following:
                str: a string/array of strings specifying keys to listen for
                ['key'/'mouse', options]: an input event to listen for. see
                  MRTClassInput.addHandler for options. if function is specified
                  using options.f, it will receive this object, the event info,
                  and the current step index as inputs.
            step_post: an array of functions to call after each step is
              executed. each function takes this object and the current step
              index as input. the last step's function is called immediately
              before the sequence ends. other steps' functions are called
              immediately before the next step is executed. output is stored in
              @result[i].post.

          Note: the results of the sequence are stored in array @result:
            .pre: output from the step's pre function call
            .wait: outputs from the step's wait procedure
            .output: output from the step's function call
            .post: output from the step's post function call
            .t.start: time at which the step started
            .t.end: time at which the step ended
        ###
        super root

        @name = name
        @description = options.description ? @_name

        @_fSequencePre = options.sequence_pre ? null
        @_fSequencePost = options.sequence_post ? null
        @_fStepPre = options.step_pre ? (null for step in fStep)
        @_stepWait = options.step_wait ? (null for step in fStep)
        @_fStepPost = options.step_post ? (null for step in fStep)

        do_execute = options.execute ? true
        @time_mode = options.time_mode ? 'step'

        @_fStep = fStep
        @_next = next

        @_prepare_sequence()

        if do_execute then @Execute()

      ###number of milliseconds to wait before executing the next step###
      _delay_time: (t) ->
        tExec = switch @time_mode
          when "step" then @_tStep + t
          when "relative" then @_tStart + t
          when "absolute" then t
          else throw "invalid time mode"

        tExec - @root.time.Now()

      ###should the next step be executed?###
      _check_next: (fCheck, fStep) ->
        if fCheck(@_tStart, @_tStep)
          clearInterval(@_timer)
          fStep()

      _prepare_sequence: ->
        nStep = @_fStep.length

        #include one extra step for post-processing
        @_fQueueStep = []
        for idx in [0..nStep]
          #step name
          stepName = "#{@_name}_#{idx}"

          #add the step to the queue
          @root.queue.add stepName, ((i) => => @_process_step(i))(idx),
            do: false

          #get a function to execute the step
          @_fQueueStep.push ((step) => => @root.queue.do(step))(stepName)

        @result = ({t:{}} for [0..nStep-1])

      _process_step: (idx) ->
        nStep = @_fStep.length

        #end the last step or start the sequence
        if idx>0
          @_do_step_post(idx-1)
        else
          @_do_sequence_pre()
          @_do_step_pre(idx)

        @_tStep = @root.time.Now()

        #execute the step or end the sequence
        if idx==nStep
          @_do_sequence_post()
        else
          @_do_step(idx)

          if idx+1<nStep then @_do_step_pre(idx+1)

          @_parse_next(idx)

      _do_sequence_pre: ->
        @_tStart = @root.time.Now()

        if @_fSequencePre? then @sequence_pre = @_fSequencePre(@)

      _do_sequence_post: ->
        @finished = true

        if @_fSequencePost? then @sequence_post = @_fSequencePost(@)

      _do_step_pre: (idx, next=null) ->
        @result[idx].t.pre = @root.time.Now()
        if @_fStepPre[idx]? then @result[idx].pre = @_fStepPre[idx](@, idx)

      _do_step: (idx) ->
        @result[idx].t.start = @root.time.Now()
        if @_fStep[idx]? then @result[idx].output = @_fStep[idx](@, idx)

        @_start_waiting(idx)

      _do_step_post: (idx) ->
        @_stop_waiting(idx)

        @result[idx].t.end = @root.time.Now()

        if @_fStepPost[idx]? then @result[idx].post = @_fStepPost[idx](@, idx)

      _step_start_time: (idx) -> @result[idx].t.start

      _start_waiting: (idx) ->
        if @_stepWait[idx]?
          @result[idx].wait = []

          switch getClass(@_stepWait[idx])
            when 'String' #a single key was passed
              options = {
                button: @_stepWait[idx]
              }
              @_stepWait[idx] = ['key', options]
              @_start_waiting idx
            when 'Array'
              if @_stepWait[idx].length>0 and contains(['key','mouse'],@_stepWait[idx][0])
              #key/mouse event specifier passed
                type = @_stepWait[idx][0]
                options = if @_stepWait[idx].length>=2 then @_stepWait[idx][1] else {}

                options.sub_type = options.sub_type ? 'down'
                options.button = options.button ? 'any'
                options.expires = options.expires ? 0

                fHandler = (evt) => @_append_wait_button(idx, type, evt.which)

                if options.f?
                  fUser = options.f
                  options.f = (evt) => fUser(@, evt, idx); fHandler(evt);
                else
                  options.f = fHandler

                @_stepWait[idx] = ['handler',@root.input.addHandler(type,options)]
              else
              #multiple keys passed
                options = {
                  button: @_stepWait[idx]
                }
                @_stepWait[idx] = ['key', options]
                @_start_waiting idx
            else throw 'invalid step wait specifier'

      _append_wait_button: (idx, type, button) ->
        tButton = @root.time.Now()

        code2button = switch type
          when 'key' then @root.input.code2key
          when 'mouse' then @root.input.code2mouse
          else throw 'invalid wait type'

        @result[idx].wait.push {
          button: code2button button
          time: tButton
          rt: tButton - @_step_start_time(idx)
        }

      _stop_waiting: (idx) ->
        if @_stepWait[idx]?
          switch @_stepWait[idx][0]
            when 'handler'
              @root.input.removeHandler @_stepWait[idx][1]
            else throw 'what?'

      _parse_next: (idx, next=null) ->
        fNextStep = @_fQueueStep[idx+1]

        next = next ? @_next[idx]

        if !isNaN(parseFloat(next)) #time
          window.setTimeout fNextStep, @_delay_time(next)
        else if (typeof next)=='string' #key name
          @_parse_next idx, ['key',{button: next}]
        else if (typeof next)=='function' #function to check periodically
          @_timer = setInterval ((fc,fs) => => @_check_next(fc,fs))(next,fNextStep), 1
        else if Array.isArray(next) and next.length>=1
          switch next[0]
            when 'key', 'mouse' #input event
              fRegisterEvent = (f) =>
                options = if next.length>=2 then next[1] else {}

                options.sub_type = options.sub_type ? 'down'
                options.button = options.button ? 'any'
                options.expires = 1
                options.delay = options.delay ? 0

                if options.f?
                  fUser = options.f
                  options.f = -> fUser(); f();
                else
                  options.f = f

                @root.input.addHandler(next[0],options)

              @_parse_next idx,['event', fRegisterEvent]
            when 'event' #a function that registers an event
              next[1](fNextStep)
            when 'lazy'
              @_parse_next idx, next[1](@, idx)
            else throw "invalid next value"
        else
          throw "invalid next value"

      Execute: -> @_fQueueStep[0]()

    Show: (name, stim, next, options={}) -> new MRTClassExecShow(@root,name,stim,next,options)
    MRTClassExecShow: class MRTClassExecShow extends MRTClassExecSequence
      _stim: null
      _stim_step: null

      remove_stim: null
      fixation: false
      contain: null

      constructor: (root, name, stim, next, options) ->
        ###
          name: a name for the sequence
          stim: an array of arrays of the following (one array for each step):
            [<name of show class>, <arg1 to show class>, ...]
            a Stimulus (hidden)
            a function that takes this object and the current step index and
              returns an array of the above
          next: see MRTClassExecSequence, or
            ['choice', options] (create MRTClassShowChoice from current stimuli)
            ['test', options] (create MRTClassShowTest from current stimuli)
          options:
            step_show: an array of functions to call immediately before each
              stimulus step is shown.  each function takes this object and the
              current step index as input. output is stored in
              @result[i].output.
            remove_stim: when to remove stimuli. one of:
              'step': remove old stimuli at the start of the next step
              'sequence': remove old stimuli at the end of the sequence, hide
                them at the end of the step
              'sequence_show': remove old stimuli at the end of the sequence,
                keep them visible at the end of the step
              'none': don't remove stimuli
            fixation: true to show the fixation dot at each step
            contain: true to contain stimuli within the screen
            (see MRTClassExecSequence for more options)
        ###
        step_show = options.step_show ? (null for s in stim)

        @remove_stim = options.remove_stim ? 'step'
        @fixation = options.fixation ? false
        @contain = options.contain ? true

        @_stim = stim
        @_stim_step = ([] for [1..stim.length])

        super root, name, step_show, next, options

      _do_sequence_post: ->
        super()

        if @remove_stim=='sequence' or @remove_stim=='sequence_show'
          for stim,idx in @_stim_step
            s.remove() for s in stim

            if @remove_stim=='sequence_show'
              @result[idx].t.remove = @root.time.Now()

        if @remove_stim!='none'
          @_stim_step = []

      _do_step_pre: (idx) ->
        super idx

        stimuli = forceArray(@_stim[idx])

        if @_fixation
          fixObj = @root.fixation[0]
          fixArg = @root.fixation[1]
          stimuli.push [fixObj, fixArg...]

        @_parse_stimulus(stim, idx) for stim in stimuli

      _do_step: (idx) ->
        super idx

        s.show(true) for s in @_stim_step[idx]
        @result[idx].t.show = @root.time.Now()

      _do_step_post: (idx) ->
        super idx

        #remove the stimuli
        if @remove_stim=='step'
          stim.remove() for stim in @_stim_step[idx]
          @result[idx].t.remove = @root.time.Now()
        else if @remove_stim=='sequence'
          stim.show(false) for stim in @_stim_step[idx]
          @result[idx].t.remove = @root.time.Now()

      _step_start_time: (idx) -> @result[idx].t.show

      _parse_next: (idx, next=null) ->
        next = next ? @_next[idx]

        if Array.isArray(next) and (next[0]=='choice' or next[0]=='test')
          fNextStep = @_fQueueStep[idx+1]

          options = next[1] ? {}
          fCallback = options.callback ? null
          options.callback = (obj,i) =>
            @result[idx].t.choice = obj._tChoice
            @result[idx].t.rt = @result[idx].t.choice - @result[idx].t.show
            @result[idx].choice = i
            if obj instanceof @root.show.MRTClassShowTest then @result[idx].correct = obj.correct
            if fCallback? then fCallback(i)
            fNextStep()

          stim = @root.show[capitalize(next[0])](@_stim_step[idx], options)
          @_store_stimulus stim, idx
        else
          super idx, next

      _parse_stimulus: (stim, idx) ->
        if Array.isArray(stim) and stim.length>0 and (typeof stim[0] == 'string')
          @_parse_stimulus (@root.show[stim[0]](stim[1..]...)), idx
        else if stim?
          for s in forceArray(stim)
            if s instanceof @root.show.MRTClassShowStimulus
              @_store_stimulus s, idx

              if @contain then s.contain()

              s.show(false)
            else if s instanceof Function
              @_parse_stimulus s(@, idx), idx
            else if Array.isArray(s)
              @_parse_stimulus s, idx
            else
              throw "invalid stimulus"
        else
          null

      _store_stimulus: (stim, idx) ->
        @_stim_step[idx].push stim
        stim

  Queue: -> new MRTClassQueue(@)
  MRTClassQueue: class MRTClassQueue extends MRTClass
    _queue: null

    constructor: (root) ->
      super root

      @clear()

    length: -> @_queue.length

    add: (name, f, options={}) ->
      options.do = options.do ? true
      @_queue.push {name:name, f:f, ready:false}

      if options.do then @do name

    do: (name=null) ->
      if @_queue.length>0
        if not name? and @_queue[0].ready
          @do(@_queue[0].name)
        else if @_queue[0].name==name and @root.ready()
          @_queue[0].ready = true
          @_queue.shift().f() while @_queue.length>0 and @_queue[0].ready
        else
          for i in [0..@_queue.length-1]
            if @_queue[i].name==name
              @_queue[i].ready = true
              break

    clear: -> @_queue = []

  Data: -> new MRTClassData(@)
  MRTClassData: class MRTClassData extends MRTClass
    timeout: null

    _local: false

    _local_datastore: null
    _archive: null

    _numBusy: 0

    _failed: false
    _failSafeExecuted: false
    _failSafeCallback: null

    constructor: (root, options={}) ->
      super root

      @timeout = options.timeout ? 10000
      @_local = options.local

      @_local_datastore = {}
      @_archive = {}

      @load()

    load: ->
      @block('loading data')

      @read 'keys',
        store: false
        callback: (result) => @loadCallback(result)

    loadCallback: (result) ->
      keys = result.value ? null

      if keys?
        for key in keys
          @_numBusy++
          @read key,
            callback: (result) => @unblock()
      else
        @unblock()

    save: (options={}) ->
      options.callback = options.callback ? null
      options.previous_failure = options.previous_failure ? @_failed

      @block('saving data')

      for key of @_local_datastore
        @_numBusy++
        @write key, @_local_datastore[key],
          store: false
          callback: (result) => @saveCallback(result, options)

      for key of @_archive
        for time of @_archive[key]
          @_numBusy++
          @archive key,
            store: false
            time: time
            callback: (result) => @saveCallback(result, options)

    saveCallback: (result, options) ->
      if options.callback?
        @root.queue.add 'save_callback', => options.callback()

      if not result.success and options.previous_failure
        @failSafe
          callback: => @unblock()
      else

        @unblock()

    block: (description) ->
      @_numBusy = 0
      @root.queue.add 'data_block', (-> null), {do:false}

    unblock: ->
      if @_numBusy>0 then @_numBusy--

      if @_numBusy==0
        @root.queue.do 'data_block'

    ajax: (data, options) ->
      data.csrfmiddlewaretoken = @root.csrf
      data.user = @root.subject

      $.ajax
        type: 'POST'
        url: '/mrt/data/'
        data: data
        success: (result) => @["#{data.action}Callback"](result, options)
        error: (jqXHR, status, err) => @failure()
        timeout: @timeout

    read: (key, options={}) ->
      options.force_remote = options.force_remote ? false
      options.store = options.store ? true
      options.callback = options.callback ? null

      if @_local or (not options.force_remote and key of @_local_datastore)
        result = {
          success: true
          action: 'read'
          key: key
          status: if (key of @_local_datastore) then 'read' else 'nonexistent'
          value: @_local_datastore[key]
        }
        window.setTimeout (=> @readCallback(result, options)), 0
      else
        data = {
          action: 'read'
          key: key
        }

        @ajax data, options

    readCallback: (result, options) ->
      if result.success
        if options.store and result.status=='read'
          @_local_datastore[result.key] = result.value
      else
        @failure()
      if options.callback? then options.callback(result)

    write: (key, value, options={}) ->
      options.store = options.store ? true
      options.callback = options.callback ? null

      #write locally
      if options.store
        newKey = not (key of @_local_datastore)
        @_local_datastore[key] = value
        if newKey then @write 'keys', Object.keys(@_local_datastore),
            store: false

      if @_local
        result = {
          success: true
          action: 'write'
          key: key
          status: 'write'
        }
        window.setTimeout (=> @writeCallback(result, options)), 0
      else
        data = {
          action: 'write'
          key: key
          value: JSON.stringify(value)
        }

        @ajax data, options

    writeCallback: (result, options) ->
      if not result.success then @failure()
      if options.callback? then options.callback(result)

    archive: (key, options={}) ->
      options.store = options.store ? true
      options.callback = options.callback ? null
      options.time = options.time ? @root.time.Now()

      #archive locally
      if options.store
        if not (key of @_archive) then @_archive[key] = {}
        @_archive[key][options.time] = @_local_datastore[key]

      if @_local
        result = {
          success: true
          action: 'archive'
          key: key
          status: 'archive'
          time: options.time
        }
        window.setTimeout (=> @archiveCallback(result, options)), 0
      else
        data = {
          action: 'archive'
          key: key
          time: options.time
          value: JSON.stringify(@_local_datastore[key])
        }

        @ajax data, options

    archiveCallback: (result, options) ->
      if not result.success then @failure()
      if options.callback? then options.callback(result)

    failure: -> @_failed = true

    failSafe: (options) ->
      if not @_failSafeExecuted
        @_failSafeCallback = options.callback ? null
        @_failSafeExecuted = true

        failSafeData = "#{JSON.stringify(@_local_datastore)}\n\n#{JSON.stringify(@_archive)}"

        $('#failsafe_data').val(failSafeData)

        mailSubject = encodeURIComponent("Session Data for #{@root.subject}")
        mailBody = if failSafeData.length < 2000
          encodeURIComponent(failSafeData)
        else
          ''

        $('#failsafe_mailto').attr("href", "mailto:schlegel@gmail.com?subject=#{mailSubject}&body=#{mailBody}")
        $('#failsafe').show()
      else
        if options.callback then options.callback()

    failSafeHide: ->
      $('#failsafe').hide()
      if @_failSafeCallback? then @_failSafeCallback()

    Variable: (key, value, options={}) -> new MRTClassDataVariable(@, key, value, options)
    MRTClassDataVariable: class MRTClassDataVariable
      track: false

      _data: null

      _key: null
      _value: null

      _initialized: false

      constructor: (data, key, value, options) ->
        ###
          data: the parent MRTClassData object
          key: the variable name
          value: the variable value
          options:
            track: true to archive each change to the variable
            timeout: the number of milliseconds before the variable value resets
              to its initial value
            timeout_type: one of the following:
              'session': value will only reset in between sessions
              'instant': value will reset immediately after timeout
            callback: a function that takes the variable as an input and is
              called after the variable is initialized
        ###
        @_data = data

        @track = options.track ? false
        options.timeout = options.timeout ? null
        options.timeout_type = options.timeout_type ? 'session'
        options.callback = options.callback ? null

        @_key = key
        @_value = {value:value}

        if options.timeout?
          @_value.timeout = options.timeout
          @_value.timeout_type = options.timeout_type

        @update(options)

      update: (options={}) ->
        @_data.read @_key,
          callback: (result) => @dataCallback(result, options)

      initialize: ->
        if @_value.timeout? then @_value.initial = @_value.value
        @reset()

      reset: ->
        if @_value.timeout?
          @_value.reset_time = @_data.root.time.Now()
          @set @_value.initial
        else
          @set @_value.value

      dataCallback: (result, options={}) ->
        options.callback = options.callback ? null

        if result.success
          switch result.status
            when 'nonexistent'
              @initialize()
            when 'read'
              @_value = result.value
              @checkTimeout()
            when 'write'
              if @track and @get()? then @_data.archive @_key,
                callback: (result) => @dataCallback(result)
              @checkTimeout()
            when 'archive'
              null
            else
              null

          if not @_initialized then @_initialized = true

          if options.callback? then options.callback(@)

      checkTimeout: ->
        if @_value.timeout? and (@_value.timeout_type=='instant' or not @_initialized)
          if @_data.root.time.Now() >= @nextReset() then @reset()

      nextReset: -> if @_value.timeout? then @_value.reset_time + @_value.timeout else null

      get: -> @_value.value

      set: (value) ->
        @_value.value = value
        @_data.write @_key, @_value,
          callback: (result) => @dataCallback(result)
        @

  Session: -> new MRTClassSession(@)
  MRTClassSession: class MRTClassSession extends MRTClass
    _started: false
    _responded: false
    _result_idx: 0

    _sequence: null

    _base_param: null

    stim_figure_prompt: null
    stim_figure_target: null
    stim_prompt: null

    current_trial: 0

    response_map: null

    constructor: (root) ->
      super root

      @base_param = {}

      @response_map = {
        left: true
        right: false
      }

    remaining: -> @getSequence().length - @current_trial

    run: (param=null) =>
      if not @_started
        @start(param)
      else if @remaining()>0
        @step()
      else
        @finish()

    start: (param=null) ->
      @setSequence param
      @_base_param = param ? @root.param.getBase()

      #get the total experiment time
      @root.dbg.showDuration()

      if @setSubject()
        @instructSession {
          sequence_post: (shw) =>
            @_started = true
            @run()
        }
      else
        @root.dbg.clear()

    step: ->
        @root.dbg.set 'trial', @current_trial+1

        param = copy @_base_param
        param.trial = @root.param.fill param.trial, 'trial', false
        param.stimulus = @getSequence(@current_trial)
        @doTrial param,
          callback: (shw) => setTimeout @run, param.trial.iti

        @current_trial++

    finish: -> @root.show.Instructions 'Finished!'

    code2response: (code) ->
      key = @root.input.code2key(code)
      if key of @response_map
        @response_map[key]
      else
        null

    setSubject: ->
      subject = prompt('subject id:',@root.default_subject)
      if subject?
        @root.subject = subject
        true
      else
        false


    setSequence: (param=null) ->
      param = if param? then copy(param,true) else {}
      if not param.stimulus? then param.stimulus={}

      #make sure we get the same sequence every time
      @root.setSeed()

      #fill the sequence parameters
      param.sequence = @root.param.fill param.sequence, 'sequence', false

      #get the possible rotation directions and angles
      rotate_dir = forceArray(@root.param.fillBase(param.stimulus.rotate_dir,'stimulus','rotate_dir'))
      rotate_angle = forceArray(@root.param.fillBase(param.stimulus.rotate_angle,'stimulus','rotate_angle'))

      #get an array of match values that matches the specified ratio
      match = if @root.param.isEmpty(param.stimulus.match)
        [t, f] = dec2frac(param.sequence.match_ratio)
        (true for [1..t]).concat (false for [1..f])
      else
        forceArray(param.stimulus.match)
      num_match = match.length

      #choose the stimulus parameters for each trial
      @_sequence = []
      for dir in rotate_dir
        for angle in rotate_angle
          idx_match = 0
          for [1..param.sequence.trials_per_condition]
            param.stimulus.rotate_dir = dir
            param.stimulus.rotate_angle = angle
            param.stimulus.match = match[idx_match]

            stim = @root.param.fill(param.stimulus,'stimulus',false)
            @_sequence.push stim

            idx_match = (idx_match+1) % num_match

      #randomize the trials
      randomize @_sequence

      #interleave no rotation trials
      if param.sequence.interleave_norotation
        param.stimulus.rotate_angle = 0

        #generate the same trials as above, but with no rotation
        seq_norotate = []
        for dir in rotate_dir
          for angle in rotate_angle
            idx_match = 0
            for [1..param.sequence.trials_per_condition]
              param.stimulus.rotate_dir = dir
              param.stimulus.match = match[idx_match]

              stim = @root.param.fill(param.stimulus,'stimulus',false)
              seq_norotate.push stim

              idx_match = (idx_match+1) % num_match

        #randomize the order of the norotate trials
        randomize seq_norotate

        #interleave all but the last norotate trial
        seq_rotate = @_sequence
        @_sequence = []
        for idx in [0..seq_rotate.length-1]
          @_sequence.push seq_rotate[idx]
          @_sequence.push seq_norotate[idx]
        @_sequence.pop()

      @root.dbg.set 'num_trials', @_sequence.length

    getSequence: (idx_trial=null) ->
      if not @_sequence? then @setSequence()
      if idx_trial? then @_sequence[idx_trial] else @_sequence

    instructSession: (options=null) ->
      stim = []
      next = []

      stim.push [['Instructions', "\<Instructions Go Here\>\n \nFor now:\nPress \u2190 for \"same\"\nand \u2192 for \"different\"\n \nPress any key to continue."]]
      next.push 'any'

      stim.push [['Instructions', "Press any key to begin the experiment."]]
      next.push 'any'

      @root.exec.Show 'instruction', stim, next, options

    clearStimulus: ->
      if @stim_figure_prompt? then @stim_figure_prompt.remove()
      if @stim_figure_target? then @stim_figure_target.remove()
      if @stim_prompt? then @stim_prompt.remove()

    getAngleText: (param) -> param.rotate_angle+'\u00B0'

    getPromptText: (param) ->
      if param.rotate_angle==0
        strPrompt = 'N'
      else
        strPrompt = param.rotate_dir
        if param.show_angle then strPrompt += ' '+@getAngleText(param)
      strPrompt

    showPrompt: (param, options=null) ->
      options = options ? {}

      flip = [param.flip_x, param.flip_y, param.flip_z]

      a = param.position*Math.PI/4 + Math.PI
      x = param.offset*Math.cos(a)
      y = param.offset*Math.sin(a)

      @stim_figure_prompt = @root.show.SMFigure param.idx,
        x: x
        y: y
        cube_size: param.cube_size
        'stroke-width': param.edge
        flip: flip
        show: options.show

      strPrompt = @getPromptText param
      yPrompt = @stim_figure_prompt.attr('y') - @stim_figure_prompt.attr('height')/2 - param.font_size/2
      @stim_prompt = @root.show.Text strPrompt,
        x: @stim_figure_prompt.attr 'x'
        y: yPrompt
        'font-size': param.font_size
        show: options.show

      [@stim_figure_prompt, @stim_prompt]

    showTarget: (param, options=null) ->
      options = options ? {}

      flip = [param.flip_x==param.match, param.flip_y, param.flip_z]

      a = param.position*Math.PI/4
      x = param.offset*Math.cos(a)
      y = param.offset*Math.sin(a)

      @stim_figure_target = @root.show.SMFigure param.idx,
        x: x
        y: y
        cube_size: param.cube_size
        'stroke-width': param.edge
        flip: flip
        theta: [[param.rotate_dir, param.rotate_angle]]
        show: options.show

      [@stim_figure_target]

    showStimulus: (param, options=null) ->
      options = options ? {}

      @showPrompt(param, options).concat(@showTarget(param, options))

    doTrial: (param, options=null) ->
      @_responded = false

      options = options ? {}

      options.remove_stim = 'sequence_show'

      stim = []
      options.step_wait = []
      next = []

      if param.trial.target_delay==0
        @_result_idx = 0

        #stimulus
        stim.push @showStimulus param.stimulus, {show: false}
        options.step_wait.push ['key', {
          button: 'any'
          f: @subjectResponse
        }]
        next.push param.trial.duration
      else
        @_result_idx = 1

        #prompt
        stim.push @showPrompt param.stimulus, {show: false}
        options.step_wait.push null
        next.push param.trial.target_delay

        #target
        stim.push @showTarget param.stimulus, {show: false}
        options.step_wait.push ['key', {
          button: 'any'
          f: @subjectResponse
        }]
        next.push param.trial.duration - param.trial.target_delay

      #callback
      f = options.callback ? null
      options.sequence_post = (shw) =>
        @endTrial(shw, param)
        if f? then f(shw)

      #do it now!
      trialName = @trialName
        trial: options.trial
      shw = @root.exec.Show "#{trialName}", stim, next, options

    subjectResponse: (s, evt, idx) =>
      if not @_responded
        @_responded = true

        response = @code2response evt.which
        if response?
          strResponse = if response then 'S' else 'D'
          colResponse = 'limegreen'
        else
          strResponse = 'X'
          colResponse = 'red'

        stimResponse = @root.show.Text strResponse,
          'font-weight': 'bold'
          color: colResponse

        s._store_stimulus stimResponse, idx

    trialName: (options={}) ->
      trial = options.trial ? @current_trial
      "trial#{trial}"

    endTrial: (shw, param) ->
      @root.dbg.set 'result', @trialResult(shw, param)
#        result = @trialResult(shw)
#
#        @trial_result.set result
#        @stepSkill result.correct
#
#        if @record? then @record.append @name, result.correct, shw.pre.param
#
#        #increment the trial
#        @current_trial += 1
#        @trials_finished.set @trials_finished.get()+1

    trialResult: (shw, param) ->
      result = copy param.stimulus

      result_response = shw.result[@_result_idx].wait[0]
      if result_response
        result.response = @code2response result_response.button
        result.correct = result.match==result.response
        result.rt = result_response.rt + param.trial.target_delay
      else
        result.response = null
        result.correct = false
        result.rt = null

      result

  Param: -> new MRTClassParam(@)
  MRTClassParam: class MRTClassParam extends MRTClass
    _presets: null
    _base: null

    _min_window_dim: => Math.min(@root.width(),@root.height())
    _default_cube_size: => Math.round(@_min_window_dim()/20)
    _default_offset: => Math.round(@_min_window_dim()/4)
    _default_edge: => Math.max(1,Math.round(@_min_window_dim()/200))
    _default_font_size: => Math.round(@_min_window_dim()/20)

    sm_figure: [
      [[0,0,0],[0,1,0],[0,2,0],[0,3,0],[0,3,1],[0,0,1],[0,0,2],[0,0,3],[1,0,3],[2,0,3]],
      [[0,0,0],[0,1,0],[0,2,0],[0,3,0],[-1,3,0],[0,0,1],[0,0,2],[0,0,3],[1,0,3],[2,0,3]],
      [[0,0,0],[0,1,0],[0,2,0],[0,3,0],[0,3,-1],[0,0,1],[0,0,2],[0,0,3],[-1,0,3],[-2,0,3]],
      [[0,0,0],[0,1,0],[0,2,0],[0,3,0],[-1,3,0],[0,0,1],[0,0,2],[0,0,3],[0,-1,3],[0,-2,3]],
      [[0,0,0],[0,1,0],[0,2,0],[0,3,0],[0,0,1],[0,0,2],[0,0,3],[-1,0,3],[-2,0,3],[-2,-1,3]],
      [[0,0,0],[0,1,0],[0,2,0],[1,2,0],[2,2,0],[3,2,0],[0,0,1],[0,0,2],[0,0,3],[-1,0,3]],
      [[0,0,0],[0,1,0],[0,2,0],[0,3,0],[1,3,0],[2,3,0],[0,0,1],[0,0,2],[0,0,3],[-1,0,3],[-2,0,3]],
      [[0,0,0],[0,1,0],[0,2,0],[1,2,0],[2,2,0],[0,0,1],[0,0,2],[0,0,3],[-1,0,3],[-2,0,3]],
    ]

    constructor: (root) ->
      super root

      @_presets = {}

      @_presets.default = {
        sequence: {
          trials_per_condition: 9 #"condition" == angle + direction
          match_ratio: 2 #matches per non-match
          interleave_norotation: false
        }
        trial: {
          duration: 6000
          target_delay: 1000
          iti: 6000
        }
        stimulus: {
          match: [false, true]
          idx: [0..@sm_figure.length-1]
          rotate_dir: ['F','B','L','R']
          rotate_angle: [0,45,90,135]
          position: [0..7]
          flip_x: false
          flip_y: false
          flip_z: false
          show_angle: true
          cube_size: @_default_cube_size
          offset: @_default_offset
          edge: @_default_edge
          font_size: @_default_font_size
        }
      }

      @_presets.interleave_norotation = copy @_presets.default, true
      @_presets.interleave_norotation.sequence.interleave_norotation = true
      @_presets.interleave_norotation.trial.iti = 0
      @_presets.interleave_norotation.stimulus.rotate_angle = @_presets.default.stimulus.rotate_angle[1..]

      @setBase 'default'

    setBase: (x) ->
      switch getClass(x)
        when 'String' then @_base = @_presets[x]
        when 'Object' then x
        else throw 'invalid base'

    getBase: -> copy @_base, true

    isEmpty: (val) ->
      not val? or
        (getClass(val)=='Number' and isNaN(val)) or
        (getClass(val)=='String' and val.length==0)

    fillBase: (value, type, key) ->
      if @isEmpty(value) then @_base[type][key] else value

    fill: (param=null, type=null, dbg=true) ->
      param = if param? then copy(param) else {}

      if type?
        for key of @_base[type]
          param[key] = @fillBase(param[key], type, key)

          param[key] = if Array.isArray(param[key])
            pickFrom(param[key])
          else if getClass(param[key])=='Function'
            param[key]()
          else
            param[key]

        if dbg then @root.dbg.set type, param
      else
        for type of @_base
          param[type] = @fill(param[type],type)

      param

  Debugger: -> new MRTClassDebugger(@)
  MRTClassDebugger: class MRTClassDebugger extends MRTClass
    debug_values: null

    constructor: (root) ->
      super root

      @clear()

    _parse_param: (val, f) ->
      if contains val, ','
        (f(v) for v in val.split(','))
      else
        f(val)

    parseParamInt: (val) -> @_parse_param(val, parseInt)
    parseParamDec: (val) -> @_parse_param(val, parseFloat)

    getSequenceParam: (fill=true, show=true) ->
      param = {
        trials_per_condition: @parseParamInt($('#sequence_trials_per_condition').val())
        match_ratio: @parseParamDec($('#sequence_match_ratio').val())
        interleave_norotation: $('#sequence_interleave_norotation').data('state')
      }

      if fill then @root.param.fill(param,'sequence',show) else param

    getTrialParam: (fill=true, show=true) ->
      param = {
        duration: @parseParamInt($('#trial_duration').val())
        target_delay: @parseParamInt($('#trial_target_delay').val())
        iti: @parseParamInt($('#trial_iti').val())
      }

      if fill then @root.param.fill(param,'trial',show) else param

    getStimulusParam: (fill=true, show=true) ->
      param = {
        match: $('#stimulus_match').data('state')
        idx: @parseParamInt($('#stimulus_idx').val())
        rotate_dir: $('#stimulus_rotate_dir').val()
        rotate_angle: @parseParamInt($('#stimulus_rotate_angle').val())
        show_angle: $('#stimulus_show_angle').data('state')
        position: @parseParamInt($('#stimulus_position').val())
        flip_x: $('#stimulus_flip_x').data('state') ? [false, true]
        flip_y: $('#stimulus_flip_y').data('state') ? [false, true]
        flip_z: $('#stimulus_flip_z').data('state') ? [false, true]
        cube_size: @parseParamInt($('#stimulus_cube_size').val())
        offset: @parseParamInt($('#stimulus_offset').val())
        edge: @parseParamInt($('#stimulus_edge').val())
        font_size: @parseParamInt($('#stimulus_font_size').val())
      }

      if fill then @root.param.fill(param,'stimulus',show) else param

    getParam: (fill=true,show=true) ->
      {
        sequence: @getSequenceParam(fill,show)
        trial: @getTrialParam(fill,show)
        stimulus: @getStimulusParam(fill,show)
      }

    showStimulus: ->
      param = @getStimulusParam()

      @root.session.clearStimulus()
      @root.session.showStimulus(param, true)

    doTrial: ->
      param = @getParam()

      @root.session.clearStimulus()
      @root.session.doTrial(param)

    run: ->
      @clear()
      @root.session.run(@getParam(false,false))

    showSequence: ->
      param = @getParam(false,false)
      @root.session.setSequence(param)
      seq = @root.session.getSequence()
      @set {sequence:seq}, null, true

    showDuration: ->
      if @root.debug
        param = @getParam(false,false)
        @root.session.setSequence(param)
        trial = @root.param.fill param.trial, 'trial', false
        tTotal = @root.session.getSequence().length*(trial.duration+trial.iti) - trial.iti
        @clear 'sequence'
        @set 'exp_duration', "#{tTotal/(1000*60)} min."

    get: (key=null) -> if key? then @debug_values[key] else @debug_values

    set: (key, value=null, override=false) ->
      if override then @clear()

      switch getClass(key)
        when 'String'
          @debug_values[key] = value
        when 'Object'
          @debug_values = merge @debug_values, key
        else
          throw 'invalid key'

      @disp()
      value

    step: (key) -> @set key, (@get(key) ? 0)+1

    timestamp: (key) -> @set key, @root.time.Now()

    clear: (key=null) ->
      if key?
        if getClass(key)=='String'
          delete @debug_values[key]
      else
        @debug_values = {}

      @disp()

    disp: -> if @root.debug then $('#debug-info').html obj2str(@debug_values)

    test: ->
      x = [1,2,3,4]
      alert x[1..]
