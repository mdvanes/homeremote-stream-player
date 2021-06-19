import React, { FC, ReactNode } from "react";
import { action } from "@storybook/addon-actions";
// NOTE only use compiled versions, i.e. from lib! To get a good idea of what use of the modules looks like
import StreamPlayer from "@mdworld/homeremote-stream-player";
// TODO use this one: import { DockerListMod } from "@mdworld/homeremote-dockerlist";
import { DockerListMod } from "../../dockerlist-client/src/DockerList.gen";
import { Meta } from "@storybook/react";
import "./storybookStyles.css";
import {
    Button,
    Card,
    CardContent,
    CardActions,
    createMuiTheme,
    CssBaseline,
    Grid,
    ThemeProvider,
} from "@material-ui/core";
import { green, yellow } from "@material-ui/core/colors";

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
                minWidth: "500px",
                maxWidth: "622px",
                padding: "1rem",
                height: "100%",
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

// type SomeStyle = Record<string, string>; // Alternatively, use a type from Material UI

// const style: SomeStyle = {
//     backgroundColor: "#1a237e",
//     color: "white",
// };

const theme = (isDarkMode: boolean) =>
    createMuiTheme({
        palette: {
            primary: green,
            secondary: yellow,
            type: isDarkMode ? "dark" : "light",
        },
    });

interface Props {
    width: number;
    isDarkMode: boolean;
}

export const Default = ({ isDarkMode }: Props): ReactNode => (
    <ThemeProvider theme={theme(isDarkMode)}>
        <CssBaseline />
        <Grid container>
            <Grid item xs={6}>
                <Wrapper>
                    <h1 className="reset">Example App</h1>
                    <p className="reset">
                        This is an example application that uses the (compiled)
                        components from this monorepo.
                    </p>
                    <StreamPlayer url={url} />
                </Wrapper>
            </Grid>
            <Grid item xs={6}>
                <Wrapper>
                    <Card elevation={5}>
                        <CardContent>
                            <DockerList
                                url={url}
                                onError={action("some error has occurred")}
                            />
                        </CardContent>
                        <CardActions>
                            <Button color="primary" variant="contained">
                                primary
                            </Button>
                            <Button color="secondary" variant="contained">
                                secondary
                            </Button>
                        </CardActions>
                    </Card>
                </Wrapper>
            </Grid>
        </Grid>
    </ThemeProvider>
);

// See https://github.com/storybookjs/storybook/blob/next/addons/controls/README.md#knobs-to-manually-configured-args
Default.args = { isDarkMode: true };
Default.argTypes = {
    isDarkMode: { control: { type: "boolean" } },
};
