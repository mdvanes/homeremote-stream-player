[@bs.val] external fetch: string => Js.Promise.t('a) = "fetch";

// type state =
//   | LoadingDogs
//   | ErrorFetchingDogs
//   | LoadedDogs(array(string));

let myFunc = (): Js.Promise.t('array) => Js.Promise.resolve(["a"])

let fetchDogs = () => Js.Promise.(
      // "https://dog.ceo/api/breeds/image/random/3"
      // ->
      // fetch
      fetch("https://dog.ceo/api/breeds/image/random/3")
      |> then_(response => response##json())
      |> then_(jsonResponse => {
           // setState(_previousState => LoadedDogs(jsonResponse##message));
           // Js.log2("testFunc Done", jsonResponse##message)
           // Js.Promise.resolve(Belt.List.toArray(jsonResponse##message));
           Js.Promise.resolve(jsonResponse##message);
         })
      |> catch(_err => {
           // setState(_previousState => ErrorFetchingDogs);
           // TODO In Rescript ["a"] is an array, but in Reason ["a"] is a list and [|"a"|] is an array
           Js.Promise.resolve([||]);
         })
      // |> ignore
    );

let getDockerList = () => Js.Promise.(
  "http://localhost:3100/api/dockerlist"
  ->
  fetch
  // fetch("http://localhost:3100/api/dockerlist")
  |> then_(response => response##json())
  |> then_(jsonResponse => {
        Js.Promise.resolve(jsonResponse##containers);
      })
  |> catch(_err => {
        // Note: In Rescript ["a"] is an array, but in Reason ["a"] is a list and [|"a"|] is an array
        Js.Promise.resolve([||]);
      })
  // |> ignore
);

let startContainer = (id: string) => Js.Promise.(
  ("http://localhost:3100/api/dockerlist/start/" ++ id)
  ->
  fetch
  // fetch("http://localhost:3100/api/dockerlist")
  |> then_(response => response##json())
  |> then_(jsonResponse => {
        Js.Promise.resolve(jsonResponse##containers);
      })
  |> catch(_err => {
        // Note: In Rescript ["a"] is an array, but in Reason ["a"] is a list and [|"a"|] is an array
        Js.Promise.resolve([||]);
      })
  // |> ignore
);

let stopContainer = (id: string) => Js.Promise.(
  ("http://localhost:3100/api/dockerlist/stop/" ++ id)
  ->
  fetch
  |> then_(response => response##json())
  |> then_(jsonResponse => {
        Js.Promise.resolve(jsonResponse##containers);
      })
  |> catch(_err => {
        // Note: In Rescript ["a"] is an array, but in Reason ["a"] is a list and [|"a"|] is an array
        Js.Promise.resolve([||]);
      })
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
    