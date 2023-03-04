open Zora

let wait = (amount: int) => {
  Js.Promise2.make((~resolve, ~reject) => {
    reject->ignore
    Js.Global.setTimeout(_ => {
      resolve(. Js.undefined)
    }, amount)->ignore
  })
}

zora("Some Parallel Tests", async t => {
  let state = ref(0)

  t->test("parallel 1", async t => {
    {await wait(10)}-> ignore
    t->equal(state.contents, 1, "parallel 2 should have incremented by now")
    state.contents = state.contents + 1
    t->equal(state.contents, 2, "parallel 1 should increment")
  })

  t->test("parallel 2", async t => {
    t->equal(state.contents, 0, "parallel 2 should be the first to increment")
    state.contents = state.contents + 1
    t->equal(state.contents, 1, "parallel 2 should increment")
  })

  t->test("parallel 3", async t => {
    {await wait(20)}->ignore
    t->equal(state.contents, 2, "parallel 1 and 2 should have incremented by now")
    state.contents = state.contents + 1
    t->equal(state.contents, 3, "parallel 3 should increment last")
  })
})
