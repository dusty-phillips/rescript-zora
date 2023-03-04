open Zora

exception AnError(string)

zoraBlock("should catch failures", t => {
  t->test("Promise Rejection", t => {
    Js.Promise2.reject(AnError("Things not good"))
    ->Js.Promise2.then(_ => t->fail("Should not enter then clause")->Js.Promise2.resolve)
    ->Js.Promise2.catch(_ => {
      t->ok(true, "The promise did reject")->Js.Promise2.resolve
    })
  })
})
