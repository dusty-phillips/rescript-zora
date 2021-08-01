open Zora

zoraBlock("should run a test synchronously", t => {
  let answer = 3.14
  t->equal(answer, 3.14, "Should be a tasty dessert")
})
