import got from "got";

interface DockerContainerInfo {
    Id: string;
    Names: string[];
    State: string;
    Status: string;
}

type AllResponse = DockerContainerInfo[];

export interface DockerListResponse {
    status: "received" | "error";
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

    // TODO add error handling
    const result = await got("http:/v1.41/containers/json?all=true", {
        socketPath: "/var/run/docker.sock",
    }).json<AllResponse>();

    return {
        status: "received",
        containers: result.map(pickAndMapContainerProps),
    };
};

export const startContainer = async (
    containerId: string
): Promise<DockerListResponse> => {
    // TODO add error handling
    await got(`http://localhost/v1.41/containers/${containerId}/start`, {
        method: "POST",
        socketPath: "/var/run/docker.sock",
    }).json<unknown>();
    console.log("before received");
    return {
        status: "received",
    };
};

export const stopContainer = async (
    containerId: string
): Promise<DockerListResponse> => {
    try {
        const result = await got(
            // TODO using invalid url to emulate error
            `http://localhost/v1.41/containers/111${containerId}/stop`,
            {
                method: "POST",
                socketPath: "/var/run/docker.sock",
            }
        ).json<unknown>();
        console.log("result", result);
        return {
            status: "received",
        };
    } catch (err) {
        console.log("err", err);
        return {
            status: "error",
        };
    }
};
