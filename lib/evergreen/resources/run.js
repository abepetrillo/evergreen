if(!this.JSON){this.JSON={};}

var Evergreen = {};

Evergreen.dots = ""

Evergreen.templates = {};

Evergreen.getResults = function() {
  return JSON.stringify(Evergreen.results);
};

var require = function(file) {
  document.write('<script type="text/javascript" src="' + file + '"></script>');
};

var stylesheet = function(file) {
  document.write('<link rel="stylesheet" type="text/css" href="' + file + '"/>');
};
