import React from 'react';
import { storiesOf } from '@storybook/react';
import HomeremoteStreamPlayer from "./HomeremoteStreamPlayer";
// import TestElem from '../src/TestElem';
import "./styles.css";

storiesOf('homeremote-stream-player', module)
  .add('default', () => (
    <HomeremoteStreamPlayer url="http://localhost:3100" />
  ));
  // .add('test', () => (
  //   <TestElem/>
  // ));
