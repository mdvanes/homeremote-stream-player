const got = require('got');

interface NowPlayingResponse {
    artist: string;
    title: string;
    last_updated: string;
    songImageUrl: string;
    name: string;
    imageUrl: string;
}

enum ChannelName {
    RADIO2,
    RADIO3
}

// Export for use by other apps
const getNowPlaying = async (channelName: ChannelName): Promise<NowPlayingResponse> => {
    if (channelName === ChannelName.RADIO2) {
        const nowonairResponse = await got('https://radiobox2.omroep.nl/data/radiobox2/nowonair/2.json').json();
        const {artist, title, last_updated, songversion} = nowonairResponse.results[0].songfile;
        const songImageUrl = songversion && songversion.image && songversion.image[0].url ? songversion.image[0].url : '';
        const broadcastResponse = await got('https://radiobox2.omroep.nl/data/radiobox2/currentbroadcast/2.json').json();
        const {name, image} = broadcastResponse.results[0];
        const imageUrl = image && image.url ? image.url : '';
        return {artist, title, last_updated, songImageUrl, name, imageUrl};
    }
    if (channelName === ChannelName.RADIO3) {
        const nowonairResponse = await got('https://www.npo3fm.nl/api/tracks').json();
        const {artist, title, image, enddatetime} = nowonairResponse.data[0];
        const broadcastResponse = await got('https://www.npo3fm.nl/api/broadcasts').json();
        const {title: name, presenters, image_url} = broadcastResponse.data[0];
        return {
            artist,
            title,
            last_updated: enddatetime,
            songImageUrl: image,
            name: `${name} / ${presenters}`,
            imageUrl: image_url
        }
    }
}

module.exports = {
    getNowPlaying,
    ChannelName
};
