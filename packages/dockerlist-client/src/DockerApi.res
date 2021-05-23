// NOTE: it might be better to do `|> then_(Fetch.Response.json)` (instead of `|> then_(Fetch.Response.text)`) and then Decode the response with e.g. @glennsl/bs-json
@scope("JSON") @val
external parseIntoDockerListResponse: string => DockerUtil.dockerListResponse = "parse"

open Js.Promise

// Prevent type casting with Obj.magic, e.g. like let message: string = err->Obj.magic, see https://dev.to/fhammerschmidt/reason-react-best-practices-2cb7
// Convert Js.Promise.error to string (effectively an unchecked type cast)
external promiseErrToString: Js.Promise.error => string = "%identity";

let handleResponse = (
  promise: Js.Promise.t<string>,
  onError: string => unit,
  errorMessage: string,
) => promise
  ->then_(jsonResponse => {
    let response = parseIntoDockerListResponse(jsonResponse)
    switch response.status {
    | "received" => Js.Promise.resolve(response.containers)
    | _ => Js.Exn.raiseError("Error in response")
    }
  }, _)
  ->catch(err => {
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
