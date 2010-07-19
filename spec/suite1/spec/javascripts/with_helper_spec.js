describe('the spec helper', function() {
  it("should load js file", function() {
    expect(SpecHelper.spec).toEqual('helper');
  });

  it("should load coffee file", function() {
    expect(CoffeeSpecHelper.coffee).toEqual('script');
  });
});
