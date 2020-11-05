import { getNowPlaying, ChannelName } from "./StreamPlayerAPI";
import * as GotModule from "got";

jest.mock("got");

const gotSpy = jest.spyOn(GotModule, "default");

const SomeArtist = "Some Artist";

describe("StreamPlayerAPI", () => {
    beforeEach(() => {
        gotSpy.mockReset();
        const jsonResponse = {
            data: [{ artist: SomeArtist, presenters: "SomePresenters" }],
        };
        gotSpy.mockReturnValue({
            json: () => jsonResponse,
        } as any);
    });

    it("reponds with transformed message", async () => {
        // const y: Partial<Request> = {
        //     json: (): Promise<any> => ({
        //         data: [{ artist: SomeArtist }],
        //     }),
        // };
        // gotSpy.mockReturnValue({
        //     json: () => ({
        //         data: [{ artist: SomeArtist }],
        //     }),
        // } as any);
        const response = await getNowPlaying(ChannelName.RADIO2);
        expect(gotSpy).toHaveBeenCalledWith(
            "https://www.nporadio2.nl/api/tracks"
        );
        expect(response).toEqual({
            artist: SomeArtist,
            title: undefined, // TODO better mock response
            // eslint-disable-next-line @typescript-eslint/camelcase
            last_updated: undefined,
            songImageUrl: "",
            name: "undefined / SomePresenters",
            imageUrl: "",
        });
    });

    it("can respond when presenters not defined", async () => {
        gotSpy.mockReturnValue({
            json: () => ({
                data: [{ artist: SomeArtist }],
            }),
        } as any);
        const response = await getNowPlaying(ChannelName.RADIO2);
        expect(gotSpy).toHaveBeenCalledWith(
            "https://www.nporadio2.nl/api/tracks"
        );
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

    it("retrieves data from Radio3 endpoint", async () => {
        await getNowPlaying(ChannelName.RADIO3);
        expect(gotSpy).toHaveBeenCalledWith("https://www.npo3fm.nl/api/tracks");
    });

    it("can respond when presenters not defined for Radio 3", async () => {
        gotSpy.mockReturnValue({
            json: () => ({
                data: [{ artist: SomeArtist }],
            }),
        } as any);
        const response = await getNowPlaying(ChannelName.RADIO3);
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

    it("ignores invalid channels", async () => {
        const response = await getNowPlaying(("" as unknown) as ChannelName);
        expect(response).toBeUndefined();
    });
});
