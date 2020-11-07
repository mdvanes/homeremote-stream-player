import React, { useRef } from "react";
import ReactDOM from "react-dom";
import "./StreamPlayer.css";
import Elm from "react-elm-components";
import Audio from "./Elm/Audio.elm";

const setupPorts = (elmElem) => (ports) => {
    ports.setPlayPauseStatusPort.subscribe((newStatus) => {
        const audioElem = ReactDOM.findDOMNode(elmElem.current).querySelector(
            "audio"
        );
        // Wait to let the audio elem be updated with a new cachebusting timestamp in Audio.elm `Cmd.batch [ Task.perform UpdateTimestamp Time.now, Cmd.map MsgControls controlsCmds ]`
        setTimeout(() => {
            if (newStatus === "Play") {
                audioElem.play();
            } else {
                audioElem.pause();
            }
        }, 50);
    });
};

const StreamPlayer = ({ url }) => {
    const elmElem = useRef(null);
    return (
        <Elm
            ref={elmElem}
            src={Audio.Elm.Elm.Audio}
            flags={{ url }}
            ports={setupPorts(elmElem)}
        />
    );
};

export default StreamPlayer;
