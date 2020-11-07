const elmloader = require("../webpack.elmloader.js");

module.exports = {
    stories: [
        "../*.stories.@(js|jsx|ts|tsx|mdx)",
        "../packages/**/*.stories.@(js|jsx|ts|tsx)",
    ],
    addons: [
        "@storybook/addon-links",
        "@storybook/addon-essentials",
        "@storybook/preset-create-react-app",
        "@storybook/addon-controls",
        "@storybook/addon-storysource",
        //   {
        //     name: "@storybook/preset-create-react-app",
        //     options: {
        //       craOverrides: {
        //         fileLoaderExcludes: ["less"]
        //       },
        //     }
        //   },
    ],
    webpack: (webpackConfig, options) => {
        return {
            ...webpackConfig,
            module: {
                ...webpackConfig.module,
                rules: [...(webpackConfig.module.rules || []), elmloader],
            },
        };
    },
    webpackFinal: (config) => {
        const {
            module: {
                rules: [, , , , , , { oneOf }],
            },
        } = config;
        const babelLoader = oneOf.find(({ test }) =>
            new RegExp(test).test(".jsx")
        );
        babelLoader.include = [/packages\/(.*)\/src/, /src/, /helpers/];
        babelLoader.exclude = [/(node_modules|bower_components|build)/];
        const fileLoader = oneOf.find(({ test }) =>
            new RegExp(test).test(".elm")
        );
        fileLoader.exclude.push(/\.elm$/);
        return config;
    },
};
