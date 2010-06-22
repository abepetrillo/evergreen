require('./implementation')

describe('with no tokens', function () {
  it("should return an empty string if an empty string is given", function() {
  })

  it("should return a string unchanged", function() {
  })
})

describe('with one token', function () {
  it("should replace the token with an empty string if no value is passed in", function() {
  })

  it("should replace the token with a given value", function() {
  })

  it("should not replace partial token matches", function() {
  })

  it("should work when calling replace twice on the same string template", function() {
  })
})

describe('with two tokens (OMG!?)', function () {
  it("should replace all tokens with their values", function() {
  })

  it("should not do anything about tokens not present in the string template", function() {
  })

  it("should replace tokens without value with the empty string", function() {
  })
})

jasmine.run()
