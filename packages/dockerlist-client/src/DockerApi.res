// NOTE: it might be better to do `|> then_(Fetch.Response.json)` (instead of `|> then_(Fetch.Response.text)`) and then Decode the response with e.g. @glennsl/bs-json
@scope("JSON") @val
external parseIntoDockerListResponse: string => DockerUtil.dockerListResponse = "parse"

open Js.Promise

let handleResponse = (onError: string => unit, errorMessage: string, promise: Js.Promise.t<string>) => promise |> then_(jsonResponse => {
    let response = parseIntoDockerListResponse(jsonResponse)
    if response.status == "received" {
      Js.Promise.resolve(response.containers)
    } else {
      Js.Exn.raiseError("Error in response")
    }
  }, _) |> catch(_err => {
    onError(errorMessage)
    Js.Promise.resolve([])
  }, _)

let getDockerList = (url: string, onError: string => unit) =>
  Fetch.fetch(`${url}/api/dockerlist`)
  |> then_(Fetch.Response.text)
  |> handleResponse(onError, "error in getDockerList")

let startContainer = (url: string, id: string, onError: string => unit) =>
  Fetch.fetch(`${url}/api/dockerlist/start/${id}`)
  |> then_(Fetch.Response.text)
  |> handleResponse(onError, "error in startContainer")

let stopContainer = (url: string, id: string, onError: string => unit) =>
  Fetch.fetch(`${url}/api/dockerlist/stop/${id}`)
  |> then_(Fetch.Response.text)
  |> handleResponse(onError, "error in stopContainer")
