require('/jquery.js');

describe('transactions', function() {

  it("should add stuff in one test...", function() {
    $('#test').append('<h1 id="added">New Stuff</h1>');
    expect($('#test h1#added').length).toEqual(1);
  });

  it("... should have been removed before the next starts", function() {
    expect($('#test h1#added').length).toEqual(0);
  });

});
