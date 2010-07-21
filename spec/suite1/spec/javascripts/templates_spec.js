require('/jquery.js');
stylesheet('/styles.css')

describe('templates', function() {

  describe('with template', function() {
    template('one_template.html')

    it("should append the template to the test div", function() {
      expect($('#test h1#from-template').length).toEqual(1);
    });

    it("should change stuff in one test...", function() {
      expect($('#test h1#from-template').length).toEqual(1);

      $('#test h1#from-template').attr('id', 'changed');

      expect($('#test h1#changed').length).toEqual(1);
      expect($('#test h1#from-template').length).toEqual(0);
    });

    it("... should have been removed before the next starts", function() {
      expect($('#test h1#changed').length).toEqual(0);
      expect($('#test h1#from-template').length).toEqual(1);
    });
  });

  describe('with another template', function() {
    template('another_template.html')

    it("should append the template to the test div", function() {
      expect($('#test h1#another-template').length).toEqual(1);
    });
  });

});

describe('stylesheet', function() {
  template('one_template.html')

  it("should style the template", function() {
    // Env-js does not have support for stylesheets
    if (Evergreen.driver != "envjs") {
      expect(document.getElementById('from-template').offsetWidth).toEqual(300)
    }
  });
});
