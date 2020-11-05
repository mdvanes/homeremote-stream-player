/* eslint-disable @typescript-eslint/camelcase */
/* eslint-disable @typescript-eslint/no-var-requires */
const got = require("got");

export interface NowPlayingResponse {
    artist: string;
    title: string;
    last_updated: string;
    songImageUrl: string;
    name: string;
    imageUrl: string;
}

export enum ChannelName {
    RADIO2,
    RADIO3,
}

// TODO add unit tests

// Export for use by other apps
export const getNowPlaying = async (
    channelName: ChannelName
): Promise<NowPlayingResponse> => {
    if (channelName === ChannelName.RADIO2) {
        const nowonairResponse = await got(
            "https://www.nporadio2.nl/api/tracks"
        ).json();
        const { artist, title, image, enddatetime } = nowonairResponse.data[0];
        const broadcastResponse = await got(
            "https://www.nporadio2.nl/api/broadcasts"
        ).json();
        const {
            title: name,
            presenters,
            image_url,
        } = broadcastResponse.data[0];
        const presentersSuffix = presenters ? ` / ${presenters}` : "";
        return {
            artist,
            title,
            last_updated: enddatetime,
            songImageUrl: image ?? "",
            name: `${name}${presentersSuffix}`,
            imageUrl: image_url ?? "",
        };
    }
    if (channelName === ChannelName.RADIO3) {
        const nowonairResponse = await got(
            "https://www.npo3fm.nl/api/tracks"
        ).json();
        const { artist, title, image, enddatetime } = nowonairResponse.data[0];
        const broadcastResponse = await got(
            "https://www.npo3fm.nl/api/broadcasts"
        ).json();
        const {
            title: name,
            presenters,
            image_url,
        } = broadcastResponse.data[0];
        const presentersSuffix = presenters ? ` / ${presenters}` : "";
        return {
            artist,
            title,
            last_updated: enddatetime,
            songImageUrl: image ?? "",
            name: `${name}${presentersSuffix}`,
            imageUrl: image_url ?? "",
        };
    }
};
