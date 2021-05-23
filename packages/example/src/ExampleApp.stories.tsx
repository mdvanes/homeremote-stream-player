import React, { FC, ReactNode } from "react";
import { action } from "@storybook/addon-actions";
// NOTE only use compiled versions, i.e. from lib! To get a good idea of what use of the modules looks like
import StreamPlayer from "@mdworld/homeremote-stream-player";
import { DockerListMod } from "@mdworld/homeremote-dockerlist";
import { Meta } from "@storybook/react";
import "./storybookStyles.css";

const DockerList = DockerListMod.make;

export default {
    title: `ExampleApp`,
    component: StreamPlayer,
    parameters: {
        backgrounds: {
            values: [
                { name: "grey", value: "#eceff1" },
                { name: "black", value: "black" },
                { name: "white", value: "white" },
            ],
        },
    },
} as Meta; // workaround because eslint disable in .eslintrc does not see this file

const Wrapper: FC = ({ children }) => {
    return (
        <div
            style={{
                backgroundColor: "#eceff1",
                minWidth: "500px",
                maxWidth: "600px",
                padding: "1rem",
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
        <h1 className="reset">Example App</h1>
        <p className="reset">
            This is an example application that uses the (compiled) components
            from this monorepo.
        </p>
        <StreamPlayer url={url} />
        <DockerList
            url={url}
            onError={action("some error has occurred")}
            confirmButtonStyle={{
                backgroundColor: "#1a237e",
                color: "white",
            }}
        />
    </Wrapper>
);
