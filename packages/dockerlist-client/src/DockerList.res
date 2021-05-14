// {..} means we are handling a JS object with an unknown
// set of attributes
@module external styles: {..} = "./DockerList.module.css"

module DockerListMod = {
  @react.component
  let make = (~count: int) => {
    let times = switch count {
    | 1 => "once"
    | 2 => "twice"
    | n => Belt.Int.toString(n) ++ " times"
    }
    let msg = "Click me " ++ times

    let (imgs, setImgs) = React.useState(_ =>
      "https://images.dog.ceo/breeds/waterdog-spanish/20180714_201544.jpg"
    )

    // Runs only once right after mounting the component
    React.useEffect0(() => {
      // Run effects
      DockerApi.Api.getDogsAndPrint()
      None // or Some(() => {})
    })

    let handleClick = _event => {
      // DockerApi.Api.getDogsAndPrint()
      DockerApi.Api.getDogsAndShow(~show=_param => setImgs(_prev => _param))
    }

    let handleClickFetch = _event => {
      Js.log("handleClickFetch")
      // TODO DockerApi.Api.getDogsFetch()
    }

    <div
      className={styles["root"]}
      style={ReactDOM.Style.make(
        // ~backgroundColor="white",
        ~padding="2px",
        ~borderRadius="2px",
        (),
      )}>
      {React.string("Docker List")}
      <button className={styles["button"]} onClick={handleClick}> {msg->React.string} </button>
      <button className={styles["button"]} onClick={handleClickFetch}>
        {React.string("with Fetch Api")}
      </button>
      <img
        className={styles["image"]}
        // TODO why can "height" not be set?
        // style={ReactDOM.Style.make(~height="100px")}
        src={imgs}
      />
    </div>
  }
}

// Js.log("Hello, World!")
