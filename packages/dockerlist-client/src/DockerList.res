// {..} means we are handling a JS object with an unknown
// set of attributes
@module external styles: {..} = "./DockerList.module.css"

@send external showModal: Dom.element => unit = "showModal"
@send external close: Dom.element => unit = "close"

// Workaround: when ReactDom.Style.ts is used directly, it will create an import in Dockerlist.gen.tsx that can't be resolved. It might be fixible with shims, but I don't know how.
@genType.opaque
type rdStyleT = ReactDOM.Style.t

module DockerListMod = {
  @genType @react.component
  let make = (
    ~url: string,
    ~onError: string => unit,
    ~confirmButtonStyle: rdStyleT=ReactDOM.Style.make(
      ~backgroundColor="darkblue",
      ~color="white",
      (),
    ),
  ) => {
    let update_interval_ms = 60000

    let (containers, setContainers) = React.useState(_ => [])

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

    let dockerContainersElems =
      containers
      ->Js.Array2.sortInPlaceWith(DockerUtil.compareDockerContainer)
      ->Js.Array2.map(dockerContainer =>
        <DockerListItem
          key={dockerContainer["Id"]}
          url={url}
          container={dockerContainer}
          setContainers={setContainers}
          confirmButtonStyle={confirmButtonStyle}
          onError={onError}
        />
      )
      ->React.array

    <div className={styles["root"]}>
      <table className={styles["button-list"]}>
        <thead>
          <tr>
            <th> {"State"->React.string} </th>
            <th> {"Name"->React.string} </th>
            <th> {"Status"->React.string} </th>
          </tr>
        </thead>
        <tbody> dockerContainersElems </tbody>
      </table>
    </div>
  }
}
