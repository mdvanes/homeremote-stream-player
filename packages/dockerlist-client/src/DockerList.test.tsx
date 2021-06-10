import React from "react";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { DockerListMod } from "./DockerList.bs";

const DockerList = DockerListMod.make;

jest.mock("./DockerList.module.css", () => "");

const MOCK_DOCKERLIST_RESPONSE = {
    status: "received",
    containers: [
        {
            Id:
                "2757091519a2e227b40e6fae4f92b7f4c8b7b189037bda0bc3152ce2be96af9d",
            Names: ["/determined_edison"],
            State: "running",
            Status: "Up 2 days",
        },
        {
            Id:
                "42aebf279f8c95488fab905d788f3caffee6afcaad240fc4aca68106c7173bfe",
            Names: ["/tinycors"],
            State: "exited",
            Status: "Exited (2) 13 hours ago",
        },
        {
            Id:
                "c7f51601f9870180859a2feb981613b30e3fcd282830b398185aa4facff21be1",
            Names: ["/hello_world"],
            State: "exited",
            Status: "Exited (0) 17 hours ago",
        },
    ],
};

window.fetch = jest.fn().mockResolvedValue({
    text: () => Promise.resolve(JSON.stringify(MOCK_DOCKERLIST_RESPONSE)),
});

describe("DockerList client", () => {
    it("renders buttons for each docker container", async () => {
        const { container } = render(<DockerList url={"some_url"} />);
        await screen.findByText("determined_edison");
        // const buttons = screen.getAllByRole("button");
        expect(screen.getAllByRole("button").length).toBe(3);
        // const buttonsParent = buttons[0].parentNode;
        expect(container).toMatchSnapshot("container");
    });

    it("can stop running container", async () => {
        render(<DockerList url={"some_url"} />);

        // Note: find instead of waitFor(await getByText("determined_edison"))
        await screen.findByText("determined_edison");

        const runningContainerButton = screen.getByRole("button", {
            name: "determined_edison Up 2 days",
        });

        userEvent.click(runningContainerButton);

        await screen.findByText(/Do you want to/);

        expect(
            screen.getByText(/Do you want to stop determined_edison/)
        ).toBeInTheDocument();

        const okButton = screen.getByRole("button", {
            name: "OK",
        });

        const expectedUrl =
            "some_url/api/dockerlist/stop/2757091519a2e227b40e6fae4f92b7f4c8b7b189037bda0bc3152ce2be96af9d";

        expect(window.fetch).not.toBeCalledWith(expectedUrl);
        userEvent.click(okButton);

        expect(
            await screen.findByText(/Do you want to/)
        ).not.toBeInTheDocument();

        expect(window.fetch).toBeCalledWith(expectedUrl);
    });

    it("can start stopped container", async () => {
        render(<DockerList url={"some_url"} />);

        // Note: find instead of waitFor(await getByText("determined_edison"))
        await screen.findByText("determined_edison");

        const stoppedContainerButton = screen.getByRole("button", {
            name: "hello_world Exited (0) 17 hours ago",
        });

        userEvent.click(stoppedContainerButton);

        await screen.findByText(/Do you want to/);

        expect(
            screen.getByText(/Do you want to start hello_world/)
        ).toBeInTheDocument();

        const okButton = screen.getByRole("button", {
            name: "OK",
        });

        const expectedUrl =
            "some_url/api/dockerlist/start/c7f51601f9870180859a2feb981613b30e3fcd282830b398185aa4facff21be1";

        expect(window.fetch).not.toBeCalledWith(expectedUrl);
        userEvent.click(okButton);

        expect(
            await screen.findByText(/Do you want to/)
        ).not.toBeInTheDocument();

        expect(window.fetch).toBeCalledWith(expectedUrl);
    });
});
