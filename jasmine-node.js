var kiwi = require('kiwi');
var sys = require('sys');

kiwi.require('jasmine')

var window = GLOBAL;

ansiColor = function(color) {
  var colors = {
    green: "32",
    red: "31",
    yellow: "33"
  };

  if (color) {
    sys.print("\u001B[" + colors[color] + "m")
  } else {
    sys.print("\u001B[0m")
  }
};

jasmine.NodeReporter = function() {
  this.failedCount = 0;
  this.successCount = 0;
  this.failures = [];
  this.startTime = (new Date()).getTime();
};

//noinspection JSUnusedLocalSymbols
jasmine.NodeReporter.prototype.reportRunnerStarting = function(runner) {
  sys.puts("Starting tests...");
};

//noinspection JSUnusedLocalSymbols
jasmine.NodeReporter.prototype.reportRunnerResults = function(runner) {
  sys.puts("\n")
  for (var i = 0; i < this.failures.length; i++) {
    var failure = this.failures[i];
    sys.puts("Failing test in '" + failure.getFullName() + "'")
    var items = failure.results().getItems();
    for (var j = 0; j < items.length; j++) {
      var item = items[j];
      if (item.passed())
        continue;
      sys.puts(item.trace.stack);
    }
    sys.puts("")
  }
  var endTime = (new Date()).getTime();

  sys.puts("Tests finished in " + (endTime - this.startTime) + "ms. " + this.successCount + " success, " + this.failedCount + " failed.");
};

//noinspection JSUnusedLocalSymbols
jasmine.NodeReporter.prototype.reportSuiteResults = function(suite) {
};

//noinspection JSUnusedLocalSymbols
jasmine.NodeReporter.prototype.reportSpecResults = function(spec) {
  var result = spec.results();
  if (result.passed()) {
    this.successCount++;
    ansiColor("green");
    sys.print(".");
  } else if (result.skipped) {
    ansiColor("yellow");
    sys.print("*");
  } else {
    ansiColor("red");
    this.failedCount++;
    this.failures.push(spec);
    sys.print("F");
  }
  ansiColor(null);
};

//noinspection JSUnusedLocalSymbols
jasmine.NodeReporter.prototype.log = function(str) {
};

for (var a in jasmine) {
  if (jasmine.hasOwnProperty(a)) exports[a] = jasmine[a];
}

exports.include = function(url, opt_global) {
  var data = fs.readFileSync(url);
  eval(data);
};

filesFromGlob = function(path) {
  var glob = path.replace(/\./g, "\\.").replace(/\*/g, "[^/]*").replace(/\[\^\/\]\*\[\^\/\]\*/g, ".*").replace(/\?/g, ".");
  var regex = new RegExp(glob, "gi");
  var rootDir = ".";
  var dirQueue = [rootDir];
  var files = [];
  while (dirQueue.length > 0) {
    var dir = dirQueue.shift();
    var dirContents = fs.readdirSync(dir);
    for (var i = 0; i < dirContents.length; i++) {
      var file = dirContents[i];
      var relativePath = dir + "/" + file;
      var stat = fs.lstatSync(relativePath);
      if (stat.isDirectory()) {
        dirQueue.push(relativePath);
      } else if (stat.isFile()) {
        if (regex.test(relativePath)) {
          files.push(relativePath);
        } else {
        }
      }
    }
  }
  return files;
};

exports.includeAll = function(path, opt_global) {
  var files = filesFromGlob(path);
  for (var i = 0; i < files.length; i++) {
    exports.include(files[i], opt_global);
  }
};

exports.runDefaultNodeSpecs = function() {
  exports.includeAll("spec/spec_helper.js");
  exports.includeAll("spec/*_spec.js");
  exports.includeAll("spec/**/*_spec.js");
  var jasmineEnv = jasmine.getEnv();
  jasmineEnv.reporter = new jasmine.NodeReporter();
  jasmineEnv.execute();
};

jasmine.run = function() {
  var jasmineEnv = jasmine.getEnv();
  jasmineEnv.reporter = new jasmine.NodeReporter();
  jasmineEnv.execute();
};
