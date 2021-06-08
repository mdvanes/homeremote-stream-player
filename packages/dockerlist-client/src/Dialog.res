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

let getDialog = (close: () => unit) => (c: DockerUtil.selectedContainerType): React.element => {
  open MaterialUi
  switch c {
  | NoContainer => <MaterialUi_Dialog aria_labelledby="dockerlist-dialog-title" _open={false} />
  | DockerContainer(container) => {
      let state = container["State"]
      let status = container["Status"]
      let name =
        container["Names"]
        ->Js.Array2.map(name => Js.String2.sliceToEnd(name, ~from=1))
        ->Js.Array2.joinWith(" ")

      <MaterialUi_Dialog aria_labelledby="dockerlist-dialog-title" _open={true}>
        <DialogTitle id="dockerlist-dialog-title">
          {`${name} (${state})`->React.string}
        </DialogTitle>
        <MaterialUi_DialogContent>
          <MaterialUi_Typography> {status->React.string} </MaterialUi_Typography>
        </MaterialUi_DialogContent>
        <DialogActions>
          <Button color=#Secondary onClick={_ev => close()}>
            {"cancel"->React.string}
          </Button>
          <Button color=#Primary> {"OK"->React.string} </Button>
        </DialogActions>
      </MaterialUi_Dialog>
    }
  }
}

@react.component
let make = (
  //   ~url: string,
  ~container: DockerUtil.selectedContainerType,
  ~close: () => unit
) => {
  //   ~setContainers: DockerUtil.setContainersType,
  //   ~confirmButtonStyle: ReactDOM.Style.t,
  //   ~onError: string => unit, // TODO?
  //   ~onSelect: DockerUtil.setSelectedContainer,

 

  getDialog(close)(container)

  
}
