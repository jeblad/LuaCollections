--- Tests for the util module.
-- @license GPL-2.0-or-later
-- @author John Erling Blad < jeblad@gmail.com >

local testframework = require 'Module:TestFramework'

local util = require 'collectionUtil'
assert( util )

local function testExists()
	return type( util )
end

local function testFunction( name, ... )
	local results = {}
	for i,v in ipairs{ ... } do
		results[i] = { pcall( function( ... ) return util[name]( ... ) end, unpack( v ) ) }
		if not results[i][1] then
			results[i][2] = type(results[i][2])
		end
	end
	return unpack( results )
end

local tests = {
	{
		name = 'Verify the lib is loaded and exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	{
		name = 'Count',
		func = testFunction,
		args = { 'count',
			{ nil },
			{ {} },
			{ { 'a' } },
			{ { 'a', { 'b', 'c' } } },
			{ { 'a', 'b', 'c' } },
		},
		expect = {
			{ true, nil },
			{ true, 0 },
			{ true, 1 },
			{ true, 2 },
			{ true, 3 },
		}
	},
	{
		name = 'Size',
		func = testFunction,
		args = { 'size',
			{ nil },
			{ {} },
			{ { 'a' } },
			{ { 'a', { 'b', 'c' } } },
			{ { 'a', 'b', 'c' } },
		},
		expect = {
			{ true, 0 },
			{ true, 0 },
			{ true, 1 },
			{ true, 2 },
			{ true, 3 },
		}
	},
	{
		name = 'Deep equal',
		func = testFunction,
		args = { 'deepEqual',
			{ { 'a', { 'b' }, 'c' }, { 'a', 'b', 'c' } },
			{ { 'a', { 'b' }, 'c' }, { 'a', { 'b' }, 'c' } },
			{ { 'a', { ['foo'] = 'b' }, 'c' }, { 'a', { ['bar'] = 'b' }, 'c' } },
			{ { 'a', { ['foo'] = 'b' }, 'c' }, { 'a', { ['foo'] = 'b' }, 'c' } },
		},
		expect = {
			{ true, false },
			{ true, true },
			{ true, false },
			{ true, true },
		}
	},
	{
		name = 'Contains',
		func = testFunction,
		args = { 'contains',
			{ { 'a', { 'b' }, 'c' }, { 'a' } },
			{ { 'a', { 'b' }, 'c' }, 'a' },
			{ { 'a', { 'b' }, 'c' }, { 'b' } },
			{ { 'a', { 'b' }, 'c' }, 'c' },
			{ { 'a', { ['foo'] = 'b' }, 'c' }, { ['bar'] = 'b' } },
			{ { 'a', { ['foo'] = 'b' }, 'c' }, { ['foo'] = 'b' } },
		},
		expect = {
			{ true, false },
			{ true, 1 },
			{ true, 2 },
			{ true, 3 },
			{ true, false },
			{ true, 2 },
		}
	},
}

return testframework.getTestProvider( tests )
