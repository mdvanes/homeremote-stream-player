const express = require('express');
const app = express();
const port = 3000;
const got = require('got');

app.get('/', (req, res) => res.send('Hello World!'));

app.get('/api/nowplaying/radio2', async (req, res) => {
    try {
      const nowonairResponse = await got('https://radiobox2.omroep.nl/data/radiobox2/nowonair/2.json').json();
      const { artist, title, last_updated } = nowonairResponse.results[0].songfile;
      // console.log(response.results[0].songfile);
      const broadcastResponse = await got('https://radiobox2.omroep.nl/data/radiobox2/currentbroadcast/2.json').json();
      const { name } = broadcastResponse.results[0];
      // console.log(broadcastResponse.results[0].name);
      res.send({ artist, title, last_updated, name });
    } catch (error) {
      console.log(error);
      res.sendStatus(500);
    }
  }
);

app.listen(port, () => console.log(`App listening on port ${port}!`));
