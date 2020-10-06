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
        const nowonairResponse = await got('https://www.nporadio2.nl/api/tracks').json();
        const {artist, title, image, enddatetime} = nowonairResponse.data[0];
        const broadcastResponse = await got('https://www.nporadio2.nl/api/broadcasts').json();
        const {title: name, presenters, image_url} = broadcastResponse.data[0];
        const presentersSuffix = presenters ? ` / ${presenters}` : '';
        return {
            artist,
            title,
            last_updated: enddatetime,
            songImageUrl: image ?? "",
            name: `${name}${presentersSuffix}`,
            imageUrl: image_url ?? ""
        }
    }
    if (channelName === ChannelName.RADIO3) {
        const nowonairResponse = await got('https://www.npo3fm.nl/api/tracks').json();
        const {artist, title, image, enddatetime} = nowonairResponse.data[0];
        const broadcastResponse = await got('https://www.npo3fm.nl/api/broadcasts').json();
        const {title: name, presenters, image_url} = broadcastResponse.data[0];
        const presentersSuffix = presenters ? ` / ${presenters}` : '';
        return {
            artist,
            title,
            last_updated: enddatetime,
            songImageUrl: image ?? "",
            name: `${name}${presentersSuffix}`,
            imageUrl: image_url ?? ""
        }
    }
}

module.exports = {
    getNowPlaying,
    ChannelName
};
