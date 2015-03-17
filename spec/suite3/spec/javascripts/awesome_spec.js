Evergreen.require('/foo.js');

describe('awesome', function() {
  Evergreen.template('foo.html');

  it('requires public files', function() {
    expect(something).toEqual('The Foo');
  });
  it('loads templates', function() {
    expect(document.getElementById('foo').innerHTML).toEqual('The foo template');
  });
});
