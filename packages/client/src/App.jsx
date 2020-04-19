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

const setupPorts = (ports) => {
  ports.setPlayPauseStatusPort.subscribe(newStatus => {
    // TODO use ref instead of getElementById
    const audioElem = document.getElementById("homeremote-stream-player-audio-elem");
    if(newStatus === 'Play') {
      audioElem.play();
    } else {
      audioElem.pause();
    }
  })
}

const App = ({ url }) =>(
  // <Elm src={Buttons.Elm.Elm.Buttons} />
  <Elm id="elm" src={Audio.Elm.Elm.Audio} flags={{ url } } ports={setupPorts} />
);

export default App;
