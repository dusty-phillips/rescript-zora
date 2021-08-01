open Zora

zora("should skip some tests", t => {
  t->skip("broken test", t => {
    t->fail("Test is broken")
    done()
  })

  t->blockSkip("also broken", t => {
    t->fail("Test is broken, too")
  })

  done()
})
