// {..} means we are handling a JS object with an unknown
// set of attributes
@module external styles: {..} = "./DockerList.module.css"

@send external showModal: Dom.element => unit = "showModal"
@send external close: Dom.element => unit = "close"

// Workaround: when ReactDom.Style.ts is used directly, it will create an import in Dockerlist.gen.tsx that can't be resolved. It might be fixible with shims, but I don't know how.
@genType.opaque
type reactDomStyleT = ReactDOM.Style.t

module DockerListMod = {
  @genType @react.component
  let make = (~url: string, ~onError: string => unit) => {
    // ~confirmButtonStyle: reactDomStyleT=ReactDOM.Style.make(
    //   ~backgroundColor="darkblue",
    //   ~color="white",
    //   (),
    // ),

    let update_interval_ms = 60000

    let (containers, setContainers) = React.useState(_ => [])
    let (selectedContainer, setSelectedContainer) = React.useState(_ => DockerUtil.NoContainer)

    // Runs only once right after mounting the component
    React.useEffect0(() => {
      let update = () => {
        DockerApi.getDockerList(url, onError)
        |> Js.Promise.then_(containerList => {
          setContainers(_prev => containerList)
          Js.Promise.resolve(containerList)
        })
        |> ignore
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

    let toggleContainerState = (c: DockerUtil.dockerContainer): (string => unit) => {
      let state = c["State"]
      let id = c["Id"]
      let isRunning = state == "running"

      let startContainerAndUpdate = (id: string) => {
        // Note: |> is deprecated in favor of ->, however `a |> fn(b)` converts to `fn(b, a)`
        // where `a -> fn(b)` converts to `fn(a, b)` and `Js.Promise.then_` has not been optimized
        // for this order, e.g. like how Js.Array2 has been optimized for -> while Js.Array is optimized for |>
        // This can be remedied by using the _ pipe placeholder. With the placeholder it is possible to write
        // ```DockerApi.startContainer(url, id, onError)
        // |> Js.Promise.then_(_response => {
        //   DockerApi.getDockerList(url, onError)
        // })```
        // Like:
        // ```DockerApi.startContainer(url, id, onError)
        // -> Js.Promise.then_(_response => {
        //   DockerApi.getDockerList(url, onError)
        // }, _)```
        let _ = DockerApi.startContainer(url, id, onError)->Js.Promise.then_(_response => {
            DockerApi.getDockerList(url, onError)
          }, _)->Js.Promise.then_(containerList => {
            setContainers(_prev => containerList)
            Js.Promise.resolve(containerList)
          }, _)
      }

      let stopContainerAndUpdate = (id: string) => {
        let _ =
          DockerApi.stopContainer(url, id, onError)
          |> Js.Promise.then_(_response => {
            DockerApi.getDockerList(url, onError)
          })
          |> Js.Promise.then_(containerList => {
            setContainers(_prev => containerList)
            Js.Promise.resolve(containerList)
          })
      }

      let foo = (_x) =>
        if isRunning {
          stopContainerAndUpdate(id)
        } else {
          startContainerAndUpdate(id)
        }

      foo
    }

    <div className={styles["root"]}>
      // {selectedContainer->React.string}
      <MaterialUi_List>
        {containersFirstHalf
        ->Js.Array2.map(dockerContainer =>
          <DockerListItem2
            key={dockerContainer["Id"]}
            // url={url}
            container={dockerContainer}
            // setContainers={setContainers}
            // confirmButtonStyle={confirmButtonStyle}
            // onError={onError}
            onSelect={c => setSelectedContainer(_prev => c)}
          />
        )
        ->React.array}
      </MaterialUi_List>
      <MaterialUi_List>
        {
          // TODO deduplicate
          containersSecondHalf
          ->Js.Array2.map(dockerContainer =>
            <DockerListItem2
              key={dockerContainer["Id"]}
              // url={url}
              container={dockerContainer}
              // setContainers={setContainers}
              // confirmButtonStyle={confirmButtonStyle}
              // onError={onError}
              onSelect={c => setSelectedContainer(_prev => c)}
            />
          )
          ->React.array
        }
      </MaterialUi_List>
      <Dialog
        container={selectedContainer}
        toggleContainerState={toggleContainerState}
        close={() => setSelectedContainer(_prev => DockerUtil.NoContainer)}
      />
    </div>
  }
}
