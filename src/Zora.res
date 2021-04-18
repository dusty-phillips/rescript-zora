type t
type zoraTest = t => unit
type asyncZoraTest = t => Promise.t<unit>
type testTitle = string
type testMessage = string

@module("zora") external zora: (string, asyncZoraTest) => unit = "test"
@module("zora") external zoraBlock: (string, zoraTest) => unit = "test"

@send external test: (t, testTitle, asyncZoraTest) => unit = "test"
@send external block: (t, testTitle, zoraTest) => unit = "test"

@send external skip: (t, testTitle, zoraTest) => unit = "skip"
@send external only: (t, testTitle, zoraTest) => unit = "only"

@send external equal: (t, 't, 't, testMessage) => unit = "equal"
@send external notEqual: (t, 't, 't, testMessage) => unit = "notEqual"
@send external is: (t, 't, 't, testMessage) => unit = "is"
@send external isNot: (t, 't, 't, testMessage) => unit = "isNot"
@send external ok: (t, bool, testMessage) => unit = "ok"
@send external notOk: (t, bool, testMessage) => unit = "notOk"
@send external fail: (t, testMessage) => unit = "fail"

let {then, resolve: done} = module(Promise)
