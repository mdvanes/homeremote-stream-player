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
  let make = (
    ~url: string,
    ~onError: string => unit,
    // ~confirmButtonStyle: reactDomStyleT=ReactDOM.Style.make(
    //   ~backgroundColor="darkblue",
    //   ~color="white",
    //   (),
    // ),
  ) => {
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
      <Dialog container={selectedContainer} close=(() => setSelectedContainer(_prev => DockerUtil.NoContainer)) />
      
    </div>
  }
}
