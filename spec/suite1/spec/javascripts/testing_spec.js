require('/spec/helpers/required.js')

describe('testing', function() {

  it("should pass", function() {
    expect('foo').toEqual('foo');
  });

  it("should also pass", function() {
    expect('bar').toEqual('bar');
  });

  it("should load required spec files", function() {
    expect(var_from_required_file).toBe(true);
  });
});
