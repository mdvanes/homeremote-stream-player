import React from "react";
import { render } from "@testing-library/react";
import HomeremoteStreamPlayer from "./HomeremoteStreamPlayer";

jest.mock("./HomeremoteStreamPlayer.css", () => "");
jest.mock("./Elm/Audio.elm", () => ({
    Elm: {
        Elm: {
            Audio: "mock-elm-audio",
        },
    },
}));
jest.mock("react-elm-components", () => "mock-react-elm-components");

describe("StreamPlayer client", () => {
    it("renders the element", () => {
        const { baseElement } = render(<HomeremoteStreamPlayer />);
        expect(
            baseElement
                .querySelector("mock-react-elm-components")
                .getAttribute("src")
        ).toBe("mock-elm-audio");
    });
});
