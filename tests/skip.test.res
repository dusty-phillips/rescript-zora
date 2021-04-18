open Zora

let default: zoraTest = t => {
  t->skip("broken test", t => {
    t->fail("Test is broken")
    done()
  })

  t->blockSkip("also broken", t => {
    t->fail("Test is broken, too")
  })

  done()
}
