import {
    getNowPlaying,
    ChannelName,
    NowPlayingResponse,
} from "./packages/streamplayer-server/lib/StreamPlayerAPI";
import {
    getDockerList,
    startContainer,
} from "./packages/dockerlist-server/lib/DockerListAPI";
import express, { Request, Response } from "express";
const app = express();

const port = 3100;

enum CORS_MODE {
    NONE,
    DEBUG,
}

const corsMode: CORS_MODE =
    process.argv.length > 2 && process.argv[2] === "--CORS=debug"
        ? CORS_MODE.DEBUG
        : CORS_MODE.NONE;

const setCorsHeaders = (corsMode: CORS_MODE, res: Response): void => {
    if (corsMode === CORS_MODE.DEBUG) {
        console.log("CORS DEBUG MODE");
        res.header("Access-Control-Allow-Origin", "http://localhost:6006"); // update to match the domain you will make the request from
        res.header(
            "Access-Control-Allow-Headers",
            "Origin, X-Requested-With, Content-Type, Accept"
        );
    }
};

const logRequest = (req: Request): void => {
    console.log(`Request made to ${req.url}`);
};

const startServer = (corsMode: CORS_MODE): void => {
    app.get("/", (req, res) => res.sendStatus(404));

    app.get("/api/nowplaying/radio2", async (req, res) => {
        logRequest(req);
        setCorsHeaders(corsMode, res);
        try {
            const response = await getNowPlaying(ChannelName.RADIO2);
            res.send(response);
        } catch (error) {
            console.log(error);
            res.sendStatus(500);
        }
    });

    app.get("/mock/square/api/nowplaying/radio2", async (req, res) => {
        logRequest(req);
        setCorsHeaders(corsMode, res);
        const mockResponse: NowPlayingResponse = {
            artist: "Family Of The Year",
            title: "Hero",
            last_updated: "2020-10-31T11:57:03",
            songImageUrl: "http://localhost:3100/square.jpg",
            name: "Spijkers Met Koppen / Dolf Jansen, Felix Meurders",
            imageUrl:
                "https://radio-images.npo.nl/{format}/34e8df87-0f33-45c6-bd1a-f2528ff87626/b4c0c59c-1ade-4d9f-b2ed-a5710ca23e8e.png",
        };
        res.send(mockResponse);
    });

    app.get("/mock/landscape/api/nowplaying/radio2", async (req, res) => {
        logRequest(req);
        setCorsHeaders(corsMode, res);
        const mockResponse: NowPlayingResponse = {
            artist: "Family Of The Year",
            title: "Hero",
            last_updated: "2020-10-31T11:57:03",
            songImageUrl: "http://localhost:3100/landscape.jpg",
            name: "Spijkers Met Koppen / Dolf Jansen, Felix Meurders",
            imageUrl:
                "https://radio-images.npo.nl/{format}/34e8df87-0f33-45c6-bd1a-f2528ff87626/b4c0c59c-1ade-4d9f-b2ed-a5710ca23e8e.png",
        };
        res.send(mockResponse);
    });

    app.get("/api/nowplaying/radio3", async (req, res) => {
        logRequest(req);
        setCorsHeaders(corsMode, res);
        try {
            const response = await getNowPlaying(ChannelName.RADIO3);
            res.send(response);
        } catch (error) {
            console.log(error);
            res.sendStatus(500);
        }
    });

    app.get("/api/dockerlist", async (req, res) => {
        logRequest(req);
        setCorsHeaders(corsMode, res);
        try {
            const response = await getDockerList();
            res.send(response);
        } catch (error) {
            console.log(error);
            res.sendStatus(500);
        }
    });

    app.get("/api/dockerlist/start/:id", async (req, res) => {
        logRequest(req);
        setCorsHeaders(corsMode, res);
        try {
            const response = await startContainer(req.params.id);
            res.send(response);
        } catch (error) {
            console.log(error);
            res.sendStatus(500);
        }
    });

    app.use(express.static("mocks/public"));

    app.listen(port, () =>
        console.log(`Storybook Mock server listening on port ${port}!`)
    );
};

startServer(corsMode);

module.exports = {
    getNowPlaying,
};
