<?php

declare( strict_types = 1 );

namespace LuaCollections\Test;

use Scribunto_LuaEngineTestBase;

/**
 * @group LuaCollections
 *
 * @license GPL-2.0-or-later
 *
 * @author John Erling Blad < jeblad@gmail.com >
 */
class QueueTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'QueueTest';

	/**
	 * @slowThreshold 1000
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	protected function getTestModules(): array {
		return parent::getTestModules() + [
			'QueueTest' => __DIR__ . '/QueueTest.lua'
		];
	}
}
