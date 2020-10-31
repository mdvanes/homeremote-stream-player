declare const got: any;
interface NowPlayingResponse {
    artist: string;
    title: string;
    last_updated: string;
    songImageUrl: string;
    name: string;
    imageUrl: string;
}
declare enum ChannelName {
    RADIO2 = 0,
    RADIO3 = 1
}
declare const getNowPlaying: (channelName: ChannelName) => Promise<NowPlayingResponse>;
