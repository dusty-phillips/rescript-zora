type zora
type zoraTest = zora => unit
type asyncZoraTest = zora => Promise.t<unit>
type testTitle = string
type testMessage = string

@send external test: (zora, testTitle, asyncZoraTest) => unit = "test"
@send external block: (zora, testTitle, zoraTest) => unit = "test"

@send external skip: (zora, testTitle, zoraTest) => unit = "skip"
@send external only: (zora, testTitle, zoraTest) => unit = "only"

@send external equal: (zora, 't, 't, testMessage) => unit = "equal"
@send external notEqual: (zora, 't, 't, testMessage) => unit = "notEqual"
@send external is: (zora, 't, 't, testMessage) => unit = "is"
@send external isNot: (zora, 't, 't, testMessage) => unit = "isNot"
@send external ok: (zora, bool, testMessage) => unit = "ok"
@send external notOk: (zora, bool, testMessage) => unit = "notOk"
@send external fail: (zora, testMessage) => unit = "fail"

let {then, resolve: done} = module(Promise)
