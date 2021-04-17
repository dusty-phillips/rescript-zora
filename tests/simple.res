open Zora

let default: zoraTest = t => {
  let answer = 42
  t->equal(answer, 42, "answer should be 42")
}
