[@bs.val] external fetch: string => Js.Promise.t('a) = "fetch";

// type state =
//   | LoadingDogs
//   | ErrorFetchingDogs
//   | LoadedDogs(array(string));

let testFunc = () => Js.Promise.(
      fetch("https://dog.ceo/api/breeds/image/random/3")
      |> then_(response => response##json())
      |> then_(jsonResponse => {
           // setState(_previousState => LoadedDogs(jsonResponse##message));
           // Js.log2("testFunc Done", jsonResponse##message)
           // Js.Promise.resolve(Belt.List.toArray(jsonResponse##message));
           Js.Promise.resolve(jsonResponse##message);
         })
         // TODO this catch may not resolve to (), it must resolve to an array. Not resolve([]), because that makes it a "list"
      // |> catch(_err => {
      //      // setState(_previousState => ErrorFetchingDogs);
      //      Js.Promise.resolve(Js.Array.from([]));
      //    })
      // |> ignore
    );

// let testFunc = () => 
//       fetch("https://dog.ceo/api/breeds/image/random/3")
//       |> Js.Promise.then_(response => response##json())
//       |> Js.Promise.then_(jsonResponse => {
//            // setState(_previousState => LoadedDogs(jsonResponse##message));
//            Js.log2("testFunc Done", jsonResponse##message)
//            Js.Promise.resolve(jsonResponse##message);
//          })
//       |> Js.Promise.catch(_err => {
//            // setState(_previousState => ErrorFetchingDogs);
//            Js.Promise.resolve([]);
//          })
//       |> ignore
    