<?php

declare( strict_types = 1 );

namespace LuaCollections\Test;

use Scribunto_LuaEngineTestBase;

/**
 * @group LuaCollections
 */
class MapTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'MapTest';

	/**
	 * @slowThreshold 1000
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	protected function getTestModules(): array {
		return parent::getTestModules() + [
			'MapTest' => __DIR__ . '/MapTest.lua'
		];
	}
}
