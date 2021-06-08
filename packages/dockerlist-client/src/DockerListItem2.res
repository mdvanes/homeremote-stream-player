@module
external styles: {
  "button-list-item": string,
  "mui-button": string,
  "button-success": string,
  "button-error": string,
} = "./DockerList.module.css"

// See https://github.com/cca-io/rescript-material-ui/blob/3ff6bdac3f01c9868ce3a9f903a22ac027f86682/examples/src/examples/ExampleIcons.res
module ErrorIcon = {
  @react.component @module("@material-ui/icons/Error")
  external make: (~color: string=?) => React.element = "default"
}

@react.component
let make = (
  ~url: string,
  ~container: DockerUtil.dockerContainer,
  ~setContainers: DockerUtil.setContainersType,
  ~confirmButtonStyle: ReactDOM.Style.t,
  ~onError: string => unit,
) => {
  open MaterialUi
  let id = container["Id"]
  // https://stackoverflow.com/a/32428199: created, restarting, running, paused, exited, dead
  let state = container["State"]
  let status = container["Status"]
  let isRunning = state == "running"
  let isExited = state == "exited"
  let isUnexpected = !isRunning && !isExited
  let className = DockerUtil.toClassName([
    Name(styles["button-list-item"]),
    Name(styles["mui-button"]),
    // NameOn(styles["button-success"], isRunning),
    NameOn(styles["button-error"], isUnexpected),
  ])

  let (isOpen, setIsOpen) = React.useState(_ => false)

  //   let startContainerAndUpdate = (id: string, _event) => {
  //     // Note: |> is deprecated in favor of ->, however `a |> fn(b)` converts to `fn(b, a)`
  //     // where `a -> fn(b)` converts to `fn(a, b)` and `Js.Promise.then_` has not been optimized
  //     // for this order, e.g. like how Js.Array2 has been optimized for -> while Js.Array is optimized for |>
  //     // This can be remedied by using the _ pipe placeholder. With the placeholder it is possible to write
  //     // ```DockerApi.startContainer(url, id, onError)
  //     // |> Js.Promise.then_(_response => {
  //     //   DockerApi.getDockerList(url, onError)
  //     // })```
  //     // Like:
  //     // ```DockerApi.startContainer(url, id, onError)
  //     // -> Js.Promise.then_(_response => {
  //     //   DockerApi.getDockerList(url, onError)
  //     // }, _)```
  //     let _ = DockerApi.startContainer(url, id, onError)->Js.Promise.then_(_response => {
  //         DockerApi.getDockerList(url, onError)
  //       }, _)->Js.Promise.then_(containerList => {
  //         setContainers(_prev => containerList)
  //         Js.Promise.resolve(containerList)
  //       }, _)
  //   }

  //   let stopContainerAndUpdate = (id: string, _event) => {
  //     let _ =
  //       DockerApi.stopContainer(url, id, onError)
  //       |> Js.Promise.then_(_response => {
  //         DockerApi.getDockerList(url, onError)
  //       })
  //       |> Js.Promise.then_(containerList => {
  //         setContainers(_prev => containerList)
  //         Js.Promise.resolve(containerList)
  //       })
  //   }

  let name =
    container["Names"]
    ->Js.Array2.map(name => Js.String2.sliceToEnd(name, ~from=1))
    ->Js.Array2.joinWith(" ")

  //   let prefix = if isRunning {
  //     ""->React.string
  //   } else {
  //     ""->React.string
  //     // <SVGCross fill="#f44336" width="30" />
  //   }

  //   let suffix = if isRunning {
  //     ""->React.string
  //     // <SVGCheck fill="#4caf50" width="30" />
  //   } else {
  //     ""->React.string
  //   }

  <div>
    <ListItem button={true} onClick={_ev => setIsOpen(_prev => true)}>
      <ListItemIcon>
        <Checkbox
          edge={Checkbox.Edge.start} checked={isRunning} inputProps={{"aria-labelledby": id}}
        />
      </ListItemIcon>
      <ListItemText id={id} primary={name->React.string} secondary={status->React.string} />
      <ListItemIcon>
        <IconButton edge={IconButton.Edge._end}> <ErrorIcon color="error" /> </IconButton>
      </ListItemIcon>
    </ListItem>
    <MaterialUi_Dialog aria_labelledby="simple-dialog-title" _open={isOpen}>
      <MaterialUi_DialogTitle id="simple-dialog-title">
        {`${name} (${state})`->React.string}
      </MaterialUi_DialogTitle>
      <MaterialUi_DialogContent>
        <MaterialUi_Typography> {status->React.string} </MaterialUi_Typography>
      </MaterialUi_DialogContent>
      <MaterialUi_DialogActions>
        <MaterialUi_Button color=#Secondary onClick={_ev => setIsOpen(_prev => false)}>
          {"cancel"->React.string}
        </MaterialUi_Button>
        <MaterialUi_Button color=#Primary> {"OK"->React.string} </MaterialUi_Button>
      </MaterialUi_DialogActions>
    </MaterialUi_Dialog>
  </div>
}
