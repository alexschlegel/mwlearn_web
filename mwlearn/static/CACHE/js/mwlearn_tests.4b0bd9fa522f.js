// Generated by CoffeeScript 1.7.1
(function() {
  var MWLearnTests, fTestAssemblage, fTestAssemblageDistractor, fTestAssemblageSet, fTestAssemblageTrial, fTestChoice, fTestCompoundStimulus, fTestConstruct, fTestConstructPrompt, fTestConstructTrial, fTestDataBackend, fTestExecuteSequence, fTestInput, fTestNaturalDirection, fTestRemove, fTestRotateTrial, fTestScaling, fTestSession, fTestShowItemList, fTestShowPath, fTestShowRotate, fTestShowSequence, fTestShowTest, fTestStimulus, fTestStimulusGrid;

  fTestNaturalDirection = function(mwl) {
    var a, fTest, _i, _len, _ref, _results;
    fTest = function(a) {
      return "" + a + ": " + (naturalDirection(a));
    };
    _ref = [0, 90, 180, 270, -90, 45, -45, 360];
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      a = _ref[_i];
      _results.push(alert(fTest(a)));
    }
    return _results;
  };

  fTestStimulus = function(mwl) {
    var el;
    el = mwl.show.Rectangle();
    el.attr("x", -100);
    alert('1');
    return el.attr("width", 50);
  };

  fTestCompoundStimulus = function(mwl) {
    var x, y, z;
    x = mwl.show.Rectangle({
      x: -100
    });
    y = mwl.show.Circle({
      x: 100
    });
    z = mwl.show.CompoundStimulus([x, y], {
      background: "red",
      element_mousedown: function(el, x, y) {
        return alert(getClass(el));
      }
    });
    z.attr("y", 100);
    z.attr("height", 300);
    alert('1');
    z.show(false);
    alert('2');
    return z.show(true);
  };

  fTestStimulusGrid = function(mwl) {
    var f, fStep, n, next, y;
    y = mwl.show.StimulusGrid([]);
    f = (function(_this) {
      return function() {
        return y.addElement(mwl.show.Circle({
          color: mwl.color.pick()
        }));
      };
    })(this);
    n = 100;
    fStep = (function() {
      var _i, _results;
      _results = [];
      for (_i = 1; 1 <= n ? _i <= n : _i >= n; 1 <= n ? _i++ : _i--) {
        _results.push(f);
      }
      return _results;
    })();
    next = (function() {
      var _i, _results;
      _results = [];
      for (_i = 1; 1 <= n ? _i <= n : _i >= n; 1 <= n ? _i++ : _i--) {
        _results.push(100);
      }
      return _results;
    })();
    return mwl.exec.Sequence('stimulusgrid', fStep, next);
  };

  fTestShowPath = function(mwl) {
    var path, x;
    path = [['M', .692, .607], ['C', .694, .6, .7, .591, .704, .586, .707, .581, .714, .571, .718, .564, .723, .554, .727, .549, .735, .542, .742, .535, .745, .532, .746, .527, .748, .516, .763, .48, .77, .466, .786, .435, .804, .407, .811, .4, .819, .393, .82, .393, .83, .403], ['L', .836, .41, .83, .419], ['C', .825, .428, .823, .439, .825, .448, .827, .455, .831, .454, .837, .444, .847, .426, .859, .411, .877, .39, .887, .379, .896, .368, .898, .366, .9, .363, .9, .337, .898, .314, .897, .308, .898, .298, .9, .291, .906, .263, .905, .235, .894, .201, .887, .18, .878, .164, .862, .146], ['L', .862, .146], ['C', .849, .132, .845, .129, .83, .128, .822, .127, .821, .127, .817, .121, .812, .114, .812, .114, .809, .117, .806, .12, .803, .119, .798, .116, .791, .113, .789, .113, .787, .117, .786, .122, .782, .121, .778, .114, .776, .111, .768, .1, .759, .089, .751, .077, .741, .065, .738, .06, .731, .051, .729, .051, .717, .057, .71, .06, .709, .061, .709, .064, .71, .067, .709, .067, .704, .067, .7, .068, .697, .069, .693, .073, .69, .075, .685, .079, .682, .081, .665, .091, .659, .101, .657, .119, .655, .135, .649, .163, .646, .165, .644, .168, .646, .192, .649, .196, .654, .201, .657, .216, .655, .231, .654, .244, .653, .25, .646, .264, .639, .28, .638, .281, .626, .292, .614, .304, .61, .306, .567, .328, .542, .341, .517, .355, .512, .358, .502, .364, .501, .365, .486, .365, .448, .367, .426, .373, .402, .39, .392, .397, .389, .4, .385, .406, .383, .41, .377, .417, .372, .422, .363, .43, .362, .43, .35, .432, .335, .434, .32, .433, .315, .431, .311, .429, .309, .429, .307, .432, .305, .434, .301, .436, .299, .436], ['S', .285, .444, .272, .452], ['L', .248, .466, .226, .468], ['C', .208, .47, .203, .471, .201, .474, .2, .476, .192, .482, .183, .489, .165, .503, .162, .508, .153, .532, .15, .542, .146, .55, .143, .552, .141, .554, .139, .558, .138, .561, .136, .565, .134, .568, .127, .573, .119, .579, .118, .581, .114, .591, .111, .597, .108, .604, .107, .606, .105, .61, .088, .623, .071, .635], ['L', .063, .641, .069, .648], ['C', .073, .652, .075, .656, .075, .658, .074, .664, .079, .672, .091, .68, .103, .689, .111, .691, .121, .69, .126, .689, .128, .69, .132, .694, .136, .698, .136, .701, .136, .706], ['L', .136, .713, .112, .732, .089, .752, .09, .759], ['C', .09, .762, .09, .769, .091, .774, .091, .782, .091, .782, .102, .795, .109, .803, .114, .809, .114, .81, .114, .812, .115, .813, .122, .817, .126, .82, .128, .82, .13, .818, .132, .816, .137, .815, .141, .815, .148, .815, .15, .814, .155, .808, .16, .802, .166, .789, .169, .778, .17, .773, .171, .771, .176, .768, .18, .765, .181, .764, .18, .761, .178, .754, .187, .735, .196, .729, .2, .727, .204, .726, .214, .727, .227, .728, .228, .728, .234, .734, .239, .74, .241, .741, .246, .741, .254, .74, .26, .748, .259, .757, .259, .761, .259, .765, .26, .767, .263, .773, .266, .793, .265, .803, .264, .811, .264, .812, .273, .824, .285, .84, .286, .848, .281, .858, .278, .862, .275, .867, .273, .869, .27, .872, .27, .873, .273, .882, .274, .887, .277, .892, .279, .893, .281, .895, .283, .899, .284, .903, .287, .911, .293, .918, .305, .926, .315, .932, .315, .932, .323, .928, .33, .924, .331, .924, .337, .914, .341, .908, .346, .9, .35, .896, .354, .891, .356, .887, .355, .886, .354, .885, .355, .883, .37, .864, .378, .854, .385, .847, .392, .842, .398, .837, .41, .826, .42, .817, .44, .798, .477, .773, .497, .763, .51, .757, .547, .734, .577, .713, .592, .702, .594, .701, .606, .699, .64, .691, .665, .664, .692, .607], ['Z'], ['M', .825, .19], ['C', .824, .19, .822, .188, .821, .187, .819, .185, .817, .183, .816, .18, .816, .178, .816, .176, .817, .175, .818, .173, .821, .172, .824, .173, .826, .174, .828, .176, .828, .178, .829, .18, .828, .182, .828, .184, .827, .186, .827, .189, .825, .19], ['Z'], ['M', .49, .683, .494, .684, .494, .686, .485, .697, .477, .707, .471, .711, .456, .725, .47, .709, .472, .708, .472, .702, .475, .698, .478, .693, .481, .686, .49, .683], ['Z'], ['M', .394, .776, .38, .782, .369, .79, .361, .798, .353, .805, .348, .806, .341, .809, .334, .813, .328, .806, .325, .791, .322, .777, .324, .765, .325, .76, .33, .753, .336, .752, .342, .757, .35, .762, .36, .761, .367, .762, .378, .767, .387, .767, .394, .769, .408, .767, .408, .767, .409, .77, .407, .773, .394, .776], ['Z']];
    return x = mwl.show.Path(path, {
      color: 'blue',
      width: 400,
      height: 400
    });
  };

  fTestShowItemList = function(mwl) {
    var items, x;
    items = {
      blah: 'it worked',
      bloo: 'or did it'
    };
    x = mwl.show.ItemList(items);
    x.add('meow', 'new item!');
    alert('here');
    return x.remove('bloo');
  };

  fTestConstruct = function(mwl) {
    var d, i, n, x, y, _i, _ref;
    n = 600;
    x = [];
    for (i = _i = 0, _ref = n - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
      d = i / (n - 1);
      x.push(mwl.show.ConstructFigure(d, {
        color: mwl.game.construct.difficultyColor(d, 0, 1)
      }));
    }
    return y = mwl.show.StimulusGrid(x, {
      padding: 1
    });

    /*R = 20; C = 30
    W = 600
    for i in [0..R-1]
      for j in [0..C-1]
        d = 1*( (i*C + j)/(R*C-1) )
        x = mwl.show.ConstructFigure d,
          width: W/R
          height: W/R
          x: -W/2*(C/R) + j*W/(R-1)
          y: -W/2 + i*W/(R-1)
           *rot: 45
          color: mwl.game.construct.difficultyColor(d,0,1)
           *mousedown: (e,x,y,z) -> alert "#{x}, #{y}, #{z}"
     */
  };

  fTestConstructPrompt = function(mwl) {
    var figure, prompt;
    figure = mwl.show.ConstructFigure(0.2, {
      color: 'red',
      width: 200,
      height: 200,
      t: 0
    });
    return prompt = mwl.show.ConstructPrompt(figure);
  };

  fTestAssemblage = function(mwl) {
    var a, x, y;
    a = mwl.show.Assemblage({
      color: mwl.color.pick()
    });
    x = a.addPart("square");
    y = a.addPart("triangle", x, 1, 2);
    return a.rotate(2);
  };

  fTestAssemblageSet = function(mwl) {
    var a, b;
    a = mwl.game.assemblage.create({
      steps: 10
    });
    a.attr('x', -200);
    a.show(true);
    b = mwl.show.Assemblage();
    b.addSet(a.getSet());
    b.rotate(a._rotation / 90);
    b.attr('x', 200);
    return alert(window.equals(a.getSet(), b.getSet()));
  };

  fTestAssemblageDistractor = function(mwl) {
    var a, b, c;
    a = mwl.game.assemblage.create({
      steps: 3
    });
    a.show(true);
    b = mwl.game.assemblage.createDistractors(a);
    b.push(a);
    c = mwl.show.Choice(b);
    return c.show(true);
  };

  fTestShowRotate = function(mwl) {
    var c, idx, nC, nR, nRotate, offset, r, s, x, y, _i, _ref, _results;
    nRotate = mwl.game.rotate.path.length;
    nC = 9;
    nR = 8;
    s = 60;
    offset = 30;
    _results = [];
    for (c = _i = 0, _ref = nC - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; c = 0 <= _ref ? ++_i : --_i) {
      _results.push((function() {
        var _j, _ref1, _results1;
        _results1 = [];
        for (r = _j = 0, _ref1 = nR - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; r = 0 <= _ref1 ? ++_j : --_j) {
          idx = c + nC * r;
          if (idx < nRotate) {
            x = (-(nC - 1) * (s + offset) - offset) / 2 + c * (s + offset);
            y = (-(nR - 1) * (s + offset) - offset) / 2 + r * (s + offset);
            _results1.push(mwl.show.RotateStimulus(idx, {
              color: mwl.color.pick(),
              width: s,
              height: s,
              x: x,
              y: y,
              orientation: 45,
              mousedown: (function(row, column) {
                return function(obj, x, y) {
                  return alert("" + row + "," + column);
                };
              })(r, c)
            }));
          } else {
            _results1.push(void 0);
          }
        }
        return _results1;
      })());
    }
    return _results;
  };

  fTestScaling = function(mwl) {
    var a, x;
    x = mwl.show.Square;
    a = mwl.game.assemblage.create(10, 4);
    a.show(true);
    a.scale(0.1);
    return x.attr("height", a.attr("height"));
  };

  fTestRemove = function(mwl) {
    var x, y, z;
    x = mwl.show.Circle();
    alert('1');
    x.remove();
    alert('2');
    x = mwl.show.Circle({
      x: -100
    });
    y = mwl.show.Square({
      x: 100
    });
    z = mwl.show.CompoundStimulus([x, y]);
    alert('3');
    z.remove();
    return alert('4;');
  };

  fTestInput = function(mwl) {
    return mwl.input.addHandler("mouse", {
      event: 'down',
      button: 'left',
      expires: 0,
      f: function(evt) {
        return document.title = mwl.time.Now();
      }
    });
  };

  fTestExecuteSequence = function(mwl) {
    var cleanup, exec, f, n;
    f = [
      function() {
        return document.title = 1;
      }, function() {
        return document.title = 2;
      }, function() {
        return document.title = 3;
      }, function() {
        return document.title = 'press the "a" key!';
      }, function() {
        return document.title = 'click the button!';
      }, function() {
        return document.title = 'bye';
      }
    ];
    n = [
      function(tStart, tStep) {
        return mwl.time.Now() > tStep + 2000;
      }, 1000, 1000, [
        'key', {
          button: 'a'
        }
      ], [
        'mouse', {
          button: 'left'
        }
      ], 1000
    ];
    cleanup = [
      function() {
        return alert('clean up step 1!');
      }, null, null, null, null
    ];
    exec = mwl.exec.Sequence('test_sequence', f, n, {
      cleanup: cleanup,
      callback: function() {
        return document.title = 'done!';
      }
    });
    return mwl.queue.add("blah", function() {
      return alert('hi');
    });
  };

  fTestChoice = function(mwl) {
    var c, x, y, z;
    x = mwl.show.Circle({
      x: -150
    });
    y = mwl.show.Square({
      color: 'red',
      x: 0
    });
    z = mwl.show.Circle({
      x: 150
    });
    return c = mwl.show.Choice([x, y, z], {
      callback: function(ch, idx) {
        return document.title = "choice: " + idx;
      },
      choice_include: [0, 2],
      autoposition: false,
      autosize: false,
      timeout: 3000
    });
  };

  fTestShowTest = function(mwl) {
    var c, x, y, z;
    x = mwl.show.Circle({
      color: 'red'
    });
    y = mwl.show.Circle({
      color: 'red'
    });
    z = mwl.show.Circle();
    return c = mwl.show.Test([x, y, z], {
      callback: function(tst, idx) {
        return alert("" + idx + " is " + (tst.correct ? 'correct' : 'wrong') + "!");
      },
      correct: [0, 1],
      instruct: 'Choose a red one'
    });
  };

  fTestShowSequence = function(mwl) {
    var next, shw, stim;
    stim = [
      [
        ['Text', 'Click the red circle!'], [
          'Circle', {
            color: 'red',
            y: -100
          }
        ]
      ], function(s, idx) {
        return ['Text', "This is step " + idx];
      }, [
        ['Text', 'green circle!'], [
          'Circle', {
            color: 'green',
            y: -100
          }
        ]
      ], [
        ['Text', 'multiple circles!'], [
          'Circle', {
            color: 'blue',
            x: -100,
            y: -100
          }
        ], [
          'Circle', {
            color: 'red',
            x: 100,
            y: -100
          }
        ]
      ], [
        [
          'Circle', {
            color: 'blue',
            r: 100,
            y: -100
          }
        ], ['Text', 'is this text properly centering itself, and what is the nature of the universe?']
      ], [
        [
          'Circle', {
            color: 'red'
          }
        ], [
          'Circle', {
            color: 'green'
          }
        ], [
          'Circle', {
            color: 'blue'
          }
        ]
      ], [['Text', 'finished']]
    ];
    next = [
      [
        'mouse', {
          button: 'left'
        }
      ], 1000, 1000, [
        'choice', {
          callback: function(el, idx) {
            return document.title = el;
          }
        }
      ], 1000, [
        'test', {
          callback: function(el, idx) {
            return document.title = el;
          }
        }
      ], 1000
    ];
    return shw = mwl.exec.Show('test_show_sequence', stim, next, {
      callback: function() {
        return document.title = 'done!';
      }
    });
  };

  fTestDataBackend = function(mwl) {
    $.get('/data', {
      action: 'write',
      key: 'blah',
      value: 1
    }, function(data) {
      return alert(obj2str(data));
    });
    $.get('/data', {
      action: 'archive',
      key: 'blah',
      value: 'hmm'
    }, function(data) {
      return alert(obj2str(data));
    });
    return $.get('/data', {
      action: 'read',
      key: 'blah'
    }, function(data) {
      return alert(obj2str(data));
    });
  };

  fTestConstructTrial = function(mwl) {
    var d, df, fStep, fTrial, idx;
    d = (function() {
      var _i, _results;
      _results = [];
      for (df = _i = 0; _i <= 1; df = _i += 0.025) {
        _results.push(df);
      }
      return _results;
    })();
    idx = -1;
    fStep = function(shw) {
      idx++;
      if (idx < d.length) {
        return fTrial();
      }
    };
    fTrial = function() {
      return mwl.game.construct.trial({
        d: d[idx]
      }, {
        callback: fStep
      });
    };
    return fStep(null);
  };

  fTestAssemblageTrial = function(mwl) {
    var fStep, fTrial, idx, steps, _i, _results;
    steps = (function() {
      _results = [];
      for (_i = 1; _i <= 100; _i++){ _results.push(_i); }
      return _results;
    }).apply(this);
    idx = -1;
    fStep = function(shw) {
      idx++;
      if (idx < steps.length) {
        return fTrial();
      }
    };
    fTrial = function() {
      return mwl.game.assemblage.trial({
        steps: steps[idx]
      }, {
        callback: fStep
      });
    };
    return fStep(null);
  };

  fTestRotateTrial = function(mwl) {
    var fStep, fTrial, idx, precision, _i, _ref;
    precision = [90, 80, 70, 60, 50, 40, 30, 20, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1];
    for (idx = _i = 0, _ref = precision.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; idx = 0 <= _ref ? ++_i : --_i) {
      precision[idx] = 90 - precision[idx];
    }
    idx = -1;
    fStep = function(shw) {
      idx++;
      if (idx < precision.length) {
        return fTrial();
      }
    };
    fTrial = function() {
      return mwl.game.rotate.trial({
        precision: precision[idx]
      }, {
        callback: fStep
      });
    };
    return fStep(null);
  };

  fTestSession = function(mwl) {
    return mwl.session.run();
  };

  window.MWLearnTests = MWLearnTests = (function() {
    MWLearnTests.prototype._tests = null;

    MWLearnTests.prototype._mwl = null;

    function MWLearnTests(mwl) {
      this._tests = {};
      this._mwl = mwl;
      this.add("testnaturaldirection", fTestNaturalDirection);
      this.add("teststimulus", fTestStimulus);
      this.add("testcompoundstimulus", fTestCompoundStimulus);
      this.add('teststimulusgrid', fTestStimulusGrid);
      this.add("testshowpath", fTestShowPath);
      this.add("testshowitemlist", fTestShowItemList);
      this.add("testconstruct", fTestConstruct);
      this.add("testconstructprompt", fTestConstructPrompt);
      this.add("testassemblage", fTestAssemblage);
      this.add("testassemblageset", fTestAssemblageSet);
      this.add("testassemblagedistractor", fTestAssemblageDistractor);
      this.add("testshowrotate", fTestShowRotate);
      this.add("testscaling", fTestScaling);
      this.add("testremove", fTestRemove);
      this.add("testinput", fTestInput);
      this.add("testexec", fTestExecuteSequence);
      this.add("testchoice", fTestChoice);
      this.add("testshowtest", fTestShowTest);
      this.add("testshowsequence", fTestShowSequence);
      this.add("testdatabackend", fTestDataBackend);
      this.add("testconstructtrial", fTestConstructTrial);
      this.add("testassemblagetrial", fTestAssemblageTrial);
      this.add("testrotatetrial", fTestRotateTrial);
      this.add("testsession", fTestSession);
    }

    MWLearnTests.prototype.add = function(name, fTest) {
      return this._tests[name] = fTest;
    };

    MWLearnTests.prototype.run = function(name, options) {
      var fFail, fTest, fTry, _ref;
      if (options == null) {
        options = {};
      }
      options["try"] = (_ref = options["try"]) != null ? _ref : true;
      fTry = (function(_this) {
        return function() {
          _this._tests[name](_this._mwl);
          return alert("" + name + " succeeded!");
        };
      })(this);
      fFail = (function(_this) {
        return function(error) {
          return alert("" + name + " failed (" + error + ")!");
        };
      })(this);
      fTest = options["try"] ? (function(_this) {
        return function() {
          var error;
          try {
            return fTry();
          } catch (_error) {
            error = _error;
            return fFail(error);
          }
        };
      })(this) : (function(_this) {
        return function() {
          return fTry();
        };
      })(this);
      return this._mwl.queue.add(name, fTest);
    };

    MWLearnTests.prototype.runAll = function() {
      var name, _results;
      _results = [];
      for (name in this._tests) {
        _results.push(this.run(name));
      }
      return _results;
    };

    return MWLearnTests;

  })();

}).call(this);