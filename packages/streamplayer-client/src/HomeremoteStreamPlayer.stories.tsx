import React from "react";
import HomeremoteStreamPlayer from "./HomeremoteStreamPlayer";
// import "./storybookStyles.css";

export default {
  title: "Elm/HomeremoteStreamPlayer",
  component: HomeremoteStreamPlayer,
};

// export const Default = () => (
//   <HomeremoteStreamPlayer url="http://localhost:3100" />
// );

export const Default = () => {
  console.log("mode", process.env.STORYBOOK_MODE);
  console.log(window.location.protocol, window.location.host, window.top.location.pathname);
  const url =
    process.env.STORYBOOK_MODE === "PROD"
      ? `${window.location.protocol}://${window.location.host}/${window.top.location.pathname}`
      : "http://localhost:3100";

  return <HomeremoteStreamPlayer url={url} />;
};

export const Default2 = () => {
  console.log("mode", process.env.STORYBOOK_MODE);
  console.log(window.location.protocol, window.location.host, window.top.location.pathname);
  const url =
    process.env.STORYBOOK_MODE === "PROD"
      ? `https://${window.location.host}/${window.top.location.pathname}`
      : "http://localhost:3100";

  return <HomeremoteStreamPlayer url={url} />;
};
