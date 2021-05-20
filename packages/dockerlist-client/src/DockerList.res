// {..} means we are handling a JS object with an unknown
// set of attributes
@module external styles: {..} = "./DockerList.module.css"

@send external showModal: Dom.element => unit = "showModal"
@send external close: Dom.element => unit = "close"

module DockerListMod = {
  @genType @react.component
  let make = (
    ~url: string,
    ~onError: string => unit,
    ~confirmButtonStyle: ReactDOM.Style.t=ReactDOM.Style.make(
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
        ReasonApi.getDockerList(url, onError)
        |> Js.Promise.then_(containerList => {
          // Js.log()
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
      <div className={styles["button-list"]}> dockerContainersElems </div>
    </div>
  }
}
