# Pluginade Scripts
Pluginade Scripts is a simple solution for adding linting, testing, zipping, and more to your WordPress plugin in seconds.

It allows you to instantly run PHP WordPress Coding Standards, phpunit, eslint, stylelint and more, on any machine that supports Docker.

## Getting Started

1. Copy the contents of [this file](https://raw.githubusercontent.com/pluginade/pluginade-scripts/main/pluginade.sh)
2. Create a new file in the root of your plugin called `pluginade.sh`
3. Paste the contents into that file.
4. In that file replace these strings:
	- `my-plugin-text-domain` - The text domain to use for your plugin (Will be enforced by WordPress Coding Standards)
	- `MyPluginNamespace` - The unique namespace used for your plugin (Will be enforced as function/class prefix in WordPress Coding Standards)

5. Make sure you have [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running.
6. On the command line inside your plugin, run one of the [pluginade commands](https://github.com/pluginade/pluginade-scripts/main/available-commands.md).
