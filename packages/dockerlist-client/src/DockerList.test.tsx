import React from "react";
import { render, screen, waitFor } from "@testing-library/react";
import { DockerListMod } from "./DockerList.bs";

// TODO convert to bs-jest?

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

global.fetch = jest.fn().mockResolvedValue({
    text: () => Promise.resolve(JSON.stringify(MOCK_DOCKERLIST_RESPONSE)),
});

describe("DockerList client", () => {
    it("renders buttons for each docker container", async () => {
        render(<DockerList url={"some_url"} />);
        await waitFor(() => {
            screen.getByText("determined_edison");
        });
        expect(screen.getAllByRole("button").length).toBe(3);
    });

    it("can stop running container", async () => {
        const { container } = render(<DockerList url={"some_url"} />);

        await waitFor(() => {
            screen.getByText("determined_edison");
        });

        expect(
            screen.getByRole("button", {
                name: /determined_edison up 2 days/i,
            })
        ).toMatchSnapshot();

        expect(container).toMatchSnapshot();
    });
});
