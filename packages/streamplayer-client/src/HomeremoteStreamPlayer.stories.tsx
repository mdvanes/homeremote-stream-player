import React from "react";
import HomeremoteStreamPlayer from "./HomeremoteStreamPlayer";
// import "./storybookStyles.css";

export default {
  title: "Elm/HomeremoteStreamPlayer",
  component: HomeremoteStreamPlayer,
};

export const Default = () => (
  <HomeremoteStreamPlayer url="http://localhost:3100" />
);