# rescript-zora: Lightning-fast unit tests

This package provides [Rescript](https://rescript-lang.org/) bindings for the
[Zora](https://github.com/lorenzofox3/zora) testing framework. Rescript and Zora
go very well together because they have a common mission of SPEED.

In the interest of maintaining that speed, this package is asynchronous by
default, though you can create blocking tests if you prefer.

This package mostly just binds directly to Zora, but there are a couple
niceties to help work with Rescript promises and the standard library.

## Beta software alert

This package is so beta that it depends on the as-yet-unreleased [Rescript
9.1.1](https://www.npmjs.com/package/rescript) toolchain and the new
[Promises](https://github.com/ryyppy/rescript-promise) proposal that hasn't
been integrated into the Rescript standard library.

## Installation

_Note: If you don't have a Rescript 9.1.1 project initialized already, the
fastest way to get one is with `npx rescript init myproject`._

Install [zora](https://github.com/lorenzofox3/zora) and this package:

```
npm install --save-dev @dusty-phillips/rescript-zora
```

Add `@dusty-phillips/rescript-zora` as a dependency in your `bsconfig.json`:

```
"bs-dependencies": ["@dusty-phillips/rescript-zora"]
```

## Suggested configuration

I've only tested the package with es6-style modules, so you may want to add
`"type": "module"` to your `package.json`. 

You'll probably also want to add the following `package-specs` configuration to
your `bsconfig.json`:

```json
  "package-specs": {
    "module": "es6",
    "in-source": true
  },
```

If you like to keep your tests separate from your source code, you'll need to
add that directory so Rescript will compile your test files:

```json
  "sources": [
    {
      "dir": "src",
      "subdirs": true
    },
    { "dir": "tests", "subdirs": true, "type": "dev" }
  ],
```

So a minimal `bsconfig.json` might look like this:

```json
{
  "name": "myproject",
  "version": "0.1.0",
  "sources": [
    {
      "dir": "src",
      "subdirs": true
    },
    { "dir": "tests", "subdirs": true, "type": "dev" }
  ],
  "package-specs": {
    "module": "es6",
    "in-source": true
  },
  "bs-dependencies": ["@dusty-phillips/rescript-zora"]
}
```

## Stand-alone test

The simplest possible Zora test looks like this:

```rescript
// tests/standalone.res
open Zora

zoraBlock("should run a test synchronously", t => {
  let answer = 3.14
  t->equal(answer, 3.14, "Should be a tasty dessert")
})
```

Building this with rescript will output a `tests/standalone.js` file that
you can run directly with `node`:

```tap
╰─○ node tests/standalone.js
TAP version 13
# should run a test asynchronously
ok 1 - Should answer the question
# should run a test synchronously
ok 2 - Should be a tasty dessert
1..2

# ok
# success: 2
# skipped: 0
# failure: 0
```

This output is in [Test Anything Protocol](https://testanything.org/) format.
The [zora docs](https://github.com/lorenzofox3/zora) go into more detail on how
it works with Zora.

## Running tests in parallel (async)

The `Block` in `zoraBlock` indicates that this is a blocking test. It's faster
to run multiple independent tests in parallel:

```rescript
// tests/standaloneParallel.res

open Zora

zora("should run a test asynchronously", t => {
  let answer = 42
  t->equal(answer, 42, "Should answer the question")
  done()
})

zora("should run a second test at the same time", t => {
  let answer = 3.14
  t->equal(answer, 3.14, "Should be a tasty dessert")
  done()
})
```

Note the absence of `Blocking`, and the presence of `done()`. Under the hood,
this is returning a [Rescript
Promise](https://github.com/ryyppy/rescript-promise), and you can call
`Promise.then` and friends inside the test if necessary. The `done()` at the
end is a more legible alias for `Promise.resolve` that is reexported in Zora.
It is necessary because all promises in the rescript-promise library must
return a promise.

## Test runner

You probably don't want to write a bunch of stand-alone test files,to be run
with separate `node` commands, though. You can use any TAP compliant test
runner ([see here](https://github.com/sindresorhus/awesome-tap) for a list),
but your best bet is probably to use
[zora-node](https://github.com/lorenzofox3/zora-node) (aka `pta`), with
[onchange](https://github.com/Qard/onchange) for watching for file changes:

```plaintext
npm install --save-dev pta onchange
```

With these installed, you can set the `test` command in your `scripts` as follows:

```json
  "test": "npx onchange --initial '{tests,src}/*.js' -- pta 'tests/*.test.js'",
```

Or, if you prefer to keep your tests alongside your code in your `src` folder:

```json
  "test": "npx onchange --initial 'src/*.js' -- pta 'src/*.test.js'",
```

Now `npm test` will do what you expect: run a test runner and watch for file
changes.

Note that pta will *not* run the standalone tests, as it instead relies on a
default export for each testing file. You can construct one for synchronous
testing as follows:

```rescript
// simple.test.res
open Zora

let default: zoraTestBlock = t => {
  t->block("should greet", t => {
    t->ok(true, "hello world")
  })

  t->block("should answer question", t => {
    let answer = 42
    t->equal(answer, 42, "should be 42")
  })
}
```

But if you like things super fast, async is the way to go (Note: the `wait()` call
below would require you to add a dependency on `@ryyppy/rescript-promise` to
your bs-config):

```rescript
// parallel.test.res
open Zora

let wait = (amount: int) => {
  Promise.make((resolve, _) => {
    Js.Global.setTimeout(_ => {
      resolve(. Js.undefined)
    }, amount)->ignore
  })
}

let default: zoraTestBlock = t => {
  t->test("Some Parallel Tests", t => {
    let state = ref(0)

    t->test("parallel 1", t => {
      wait(10)->then(_ => {
        t->equal(state.contents, 1, "parallel 2 should have incremented by now")
        state.contents = state.contents + 1
        t->equal(state.contents, 2, "parallel 1 should increment")
        done()
      })
    })

    t->test("parallel 2", t => {
      t->equal(state.contents, 0, "parallel 2 should be the first to increment")
      state.contents = state.contents + 1
      t->equal(state.contents, 1, "parallel 2 should increment")
      done()
    })

    t->test("parallel 3", t => {
      wait(20)->Promise.then(_ => {
        t->equal(state.contents, 2, "parallel 1 and 2 should have incremented by now")
        state.contents = state.contents + 1
        t->equal(state.contents, 3, "parallel 3 should increment last")
        done()
      })
    })
    done()
  })
}
```

See [zora-node](https://github.com/lorenzofox3/zora-node) for some more fun
suggestions to configure TAP logging or reporters.

## Skip, only, and fail

Zora exposes functions to skip tests if you need to. If you have a failing
test, just replace the call to `Zora.test` with a call to `Zora.skip`. Or, if
you're running blocking tests, replace `Zora.block` with `Zora.blockSkip`.

For example:

```rescript
// tests/skip.test.res
open Zora

let default: zoraTest = t => {
  t->skip("broken test", t => {
    t->fail("Test is broken")
    done()
  })

  t->blockSkip("also broken", t => {
    t->fail("Test is broken, too")
  })

  done()
}
```

The above also illustrates the use of the `Zora.fail` assertion to force a test
to be always failing.

If you want to run and debug a single test, you can run it in `only` mode. As
with skip, change the test's name from `test` to `only` or `block to
`blockOnly`.

However, `only` tests are intended only in development mode and zora will fail
by default if you try to run one. To run in only mode, you can run:

```shell
npm test -- --only
```

If you use this feature a lot, you could also consider putting additional test
commands in your `package.json` scripts, one for local only development and one
for CI:

```json
"test": "npx onchange --initial '{tests,src}/*.js' -- pta 'tests/*.test.js'",
"test:only": "npx onchange --initial '{tests,src}/*.js' -- pta --only 'tests/*.test.js'",
"test:ci": "pta 'tests/*.test.js'",
```


## Assertions

This library models all the default assertions provided by Zora except for
those dealing with raising exceptions, which don't map neatly to Rescript
exceptions.  There are additional bindings for checking if a Rescript `option`
is `Some()` or `None` or if a `Belt.Result` is `Ok()` or `Error()`.

In the interest of avoiding bloat, I do not intend to add a lot of other
Rescript-specific assertions.


```rescript
//tests/assertions.test.res
open Zora

let default: zoraTest = t => {
  t->equal(42, 42, "Numbers are equal")
  t->notEqual(42, 43, "Numbers are not equal")
  let x = {"hello": "world"}
  let y = x
  let z = {"hello": "world"}
  t->is(x, x, "object is object")
  t->is(x, y, "object is object")
  t->isNot(x, z, "object is not object with same values")
  t->equal(x, z, "Object is deep equal")
  t->ok(true, "boolean is ok")
  t->notOk(false, "boolean is not ok")
  t->Option.none(None, "None is None")
  t->Option.some(Some(x), "option is Some")
  t->Result.error(Belt.Result.Error(x), "Is Error Result")
  t->Result.ok(Belt.Result.Ok(x), "Is Ok Result")
  done()
}
```


## Running in the browser

Zora supports running tests in the browser, but I have not tested it with this
Rescript implementation. I am open to PRs that will make this Rescript
implementation work in the browser if changes are required.

## Source Maps

The biggest problem with this library is that test failures point to the lines
in the compiled js files instead of Rescript itself. If someone knows how to
configure rescript and zora to use source maps, I'd love a PR.
