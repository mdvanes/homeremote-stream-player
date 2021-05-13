import { getDockerList, startContainer, stopContainer } from "./DockerListAPI";
import * as GotModule from "got";
import { CancelableRequest } from "got";

// jest.mock("got");

// const gotSpy = jest.spyOn(GotModule, "default");

// const SomeArtist = "Some Artist";
// const SomeTitle = "Some Title";
// const SomeEndDateTime = "Some End Date Time";
// const SomePresenters = "Some Presenters";
// const SomeImageUrl = "Some Image Url";

// const mockBaseResponse = {
//     artist: SomeArtist,
//     title: SomeTitle,
//     enddatetime: SomeEndDateTime,
// };

// const createMockRequest = (
//     additional: Record<string, string>
// ): CancelableRequest<unknown> => {
//     const jsonResponse = {
//         data: [{ ...mockBaseResponse, ...additional }],
//     };
//     return {
//         json: () => Promise.resolve(jsonResponse),
//     } as CancelableRequest<unknown>;
// };

describe("DockerListAPI", () => {
    // beforeEach(() => {
    //     gotSpy.mockReset();
    //     gotSpy.mockReturnValue(
    //         createMockRequest({
    //             presenters: SomePresenters,
    //             image: SomeImageUrl,
    //         })
    //     );
    // });

    it("lists all containers", async () => {
        const response = await getDockerList();
        // console.log(response);
        // expect(gotSpy).toHaveBeenCalledWith(
        //     "https://www.nporadio2.nl/api/tracks"
        // );
        console.log(
            response.containers.map((x) => {
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

        expect(response).toEqual({
            // artist: SomeArtist,
            // title: SomeTitle,
            // last_updated: SomeEndDateTime,
            // songImageUrl: SomeImageUrl,
            // name: `${SomeTitle} / ${SomePresenters}`,
            // imageUrl: "",
        });
    });

    // TODO this already works, but needs a mock
    it("starts a container", async () => {
        // 42aebf279f8c95488fab905d788f3caffee6afcaad240fc4aca68106c7173bfe
        // const response = await startContainer(
        //     "42aebf279f8c95488fab905d788f3caffee6afcaad240fc4aca68106c7173bfe"
        // );
    });

    // TODO this already works, but needs a mock
    it("stops a container", async () => {
        // const response = await stopContainer(
        //     "42aebf279f8c95488fab905d788f3caffee6afcaad240fc4aca68106c7173bfe"
        // );
    });

    // it("can respond when fields are not defined", async () => {
    //     gotSpy.mockReturnValue(createMockRequest({}));
    //     const response = await getNowPlaying(ChannelName.RADIO2);
    //     expect(gotSpy).toHaveBeenCalledWith(
    //         "https://www.nporadio2.nl/api/tracks"
    //     );
    //     expect(response).toEqual(
    //         expect.objectContaining({
    //             name: SomeTitle,
    //             imageUrl: "",
    //         })
    //     );
    // });

    // it("retrieves data from Radio3 endpoint", async () => {
    //     await getNowPlaying(ChannelName.RADIO3);
    //     expect(gotSpy).toHaveBeenCalledWith("https://www.npo3fm.nl/api/tracks");
    // });

    // it("can respond when fields are not defined for Radio 3", async () => {
    //     gotSpy.mockReturnValue(createMockRequest({}));
    //     const response = await getNowPlaying(ChannelName.RADIO3);
    //     expect(response).toEqual(
    //         expect.objectContaining({
    //             name: SomeTitle,
    //             imageUrl: "",
    //         })
    //     );
    // });

    // it("ignores invalid channels", async () => {
    //     const response = await getNowPlaying(("" as unknown) as ChannelName);
    //     expect(response).toBeUndefined();
    // });
});
