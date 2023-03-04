type t
type zoraTest = t => promise<unit>
type zoraTestBlock = t => unit
type testTitle = string
type testMessage = string

@module("zora") external zora: (string, zoraTest) => unit = "test"
@module("zora") external zoraBlock: (string, zoraTestBlock) => unit = "test"
@module("zora") external zoraOnly: (string, zoraTest) => unit = "only"
@module("zora") external zoraBlockOnly: (string, zoraTestBlock) => unit = "only"

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

let optionNone = (zora: t, actual: option<'a>, message: testMessage) => {
  zora->ok(actual->Belt.Option.isNone, message)
}
let optionSome = (zora: t, actual: option<'a>, check: (t, 'a) => unit) => {
  switch actual {
  | None => zora->fail("Expected Some value, got None")
  | Some(value) => zora->check(value)
  }
}

let resultError = (zora: t, actual: Belt.Result.t<'a, 'b>, message: testMessage) => {
  zora->ok(actual->Belt.Result.isError, message)
}
let resultOk = (zora: t, actual: Belt.Result.t<'a, 'b>, check: (t, 'a) => unit) => {
  switch actual {
  | Belt.Result.Error(_) => zora->fail("Expected ok value, got error")
  | Belt.Result.Ok(value) => zora->check(value)
  }
}

