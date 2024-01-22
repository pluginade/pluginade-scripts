# Available Commands

#### To install all dependencies from npm and composer for all wp-modules in your plugin run this command:
`sh pluginade.sh install`

#### To remove node_modules and vendor directories for all wp-modules in your plugin and re-install all dependencies from npm and composer run this command:
`sh pluginade.sh install:clean`

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

Note: At this time there isn't a way to run only tests in a single file, it just runs all of the tests in the plugin. This functionality is on the road map for pluginade in the future.

#### To run Jest tests on your plugin's Javascript code, run this command:
`sh pluginade.sh test:js`

Note: At this time there isn't a way to run only tests in a single file, it just runs all of the tests in the plugin. This functionality is on the road map for pluginade in the future.

#### To build your plugin with webpack, run this command:
`sh pluginade.sh build`

#### To put your plugin into webpack development mode, run this command:
`sh pluginade.sh dev`

#### To create a zip of your plugin, run this command
`sh pluginade.sh zip`

Note that you can add a .zipignore file to the root of your plugin to control what files are not included in the zip. Pluginade includes a default zipignore which removes things usually not desired (like node_modules directories), but this can be overridden.