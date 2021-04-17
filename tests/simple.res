open Zora

let default: zoraTest = t => {
  t->test("should greet", t => {
    t->ok(true, "hello world")
  })

  t->test("should answer question", t => {
    let answer = 42
    t->equal(answer, 42, "should be 42")
  })
}
