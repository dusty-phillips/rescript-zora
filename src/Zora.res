
type zora
type zoraTest = zora => unit

@module("zora") external test: (string, zoraTest) => unit = "test"
@send external equal: (zora, 't, 't, string) => unit = "equal"
