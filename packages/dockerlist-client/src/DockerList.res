// {..} means we are handling a JS object with an unknown
// set of attributes
@module external styles: {..} = "./DockerList.module.css"
// @module
// external styles: {"root": string, "button": string, "button-container": string, "off": string, "error": string, "image": string} =
//   "./DockerList.module.css"

@send external showModal: Dom.element => unit = "showModal"
@send external close: Dom.element => unit = "close"

module DockerListMod = {
  // Pass props like: let make = (~count: int) => {
  @react.component
  let make = () => {
    let update_interval_ms = 60000

    let (containers, setContainers) = React.useState(_ => [])

    // Runs only once right after mounting the component
    React.useEffect0(() => {
      let update = () => {
        ReasonApi.getDockerList()
        |> Js.Promise.then_(containerList => {
          setContainers(_prev => containerList)
          Js.Promise.resolve(containerList)
        })
        |> ignore
      }

      update()

      let _ = Js.Global.setInterval(update, update_interval_ms)

      None // or Some(() => {})
    })

    let handleClickFetch = (id: string, _event) => {
      Js.log("handleClickFetch")
      // Works:
      // let _ = DockerApi.Api.getDogsFetch()

      // Works:
      // let _ =
      //   DockerApi.Api.getDogsFetch()
      //   |> Js.Promise.then_(Fetch.Response.text)
      //   |> Js.Promise.then_(text => print_endline("endline: " ++ text) |> Js.Promise.resolve)
      //   |> Js.Promise.then_(
      //     value => {
      //       Js.log2("handleClickFetch: ", value)
      //       Js.Promise.resolve(value)
      //     },
      //     // value
      //     _,
      //   )

      // let _ = ReasonApi.fetchDogs() |> Js.Promise.then_(imgList => {
      //   setImgs(_prev => imgList)
      //   Js.log2("SpecialApiTestFunc: ", imgList)
      //   Js.Promise.resolve(imgList)
      // })

      let _ = ReasonApi.getDockerList() |> Js.Promise.then_(containerList => {
        setContainers(_prev => containerList)
        // Js.log2("SpecialApiTestFunc: ", containerList)
        Js.Promise.resolve(containerList)
      })

      let _ = ReasonApi.startContainer(id) |> Js.Promise.then_(containerList => {
        setContainers(_prev => containerList)
        // Js.log2("SpecialApiTestFunc: ", containerList)
        Js.Promise.resolve(containerList)
      })
    }

    let startContainerAndUpdate = (id: string, _event) => {
      // TODO |> vs ->
      // TODO handle error?
      let _ =
        ReasonApi.startContainer(id)
        |> Js.Promise.then_(_response => {
          ReasonApi.getDockerList()
        })
        |> Js.Promise.then_(containerList => {
          setContainers(_prev => containerList)
          Js.Promise.resolve(containerList)
        })
    }

    let stopContainerAndUpdate = (id: string, _event) => {
      let _ =
        ReasonApi.stopContainer(id)
        |> Js.Promise.then_(_response => {
          ReasonApi.getDockerList()
        })
        |> Js.Promise.then_(containerList => {
          setContainers(_prev => containerList)
          Js.Promise.resolve(containerList)
        })
    }

    let dockerContainersElems =
      containers
      ->Js.Array2.map(dockerContainer => {
        let id = dockerContainer["Id"]
        let isRunning = dockerContainer["State"] == "running"
        let className =
          // TODO convenience method for multiple classNames?
          `${styles["button-list-item"]} ${styles["mui-button"]} ` ++ if isRunning {
            styles["button-success"]
          } else {
            ""
          }

        let name =
          dockerContainer["Names"]
          ->Js.Array2.map(name => Js.String2.sliceToEnd(name, ~from=1))
          ->Js.Array2.joinWith(" ")

        <ConfirmAction
          key={id}
          onClick={if isRunning {
            stopContainerAndUpdate(id)
          } else {
            startContainerAndUpdate(id)
          }}
          className={className}
          question={if isRunning {
            `Do you want to stop ${name}?`
          } else {
            `Do you want to start ${name}?`
          }}
          confirmButtonStyle={ReactDOM.Style.make(~backgroundColor="darkblue", ~color="white", ())}>
          <h1> {name->React.string} </h1> <p> {dockerContainer["Status"]} </p>
        </ConfirmAction>
      })
      ->React.array

    // open MaterialUi
    <div className={styles["root"]}>
      // <h1>
      //   {
      //     // <Typography variant=#H4 gutterBottom=true> {"Headline"->React.string} </Typography>
      //     // <MaterialUi_Typography> {"Some example text"->React.string} </MaterialUi_Typography>
      //     React.string("Docker List")
      //   }
      // </h1>
      // <h1> {"Docker List"->React.string} </h1>
      <div className={styles["button-list"]}>
        <ConfirmAction
          onClick={handleClickFetch("some-id")}
          className={styles["button-list-item"] ++ " " ++ styles["mui-button"]}
          question="turn on ?? such a long text oh wow so long wow wow wow wow wow"
          confirmButtonStyle={ReactDOM.Style.make(~backgroundColor="darkblue", ~color="white", ())}>
          {"modal"->React.string}
        </ConfirmAction>
        dockerContainersElems
      </div>
      <div className={styles["button-list"]} style={ReactDOM.Style.make(~marginTop="2rem", ())}>
        // <button className={styles["button"] ++ " " ++ styles["off"]} onClick={handleClick}>
        //   {msg->React.string}
        // </button>
        <button className={styles["mui-button"]} onClick={handleClickFetch("some-id")}>
          {React.string("modal")}
        </button>
        <button
          className={styles["mui-button"] ++ " " ++ styles["button-error"]}
          onClick={handleClickFetch("some-id")}>
          <h1> {React.string("Errrr")} </h1>
          <p> {React.string("Borked")} </p>
        </button>
      </div>
    </div>
  }
}
