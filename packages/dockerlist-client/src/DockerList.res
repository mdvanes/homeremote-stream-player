// {..} means we are handling a JS object with an unknown
// set of attributes
@module external styles: {..} = "./DockerList.module.css"

@send external showModal: Dom.element => unit = "showModal"
@send external close: Dom.element => unit = "close"

// Workaround: when ReactDom.Style.ts is used directly, it will create an import in Dockerlist.gen.tsx that can't be resolved. It might be fixible with shims, but I don't know how.
@genType.opaque
type reactDomStyleT = ReactDOM.Style.t

let renderAsItem = (setSelectedContainer, dockerContainer) =>
  <DockerListItem
    key={dockerContainer["Id"]}
    container={dockerContainer}
    onSelect={c => setSelectedContainer(_prev => c)}
  />

let renderListCreator = (
  setSelectedContainer,
  arr: array<DockerUtil.dockerContainer>,
): React.element => arr->Js.Array2.map(renderAsItem(setSelectedContainer))->React.array

module DockerListMod = {
  @genType @react.component
  let make = (~url: string, ~onError: string => unit) => {
    let update_interval_ms = 60000

    let (isLoading, setIsLoading) = React.useState(_ => false)
    let (containers, setContainers) = React.useState(_ => [])
    let (selectedContainer, setSelectedContainer) = React.useState(_ => DockerUtil.NoContainer)

    // Runs only once right after mounting the component
    React.useEffect0(() => {
      open Js.Promise
      let update = () => {
        setIsLoading(_prev => true)
        DockerApi.getDockerList(url, onError)->then_(containerList => {
          setContainers(_prev => containerList)
          resolve(containerList)
        }, _)->then_(containerList => {
          setIsLoading(_prev => false)
          resolve(containerList)
        }, _)->ignore
      }

      update()

      let interval = Js.Global.setInterval(update, update_interval_ms)

      // None or Some for a callback
      Some(
        () => {
          Js.Global.clearInterval(interval)
        },
      )
    })

    let nrOfContainers =
      containers->Js.Array2.sortInPlaceWith(DockerUtil.compareDockerContainer)->Belt.Array.length
    let middleIndex = nrOfContainers / 2
    let containersFirstHalf =
      containers
      ->Js.Array2.sortInPlaceWith(DockerUtil.compareDockerContainer)
      ->Js.Array2.slice(~start=0, ~end_=middleIndex)
    let containersSecondHalf =
      containers
      ->Js.Array2.sortInPlaceWith(DockerUtil.compareDockerContainer)
      ->Js.Array2.sliceFrom(middleIndex)

    let renderList = renderListCreator(setSelectedContainer)

    let progressSpacer = <MaterialUi_Box height={MaterialUi_Box.Value.string("4px")} />

    let progress = if isLoading {
      <MaterialUi_LinearProgress />
    } else {
      progressSpacer
    }

    <div className={styles["root"]}>
      <MaterialUi_List> {progress} {containersFirstHalf->renderList} </MaterialUi_List>
      <MaterialUi_List>
        {progressSpacer}
        {containersSecondHalf->renderList}
      </MaterialUi_List>
      <Dialog
        container={selectedContainer}
        toggleContainerState={DockerApi.toggleContainerStateCreator(setContainers, url, onError)}
        close={() => setSelectedContainer(_prev => DockerUtil.NoContainer)}
      />
    </div>
  }
}
