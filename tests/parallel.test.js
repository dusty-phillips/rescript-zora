// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Zora from "../src/Zora.js";

function wait(amount) {
  return new Promise((function (resolve, param) {
                setTimeout((function (param) {
                        return resolve(undefined);
                      }), amount);
                
              }));
}

function $$default(t) {
  t.test("Some Parallel Tests", (function (t) {
          var state = {
            contents: 0
          };
          t.test("parallel 1", (function (t) {
                  return Zora.$$then(wait(100), (function (param) {
                                t.equal(state.contents, 1, "parallel 2 should have incremented by now");
                                state.contents = state.contents + 1 | 0;
                                t.equal(state.contents, 2, "parallel 1 should increment");
                                return Zora.done(undefined);
                              }));
                }));
          t.test("parallel 2", (function (t) {
                  t.equal(state.contents, 0, "parallel 2 should be the first to increment");
                  state.contents = state.contents + 1 | 0;
                  t.equal(state.contents, 1, "parallel 2 should increment");
                  return Zora.done(undefined);
                }));
          t.test("parallel 3", (function (t) {
                  return wait(200).then(function (param) {
                              t.equal(state.contents, 2, "parallel 1 and 2 should have incremented by now");
                              state.contents = state.contents + 1 | 0;
                              t.equal(state.contents, 3, "parallel 3 should increment last");
                              return Zora.done(undefined);
                            });
                }));
          
        }));
  t.test("Some Sync Tests", (function (t) {
          var state = {
            contents: 0
          };
          t.test("sync 1", (function (t) {
                  t.equal(state.contents, 0, "sync 1 should be first to increment");
                  for(var _for = 1; _for <= 10000; ++_for){
                    state.contents = state.contents + 1 | 0;
                  }
                  t.equal(state.contents, 10000, "sync 1 should increment many times");
                  
                }));
          t.test("sync 2", (function (t) {
                  t.equal(state.contents, 10000, "sync 2 should finish after sync 1");
                  
                }));
          
        }));
  
}

export {
  wait ,
  $$default ,
  $$default as default,
  
}
/* No side effect */