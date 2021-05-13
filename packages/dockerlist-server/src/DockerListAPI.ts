import got from "got";

// export interface NowPlayingResponse {
//     artist: string;
//     title: string;
//     last_updated: string;
//     songImageUrl: string;
//     name: string;
//     imageUrl: string;
// }

// export enum ChannelName {
//     RADIO2,
//     RADIO3,
// }

// interface TracksResponse {
//     data: [
//         { artist: string; title: string; image?: string; enddatetime: string }
//     ];
// }

// interface BroadcastResponse {
//     data: [{ title: string; presenters?: string; image_url?: string }];
// }

interface DockerContainerInfo {
    Id: string;
    Names: string[];
    State: string;
    Status: string;
}

// TODO add health
type AllResponse = DockerContainerInfo[];

export interface DockerListResponse {
    status: "received";
    containers?: DockerContainerInfo[];
}

const pickAndMapContainerProps = ({
    Id,
    Names,
    State,
    Status,
}: DockerContainerInfo): DockerContainerInfo => ({ Id, Names, State, Status });

// Export for use by other apps
export const getDockerList = async (): Promise<DockerListResponse> => {
    // docker ps -as --format='{{json .}}' (see system guides for more commands)
    // Using Docker Engine API: curl --unix-socket /var/run/docker.sock http:/v1.24/containers/json?all=true

    const result = await got("http:/v1.41/containers/json?all=true", {
        socketPath: "/var/run/docker.sock",
    }).json<AllResponse>();

    // console.log(result);

    return {
        status: "received",
        containers: result.map(pickAndMapContainerProps),
    };
};

export const startContainer = async (
    containerId: string
): Promise<DockerListResponse> => {
    // Start a container:
    // https://docs.docker.com/engine/api/sdk/examples/
    // curl --unix-socket /var/run/docker.sock -X POST http://localhost/v1.41/containers/1c6594faf5/start
    // this works:
    // 42aebf279f8c95488fab905d788f3caffee6afcaad240fc4aca68106c7173bfe
    const result = await got(
        `http://localhost/v1.41/containers/${containerId}/start`,
        {
            method: "POST",
            socketPath: "/var/run/docker.sock",
        }
    ).json<unknown>();
    console.log(result);
    return {
        status: "received",
    };
};

export const stopContainer = async (
    containerId: string
): Promise<DockerListResponse> => {
    const result = await got(
        `http://localhost/v1.41/containers/${containerId}/stop`,
        {
            method: "POST",
            socketPath: "/var/run/docker.sock",
        }
    ).json<unknown>();
    console.log(result);
    return {
        status: "received",
    };
};
