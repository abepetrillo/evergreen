describe('failing spec', function() {

  it("should pass", function() {
    expect('foo').toEqual('foo');
  });

  it("should fail", function() {
    expect('bar').toEqual('noooooo');
  });

});

