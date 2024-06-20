# Changelog

## [Unreleased]

### Added
- Commands for install and install:clean added to available commands.
- Command for doing a security scan of PHP code only, which is sh pluginade.sh security:php
- Global npm packages provided by WordPress core like react, react-dom, anything from @wordpress/, and more will now automatically sync their versions to the one provided by WordPress core prior to `npm install` being run. The version in your package.json file will automatically be updated to sync with the WP core package.json version, based on the "Tested up to" value in your plugin's readme.txt file.

### Changed
- node version updated to 20 in line with WordPress core: https://github.com/WordPress/gutenberg/pull/56331
- wp-scripts version updated to 27
- @wordpress/jest-preset-default updated to "^11.20.0"
- @wordpress/eslint-plugin updated to "^17.6.0"
- @wordpress/prettier-config package added to pluginade
- Prettier package set to use WordPress fork of prettier: wp-prettier
- .eslintrc files located in plugin root directories are now copied into .pluginade, temporarily renamed to .eslintrc-temp and fixed once lint jobs are complete.
- lint:js and lint:js:fix now default to use the config from @wordpress/scripts/config/.eslintrc.js, but can be overriden by a plugin with a custom .eslintrc file in the plugin root.
- Recommended pluginade.sh file now does a `git fetch --tags` prior to checking a tag out.
- Composer packages for wp-modules containing a composer.json file are now auto installed before any pluginade script using setup.sh.
- Jobs for test:js and lint:css are allowed to pass if no tests exist in the plugin.
- Jest test began to fail on wp-scripts 27, seemingly due to changed made here: https://github.com/WordPress/gutenberg/pull/43511. Added custom transformIgnorePatterns to jest.config.js
- Now allow users to add their own custom jest config files to the root of their plugin.

### Fixed
- Sometimes `dev` and `build` could fail depending on the order of commands you've run. Now, we run npm install for wp-modules even if node_modules are empty. This can happen because we mount empty node_modules docker volumes to speed up some workflows like phpunit, but if npm install hasn't been run yet, node_modules doesn't even exist, so an empty directory was created. Now `dev` and `build` check if those directories are empty.

## [0.0.2] - 2024-01-15

### Added
- Initial release

[Unreleased]: https://github.com/your-repo/compare/v0.0.2...HEAD
[0.0.2]: https://github.com/your-repo/releases/tag/v0.0.2
