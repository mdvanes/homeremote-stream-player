// Examples

// Generic array

let toClassName0 = (input: array<(string, bool)>): string =>
  input
  ->Js.Array2.filter(((_name, isActive)) => isActive)
  ->Js.Array2.map(((name, _isActive)) => name)
  ->Js.Array2.joinWith("_")

let testResult0 = toClassName0([("class1", true), ("class2", false), ("class3", true)])

let test0 = () => Js.log2("1. With Generic array", testResult0)

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

let test1 = () => Js.log2("2. With custom variant", testResult1)

/* Shared types */

type dockerContainer = {
  "Id": string,
  "Names": Js.Array2.t<Js.String2.t>,
  "State": string,
  "Status": string,
}

type dockerListResponse = {
  status: string, // Union types do not exist in Reason but the string is pattern matched
  containers: array<dockerContainer>,
}

type setContainersType = (array<dockerContainer> => array<dockerContainer>) => unit

// Variant classNameItem with the cases "Name" and "NameOn" with contructor arguments
type classNameItem = Name(string) | NameOn(string, bool)

/* Style utils */

// Generic array with Variant parameter
let toClassName = (input: array<classNameItem>): string =>
  input
  ->Js.Array2.filter(item => {
    // Pattern matching
    switch item {
    // Destructure the Variant NameOn to name and isActive
    | NameOn(_name, isActive) => isActive
    | Name(_name) => true
    }
  })
  ->Js.Array2.map(item => {
    switch item {
    | NameOn(name, _isActive) => name
    | Name(name) => name
    }
  })
  ->Js.Array2.joinWith(" ")

/* Compare function for objects of type dockerContainer */

let compareDockerContainer = (c1: dockerContainer, c2: dockerContainer) => {
  let name1 = c1["Names"][0]
  let name2 = c2["Names"][0]
  if name1 < name2 {
    -1
  } else if name1 > name2 {
    1
  } else {
    0
  }
}
