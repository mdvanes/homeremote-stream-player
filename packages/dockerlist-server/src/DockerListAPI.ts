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

// Using Docker Engine API: curl --unix-socket /var/run/docker.sock http://v1.24/containers/json?all=true
// These urls also work: http://localhost/v1.24/containers/json?all=true or v1.24/containers/json?all=true
const ROOT_URL = "http://v1.41/containers??";

export const getDockerList = async (): Promise<DockerListResponse> => {
    try {
        const result = await got(`${ROOT_URL}/json?all=true`, {
            socketPath: "/var/run/docker.sock",
        }).json<AllResponse>();

        return {
            status: "received",
            containers: result.map(pickAndMapContainerProps),
        };
    } catch (err) {
        console.error(err);
        return {
            status: "error",
        };
    }
};

export const startContainer = async (
    containerId: string
): Promise<DockerListResponse> => {
    try {
        await got(`${ROOT_URL}/${containerId}/start`, {
            method: "POST",
            socketPath: "/var/run/docker.sock",
        }).json<unknown>();
        return {
            status: "received",
        };
    } catch (err) {
        console.error(err);
        return {
            status: "error",
        };
    }
};

export const stopContainer = async (
    containerId: string
): Promise<DockerListResponse> => {
    try {
        await got(`${ROOT_URL}/${containerId}/stop`, {
            method: "POST",
            socketPath: "/var/run/docker.sock",
        }).json<unknown>();
        return {
            status: "received",
        };
    } catch (err) {
        console.error(err);
        return {
            status: "error",
        };
    }
};
