if(!this.JSON){this.JSON={};}

var Evergreen = {
  potentialConflicts: {}
};

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

Evergreen.template = function(name) {
  beforeEach(function() {
    document.getElementById('test').innerHTML = Evergreen.templates[name]
  });
};

Evergreen.require = function(file) {
  document.write('<script type="text/javascript" src="' + file + '"></script>');
};

Evergreen.stylesheet = function(file) {
  document.write('<link rel="stylesheet" type="text/css" href="' + file + '"/>');
};

Evergreen.defineGlobalMethods = function(){
  this.potentialConflicts['require'] = window['require']
  this.potentialConflicts['template'] = window['template']
  this.potentialConflicts['stylesheet'] = window['stylesheet']

  window.require = Evergreen.require
  window.template = Evergreen.template
  window.stylesheet = Evergreen.stylesheet
}



//Tells Evergreen to namespace functions instead of potentially over-riding existing ones
Evergreen.noConflict = function() {
  window.require = this.potentialConflicts.require
  window.template = this.potentialConflicts.template
  window.stylesheet = this.potentialConflicts.stylesheet
}

Evergreen.defineGlobalMethods()
