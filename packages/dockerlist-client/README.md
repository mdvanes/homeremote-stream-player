# homeremote-stream-player

Show a list of docker containers and start or stop them

See https://github.com/mdvanes/homeremote/issues/9

## How this project was set up

- nvm use 15
- copied package.json from other client package in the monorepo
- `yarn lerna add rescript -D --scope=@mdworld/homeremote-dockerlist`
- add bsconfig.json following https://rescript-lang.org/docs/manual/latest/installation#integrate-into-an-existing-js-project
- add `"re:build": "rescript", "re:start": "rescript build -w"` to package.json/scripts
- create a file /packages/dockerlist-client/src/Test.res with the button example from https://rescript-lang.org/try
- in /packages/dockerlist-client run `yarn re:build`
- now get an error that is probably caused because rescript-react is not yet installed, see https://rescript-lang.org/docs/react/latest/introduction
- compilation indeed does work, when Test.res only contains `Js.log("Hello, World!")`
- Add rescript-react: `yarn lerna add @rescript/react --scope=@mdworld/homeremote-dockerlist`
- Add {
  "reason": { "react-jsx": 3 },
  "bs-dependencies": ["@rescript/react"]
} in bsconfig.json
- in /packages/dockerlist-client run `yarn re:build`


## Running

-   dev: `yarn storybook` and in second terminal, cwd to packages/server and run `yarn start`

## TODO

- Add Reason/Rescript
- Clean up old Elm deps from package.json
- Builders (like webpack) are discouraged: https://rescript-lang.org/docs/manual/latest/interop-with-js-build-systems
- Snowpack build to `dist` dir like in https://github.com/jihchi/rescript-react-realworld-example-app/blob/main/package.json https://www.snowpack.dev/
- Storybook like in https://raw.githubusercontent.com/elfsternberg/doc-rescript-with-storybook/main/src/stories/02_Noncard.stories.mdx