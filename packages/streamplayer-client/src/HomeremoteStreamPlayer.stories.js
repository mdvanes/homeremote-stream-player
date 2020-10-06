import React from "react";
import { storiesOf } from "@storybook/react";
import HomeremoteStreamPlayer from "./HomeremoteStreamPlayer";
import "./storybookStyles.css";

storiesOf('homeremote-stream-player', module)
  .add('default', () => (
    <HomeremoteStreamPlayer url="http://localhost:3100" />
  ));
  // .add('test', () => (
  //   <TestElem/>
  // ));

export default {
  title: "Components/Button",
  component: HomeremoteStreamPlayer,
};

export const Default = () => (
  <HomeremoteStreamPlayer url="http://localhost:3100" />
);
