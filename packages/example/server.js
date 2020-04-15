const express = require('express');
const app = express();
const port = 3200;
const { getNowPlaying } = require('@mdworld/homeremote-stream-player-server');

const startServer = () => {
  app.use(express.static('build'))

  app.get('/api/nowplaying/radio2', async (req, res) => {
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
