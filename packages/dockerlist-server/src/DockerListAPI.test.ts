import { getDockerList, startContainer, stopContainer } from "./DockerListAPI";
import * as GotModule from "got";
import { CancelableRequest } from "got";

jest.mock("got");

const gotSpy = jest.spyOn(GotModule, "default");

const createMockRequest = (
    // additional: Record<string, string[]>
    jsonResponse: unknown
): CancelableRequest<unknown> => {
    // const jsonResponse = {
    //     // data: [{ ...mockBaseResponse, ...additional }],
    //     // data: [{ ...additional }],
    //     // ...additional
    // };
    return {
        json: () => Promise.resolve(jsonResponse),
    } as CancelableRequest<unknown>;
};

describe("DockerListAPI", () => {
    beforeEach(() => {
        gotSpy.mockReset();
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

    it("starts a container", async () => {
        gotSpy.mockReturnValue(createMockRequest([]));
        const response = await startContainer(
            "42aebf279f8c95488fab905d788f3caffee6afcaad240fc4aca68106c7173bfe"
        );

        expect(response).toEqual({
            status: "received",
        });
    });

    it("stops a container", async () => {
        gotSpy.mockReturnValue(createMockRequest([]));
        const response = await stopContainer(
            "42aebf279f8c95488fab905d788f3caffee6afcaad240fc4aca68106c7173bfe"
        );

        expect(response).toEqual({
            status: "received",
        });
    });

    it("can return an error when stopping a container", async () => {
        gotSpy.mockReturnValue(createMockRequest([]));
        const response = await stopContainer(
            "42aebf279f8c95488fab905d788f3caffee6afcaad240fc4aca68106c7173bfe"
        );

        expect(response).toEqual({
            status: "error",
        });
    });
});
