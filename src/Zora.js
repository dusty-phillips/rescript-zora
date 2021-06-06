// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "../node_modules/rescript/lib/es6/curry.js";
import * as Belt_Option from "../node_modules/rescript/lib/es6/belt_Option.js";
import * as Belt_Result from "../node_modules/rescript/lib/es6/belt_Result.js";

function optionNone(zora, actual, message) {
  zora.ok(Belt_Option.isNone(actual), message);
  
}

function optionSome(zora, actual, message) {
  zora.ok(Belt_Option.isSome(actual), message);
  
}

function resultError(zora, actual, message) {
  zora.ok(Belt_Result.isError(actual), message);
  
}

function resultOk(zora, actual, message) {
  zora.ok(Belt_Result.isOk(actual), message);
  
}

function $$then(prim0, prim1) {
  return prim0.then(Curry.__1(prim1));
}

function done(prim) {
  return Promise.resolve(prim);
}

export {
  optionNone ,
  optionSome ,
  resultError ,
  resultOk ,
  $$then ,
  done ,
  
}
/* No side effect */
