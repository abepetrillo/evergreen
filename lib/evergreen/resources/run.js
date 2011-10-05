if(!this.JSON){this.JSON={};}

var Evergreen = {};

Evergreen.dots = ""

Evergreen.ReflectiveReporter = function() {
  this.reportRunnerStarting = function(runner) {
    Evergreen.results = [];
  };
  this.reportSpecResults = function(spec) {
    var results = spec.results();
    var item = results.getItems()[0] || {};
    Evergreen.results.push({
      name: spec.getFullName(),
      passed: results.failedCount === 0,
      message: item.message,
      trace: item.trace
    });
    Evergreen.dots += (results.failedCount === 0) ? "." : "F";
  };
  this.reportRunnerResults = function(runner) {
    Evergreen.done = true;
    if(Evergreen.onDone) { Evergreen.onDone() }
  };
};

Evergreen.templates = {};

Evergreen.getResults = function() {
  return JSON.stringify(Evergreen.results);
};

beforeEach(function() {
  document.getElementById('test').innerHTML = "";
});

var template = function(name) {
  beforeEach(function() {
    document.getElementById('test').innerHTML = Evergreen.templates[name]
  });
};

var require = function(file) {
  document.write('<script type="text/javascript" src="' + file + '"></script>');
};

var stylesheet = function(file) {
  document.write('<link rel="stylesheet" type="text/css" href="' + file + '"/>');
};
