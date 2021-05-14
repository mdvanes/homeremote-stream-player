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

    <div
      style={ReactDOM.Style.make(
        // ~backgroundColor="white",
        ~padding="2px",
        ~borderRadius="2px",
        (),
      )}>
      {React.string("Docker List")} <button className={styles["root"]}> {msg->React.string} </button>
    </div>
  }
}

// Js.log("Hello, World!")
