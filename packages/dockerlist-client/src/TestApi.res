// [@bs.val] external fetch: string => Js.Promise.t('a) = "fetch";

// let getDockerList1 = (url: string, onError: string => unit) => Js.Promise.("someurl"->fetch);

// let getDockerList2 = (url: string, onError: string => unit) => "someurl"->fetch;


let myPromise = Js.Promise.make((~resolve, ~reject) => {
    Js.log(reject)
    resolve(. 2) 
})

// a |> f(b) turns into f(b, a)
// a -> f(b) turns into f(a, b)

// type person = {
//   name: string,
//   friends: array<string>,
//   age: int,
// }

// @module external john: person = "john"

// let johnName = john.name

// TODO deduplicate/import this type from DockerListItem.res
type dockerContainer = {
  "Id": string,
  "Names": Js.Array2.t<Js.String2.t>,
  "State": string,
  "Status": React.element,
}

type dockerListResponse = {
    status: string, // TODO convert to "received" | "error"
    containers: array<dockerContainer>
}

// NOTE: it might be better to do `|> then_(Fetch.Response.json)` (instead of `|> then_(Fetch.Response.text)`) and then Decode the response with e.g. @glennsl/bs-json
@scope("JSON") @val
external parseIntoDockerListResponse: string => dockerListResponse = "parse"

open Js.Promise
let getDockerList = (url: string, onError: string => unit) => Fetch.fetch(`${url}/api/dockerlist`)
    |> then_(Fetch.Response.text)
    |> then_((jsonResponse) => {
        let response = parseIntoDockerListResponse(jsonResponse)
        // Js.log2("jpr_|>", response.status)
        if (response.status == "received") {
            // Js.log(response.containers)
            Js.Promise.resolve(response.containers)
        } else {
            // Js.log("errors")
            // Js.Promise.resolve([])
            Js.Exn.raiseError("Invalid getDockerList response")
        }
    }, _)
    |> catch(_err => {
        onError("error in getDockerList__TestApi.res")
        Js.Promise.resolve([])
    }, _)

let blabla = () => Fetch.fetch("http://localhost:3100/api/dockerlist")
    |> then_(Fetch.Response.json)
    |> then_(value => {
        Js.log2("jpr_|>", value)
        Js.Promise.resolve(value)
    }, _)

// let blabla3 = () => then_(value => {
//         Js.log2("jpr_nested", value)
//         Js.Promise.resolve(value)
//     }, then_(Fetch.Response.json, Fetch.fetch("http://localhost:3100/api/dockerlist")))

// let blabla = () => Fetch.Response.json
//     ->then_(Fetch.fetch("http://localhost:3100/api/dockerlist"))

let blabla1 = () => Fetch.fetch("http://localhost:3100/api/dockerlist")
    // ->Js.Promise.then_(value => {
    //     // Js.log(value)
    //     Js.Promise.resolve(value + 2)
    //     }, 
    //     _)
    // ->Js.Promise.then_(value => {
    //     // Js.log(value)
    //     Js.Promise.resolve(value + 3)
    //     }, _)
    // ->Js.Promise.then_(value => value, _)
    ->Js.Promise.then_(value => {
        // let _foo = value.json()
        Js.log2("blabla:", value)
        Js.Promise.resolve(value)
        }, _)

// type data = {names: array<string>}


// type point = {
//   x: int,
//   y: int
// };

// type line = {
//   start: point,
//   end_: point,
//   thickness: option<int>
// }



// open Json.Decode

// module Decode = {
//   let point = json =>
//     {
//       x: json |> field("x", int),
//       y: json |> field("y", int)
//     };

//   let line = json =>
//     {
//       start:     json |> field("start", point),
//       end_:      json |> field("end", point),
//       thickness: json |> optional(field("thickness", int))
//     };
// };

// let data = {
//   "start": { "x": 1, "y": -4 },
//   "end":   { "x": 5, "y": 8 }
// } ;

// let line = data |> Json.parseOrRaise
//                 |> Decode.line;