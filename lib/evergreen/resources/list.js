var Evergreen = {};

Evergreen.Spec = function(element) {
  var self = this;
  this.element = $(element);
  this.runLink = this.element.find('.run');
  this.runLink.click(function() {
    self.run()
    return false;
  });
}

Evergreen.Spec.prototype.run = function() {
  var self = this
  this.iframe = $('<iframe></iframe>').attr('src', this.runLink.attr('href')).appendTo(this.element)
  this.iframe.css({ position: 'absolute', left: '-20000px' });
  this.runLink.addClass('running').text('Running…');
  $(this.iframe).load(function() {
    var context = self.iframe.get(0).contentWindow;
    var evergreen = context.Evergreen;
    if(evergreen.done) {
      self.done(evergreen.results);
    } else {
      evergreen.onDone = function() {
        self.done(evergreen.results);
      }
    }
  });
}

Evergreen.Spec.prototype.done = function(results) {
  var failed = []
  $.each(results, function() {
    if(!this.passed) { failed.push(this); }
  });

  this.runLink.removeClass('running');

  if(failed.length) {
    this.runLink.addClass('fail').removeClass('pass').text('Fail')
  } else {
    this.runLink.addClass('pass').removeClass('fail').text('Pass')
  }
  this.iframe.remove();
}

$(function() {
  $('#specs li, #all').each(function() {
    new Evergreen.Spec(this)
  });
});
