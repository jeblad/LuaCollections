--- Tests for the util module.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >

local testframework = require 'Module:TestFramework'

local expUtil = require '_expect.util'
assert( expUtil )

local function testExists()
	return type( expUtil )
end

local function testCount( ... )
	return expUtil.count( ... )
end

local function testSize( ... )
	return expUtil.size( ... )
end

local function testDeepEqual( ... )
	return expUtil.deepEqual( ... )
end

local function testContains( ... )
	return expUtil.contains( ... )
end

local tests = {
	{
		name = 'Verify the lib is loaded and exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	{
		name = 'Calling function "count" without any argument',
		func = testCount,
		args = { {} },
		expect = { 0 }
	},
	{
		name = 'Calling function "count" with single string argument',
		func = testCount,
		args = { { 'a' } },
		expect = { 1 }
	},
	{
		name = 'Calling function "count" with composite table argument',
		func = testCount,
		args = { { 'a', { 'b', 'c' } } },
		expect = { 2 }
	},
	{
		name = 'Calling function "count" with multiple string arguments',
		func = testCount,
		args = { { 'a', 'b', 'c' } },
		expect = { 3 }
	},
	{
		name = 'Calling function "size" without any argument',
		func = testSize,
		args = { nil },
		expect = { 0 }
	},
	{
		name = 'Calling function "size" with single string argument',
		func = testSize,
		args = { { 'a' } },
		expect = { 1 }
	},
	{
		name = 'Calling function "size" with multiple string arguments',
		func = testSize,
		args = { { 'a', 'b', 'c' } },
		expect = { 3 }
	},
	{
		name = 'Calling function "deepEqual" with two dissimilar table arguments',
		func = testDeepEqual,
		args = { { 'a', { 'b' }, 'c' }, { 'a', 'b', 'c' } },
		expect = { false }
	},
	{
		name = 'Calling function "deepEqual" with two similar table arguments',
		func = testDeepEqual,
		args = { { 'a', { 'b' }, 'c' }, { 'a', { 'b' }, 'c' } },
		expect = { true }
	},
	{
		name = 'Calling function "contains" with last table argument missing from first',
		func = testContains,
		args = { { 'a', { 'b' }, 'c' }, { 'a' } },
		expect = { false }
	},
	{
		name = 'Calling function "contains" with last table argument within first',
		func = testContains,
		args = { { 'a', { 'b' }, 'c' }, 'c' },
		expect = { 3 }
	},
	{
		name = 'Calling function "contains" with last table argument within first',
		func = testContains,
		args = { { 'a', { 'b' }, 'c' }, { 'b' } },
		expect = { 2 }
	},
}

return testframework.getTestProvider( tests )
