const express = require('express');
const app = express();
const port = 3000;
const got = require('got');

// TODO ts-node

// Export for use by other apps
const getNowPlaying = async () => {
  const nowonairResponse = await got('https://radiobox2.omroep.nl/data/radiobox2/nowonair/2.json').json();
  const { artist, title, last_updated } = nowonairResponse.results[0].songfile;
  const broadcastResponse = await got('https://radiobox2.omroep.nl/data/radiobox2/currentbroadcast/2.json').json();
  const { name } = broadcastResponse.results[0];
  return { artist, title, last_updated, name };
}

const startServer = () => {
  app.get('/', (req, res) => res.sendStatus(404));

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

module.exports = {
  getNowPlaying
};
