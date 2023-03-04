open Zora

zora("should run a test asynchronously", async t => {
  let answer = 42
  t->equal(answer, 42, "Should answer the question")
})

zora("should run a second test at the same time", async t => {
  let answer = 3.14
  t->equal(answer, 3.14, "Should be a tasty dessert")
})
