# homeremote-stream-player

Choose an audio stream from a list and play the stream. If configured, retrieve "now playing" information.

See https://github.com/mdvanes/homeremote/issues/2

## How this project was set up

See also mdvanes/elmstars, https://codeburst.io/using-elm-in-react-from-the-ground-up-e3866bb0369d, https://medium.com/javascript-inside/building-a-react-redux-elm-bridge-8f5b875a9b76

* nvm use 12
* npx create-react-app homeremote-streams-player
* push to git repo
* add .nvmrc with contents: 12
* yarn add react-elm-components
* add `import Elm from 'react-elm-components'; import Buttons from './elm/Buttons.elm';` to App.jsx
* in App.jsx, replace `function App() { ... }` by `const App = () =>(
                                                     <Elm src={Buttons.Elm.Main} />
                                                   );`
* 

## Running

* dev: `yarn start`

## TODO

* Elm
* React wrapper
* Storybook
* Back-end for "now playing"
* prettier, eslint, tests
