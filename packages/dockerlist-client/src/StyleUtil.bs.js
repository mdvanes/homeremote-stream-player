// Generated by ReScript, PLEASE EDIT WITH CARE


function toClassName0(input) {
  return input.filter(function (param) {
                  return param[1];
                }).map(function (param) {
                return param[0];
              }).join("_");
}

var testResult0 = toClassName0([
      [
        "class1",
        true
      ],
      [
        "class2",
        false
      ],
      [
        "class3",
        true
      ]
    ]);

function test0(param) {
  console.log("1. With Generic array", testResult0);
  
}

function toClassName1(input) {
  return input.map(function (param) {
                return param._0;
              }).join("_");
}

var testResult1 = toClassName1([
      /* StringAndBool */{
        _0: "class1",
        _1: true
      },
      /* StringAndBool */{
        _0: "class2",
        _1: false
      },
      /* StringAndBool */{
        _0: "class3",
        _1: true
      }
    ]);

function test1(param) {
  console.log("2. With custom variant", testResult1);
  
}

function toClassName(input) {
  return input.filter(function (item) {
                  if (item.TAG === /* Name */0) {
                    return true;
                  } else {
                    return item._1;
                  }
                }).map(function (item) {
                return item._0;
              }).join(" ");
}

export {
  toClassName0 ,
  testResult0 ,
  test0 ,
  toClassName1 ,
  testResult1 ,
  test1 ,
  toClassName ,
  
}
/* testResult0 Not a pure module */
