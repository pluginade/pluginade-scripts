# Pluginade Scripts
Pluginade Scripts is a simple solution for adding linting, testing, zipping, and more to your WordPress plugin in seconds.

It allows you to instantly run PHP WordPress Coding Standards, phpunit, eslint, stylelint and more, on any machine that supports Docker.

## Getting Started

1. Copy the contents of [this file](https://raw.githubusercontent.com/pluginade/pluginade/docker/pluginade.sh)
2. Create a new file in the root of your plugin called `pluginade.sh`
3. Paste the contents into that file.
4. In that file replace these strings:
	- `my-plugin-text-domain` - The text domain to use for your plugin (Will be enforced by WordPress Coding Standards)
	- `MyPluginNamespace` - The unique namespace used for your plugin (Will be enforced as function/class prefix in WordPress Coding Standards)

5. Make sure you have [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running.
6. On the command line inside your plugin, run one of the following commands:

#### To lint your plugin's PHP code using WordPress Coding Standards, run this command:
`sh pluginade.sh lint:php`

If you want to override any WordPress Coding Standards for your project, add your own custom phpcs.xml file to the root of your plugin, and Pluginade will use that.

#### To automatically fix any PHP issues that can be autofixed to conform with WordPress Coding Standards, run this command:
`sh pluginade.sh lint:php:fix`

#### To lint your plugin's CSS code using WordPress's standards, run this command:
`sh pluginade.sh lint:css`

#### To automatically fix any CSS issues that can be autofixed to conform with WordPress's standards, run this command:
`sh pluginade.sh lint:css:fix`

#### To lint your plugin's Javascript code using WordPress's standards, run this command:
`sh pluginade.sh lint:js`

If you want to override any javascript standards in your own plugin, ass your own `.eslintrc` file to the root of your plugin, and Pluginade will use that.

#### To automatically fix any Javascript issues that can be autofixed to conform with WordPress's standards, run this command:
`sh pluginade.sh lint:js:fix`

#### To run PHPUnit on your plugin's code, run this command:
`sh pluginade.sh test:phpunit`

#### To run Jest tests on your plugin's Javascript code, run this command:
`sh pluginade.sh test:js`

#### To build your plugin with webpack, run this command:
`sh pluginade.sh build`

#### To put your plugin into webpack development mode, run this command:
`sh pluginade.sh dev`

#### To create a zip of your plugin, run this command
`sh pluginade.sh zip`

Note that you can add a .zipignore file to the root of your plugin to control what files are not included in the zip. Pluginade includes a default zipignore which removes things usually not desired (like node_modules directories), but this can be overridden.