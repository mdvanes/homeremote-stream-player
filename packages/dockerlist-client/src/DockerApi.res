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
        if (response.status == "received") {
            Js.Promise.resolve(response.containers)
        } else {
            Js.Exn.raiseError("Invalid getDockerList response")
        }
    }, _)
    |> catch(_err => {
        onError("error in getDockerList")
        Js.Promise.resolve([])
    }, _)

let startContainer = (url: string, id: string, onError: string => unit) => Fetch.fetch(`${url}/api/dockerlist/start/${id}`)
    |> then_(Fetch.Response.text)
    |> then_((jsonResponse) => {
        let response = parseIntoDockerListResponse(jsonResponse)
        if (response.status == "received") {
            Js.Promise.resolve(response.containers)
        } else {
            Js.Exn.raiseError("Invalid startContainer response")
        }
    }, _)
    |> catch(_err => {
        onError("error in startContainer")
        Js.Promise.resolve([])
    }, _)

let stopContainer = (url: string, id: string, onError: string => unit) => Fetch.fetch(`${url}/api/dockerlist/stop/${id}`)
    |> then_(Fetch.Response.text)
    |> then_((jsonResponse) => {
        let response = parseIntoDockerListResponse(jsonResponse)
        if (response.status == "received") {
            Js.Promise.resolve(response.containers)
        } else {
            Js.Exn.raiseError("Invalid stopContainer response")
        }
    }, _)
    |> catch(_err => {
        onError("error in stopContainer")
        Js.Promise.resolve([])
    }, _)
