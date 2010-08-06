describe 'slow specs', ->

  it "should wait for results to show", ->
    runs ->
      expect('foo').toEqual('foo')
    waits 1000
    runs ->
      expect('bar').toEqual('baz')
