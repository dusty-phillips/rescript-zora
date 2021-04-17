type zora
type zoraTest = zora => unit
type testTitle = string
type testMessage = string

@send external test: (zora, testTitle, zoraTest) => unit = "test"
@send external equal: (zora, 't, 't, testMessage) => unit = "equal"
@send external ok: (zora, bool, testMessage) => unit = "ok"
