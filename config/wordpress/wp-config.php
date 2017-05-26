<?php

// Load local config.
$local_config_file = __DIR__ . '/wp-configs/local-config.php';
if ( file_exists( $local_config_file ) ) {
	require_once $local_config_file;
}

$table_prefix = getenv( 'TABLE_PREFIX' ) ?: 'wp_';

// Get secrets from env vars.
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

if ( ! defined( 'FS_METHOD' ) ) {
	define( 'FS_METHOD', 'direct' );
}

if ( ! defined( 'DISALLOW_FILE_EDIT' ) ) {
	define( 'DISALLOW_FILE_EDIT', true );
}

if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/wordpress/' );
}

define( 'WP_CONTENT_DIR', '/var/www/wp-content' );

// Use built-in themes, stolen from Chassis.
if ( empty( $GLOBALS['wp_theme_directories'] ) ) {
	$GLOBALS['wp_theme_directories'] = [];
}
if ( file_exists( WP_CONTENT_DIR . '/themes' ) ) {
	$GLOBALS['wp_theme_directories'][] = WP_CONTENT_DIR . '/themes';
}
$GLOBALS['wp_theme_directories'][] = ABSPATH . 'default-themes';
$GLOBALS['wp_theme_directories'][] = ABSPATH . 'default-themes';

// SSL Support with Reverse Proxy
if ( isset( $_SERVER['HTTP_X_FORWARDED_PROTO'] ) && 'https' === $_SERVER['HTTP_X_FORWARDED_PROTO'] ) {
	$_SERVER['HTTPS'] = 'on';
}

require_once ABSPATH . 'wp-settings.php';
