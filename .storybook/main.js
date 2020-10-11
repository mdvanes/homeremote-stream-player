const elmloader = require('../webpack.elmloader.js');

module.exports = {
  "stories": [
    "../*.stories.@(js|jsx|ts|tsx|mdx)",
    "../packages/**/*.stories.@(js|jsx|ts|tsx)"
  ],
  "addons": [
    "@storybook/addon-links",
    "@storybook/addon-essentials",
    {
      name: "@storybook/preset-create-react-app",
      options: {
        craOverrides: {
          fileLoaderExcludes: ["less"]
        },
      }
    },
    // {
    //   name: "@storybook/preset-ant-design",
    //   options: {
    //     lessOptions: {
    //       modifyVars: {
    //         'primary-color': '#1DA57A',
    //         'border-radius-base': '2px',
    //       },
    //     },
    //   }
    // }
  ],
  webpack: (webpackConfig, options) => {
    return {
      ...webpackConfig,
      module: {
        ...webpackConfig.module,
        rules: [
          ...(webpackConfig.module.rules || []),
          // TODO remove less rule?
          {
            test: "/\.less$/",
            use: [
              { loader: "style-loader", options: {} },
              { loader: "css-loader", options: {} },
              {
                loader: "less-loader", options:{
                  lessOptions: {
                    javascriptEnabled: true,
                    modules: {
                      localIdentName: "[name]__[local]___[hash:base64:5]"
                    }
                  }
                }
              }
            ]
          },
          elmloader
        ]
      }
    }
  },
  webpackFinal: (config) => {
    const {
      module: {
        rules: [, , , , , , { oneOf }],
      },
    } = config;
    const babelLoader = oneOf.find(({ test }) => new RegExp(test).test( ".ts"));
    babelLoader.include = [/packages\/(.*)\/src/, /src/];
    return config;
  }
}