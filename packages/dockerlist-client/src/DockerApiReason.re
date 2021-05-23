[@bs.val] external fetch: string => Js.Promise.t('a) = "fetch";

/**
 * This is a .re (ReasonML) file instead of an .res (ReScript) file, because I can't get fetch to work in ReScript
 */

// let unwrapErrorToCb = (error: Js.Promise.error, message: string, cb: string => unit) => {
//   switch error {
//     // | error error => cb(message ++ "some kind of Error")
//     | exception error => {
//       // Note: in reason vs rescript write generic like option(Js.Exn.t) vs option<Js.Exn.t>
//       let optError: option(Js.Exn.t) = Js.Exn.asJsExn(error)
//         switch optError {
//           | Some(error) => {
//               Js.log(Js.Exn.name(error))
//               Js.log(Js.Exn.message(error))
//               // cb(message ++ Js.Exn.name(error) ++ " " ++ Js.Exn.message(error))
//               cb(message)
//             }
//           | None => cb(message ++ "Not a Js.Exn.t")
//         }
//     }
//     // | Js.Exn.Error(_obj) => cb(message ++ "Not an exn")
//     // | Some(m) => cb(message ++ "Not an exn")
//     | _ => cb(message ++ "Not an exn")
//   }
// }

// Note: In Rescript `open Js.Promise` is in Reason `Js.Promise.()`
let getDockerList = (url: string, onError: string => unit) => Js.Promise.(
  (url ++ "/api/dockerlist")
  ->
  fetch
  |> then_(response => response##json())
  // TODO deduplicate response handling with startContainer and stopContainer
  |> then_(jsonResponse => {
        if(jsonResponse##status == "received") {
          Js.Promise.resolve(jsonResponse##containers);
        } else {
          Js.Exn.raiseError("Invalid getDockerList response")
        }
      })
  |> catch(_err => {
        onError("error in getDockerList")
        // unwrapErrorToCb(err, "error in getDockerList:", onError)
        // Note: In Rescript ["a"] is an array, but in Reason ["a"] is a list and [|"a"|] is an array
        Js.Promise.resolve([||]);
      })
  // |> ignore
);

let startContainer = (url: string, id: string, onError: string => unit) => Js.Promise.(
  (url ++ "/api/dockerlist/start/" ++ id)
  ->
  fetch
  |> then_(response => response##json())
  |> then_(jsonResponse => {
        if(jsonResponse##status == "received") {
          Js.Promise.resolve([||]);
        } else {
          Js.Exn.raiseError("Invalid startContainer response")
        }
      })
  |> catch(_err => {
        onError("error in startContainer")
        // Note: In Rescript ["a"] is an array, but in Reason ["a"] is a list and [|"a"|] is an array
        Js.Promise.resolve([||]);
      })
);

let stopContainer = (url: string, id: string, onError: string => unit) => Js.Promise.(
  (url ++ "/api/dockerlist/stop/" ++ id)
  ->
  fetch
  |> then_(response => response##json())
  |> then_(jsonResponse => {
        if(jsonResponse##status == "received") {
          Js.Promise.resolve([||]);
        } else {
          Js.Exn.raiseError("Invalid stopContainer response")
        }
      })
  |> catch(_err => {
        onError("error in stopContainer")
        // Note: In Rescript ["a"] is an array, but in Reason ["a"] is a list and [|"a"|] is an array
        Js.Promise.resolve([||]);
      })
);
