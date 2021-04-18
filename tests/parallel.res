open Zora

let wait = (amount: int) => {
  Promise.make((resolve, _) => {
    Js.Global.setTimeout(_ => {
      resolve(. Js.undefined)
    }, amount)->ignore
  })
}

let default: zoraTest = t => {
  t->block("Some Parallel Tests", t => {
    let state = ref(0)

    t->test("parallel 1", t => {
      wait(100)->then(_ => {
        t->equal(state.contents, 1, "parallel 2 should have incremented by now")
        state.contents = state.contents + 1
        t->equal(state.contents, 2, "parallel 1 should increment")
        done()
      })
    })

    t->test("parallel 2", t => {
      t->equal(state.contents, 0, "parallel 2 should be the first to increment")
      state.contents = state.contents + 1
      t->equal(state.contents, 1, "parallel 2 should increment")
      done()
    })

    t->test("parallel 3", t => {
      wait(200)->Promise.then(_ => {
        t->equal(state.contents, 2, "parallel 1 and 2 should have incremented by now")
        state.contents = state.contents + 1
        t->equal(state.contents, 3, "parallel 3 should increment last")
        done()
      })
    })
  })

  t->block("Some Sync Tests", t => {
    let state = ref(0)
    t->block("sync 1", t => {
      t->equal(state.contents, 0, "sync 1 should be first to increment")
      for _ in 1 to 10000 {
        state.contents = state.contents + 1
      }
      t->equal(state.contents, 10000, "sync 1 should increment many times")
    })

    t->block("sync 2", t => {
      t->equal(state.contents, 10000, "sync 2 should finish after sync 1")
    })
  })
}
