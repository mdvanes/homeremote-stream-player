// Examples

// Generic array

let toClassName = (input: array<(string, bool)>): string =>
  input
  ->Js.Array2.filter(((_name, isActive)) => isActive)
  ->Js.Array2.map(((name, _isActive)) => name)
  ->Js.Array2.joinWith("_")

let testResult = toClassName([("class1", true), ("class2", false), ("class3", true)])

let test1 = () => Js.log2("1. With Generic array", testResult)

// Custom variant StringAndBool and destructuring of Variant in map

type foo = StringAndBool(string, bool)

let toClassName1 = (input: array<foo>): string =>
  input
  // ->Js.Array2.filter(((_name, isActive)) => isActive)
  ->Js.Array2.map((StringAndBool(name, _isActive)) => name)
  ->Js.Array2.joinWith("_")

let testResult1 = toClassName1([
  StringAndBool("class1", true),
  StringAndBool("class2", false),
  StringAndBool("class3", true),
])

let test2 = () => Js.log2("2. With custom variant", testResult1)

// Pattern matching in filter

type classNameItem = String(string) | StringAndBool(string, bool)

let toClassName2 = (input: array<classNameItem>): string =>
  input
  ->Js.Array2.filter(item => {
    switch item {
    | StringAndBool(_name, isActive) => isActive
    | String(_name) => true
    }
  })
  ->Js.Array2.map(item => {
    switch item {
    | StringAndBool(name, _isActive) => name
    | String(name) => name
    }
  })
  ->Js.Array2.joinWith(" ")

let testResult2 = toClassName2([
  StringAndBool("class1", true),
  String("class2"),
  StringAndBool("class3", false),
  StringAndBool("class4", true),
  String("class5"),
])

let test3 = () => Js.log2("3. With pattern matching", testResult2)