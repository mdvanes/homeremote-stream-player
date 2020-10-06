import React, {useRef} from 'react';
import ReactDOM from 'react-dom';
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

const setupPorts = (elmElem) => (ports) => {
  ports.setPlayPauseStatusPort.subscribe(newStatus => {
    const audioElem = ReactDOM.findDOMNode(elmElem.current).querySelector('audio');
    // Wait 10ms to let the audio elem be updated with a new cachebusting timestamp in Audio.elm `Cmd.batch [ Task.perform UpdateTimestamp Time.now, Cmd.map MsgControls controlsCmds ]`
    setTimeout(() => {
      if(newStatus === 'Play') {
        audioElem.play();
      } else {
        audioElem.pause();
      }
    }, 10);
  })
}

const App = ({ url }) => {
  const elmElem = useRef(null);
  return (
    // <Elm src={Buttons.Elm.Elm.Buttons} />
    <Elm ref={elmElem} src={Audio.Elm.Elm.Audio} flags={{ url } } ports={setupPorts(elmElem)} />
  );
}

export default App;
