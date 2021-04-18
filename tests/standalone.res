open Zora

zora("should run a test asynchronously", t => {
  let answer = 42
  t->equal(answer, 42, "Should answer the question")
  done()
})

zoraBlock("should run a test synchronously", t => {
  let answer = 3.14
  t->equal(answer, 3.14, "Should be a tasty dessert")
})
