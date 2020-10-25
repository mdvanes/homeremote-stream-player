import React, { FC, ReactNode } from "react";
import HomeremoteStreamPlayer from "./HomeremoteStreamPlayer";
import "./storybookStyles.css";
import packageJson from "../package.json";

export default {
    title: `Elm/StreamPlayer v${packageJson.version}`,
    component: HomeremoteStreamPlayer,
};

const Wrapper: FC = ({ children }) => {
    return (
        <div
            style={{
                border: "1px solid red;",
                minWidth: "500px",
                maxWidth: "800px",
            }}
        >
            {children}
        </div>
    );
};

export const Default = (): ReactNode => {
    const url =
        process.env.STORYBOOK_MODE === "PROD"
            ? `https://${window.location.host}/${window.top.location.pathname}`
            : "http://localhost:3100";
    return (
        <Wrapper>
            <HomeremoteStreamPlayer url={url} />
        </Wrapper>
    );
};
