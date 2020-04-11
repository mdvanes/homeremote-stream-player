# homeremote-stream-player

Choose an audio stream from a list and play the stream. If configured, retrieve "now playing" information.

See https://github.com/mdvanes/homeremote/issues/2

## How this project was set up

See also mdvanes/elmstars, https://codeburst.io/using-elm-in-react-from-the-ground-up-e3866bb0369d, https://medium.com/javascript-inside/building-a-react-redux-elm-bridge-8f5b875a9b76

* nvm use 12
* npx create-react-app homeremote-streams-player
* push to git repo
* add .nvmrc with contents: 12
* yarn eject (because the webpack-elm-loader must be added to the webpack config)
* yarn add react-elm-components
* add Buttons.elm in /src/Elm
* add `import Elm from 'react-elm-components'; import Buttons from './Elm/Buttons.elm';` to App.jsx
* in App.jsx, replace `function App() { ... }` by `const App = () =>(
                                                     <Elm src={Buttons.Elm.Elm.Buttons} />
                                                   );`
* If elm does not exists in this nvm node instance, install it: npm i -g elm
* Make the elm.json: elm init
* Test if properly installed: elm make src/elm/Buttons.elm
* Replace the contents of index.js by `export { default as App } from './App.jsx';`
* `yarn add @storybook/react elm-webpack-loader`
* add these scripts to package.json:       "storybook": "start-storybook",
    "build-storybook": "build-storybook -c .storybook -o docs"
* add /stories/index.js 
* add /.storybook/*
* add /webpack.config.js and /webpack.elmloader.js
* start storybook for development with `yarn storybook`

## Running

* dev: `yarn storybook`
* build only the Elm module (useful for debugging): `elm make src/Elm/Buttons.elm` 

## TODO

Audio element in Elm, see: https://vincent.jousse.org/en/tech/interacting-with-dom-element-using-elm-audio-video/

* Switch to other radio streams
* Show logo for each radio stream, design like this https://material-ui.com/components/cards/#ui-controls
* Custom stream player controls
* Lerna
* Back-end for "now playing"
* Deliverable that can be published as NPM module
* prettier, eslint, tests
