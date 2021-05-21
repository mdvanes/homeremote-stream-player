import { getDockerList, startContainer, stopContainer } from "./DockerListAPI";
import * as GotModule from "got";
import { CancelableRequest } from "got";

jest.mock("got");

const gotSpy = jest.spyOn(GotModule, "default");

const createMockRequest = (
    jsonResponse: unknown
): CancelableRequest<unknown> => {
    return {
        json: () => Promise.resolve(jsonResponse),
    } as CancelableRequest<unknown>;
};

const createMockReject = (): CancelableRequest<unknown> => {
    return {
        json: () => Promise.reject(Error("Some Error")),
    } as CancelableRequest<unknown>;
};

describe("DockerListAPI", () => {
    beforeEach(() => {
        gotSpy.mockReset();
        jest.spyOn(console, "error").mockImplementation(() => {
            /* hide console errors when running Jest */
        });
    });

    afterEach(() => {
        (console.error as jest.Mock).mockRestore();
    });

    it("lists all containers", async () => {
        gotSpy.mockReturnValue(
            createMockRequest([
                {
                    RandomProp: "SomeValue",
                    Id: "1",
                    Names: ["a", "b", "c"],
                    State: "started",
                    Status: "started 10 minutes ago",
                },
            ])
        );
        const response = await getDockerList();
        // console.log(
        //     response.containers.map((x) => {
        //         return `name: ${x.Names.join(" ").padEnd(
        //             22,
        //             " "
        //         )}  |  State: ${x.State.padEnd(
        //             10,
        //             " "
        //         )} |  Status: ${x.Status.padEnd(25, " ")} |  Id: ${x.Id.padEnd(
        //             25,
        //             " "
        //         )}`;
        //     })
        // );

        expect(response).toEqual({
            status: "received",
            containers: [
                {
                    Id: "1",
                    Names: ["a", "b", "c"],
                    State: "started",
                    Status: "started 10 minutes ago",
                },
            ],
        });
    });

    it("can return an error when listing all containers", async () => {
        gotSpy.mockReturnValue(createMockReject());
        const response = await getDockerList();

        expect(response).toEqual({
            status: "error",
        });
    });

    it("starts a container", async () => {
        gotSpy.mockReturnValue(createMockRequest([]));
        const response = await startContainer("some_id");

        expect(response).toEqual({
            status: "received",
        });
    });

    it("can return an error when starting a container", async () => {
        gotSpy.mockReturnValue(createMockReject());
        const response = await startContainer("some_id");

        expect(response).toEqual({
            status: "error",
        });
    });

    it("stops a container", async () => {
        gotSpy.mockReturnValue(createMockRequest([]));
        const response = await stopContainer("some_id");

        expect(response).toEqual({
            status: "received",
        });
    });

    it("can return an error when stopping a container", async () => {
        gotSpy.mockReturnValue(createMockReject());
        const response = await stopContainer("some_id");

        expect(response).toEqual({
            status: "error",
        });
    });
});
