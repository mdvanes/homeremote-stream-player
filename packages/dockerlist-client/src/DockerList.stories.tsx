import React, { ReactNode } from "react";
import { action } from "@storybook/addon-actions";
import { DockerListMod } from "./DockerList.gen";
import packageJson from "../package.json";
import { BreakpointWrapper } from "../../../helpers";

const DockerList = DockerListMod.make;

export default {
    title: `ReScript/DockerList v${packageJson.version}`,
    component: DockerList,
};

const url =
    process.env.STORYBOOK_MODE === "PROD"
        ? `https://${window.location.host}/${window.top.location.pathname}`
        : "http://localhost:3100";

export const Default = ({ width }: { width: number }): ReactNode => (
    <BreakpointWrapper width={width}>
        <DockerList
            url={url}
            onError={action(`some error has occurred`)}
            confirmButtonStyle={{ backgroundColor: "#1a237e", color: "white" }}
        />
    </BreakpointWrapper>
);

// See https://github.com/storybookjs/storybook/blob/next/addons/controls/README.md#knobs-to-manually-configured-args
Default.args = { width: 600 };
Default.argTypes = {
    width: { control: { type: "range", min: 375, max: 775, step: "100" } },
};
