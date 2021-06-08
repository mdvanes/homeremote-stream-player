@react.component
let make = (
  ~width: option<string>=?,
  ~height: option<string>=?,
  ~fill: option<string>=?,
  ~stroke: option<string>=?,
) => <svg focusable="false" viewBox="0 0 24 24" ?width ?height ?fill ?stroke> <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"> </path> </svg>;
