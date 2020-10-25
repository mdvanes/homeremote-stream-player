import React from "react";
import { render } from "@testing-library/react";
import HomeremoteStreamPlayer from "./HomeremoteStreamPlayer";

test("renders learn react link", () => {
    const { getByText } = render(<HomeremoteStreamPlayer />);
    const linkElement = getByText(/learn react/i);
    expect(linkElement).toBeInTheDocument();
});
