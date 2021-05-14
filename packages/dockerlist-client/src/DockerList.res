// {..} means we are handling a JS object with an unknown
// set of attributes
@module external styles: {..} = "./DockerList.module.css"

type request
type response

@new external makeXMLHttpRequest: unit => request = "XMLHttpRequest"
@send
external addEventListener: (request, string, unit => unit) => unit = "addEventListener"
@get external response: request => response = "response"
@send external open_: (request, string, string) => unit = "open"
@send external send: request => unit = "send"
@send external abort: request => unit = "abort"

@get external status: request => int = "status"

module DockerListMod = {
  type t = {
    address: string,
    total_balance: float,
  }

  @scope("JSON") @val
  external // external parseResponse: response => t = "parse"
  parseResponse: response => {"message": array<string>} = "parse"

  let query = (~address, ~onDone, ~onError /* , () */) => {
    // let query = (~address) => {
    let request = makeXMLHttpRequest()

    request->addEventListener("load", () => onDone(request->response->parseResponse))
    request->addEventListener("error", () => onError(request->status))
    // request->addEventListener("load", () => {
    //   let response = request->response->parseResponse
    //   Js.log(response["message"])
    // })
    // request->addEventListener("error", () => {
    //   Js.log("Error logging here")
    // })

    request->open_("GET", "https://dog.ceo/api/breeds/image/random/" ++ address)
    request->send

    // () => request->abort
  }

  let myQuery = () =>
    query(
      ~address="3",
      ~onDone=response => {
        // let response = request->response->parseResponse
        Js.log(response["message"])
      },
      ~onError=x => {
        // let response = request->response->parseResponse
        Js.log("Error logging: " ++ Belt.Int.toString(x))
      },
    )

  @react.component
  let make = (~count: int) => {
    let times = switch count {
    | 1 => "once"
    | 2 => "twice"
    | n => Belt.Int.toString(n) ++ " times"
    }
    let msg = "Click me " ++ times

    // Runs only once right after mounting the component
    React.useEffect0(() => {
      // Run effects
      query(
        ~address="3",
        ~onDone=response => {
          // let response = request->response->parseResponse
          Js.log(response["message"])
        },
        ~onError=x => {
          // let response = request->response->parseResponse
          Js.log("Error logging: " ++ Belt.Int.toString(x))
        },
      )
      None // or Some(() => {})
    })

    let handleClick = event => {
      // TODO fix assign? Needs the fourth () arg?: myQuery()
      // TODO this is ignored?
      query(
        ~address="3",
        ~onDone=response => {
          // let response = request->response->parseResponse
          Js.log(response["message"])
        },
        ~onError=x => {
          // let response = request->response->parseResponse
          Js.log("Error logging: " ++ Belt.Int.toString(x))
        },
      )
      Js.log("Click!")
      // switch onClick {
      // | Location(location) =>
      //   if Utils.isMouseRightClick(event) {
      //     event |> ReactEvent.Mouse.preventDefault
      //     location |> toString |> RescriptReactRouter.push
      //   }
      // | CustomFn(fn) => fn()
      // }
      // ignore()
    }

    <div
      style={ReactDOM.Style.make(
        // ~backgroundColor="white",
        ~padding="2px",
        ~borderRadius="2px",
        (),
      )}>
      {React.string("Docker List")}
      <button className={styles["root"]} onClick={handleClick}> {msg->React.string} </button>
    </div>
  }
}

// Js.log("Hello, World!")
