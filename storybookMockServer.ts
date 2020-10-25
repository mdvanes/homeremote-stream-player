/* eslint-disable @typescript-eslint/no-var-requires */
const express = require("express");
const app = express();
const {
    getNowPlaying,
    ChannelName,
} = require("./packages/streamplayer-server/lib");

const port = 3100;

enum CORS_MODE {
    NONE,
    DEBUG,
}

const corsMode: CORS_MODE =
    process.argv.length > 2 && process.argv[2] === "--CORS=debug"
        ? CORS_MODE.DEBUG
        : CORS_MODE.NONE;

const startServer = (corsMode: CORS_MODE): void => {
    app.get("/", (req, res) => res.sendStatus(404));

    app.get("/api/nowplaying/radio2", async (req, res) => {
        if (corsMode === CORS_MODE.DEBUG) {
            console.log("CORS DEBUG MODE");
            res.header("Access-Control-Allow-Origin", "http://localhost:6006"); // update to match the domain you will make the request from
            res.header(
                "Access-Control-Allow-Headers",
                "Origin, X-Requested-With, Content-Type, Accept"
            );
        }
        try {
            const response = await getNowPlaying(ChannelName.RADIO2);
            res.send(response);
        } catch (error) {
            console.log(error);
            res.sendStatus(500);
        }
    });

    app.get("/api/nowplaying/radio3", async (req, res) => {
        if (corsMode === CORS_MODE.DEBUG) {
            console.log("CORS DEBUG MODE");
            res.header("Access-Control-Allow-Origin", "http://localhost:6006"); // update to match the domain you will make the request from
            res.header(
                "Access-Control-Allow-Headers",
                "Origin, X-Requested-With, Content-Type, Accept"
            );
        }
        try {
            const response = await getNowPlaying(ChannelName.RADIO3);
            res.send(response);
        } catch (error) {
            console.log(error);
            res.sendStatus(500);
        }
    });

    app.listen(port, () => console.log(`App listening on port ${port}!`));
};

startServer(corsMode);

module.exports = {
    getNowPlaying,
};
