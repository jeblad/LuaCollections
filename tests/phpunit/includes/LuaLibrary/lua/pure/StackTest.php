<?php

declare( strict_types = 1 );

namespace LuaCollections\Test;

use Scribunto_LuaEngineTestBase;

/**
 * @group LuaCollections
 */
class StackTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'StackTest';

	/**
	 * @slowThreshold 1000
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	protected function getTestModules(): array {
		return parent::getTestModules() + [
			'StackTest' => __DIR__ . '/StackTest.lua'
		];
	}
}
