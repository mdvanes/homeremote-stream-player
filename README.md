# Monorepo for homeremote-plugins

## homeremote-stream-player plugin

![Screenshot](screenshot.jpg)

More details:

Client: [/packages/client](/packages/client)

Server: [/packages/server](/packages/server)

## Publish

```
nvm use
lerna changed
lerna publish
```

## Running

```
nvm use
lerna run start
```

## Development

* clone the repo
* in the root: `yarn`
* start storybook: `yarn storybook`
* in another terminal, start the backend API for storybook: `yarn storybook:api`

## Build Storybook

For Github Pages

* `yarn build-storybook`

## Add dependency to e.g. packages/streamplayer-client

Adding local or an external dependency to one of the packages, run this in the *root*:

`yarn lerna add @mdworld/bla --scope=@mdworld/homeremote-stream-player`

Adding a (dev)dependency to the root project:

`yarn add -DW typescript` (dev)

`yarn add -W typescript` (not dev)

## TODO

* static storybook version for github pages

* empty packages/*/package.json
* Fix type generation for streamplayer server
* clean up streamplayer-client/stories/*.css
* Use packages/example to include all the packages in one place, but resolve dependencies with `yarn lerna add @mdworld/bla --scope=@mdworld/homeremote-stream-player` instead of normal `yarn lerna add @mdworld/bla`
