import React, { Component } from "react";
import { render, screen, waitFor, wait } from "@testing-library/react";
import { DockerListMod } from "./DockerList.bs";
import { json } from "express";
// import "./DockerList.bs.js";

// eslint-disable-next-line @typescript-eslint/no-var-requires
// const { DockerListMod } = require("./DockerList.bs");

// TODO convert to typescript?
// TODO convert to bs-jest?

const DockerList = DockerListMod.make;

jest.mock("./DockerList.module.css", () => "");

const FOO = {
    status: "received",
    containers: [
        {
            Id:
                "2757091519a2e227b40e6fae4f92b7f4c8b7b189037bda0bc3152ce2be96af9d",
            Names: ["/determined_edison"],
            State: "exited",
            Status: "Exited (1) 5 months ago",
        },
        {
            Id:
                "42aebf279f8c95488fab905d788f3caffee6afcaad240fc4aca68106c7173bfe",
            Names: ["/tinycors"],
            State: "exited",
            Status: "Exited (2) 13 hours ago",
        },
        {
            Id:
                "c7f51601f9870180859a2feb981613b30e3fcd282830b398185aa4facff21be1",
            Names: ["/hello_world"],
            State: "exited",
            Status: "Exited (0) 17 hours ago",
        },
    ],
};

// function getDockerList(url, onError) {
//     var __x = fetch(url + "/api/dockerlist");
//     return handleResponse(__x.then(function (prim) {
//                     return prim.text();
//                   }), onError, "error in getDockerList");

// global.fetch = jest.fn().mockResolvedValue({
//     then: (fn) => {
//         // fn();
//         jest.fn().mockResolvedValue(JSON.stringify(FOO));
//     },
// });

global.fetch = jest.fn().mockResolvedValue({
    text: () => Promise.resolve(JSON.stringify(FOO)),
});

// global.fetch = jest.fn().mockResolvedValue({
//     text: () => jest.fn().mockResolvedValue(FOO),
// });

describe("DockerList client", () => {
    it("trivial test", () => {
        expect(true).toBeTruthy();
    });

    // it("trivial render", () => {
    //     render(<DockerList url={"some_url"} />);
    //     screen.debug();
    // });

    it("trivial render", async () => {
        render(<DockerList url={"some_url"} />);

        await waitFor(() => {
            screen.getByText("determined_edison");
        });
        screen.debug();
    });
});

// In this case use `require`, see below. import StreamPlayer from "./StreamPlayer";

// let mockEmit = () => {
//     /* no-op */
// };

// // Example of naive mock:
// // jest.mock("react-elm-components", () => "mock-react-elm-components");

// // Example of FC mock:
// // jest.mock("react-elm-components", () => (props) => {
// //     // Do not destructure `props.ports` to keep destinct from inner `ports` argument
// //     console.log("props.ports", props.ports);
// //     // ports();
// //     const foo = (fn) => {
// //         mockEmit = fn;
// //     };
// //     const ports = { setPlayPauseStatusPort: { subscribe: foo } };
// //     // triggerPorts =
// //     props.ports(ports);
// //     return <p data-testid="mock-react-elm-components" />;
// // });

// const playSpy = jest.fn();
// const pauseSpy = jest.fn();

// window.HTMLMediaElement.prototype.play = playSpy;
// window.HTMLMediaElement.prototype.pause = pauseSpy;

// class MockReactElmComponent extends Component {
//     render() {
//         // Do not destructure `props.ports` to keep destinct from inner `ports` argument
//         const foo = (fn) => {
//             mockEmit = fn;
//         };
//         const ports = { setPlayPauseStatusPort: { subscribe: foo } };
//         this.props.ports(ports);
//         return (
//             <p data-testid="mock-react-elm-components">
//                 <audio />
//             </p>
//         );
//     }
// }

// With ref:
// jest.mock("react-elm-components", () => MockReactElmComponent);

// eslint-disable-next-line @typescript-eslint/no-var-requires
// const StreamPlayer = require("./StreamPlayer").default;

// jest.mock("./Elm/Audio.elm", () => ({
//     Elm: {
//         Elm: {
//             Audio: "mock-elm-audio",
//         },
//     },
// }));
