# numtel:velocity-tinytest

Use Tinytest to test your Meteor app, just like you would a package.

If you would like to use Tinytest with your app but without Velocity, see my
[numtel:tinytest-in-app](https://github.com/numtel/tinytest-in-app) package.

## Installation
The `tinytest` package is included automatically.

```bash
$ meteor add numtel:velocity-tinytest
```

## Quick start

1. Add a test to a `.js` or `.coffee` file inside `tests/tinytest`
    ```javascript
    Tinytest.add('test title', function(test){
      test.equal(true, true);
    });
    ```

2. To view the results, install the Velocity HTML Reporter:
    ```bash
    $ meteor add velocity:html-reporter
    ```

## Tinytest documentation

Since there is no official documentation for Tinytest, it may be helpful to have
some here.

Test titles can be any string. Use a separator of `" - "` to define sections.

**Test Syntax:**
```javascript
// Synchronous test
Tinytest.add('test title', function(test){
  test.equal(true, true);
});

// Asynchronous test
Tinytest.addAsync('async test title', function(test, onComplete){
  Meteor.setTimeout(function(){
    test.equal(true, true);
    onComplete();
  }, 1000);
});
```

**Assertions:**
```javascript
test.isFalse(v, msg) // if (!v)
test.isTrue(v, msg) // if(v)
test.equal(actual, expected, message)
test.notEqual(actual, expected, message)
test.length(obj, len, msg)
test.include(s, v) // s = string or object
test.isNaN(v, msg)
test.isUndefined(v, msg)
test.isNotNull(v, msg)
test.isNull(v, msg)

// expected can be:
//  undefined: accept any exception.
//  string: pass if the string is a substring of the exception message.
//  regexp: pass if the exception message passes the regexp.
//  function: call the function as a predicate with the exception.
test.throws(func, expected)

test.instanceOf(obj, klass)

test.runId() // Unique id for this test run

// Call this to fail the test with an exception. Use this to record
// exceptions that occur inside asynchronous callbacks in tests.
//
// It should only be used with asynchronous tests, and if you call
// this function, you should make sure that (1) the test doesn't
// call its callback (onComplete function); (2) the test function
// doesn't directly raise an exception.
test.exception(exception)

test.expect_fail()
```

## Related packages
* [numtel:tinytest-fixture-account](http://github.com/numtel/tinytest-fixture-account) - Create a fixture account for tests, remove when done
* [numtel:tinytest-in-app](https://github.com/numtel/tinytest-in-app) - Use Tinytest in a Meteor app without Velocity

## Todo

* Make tests post results one at a time as they come in instead of in big groups after each location (Server/Client)

## License

MIT
