const got = require('got');

interface NowPlayingResponse {
    artist: string;
    title: string;
    last_updated: string;
    songImageUrl: string;
    name: string;
    imageUrl: string;
}

// Export for use by other apps
const getNowPlaying = async (): Promise<NowPlayingResponse> => {
  const nowonairResponse = await got('https://radiobox2.omroep.nl/data/radiobox2/nowonair/2.json').json();
  const { artist, title, last_updated, songversion } = nowonairResponse.results[0].songfile;
  const songImageUrl = songversion && songversion.image && songversion.image[0].url ? songversion.image[0].url : '';
  const broadcastResponse = await got('https://radiobox2.omroep.nl/data/radiobox2/currentbroadcast/2.json').json();
  const { name, image } = broadcastResponse.results[0];
  const imageUrl = image && image.url ? image.url : '';
  return { artist, title, last_updated, songImageUrl, name, imageUrl };
}

module.exports = {
  getNowPlaying
};
