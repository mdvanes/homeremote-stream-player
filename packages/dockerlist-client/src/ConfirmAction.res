// {..} means we are handling a JS object with an unknown
// set of attributes
@module external styles: {..} = "./DockerList.module.css"

@send external showModal: Dom.element => unit = "showModal"
@send external close: Dom.element => unit = "close"

// TODO rename to ButtonWithConfirm / ConfirmingButton

// Pass props like: let make = (~count: int) => {
@react.component
let make = (
  ~onClick: ReactEvent.Mouse.t => unit,
  ~question: string,
  ~className: string="",
  ~confirmButtonColor: string="",
) => {
  let dialogEl = React.useRef(Js.Nullable.null)
  let openDialog = _event => {
    // Js.log("handleClickFetch")
    // TODO full screen modal to confirm the action when starting/stopping container
    dialogEl.current->Js.Nullable.toOption->Belt.Option.forEach(input => input->showModal)
  }

  let closeDialog = _event => {
    dialogEl.current->Js.Nullable.toOption->Belt.Option.forEach(input => input->close)
  }

  <>
    <button className={className} onClick={openDialog}> {React.string("modal")} </button>
    <dialog ref={ReactDOM.Ref.domRef(dialogEl)}>
      {question->React.string}
      <button className={styles["button"] ++ " " ++ styles["off"]} onClick={closeDialog}>
        {"cancel"->React.string}
      </button>
      <button
        className={styles["button"]} style={ReactDOM.Style.make(~backgroundColor=confirmButtonColor, ())} onClick={onClick}>
        {"OK"->React.string}
      </button>
    </dialog>
  </>
}
