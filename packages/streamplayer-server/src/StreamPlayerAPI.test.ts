import { getNowPlaying, ChannelName } from "./StreamPlayerAPI";
import * as GotModule from "got";

jest.mock("got");

const gotSpy = jest.spyOn(GotModule, "default");

describe("StreamPlayerAPI", () => {
    it("reponds with transformed message", async () => {
        const SomeArtist = "Some Artist";
        // const y: Partial<Request> = {
        //     json: (): Promise<any> => ({
        //         data: [{ artist: SomeArtist }],
        //     }),
        // };
        gotSpy.mockReturnValue({
            json: () => ({
                data: [{ artist: SomeArtist }],
            }),
        } as any);
        const response = await getNowPlaying(ChannelName.RADIO2);
        expect(response).toEqual({
            artist: SomeArtist,
            title: undefined, // TODO better mock response
            // eslint-disable-next-line @typescript-eslint/camelcase
            last_updated: undefined,
            songImageUrl: "",
            name: "undefined",
            imageUrl: "",
        });
    });
});
