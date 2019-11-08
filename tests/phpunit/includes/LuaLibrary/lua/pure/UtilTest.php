<?php

declare( strict_types = 1 );

namespace LuaCollections\Test;

use Scribunto_LuaEngineTestBase;

/**
 * @group LuaCollections
 */
class UtilTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'UtilTest';

	/**
	 * @slowThreshold 1000
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	protected function getTestModules(): array {
		return parent::getTestModules() + [
			'UtilTest' => __DIR__ . '/UtilTest.lua'
		];
	}
}
