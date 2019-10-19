<?php

declare( strict_types = 1 );

namespace LuaCollections;

/**
 * Hook handlers for the LuaCollections extension
 *
 * @ingroup Extensions
 */

class Hooks {

	/**
	 * Setup for the extension
	 */
	public static function onExtensionSetup() {
		global $wgDebugComments;

		// turn on comments while in development
		$wgDebugComments = true;
	}

	/**
	 * External Lua library paths for Scribunto
	 *
	 * @param any $engine to be used for the call
	 * @param array &$extraLibraryPaths additional libs
	 * @return bool
	 */
	public static function onRegisterScribuntoExternalLibraryPaths(
		string $engine,
		array &$extraLibraryPaths
	): bool {
		if ( $engine !== 'lua' ) {
			return true;
		}

		// Path containing pure Lua libraries that don't need to interact with PHP
		$extraLibraryPaths[] = __DIR__ . '/LuaLibrary/lua/pure';

		return true;
	}
}
