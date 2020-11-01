module.exports = {
    test: /\.elm$/,
    exclude: [/elm-stuff/, /node_modules/],
    loader: "elm-webpack-loader",
    options: {
        // optimize: true, // TODO should be done by setting production mode running webpack
    },
};
