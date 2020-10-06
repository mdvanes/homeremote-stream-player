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

## Add dependency to e.g. packages/streamplayer-client

Adding local or an external dependency to one of the packages, run this in the *root*:

`yarn lerna add @mdworld/bla --scope=@mdworld/homeremote-stream-player`

Adding a (dev)dependency to the root project:

`yarn add -DW typescript` (dev)

`yarn add -W typescript` (not dev)

