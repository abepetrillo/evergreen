require('/jquery.js');

describe('templates', function() {

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
