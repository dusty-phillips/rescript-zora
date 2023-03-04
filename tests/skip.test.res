open Zora

zora("should skip some tests", async t => {
  t->skip("broken test", async t => {
    t->fail("Test is broken")
  })

  t->blockSkip("also broken", t => {
    t->fail("Test is broken, too")
  })

})
