import React from 'react';
import './App.css';
import Elm from 'react-elm-components';
// import Buttons from './Elm/Buttons.elm';
import Audio from './Elm/Audio.elm';

// function App() {
//   return (
//     <div className="App">
//       <header className="App-header">
//         <img src={logo} className="App-logo" alt="logo" />
//         <p>
//           Edit <code>src/App.js</code> and save to reload.
//         </p>
//         <a
//           className="App-link"
//           href="https://reactjs.org"
//           target="_blank"
//           rel="noopener noreferrer"
//         >
//           Learn React
//         </a>
//       </header>
//     </div>
//   );
// }

const App = ({ url }) =>(
  // <Elm src={Buttons.Elm.Elm.Buttons} />
  <Elm src={Audio.Elm.Elm.Audio} flags={{ url } } />
);

export default App;
