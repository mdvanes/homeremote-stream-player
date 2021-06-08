@module
external styles: {
  "button-list-item": string,
  "mui-button": string,
  "button-success": string,
  "button-error": string,
} = "./DockerList.module.css"

let getDialog = (
  toggleContainerState: (
    DockerUtil.dockerContainer
  ) => Js.Promise.t<array<DockerUtil.dockerContainer>>,
  onClose: unit => unit,
  c: DockerUtil.selectedContainerType,
): React.element => {
  open MaterialUi

  switch c {
  | NoContainer => <MaterialUi_Dialog aria_labelledby="dockerlist-dialog-title" _open={false} />
  | DockerContainer(container) => {
      let state = container["State"]
      let isRunning = state == "running"
      let status = container["Status"]
      let name =
        container["Names"]
        ->Js.Array2.map(name => Js.String2.sliceToEnd(name, ~from=1))
        ->Js.Array2.joinWith(" ")
      let questionPrefix = "Do you want to"

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
          <Button
            color=#Primary
            onClick={_ev => {
              let _ = toggleContainerState(container)->Js.Promise.then_(_containers => {
                onClose()
                Js.Promise.resolve()
              }, _)
            }}>
            {"OK"->React.string}
          </Button>
        </DialogActions>
      </MaterialUi_Dialog>
    }
  }
}

@react.component
let make = (
  ~container: DockerUtil.selectedContainerType,
  ~toggleContainerState: (
    DockerUtil.dockerContainer
  ) => Js.Promise.t<array<DockerUtil.dockerContainer>>,
  ~close: unit => unit,
) => {
  getDialog(toggleContainerState, close, container)
}
