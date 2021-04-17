type zora
type zoraTest = zora => unit

@module("zora") external test: (string, zoraTest) => unit = "test"
@send external equal: (zora, 't, 't, string) => unit = "equal"

let default: zoraTest = t => {
    let answer = 42;
    t->equal(answer, 43, "answer should be 42");
}
