<?php

$table_prefix = getenv( 'TABLE_PREFIX' ) ?: 'wp_';

$env_keys = [
	// Salt.
	'AUTH_KEY',
	'SECURE_AUTH_KEY',
	'LOGGED_IN_KEY',
	'NONCE_KEY',
	'AUTH_SALT',
	'SECURE_AUTH_SALT',
	'LOGGED_IN_SALT',
	'NONCE_SALT',
	// Database.
	'DB_HOST',
	'DB_NAME',
	'DB_NAME',
	'DB_USER',
	'DB_PASSWORD',
];

foreach ( $env_keys as $key ) {
	if ( isset( $_ENV[ $key ] ) && ! defined( $key ) ) {
		define( $key, $_ENV[ $key ] );
	}
}

if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

define( 'WP_CONTENT_DIR', '/var/www/content' );
define( 'WP_CONTENT_URL', sprintf(
	'%s://%s/content',
	empty( $_SERVER['HTTPS'] ) ? 'https' : 'http',
	$_SERVER['HTTP_HOST']
) );

// Use built-in themes, stolen from Chassis.
if ( empty( $GLOBALS['wp_theme_directories'] ) ) {
	$GLOBALS['wp_theme_directories'] = [];
}
if ( file_exists( WP_CONTENT_DIR . '/themes' ) ) {
	$GLOBALS['wp_theme_directories'][] = WP_CONTENT_DIR . '/themes';
}
$GLOBALS['wp_theme_directories'][] = ABSPATH . 'wp-content/themes';
$GLOBALS['wp_theme_directories'][] = ABSPATH . 'wp-content/themes';

require_once ABSPATH . 'wp-settings.php';
