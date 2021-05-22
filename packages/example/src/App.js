import React from 'react';
import './App.css';
import StreamPlayer from '@mdworld/homeremote-stream-player';
import DockerList from '@mdworld/homeremote-dockerlist';

function App() {
  return (
    <div className="App">
      <StreamPlayer url="http://localhost:3200" />
      <DockerList url="http://localhost:3200" />
    </div>
  );
}

export default App;
