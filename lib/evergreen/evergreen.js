var Evergreen = {};

Evergreen.ReflectiveReporter = function() {
  this.reportRunnerStarting = function(runner) {
    jasmine.results = [];
  };
  this.reportSpecResults = function(spec) {
    var results = spec.results();
    var item = results.getItems()[0] || {};
    jasmine.results.push({
      name: spec.getFullName(),
      passed: results.failedCount === 0,
      message: item.message,
      trace: item.trace
    });
  };
}

beforeEach(function() {
  var test = document.getElementById('test');
  test.innerHTML = Evergreen.template;
});

var require = function(file) {
  document.write('<script type="text/javascript" src="' + file + '"></script>');
};
