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
  ~container: DockerUtil.dockerContainer,
  ~onSelect: DockerUtil.setSelectedContainer,
) => {
  open MaterialUi
  let id = container["Id"]
  // https://stackoverflow.com/a/32428199: created, restarting, running, paused, exited, dead
  let state = container["State"]
  let status = container["Status"]
  let isRunning = state == "running"
  let isExited = state == "exited"
  let isUnexpected = !isRunning && !isExited

  let name =
    container["Names"]
    ->Js.Array2.map(name => Js.String2.sliceToEnd(name, ~from=1))
    ->Js.Array2.joinWith(" ")

  <div>
    <ListItem button={true} dense={true} onClick={_ev => onSelect(DockerContainer(container))}>
      <ListItemIcon>
        <Checkbox
          edge={Checkbox.Edge.start} checked={isRunning} inputProps={{"aria-labelledby": id}}
        />
      </ListItemIcon>
      <ListItemText id={id} primary={name->React.string} secondary={status->React.string} />
      <ListItemIcon>
      {if isUnexpected {
        <IconButton edge={IconButton.Edge._end}> <ErrorIcon color="error" /> </IconButton>
      } else { <></>}}
      </ListItemIcon>
    </ListItem>
  </div>
}
