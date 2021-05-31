import React, { ReactNode } from "react";
import { action } from "@storybook/addon-actions";
import { DockerListMod, reactDomStyleT } from "./DockerList.gen";
import packageJson from "../package.json";
import { BreakpointWrapper } from "../../../helpers";

const DockerList = DockerListMod.make;

export default {
    title: `ReScript/DockerList v${packageJson.version}`,
    component: DockerList,
};

// Force type to reactDomStyleT without any type. Alternative is (style as unknown) as reactDomStyleT
const makeStyle = (styleRules: Record<string, string>) => {
    class RdStyleT extends reactDomStyleT {
        opaque: null;
    }

    const confirmButtonStyle = new RdStyleT();
    for (const styleRule in styleRules) {
        confirmButtonStyle[styleRule] = styleRules[styleRule];
    }
    return confirmButtonStyle;
};

const url =
    process.env.STORYBOOK_MODE === "PROD"
        ? `https://${window.location.host}/${window.top.location.pathname}`
        : "http://localhost:3100";

export const Default = ({ width }: { width: number }): ReactNode => (
    <BreakpointWrapper width={width}>
        <div
            style={{
                backgroundColor: "white",
                borderRadius: 4,
            }}
        >
            <DockerList
                url={url}
                onError={action("some error has occurred")}
                confirmButtonStyle={makeStyle({
                    backgroundColor: "#1a237e",
                    color: "white",
                })}
            />
        </div>
    </BreakpointWrapper>
);

// See https://github.com/storybookjs/storybook/blob/next/addons/controls/README.md#knobs-to-manually-configured-args
Default.args = { width: 600 };
Default.argTypes = {
    width: { control: { type: "range", min: 375, max: 775, step: "100" } },
};
