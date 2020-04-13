import React from 'react';
import { storiesOf } from '@storybook/react';
import App from "../src/App";
// import TestElem from '../src/TestElem';
import "./styles.css";

storiesOf('homeremote-stream-player', module)
  .add('default', () => (
    <App />
  ));
  // .add('test', () => (
  //   <TestElem/>
  // ));
