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

interface DockerContainerInfo {
    Id: string;
    Names: string[];
    State: string;
    Status: string;
}

// TODO add health
type DockerListResponse = DockerContainerInfo[];

// Export for use by other apps
export const getDockerList = async (
    channelName: ChannelName
): Promise<void> => {
    // docker ps -as --format='{{json .}}' (see system guides for more commands)
    // Using Docker Engine API: curl --unix-socket /var/run/docker.sock http:/v1.24/containers/json?all=true

    const result = await got("http:/v1.41/containers/json?all=true", {
        socketPath: "/var/run/docker.sock",
    }).json<DockerListResponse>();

    // console.log(result);

    console.log(
        result.map((x) => {
            return `name: ${x.Names.join(" ").padEnd(
                22,
                " "
            )}  |  State: ${x.State.padEnd(
                10,
                " "
            )} |  Status: ${x.Status.padEnd(25, " ")} |  Id: ${x.Id.padEnd(
                25,
                " "
            )}`;
        })
    );

    // Start a container:
    // https://docs.docker.com/engine/api/sdk/examples/
    // curl --unix-socket /var/run/docker.sock -X POST http://localhost/v1.41/containers/1c6594faf5/start
    // TODO this works:
    // const result1 = await got(
    //     "http://localhost/v1.41/containers/42aebf279f8c95488fab905d788f3caffee6afcaad240fc4aca68106c7173bfe/start",
    //     {
    //         method: "POST",
    //         socketPath: "/var/run/docker.sock",
    //     }
    // ).json<any>();
    // console.log(result1);

    // OLD:
    // if (channelName === ChannelName.RADIO2) {
    //         const nowonairResponse = await got(
    //             "https://www.nporadio2.nl/api/tracks"
    //         ).json<TracksResponse>();
    //         const { artist, title, image, enddatetime } = nowonairResponse.data[0];
    //         const broadcastResponse = await got(
    //             "https://www.nporadio2.nl/api/broadcasts"
    //         ).json<BroadcastResponse>();
    //         const {
    //             title: name,
    //             presenters,
    //             image_url,
    //         } = broadcastResponse.data[0];
    //         const presentersSuffix = presenters ? ` / ${presenters}` : "";
    //         return {
    //             artist,
    //             title,
    //             last_updated: enddatetime,
    //             songImageUrl: image ?? "",
    //             name: `${name}${presentersSuffix}`,
    //             imageUrl: image_url ?? "",
    //         };
    //     }
    //     if (channelName === ChannelName.RADIO3) {
    //         const nowonairResponse = await got(
    //             "https://www.npo3fm.nl/api/tracks"
    //         ).json<TracksResponse>();
    //         const { artist, title, image, enddatetime } = nowonairResponse.data[0];
    //         const broadcastResponse = await got(
    //             "https://www.npo3fm.nl/api/broadcasts"
    //         ).json<BroadcastResponse>();
    //         const {
    //             title: name,
    //             presenters,
    //             image_url,
    //         } = broadcastResponse.data[0];
    //         const presentersSuffix = presenters ? ` / ${presenters}` : "";
    //         return {
    //             artist,
    //             title,
    //             last_updated: enddatetime,
    //             songImageUrl: image ?? "",
    //             name: `${name}${presentersSuffix}`,
    //             imageUrl: image_url ?? "",
    //         };
    //     }
};
