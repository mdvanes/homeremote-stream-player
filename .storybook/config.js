import { configure } from '@storybook/react';

function loadStories() {
  require('../packages/streamplayer-client/src/HomeremoteStreamPlayer.stories.js');
}

configure(loadStories, module);