open Zora

let default: zoraTest = t => {
  t->equal(42, 42, "Numbers are equal")
  t->notEqual(42, 43, "Numbers are not equal")
  let x = {"hello": "world"}
  let y = x
  let z = {"hello": "world"}
  t->is(x, x, "object is object")
  t->is(x, y, "object is object")
  t->isNot(x, z, "object is not object with same values")
  t->equal(x, z, "Object is deep equal")
  t->ok(true, "boolean is ok")
  t->notOk(false, "boolean is not ok")
  t->Option.none(None, "None is None")
  t->Option.some(Some(x), "option is Some")
  t->Result.error(Belt.Result.Error(x), "Is Error Result")
  t->Result.ok(Belt.Result.Ok(x), "Is Ok Result")
  done()
}
