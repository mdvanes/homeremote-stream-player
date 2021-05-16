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
    // let times = switch count {
    // | 1 => "once"
    // | 2 => "twice"
    // | n => Belt.Int.toString(n) ++ " times"
    // }
    // let msg = "Click me " ++ times

    // let (imgs, setImgs) = React.useState(_ => [])

    let (containers, setContainers) = React.useState(_ => [])

    // TODO extract modal
    // let (showModal, setShowModal) = React.useState(_ => false)
    let dialogEl = React.useRef(Js.Nullable.null)

    // Runs only once right after mounting the component
    React.useEffect0(() => {
      // Run effects
      // DockerApi.Api.getDogsAndPrint()
      // DockerApi.Api.getDogsAndShow(~show=_param => setImgs(_prev => _param))
      let _ = ReasonApi.getDockerList() |> Js.Promise.then_(containerList => {
        setContainers(_prev => containerList)
        // Js.log2("SpecialApiTestFunc: ", containerList)
        Js.Promise.resolve(containerList)
      })

      None // or Some(() => {})
    })

    // let handleClick = _event => {
    //   // DockerApi.Api.getDogsAndPrint()
    //   DockerApi.Api.getDogsAndShow(~show=_param => setImgs(_prev => _param))
    // }

    let handleClickFetch = _event => {
      Js.log("handleClickFetch")
      // TODO full screen modal to confirm the action when starting/stopping container
      // dialogEl.current->Js.Nullable.toOption->Belt.Option.forEach(input => input->showModal)

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
    }

    let closeDialog = _event => {
      dialogEl.current->Js.Nullable.toOption->Belt.Option.forEach(input => input->close)
    }

    // let imgElems = React.array([React.string("elem 1")]->Js.Array2.map(a => <h1> a </h1>))
    // let imgElems =
    //   [React.string("elem 1"), React.string("elem 2")]
    //   ->Js.Array2.map(a => <h1> a </h1>)
    //   ->React.array
    //Js.log(result)
    // let fooElems = React.array([React.string("foo")]);
    // let imgElems =
    //   imgs
    //   ->Js.Array2.map(url =>
    //     <img
    //       className={styles["image"]}
    //       // TODO why can "height" not be set?
    //       // style={ReactDOM.Style.make(~height="100px")}
    //       src={url}
    //     />
    //   )
    //   ->React.array

    let dockerContainersElems =
      containers
      ->Js.Array2.map(dockerContainer => {
        let state = dockerContainer["State"]
        let className =
          styles["button"] ++
          " " ++ if state != "running" {
            styles["off"]
          } else {
            ""
          }

        <button className={className}>
          <h1> {dockerContainer["Names"]} </h1> <p> {dockerContainer["Status"]} </p>
        </button>
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
      <div className={styles["button-container"]}>
        <ConfirmAction onClick={handleClickFetch} className={styles["button"]} question="turn on ??" confirmButtonColor="blue" />
        dockerContainersElems
      </div>
      <div
        className={styles["button-container"]} style={ReactDOM.Style.make(~marginTop="2rem", ())}>
        // <button className={styles["button"] ++ " " ++ styles["off"]} onClick={handleClick}>
        //   {msg->React.string}
        // </button>
        <button className={styles["button"] ++ " " ++ styles["off"]} onClick={handleClickFetch}>
          {React.string("modal")}
        </button>
        // <button className={styles["button"] ++ " " ++ styles["off"]} onClick={handleClickFetch}>
        //   <h1> {React.string("Name")} </h1>
        //   // {React.string("State")}
        //   <p> {React.string("Off")} </p>
        // </button>
        // <button className={styles["button"]} onClick={handleClickFetch}>
        //   <h1> {React.string("Bladiebla")} </h1>
        //   // {React.string("State")}
        //   <p> {React.string("Up 2 days")} </p>
        // </button>
        <button className={styles["button"] ++ " " ++ styles["error"]} onClick={handleClickFetch}>
          <h1> {React.string("Errrr")} </h1>
          // {React.string("State")}
          <p> {React.string("Borked")} </p>
        </button>
      </div>
      // <div> imgElems </div>
      // <img
      //   className={styles["image"]}
      //   // TODO why can "height" not be set?
      //   // style={ReactDOM.Style.make(~height="100px")}
      //   src={imgs}
      // />
      <dialog ref={ReactDOM.Ref.domRef(dialogEl)}>
        {
          // style={ReactDOM.Style.make(~height="100px")}>
          "are you sure you want to start container SOMEConTAINEr"->React.string
        }
        <button onClick={closeDialog}> {"close"->React.string} </button>
      </dialog>
    </div>
  }
}

// Js.log("Hello, World!")
