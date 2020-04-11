const elmloader = require('../webpack.elmloader.js');

module.exports = async ({ config, mode }) => {
  return { ...config, module: { ...config.module, rules: [...config.module.rules, elmloader] } };
};
