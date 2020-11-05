/* eslint-disable @typescript-eslint/camelcase */
import got from "got";

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

interface TracksResponse {
    data: [
        { artist: string; title: string; image?: string; enddatetime: string }
    ];
}

interface BroadcastResponse {
    data: [{ title: string; presenters?: string; image_url?: string }];
}

// Export for use by other apps
export const getNowPlaying = async (
    channelName: ChannelName
): Promise<NowPlayingResponse | undefined> => {
    if (channelName === ChannelName.RADIO2) {
        const nowonairResponse = await got(
            "https://www.nporadio2.nl/api/tracks"
        ).json<TracksResponse>();
        const { artist, title, image, enddatetime } = nowonairResponse.data[0];
        const broadcastResponse = await got(
            "https://www.nporadio2.nl/api/broadcasts"
        ).json<BroadcastResponse>();
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
        ).json<TracksResponse>();
        const { artist, title, image, enddatetime } = nowonairResponse.data[0];
        const broadcastResponse = await got(
            "https://www.npo3fm.nl/api/broadcasts"
        ).json<BroadcastResponse>();
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
