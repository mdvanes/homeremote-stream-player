# Monorepo for homeremote-plugins

## homeremote-stream-player plugin

![Screenshot](screenshot.jpg)

More details:

Client: [/packages/client](/packages/client)

Server: [/packages/server](/packages/server)

## Publish

* `nvm use`
* in webpack.elmloader.js, enable `optimize: true,` (should be done automatically on webpack production mode)
* `yarn build`
* commit changes (lib dirs should eventually be in git ignore)
* optionally: `lerna changed`
* `lerna publish`
* build storybook manually (currently fails on CI): `yarn build-storybook`
* commit and push the content of `docs`

## Running

```
nvm use
lerna run start
```

## Development

* clone the repo
* `nvm use`
* in the root: `yarn`
* start storybook: `yarn storybook`
* in another terminal, start the backend API for storybook: `yarn storybook:api`

## Build Storybook

For Github Pages

* `nvm use`
* `yarn build-storybook`
* PR to master
* visit https://mdworld.nl/homeremote-plugins/

## Add dependency to e.g. packages/streamplayer-client

Adding local or an external dependency to one of the packages, run this in the *root*:

`yarn lerna add @mdworld/bla --scope=@mdworld/homeremote-stream-player`

Adding a (dev)dependency to the root project:

`yarn add -DW typescript` (dev)

`yarn add -W typescript` (not dev)

## TODO

* Fix default size with Wrapper elem in /helpers/index.ts
* Test and document production building of packages, especially streamplayer-server. (Streamplayer-client would be `lerna exec --scope @mdworld/homeremote-stream-player yarn build`)
* Fix type generation for streamplayer-server
* clean up streamplayer-client/stories/*.css
* empty packages/*/package.json
* Use packages/example to include all the packages in one place, but resolve dependencies with `yarn lerna add @mdworld/bla --scope=@mdworld/homeremote-stream-player` instead of normal `yarn lerna add @mdworld/bla`
