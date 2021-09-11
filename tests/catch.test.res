open Zora

exception AnError(string)

zoraBlock("should catch failures", t => {
  t->test("Promise Rejection", t => {
    Promise.reject(AnError("Things not good"))
    ->Promise.then(_ => t->fail("Should not enter then clause")->Promise.resolve)
    ->Promise.catch(_ => {
      t->ok(true, "The promise did reject")->Promise.resolve
    })
  })
})
