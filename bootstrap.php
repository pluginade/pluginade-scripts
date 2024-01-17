<?php
/**
 * PHPUnit bootstrap file
 *
 * @package PLUGINADE
 */

putenv( 'WP_PHPUNIT__TESTS_CONFIG=/usr/src/pluginade/pluginade-scripts/docker-phpunit/wp-tests-config.php' );

// Require composer dependencies.
require_once 'vendor/autoload.php';

// If we're running in WP's build directory, ensure that WP knows that, too.
if ( 'build' === getenv( 'LOCAL_DIR' ) ) {
	define( 'WP_RUN_CORE_TESTS', true );
}

// Determine the tests directory (from a WP dev checkout).
// Try the WP_TESTS_DIR environment variable first.
$_tests_dir = getenv( 'WP_TESTS_DIR' );

// Next, try the WP_PHPUNIT composer package.
if ( ! $_tests_dir ) {
	$_tests_dir = getenv( 'WP_PHPUNIT__DIR' );
}

// See if we're installed inside an existing WP dev instance.
if ( ! $_tests_dir ) {
	$_try_tests_dir = __DIR__ . 'tests/phpunit';
	if ( file_exists( $_try_tests_dir . '/includes/functions.php' ) ) {
		$_tests_dir = $_try_tests_dir;
	}
}
// Fallback.
if ( ! $_tests_dir ) {
	$_tests_dir = '/tmp/wordpress-tests-lib';
}

// Give access to tests_add_filter() function.
require_once $_tests_dir . '/includes/functions.php';

/**
 * Manually load the plugin being tested.
 */
function _manually_load_plugin() {
	$plugins = glob( '/var/www/html/wp-content/plugins/*' );

	echo 'Included plugins:';
	foreach ( $plugins as $plugin ) {
		echo $plugin;
		$plugin_name = basename( $plugin );
		$filename    = $plugin_name . '.php';
		$filepath    = $plugin . '/' . $filename;

		if ( is_readable( $filepath ) ) {
			require $filepath;
		}
	}
}
tests_add_filter( 'muplugins_loaded', '_manually_load_plugin' );

tests_add_filter(
	'wp_die_handler',
	function () {
		exit( 1 );
	}
);

// Start up the WP testing environment.
require $_tests_dir . '/includes/bootstrap.php';
