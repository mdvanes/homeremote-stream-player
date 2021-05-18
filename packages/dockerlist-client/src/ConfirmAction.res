// {..} means we are handling a JS object with an unknown
// set of attributes
@module external styles: {..} = "./DockerList.module.css"

@send external showModal: Dom.element => unit = "showModal"
@send external close: Dom.element => unit = "close"

// TODO rename to ButtonWithConfirm / ConfirmingButton

@react.component
let make = (
  ~onClick: ReactEvent.Mouse.t => unit,
  ~question: string,
  ~className: string="",
  ~confirmButtonStyle: ReactDOM.Style.t,
  ~children: React.element
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
    <button className={className} onClick={openDialog}> children </button>
    <dialog ref={ReactDOM.Ref.domRef(dialogEl)}>
      <p> {question->React.string} </p>
      <div className={styles["dialog-actions"]}>
        <button className={styles["mui-button"]} onClick={closeDialog}>
          {"cancel"->React.string}
        </button>
        <button
          className={styles["mui-button"]}
          // style={ReactDOM.Style.make(~backgroundColor=confirmButtonColor, ())}
          style={confirmButtonStyle}
          onClick={(event) => {
              onClick(event);
              closeDialog();
          }}>
          {"OK"->React.string}
        </button>
      </div>
    </dialog>
  </>
}
