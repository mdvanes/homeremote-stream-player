import React, { useRef } from "react";
// import "./StreamPlayer.css";
// import Elm from "react-elm-components";
// import Audio from "./Elm/Audio.elm";

// const setupPorts = (containerRef) => (ports) => {
//     ports.setPlayPauseStatusPort.subscribe((newStatus) => {
//         // NOTE: findDomNode has been deprecated
//         const audioElem = containerRef.current.children[0].querySelector(
//             "audio"
//         );
//         // Wait to let the audio elem be updated with a new cachebusting timestamp in Audio.elm `Cmd.batch [ Task.perform UpdateTimestamp Time.now, Cmd.map MsgControls controlsCmds ]`
//         setTimeout(() => {
//             if (newStatus === "Play") {
//                 audioElem.play();
//             } else {
//                 audioElem.pause();
//             }
//         }, 50);
//     });
// };

const DockerList = ({ url }) => {
    const containerRef = useRef(null);
    return (
        <div ref={containerRef}>
            <div
                style={{
                    backgroundColor: "white",
                    padding: 2,
                    borderRadius: 2,
                }}
            >
                Docker List
            </div>

            {/* <Elm
                src={Audio.Elm.Elm.Audio}
                flags={{ url }}
                ports={setupPorts(containerRef)}
            /> */}
        </div>
    );
};

export default DockerList;
