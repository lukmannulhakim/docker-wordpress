<?php

define( 'WP_CONTENT_DIR', '/var/www/wp-content' );

$table_prefix = getenv( 'TABLE_PREFIX' ) ?: 'wp_';

foreach ( $_ENV as $_key => $value ) {
	$key = strtoupper( $_key );

	if ( ! defined( $key ) ) {
		define( $key, $value );
	}
}

if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

// Use built-in themes, stolen from Chassis.
if ( empty( $GLOBALS['wp_theme_directories'] ) ) {
	$GLOBALS['wp_theme_directories'] = [];
}
if ( file_exists( WP_CONTENT_DIR . '/themes' ) ) {
	$GLOBALS['wp_theme_directories'][] = WP_CONTENT_DIR . '/themes';
}
$GLOBALS['wp_theme_directories'][] = ABSPATH . 'wp-content/themes';
$GLOBALS['wp_theme_directories'][] = ABSPATH . 'wp-content/themes';

require_once ABSPATH . 'wp-secrets.php';
require_once ABSPATH . 'wp-settings.php';
