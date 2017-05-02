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

require_once ABSPATH . 'wp-secrets.php';
require_once ABSPATH . 'wp-settings.php';
