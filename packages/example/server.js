const express = require('express');
const app = express();
const port = 3200;
// TODO fix that this import does not also start the server
const {getNowPlaying} = require('@mdworld/homeremote-stream-player-server');

const startServer = (/*corsMode*/) => {
  // app.get('/', (req, res) => res.sendStatus(404));

  app.use(express.static('build'))

  app.get('/api/nowplaying/radio2', async (req, res) => {
      // if(corsMode === CORS_MODE.DEBUG) {
      //   console.log('CORS DEBUG MODE');
      //   res.header("Access-Control-Allow-Origin", "http://localhost:3000"); // update to match the domain you will make the request from
      //   res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
      // }
      // res.header("Access-Control-Allow-Origin", "http://localhost:3000"); // update to match the domain you will make the request from
      // res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
      try {
        const response = await getNowPlaying();
        res.send(response);
      } catch (error) {
        console.log(error);
        res.sendStatus(500);
      }
    }
  );

  app.listen(port, () => console.log(`App listening on port ${port}!`));
}

startServer();
