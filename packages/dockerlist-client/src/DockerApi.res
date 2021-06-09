// NOTE: it might be better to do `|> then_(Fetch.Response.json)` (instead of `|> then_(Fetch.Response.text)`) and then Decode the response with e.g. @glennsl/bs-json
@scope("JSON") @val
external parseIntoDockerListResponse: string => DockerUtil.dockerListResponse = "parse"

open Js.Promise

// Prevent type casting with Obj.magic, e.g. like let message: string = err->Obj.magic, see https://dev.to/fhammerschmidt/reason-react-best-practices-2cb7
// Convert Js.Promise.error to string (effectively an unchecked type cast)
external promiseErrToString: Js.Promise.error => string = "%identity"

let handleResponse = (
  promise: Js.Promise.t<string>,
  onError: string => unit,
  errorMessage: string,
) => promise->then_(jsonResponse => {
    let response = parseIntoDockerListResponse(jsonResponse)
    switch response.status {
    | "received" => Js.Promise.resolve(response.containers)
    | _ => Js.Exn.raiseError("Error in response")
    }
  }, _)->catch(err => {
    let message: string = err->promiseErrToString
    onError(`${errorMessage} ${message}`)
    Js.Promise.resolve([])
  }, _)

let getDockerList = (url: string, onError: string => unit) =>
  Fetch.fetch(`${url}/api/dockerlist`)
  ->then_(Fetch.Response.text, _)
  ->handleResponse(onError, "error in getDockerList")

let startContainer = (url: string, id: string, onError: string => unit) =>
  Fetch.fetch(`${url}/api/dockerlist/start/${id}`)
  ->then_(Fetch.Response.text, _)
  ->handleResponse(onError, "error in startContainer")

let stopContainer = (url: string, id: string, onError: string => unit) =>
  Fetch.fetch(`${url}/api/dockerlist/stop/${id}`)
  ->then_(Fetch.Response.text, _)
  ->handleResponse(onError, "error in stopContainer")

// Note: |> is deprecated in favor of ->, however `a |> fn(b)` converts to `fn(b, a)`
// where `a -> fn(b)` converts to `fn(a, b)` and `Js.Promise.then_` has not been optimized
// for this order, e.g. like how Js.Array2 has been optimized for -> while Js.Array is optimized for |>
// This can be remedied by using the _ pipe placeholder. With the placeholder it is possible to write
// ```DockerApi.startContainer(url, id, onError)
// |> Js.Promise.then_(_response => {
//   DockerApi.getDockerList(url, onError)
// })```
// Like:
// ```DockerApi.startContainer(url, id, onError)
// -> Js.Promise.then_(_response => {
//   DockerApi.getDockerList(url, onError)
// }, _)```
let toggleContainerStateCreator = (
  setContainers: DockerUtil.setContainersType,
  url: string,
  onError: string => unit,
  setIsLoading: (bool => bool) => unit
): (DockerUtil.dockerContainer => Js.Promise.t<array<DockerUtil.dockerContainer>>) => {
  let startContainerWithJustId = startContainer(url, _, onError)
  let stopContainerWithJustId = stopContainer(url, _, onError)

  let toggleFn = container => {
    setIsLoading(_prev => true);
    let state = container["State"]
    let id = container["Id"]
    let isRunning = state == "running"

    let action = if isRunning {
      stopContainerWithJustId
    } else {
      startContainerWithJustId
    }

    action(id)->Js.Promise.then_(_response => {
      getDockerList(url, onError)
    }, _)->Js.Promise.then_(containerList => {
      setContainers(_prev => containerList)
      setIsLoading(_prev => false)
      Js.Promise.resolve(containerList)
    }, _)
  }

  toggleFn
}
