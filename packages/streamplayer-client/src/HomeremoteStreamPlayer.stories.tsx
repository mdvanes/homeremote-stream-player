import React from "react";
// import { storiesOf } from "@storybook/react";
import HomeremoteStreamPlayer from "./HomeremoteStreamPlayer";
// import "./storybookStyles.css";

// storiesOf('homeremote-stream-player', module)
//   .add('default', () => (
//     <HomeremoteStreamPlayer url="http://localhost:3100" />
//   ));
//   // .add('test', () => (
//   //   <TestElem/>
//   // ));

export default {
  title: "HomeremoteStreamPlayer",
  component: HomeremoteStreamPlayer,
};

// TODO fix Elm webpack loader!
// export const Default1 = () => (
//   <HomeremoteStreamPlayer url="http://localhost:3100" />
// );

export const Default = () => (
  <span>hallo wereld</span>
);
