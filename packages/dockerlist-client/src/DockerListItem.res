@module
external styles: {
  "button-list-item": string,
  "mui-button": string,
  "button-success": string,
  "button-error": string,
} = "./DockerList.module.css"

type dockerContainer = {
  "Id": string,
  "Names": Js.Array2.t<Js.String2.t>,
  "State": string,
  "Status": React.element,
}

type setContainersType = (array<dockerContainer> => array<dockerContainer>) => unit

@react.component
let make = (
  ~url: string,
  ~container: dockerContainer,
  ~setContainers: setContainersType,
  ~confirmButtonStyle: ReactDOM.Style.t,
  ~onError: string => unit
) => {
  let id = container["Id"]
  // https://stackoverflow.com/a/32428199: created, restarting, running, paused, exited, dead
  let state = container["State"]
  let isRunning = state == "running"
  let isExited = state == "exited"
  let isUnexpected = !isRunning && !isExited
  let className = StyleUtil.toClassName([
    Name(styles["button-list-item"]),
    Name(styles["mui-button"]),
    NameOn(styles["button-success"], isRunning),
    NameOn(styles["button-error"], isUnexpected),
  ])

  let startContainerAndUpdate = (id: string, _event) => {
    // TODO |> vs ->
    let _ =
      ReasonApi.startContainer(url, id, onError)
      |> Js.Promise.then_(_response => {
        ReasonApi.getDockerList(url, onError)
      })
      |> Js.Promise.then_(containerList => {
        setContainers(_prev => containerList)
        Js.Promise.resolve(containerList)
      })
  }

  let stopContainerAndUpdate = (id: string, _event) => {
    let _ =
      ReasonApi.stopContainer(url, id, onError)
      |> Js.Promise.then_(_response => {
        ReasonApi.getDockerList(url, onError)
      })
      |> Js.Promise.then_(containerList => {
        setContainers(_prev => containerList)
        Js.Promise.resolve(containerList)
      })
  }

  let name =
    container["Names"]
    ->Js.Array2.map(name => Js.String2.sliceToEnd(name, ~from=1))
    ->Js.Array2.joinWith(" ")

  <ButtonWithConfirm
    key={id}
    onClick={if isRunning {
      stopContainerAndUpdate(id)
    } else {
      startContainerAndUpdate(id)
    }}
    className={className}
    question={if isRunning {
      `Do you want to stop ${name}?`
    } else {
      `Do you want to start ${name}?`
    }}
    confirmButtonStyle={confirmButtonStyle}>
    <h1> {name->React.string} </h1> <p> {container["Status"]} </p>
  </ButtonWithConfirm>
}
