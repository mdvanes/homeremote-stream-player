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



let getDialog = (
  toggleContainerState: DockerUtil.dockerContainer => (string=> unit),
  onClose: unit => unit,
  c: DockerUtil.selectedContainerType,
): React.element => {
  open MaterialUi

  switch c {
  | NoContainer => <MaterialUi_Dialog aria_labelledby="dockerlist-dialog-title" _open={false} />
  | DockerContainer(container) => {
      let id = container["Id"]
      let state = container["State"]
      let isRunning = state == "running"
      let status = container["Status"]
      let name =
        container["Names"]
        ->Js.Array2.map(name => Js.String2.sliceToEnd(name, ~from=1))
        ->Js.Array2.joinWith(" ")
      let questionPrefix = "Do you want to"

    //   let onContinue = toggleContainerState(container)

      <MaterialUi_Dialog aria_labelledby="dockerlist-dialog-title" _open={true}>
        <DialogTitle id="dockerlist-dialog-title">
          {`${name} (${state})`->React.string}
        </DialogTitle>
        <MaterialUi_DialogContent>
          <Typography> {status->React.string} </Typography>
          <Typography>
            {if isRunning {
              `${questionPrefix} stop ${name}?`
            } else {
              `${questionPrefix} start ${name}?`
            }}
          </Typography>
        </MaterialUi_DialogContent>
        <DialogActions>
          <Button color=#Secondary onClick={_ev => onClose()}> {"cancel"->React.string} </Button>
          <Button color=#Primary onClick={_ev => toggleContainerState(container)(id)}> {"OK"->React.string} </Button>
        </DialogActions>
      </MaterialUi_Dialog>
    }
  }
}

@react.component
let make = (
  ~container: DockerUtil.selectedContainerType,
  ~toggleContainerState: DockerUtil.dockerContainer => (string=> unit),
  ~close: unit => unit,
) => {
  //   ~confirmButtonStyle: ReactDOM.Style.t,
  //   ~onError: string => unit, // TODO?
  //   ~onSelect: DockerUtil.setSelectedContainer,

  getDialog(toggleContainerState, close, container)
}
