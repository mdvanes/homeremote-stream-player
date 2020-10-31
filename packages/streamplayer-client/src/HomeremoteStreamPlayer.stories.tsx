import React, { FC, ReactNode } from "react";
import HomeremoteStreamPlayer from "./HomeremoteStreamPlayer";
// Custom storybook styles can be loaded with: import "./storybookStyles.css";
import packageJson from "../package.json";

export default {
    title: `Elm/StreamPlayer v${packageJson.version}`,
    component: HomeremoteStreamPlayer,
};

const Wrapper: FC = ({ children }) => {
    return (
        <div
            style={{
                // border: "1px solid blue",
                minWidth: "500px",
                maxWidth: "600px",
            }}
        >
            {children}
        </div>
    );
};

const url =
    process.env.STORYBOOK_MODE === "PROD"
        ? `https://${window.location.host}/${window.top.location.pathname}`
        : "http://localhost:3100";

export const Default = (): ReactNode => (
    <Wrapper>
        <HomeremoteStreamPlayer url={url} />
    </Wrapper>
);

export const WithSquarePicture = (): ReactNode => (
    <Wrapper>
        <HomeremoteStreamPlayer url={`${url}/mock/square`} />
    </Wrapper>
);

export const WithLandscapePicture = (): ReactNode => (
    <Wrapper>
        <HomeremoteStreamPlayer url={`${url}/mock/landscape`} />
    </Wrapper>
);
