import React from 'react';
import './App.css';
import HomeremoteStreamPlayer from '@mdworld/homeremote-stream-player';

function App() {
  return (
    <div className="App">
      <HomeremoteStreamPlayer url="http://localhost:3200" />
    </div>
  );
}

export default App;
