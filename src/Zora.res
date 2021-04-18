type t
type zoraTest = t => Promise.t<unit>
type zoraTestBlock = t => unit
type testTitle = string
type testMessage = string

@module("zora") external zora: (string, zoraTest) => unit = "test"
@module("zora") external zoraBlock: (string, zoraTestBlock) => unit = "test"

@send external test: (t, testTitle, zoraTest) => unit = "test"
@send external block: (t, testTitle, zoraTestBlock) => unit = "test"

@send external skip: (t, testTitle, zoraTest) => unit = "skip"
@send external only: (t, testTitle, zoraTest) => unit = "only"
@send external blockSkip: (t, testTitle, zoraTestBlock) => unit = "skip"
@send external blockOnly: (t, testTitle, zoraTestBlock) => unit = "only"

@send external equal: (t, 't, 't, testMessage) => unit = "equal"
@send external notEqual: (t, 't, 't, testMessage) => unit = "notEqual"
@send external is: (t, 't, 't, testMessage) => unit = "is"
@send external isNot: (t, 't, 't, testMessage) => unit = "isNot"
@send external ok: (t, bool, testMessage) => unit = "ok"
@send external notOk: (t, bool, testMessage) => unit = "notOk"
@send external fail: (t, testMessage) => unit = "fail"

module Option = {
  let none = (zora: t, actual: option<'t>, message: testMessage) => {
    zora->ok(actual->Belt.Option.isNone, message)
  }
  let some = (zora: t, actual: option<'t>, message: testMessage) => {
    zora->ok(actual->Belt.Option.isSome, message)
  }
}

module Result = {
  let error = (zora: t, actual: Belt.Result.t<'t, 'b>, message: testMessage) => {
    zora->ok(actual->Belt.Result.isError, message)
  }
  let ok = (zora: t, actual: Belt.Result.t<'t, 'b>, message: testMessage) => {
    zora->ok(actual->Belt.Result.isOk, message)
  }
}

let {then, resolve: done} = module(Promise)
