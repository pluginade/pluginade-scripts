// Copied from https://jestjs.io/docs/code-transformation#examples
module.exports = {
  ...require('@wordpress/scripts/config/jest-unit.config'),
  transform: {
    '^.+\\.[jt]sx?$': '<rootDir>/node_modules/@wordpress/scripts/config/babel-transform',
    '\\.(jpg|jpeg|png|svg)$': '<rootDir>/fileTransformer.js',
  },
};
