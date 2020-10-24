import React from "react";
import HomeremoteStreamPlayer from "./HomeremoteStreamPlayer";
import "./storybookStyles.css";

export default {
  title: "Elm/HomeremoteStreamPlayer",
  component: HomeremoteStreamPlayer,
};

export const Default = () => {
  const url =
    process.env.STORYBOOK_MODE === "PROD"
      ? `https://${window.location.host}/${window.top.location.pathname}`
      : "http://localhost:3100";
  return <HomeremoteStreamPlayer url={url} />;
};
