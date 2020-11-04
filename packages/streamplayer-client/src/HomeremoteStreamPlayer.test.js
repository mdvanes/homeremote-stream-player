/* eslint-disable @typescript-eslint/explicit-function-return-type */
import React, { Component } from "react";
import { render } from "@testing-library/react";
// In this case use `require`, see below. import HomeremoteStreamPlayer from "./HomeremoteStreamPlayer";

let mockSubscribe = () => {
    /* no-op */
};

// Example of naive mock:
// jest.mock("react-elm-components", () => "mock-react-elm-components");

// Example of FC mock:
// jest.mock("react-elm-components", () => (props) => {
//     // Do not destructure `props.ports` to keep destinct from inner `ports` argument
//     console.log("props.ports", props.ports);
//     // ports();
//     const foo = (fn) => {
//         mockSubscribe = fn;
//     };
//     const ports = { setPlayPauseStatusPort: { subscribe: foo } };
//     // triggerPorts =
//     props.ports(ports);
//     return <p data-testid="mock-react-elm-components" />;
// });

// const MockReactElmComponent = React.forwardRef((props, ref) => {
//     // Do not destructure `props.ports` to keep destinct from inner `ports` argument
//     console.log("props.ports", props.ports);
//     // ports();
//     const foo = (fn) => {
//         mockSubscribe = fn;
//     };
//     const ports = { setPlayPauseStatusPort: { subscribe: foo } };
//     // triggerPorts =
//     props.ports(ports);
//     return <p ref={ref} data-testid="mock-react-elm-components" />;
// });

const playSpy = jest.fn();
const pauseSpy = jest.fn();

window.HTMLMediaElement.prototype.play = playSpy;
window.HTMLMediaElement.prototype.pause = pauseSpy;

class MockReactElmComponent extends Component {
    render() {
        // Do not destructure `props.ports` to keep destinct from inner `ports` argument
        const foo = (fn) => {
            mockSubscribe = fn;
        };
        const ports = { setPlayPauseStatusPort: { subscribe: foo } };
        this.props.ports(ports);
        return (
            <p data-testid="mock-react-elm-components">
                <audio />
            </p>
        );
    }
}

// With ref:
jest.mock("react-elm-components", () => MockReactElmComponent);

const HomeremoteStreamPlayer = require("./HomeremoteStreamPlayer").default;

jest.mock("./HomeremoteStreamPlayer.css", () => "");
jest.mock("./Elm/Audio.elm", () => ({
    Elm: {
        Elm: {
            Audio: "mock-elm-audio",
        },
    },
}));

describe("StreamPlayer client", () => {
    beforeEach(() => {
        jest.useFakeTimers();
        playSpy.mockReset();
        pauseSpy.mockReset();
    });

    afterEach(() => {
        jest.runOnlyPendingTimers();
        jest.useRealTimers();
    });

    it("renders the element", () => {
        const { getByTestId } = render(<HomeremoteStreamPlayer />);
        expect(getByTestId("mock-react-elm-components")).toBeInTheDocument();
    });

    it("calls audioElem.play on new status", () => {
        render(<HomeremoteStreamPlayer />);
        expect(playSpy).not.toHaveBeenCalled();
        mockSubscribe("Play");
        jest.runAllTimers();
        expect(playSpy).toHaveBeenCalledWith();
        expect(pauseSpy).not.toHaveBeenCalled();
    });

    it("calls audioElem.pause on new status", () => {
        render(<HomeremoteStreamPlayer />);
        expect(pauseSpy).not.toHaveBeenCalled();
        mockSubscribe("Pause");
        jest.runAllTimers();
        expect(pauseSpy).toHaveBeenCalledWith();
        expect(playSpy).not.toHaveBeenCalled();
    });
});
