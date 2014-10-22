// velocity-tinytest
// MIT License ben@latenightsketches.com
// test/sample.js
// Example tinytests

Tinytest.add('Sample Tests - nada', function(test) {});

Tinytest.add('Sample Tests - simple', function(test) {
  console.log('hello, world');
  return test.equal(true, true);
});

Tinytest.add('Sample Tests - simple failure', function(test) {
  return test.equal(true, false);
});

if (Meteor.isServer) {
  Tinytest.add('Sample Tests - server only', function(test) {
    return test.equal(true, true);
  });
}

if (Meteor.isClient) {
  Tinytest.add('Sample Tests - client only', function(test) {
    return test.equal(true, true);
  });
}

Tinytest.add('Sample Tests - multiple - checks with failure', function(test) {
  test.equal(true, false);
  return test.equal(true, true);
});

Tinytest.addAsync('Sample Tests - multiple - checks success + async', function(test, done) {
  test.equal(true, true);
  return Meteor.setTimeout((function() {
    test.equal(true, true);
    return done();
  }), 1000);
});
