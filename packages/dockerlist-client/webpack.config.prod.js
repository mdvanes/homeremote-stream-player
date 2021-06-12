const path = require("path");
const TerserPlugin = require("terser-webpack-plugin");

process.env.BABEL_ENV = "production";
process.env.NODE_ENV = "production";

module.exports = {
    mode: "production",
    entry: "./src/DockerList.bs.js",
    output: {
        path: path.resolve(__dirname, "lib"),
        filename: "DockerList.bs.js",
        libraryTarget: "commonjs2",
    },
    module: {
        rules: [
            {
                test: /\.(js|jsx)$/,
                include: path.resolve(__dirname, "src"),
                exclude: /(node_modules|bower_components|build)/,
                use: {
                    loader: "babel-loader",
                    options: {
                        presets: ["@babel/preset-env", "@babel/preset-react"],
                    },
                },
            },
            { test: /\.css$/, loader: "style-loader!css-loader" },
            { test: /\.svg$/, loader: "url-loader" },
        ],
    },
    externals: {
        react: "commonjs react",
    },
    optimization: {
        minimize: true,
        minimizer: [
            new TerserPlugin({
                terserOptions: {
                    // Default is to write cache dirs in /packages/*/node_modules/.cache
                    nameCache: {},
                },
            }),
        ],
    },
};
