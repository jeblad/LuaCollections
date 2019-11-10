--- Tests for the map module.

local testframework = require 'Module:TestFramework'

local lib = require 'map'
assert( lib )

local function testCreate( ... )
	local results = {}
	for i,v in ipairs{ ... } do
		results[i] = { pcall( function() return lib.new( unpack( v ) ) end ) }
		if not results[i][1] then
			return results[i][2]
		end
	end
	return unpack( results )
end

local function testMethod( ... )
	local results = {}
	for i,v in ipairs{ ... } do
		local obj = table.remove( v, 1 )
		local met = table.remove( v, 1 )
		results[i] = { pcall( function() return obj[met]( obj, unpack( v ) ) end ) }
		if not results[i][1] then
			return results[i][2]
		end
	end
	return unpack( results )
end

local tests = {
	{
		name = 'new',
		func = testCreate,
		args = {
			{},
			{ { x = 'foo' } },
			{ { y = 'bar' }, { z = 'baz' } },
		},
		expect = {
			{ true, {} },
			{ true, { x = 'foo' } },
			{ true, { y = 'bar', z = 'baz' } },
		}
	},
	{
		name = 'insert',
		func = testMethod,
		args = {
			{ lib.new(), 'insert', },
			{ lib.new(), 'insert', { x = 'foo' } },
			{ lib.new(), 'insert', { y = 'bar' }, { z = 'baz' } },
		},
		expect = {
			{ true, {} },
			{ true, { x = 'foo' } },
			{ true, { y = 'bar', z = 'baz' } },
		}
	},
	{
		name = 'reject',
		func = testMethod,
		args = {
			{ lib.new(), 'reject', },
			{ lib.new{ x = 'foo', y = 'bar', z = 'baz' }, 'reject', 'foo' },
			{ lib.new{ x = 'foo', y = 'bar', z = 'baz' }, 'reject', 'foo', 'bar' },
		},
		expect = {
			{ true, {} },
			{ true, { { 'x', 'foo' } } },
			{ true, {{ 'y', 'bar' }, { 'x', 'foo' } } },
		}
	},
	{
		name = 'remove',
		func = testMethod,
		args = {
			{ lib.new(), 'remove', },
			{ lib.new{ x = 'foo', y = 'bar', z = 'baz' }, 'remove', 'x' },
			{ lib.new{ x = 'foo', y = 'bar', z = 'baz' }, 'remove', 'x', 'y' },
		},
		expect = {
			{ true, {} },
			{ true, { { 1, 'x' } } },
			{ true, { { 1, 'x' }, { 2, 'y' } } },
		}
	},
	{
		name = 'copy',
		func = testMethod,
		args = {
			{ lib.new(), 'copy', },
			{ lib.new{ x = 'foo', y = 'bar', z = 'baz' }, 'copy', 'x' },
			{ lib.new{ x = 'foo', y = 'bar', z = 'baz' }, 'copy', 'x', 'y' },
		},
		expect = {
			{ true, {} },
			{ true, { x = 'foo' } },
			{ true, { x = 'foo', y = 'bar' } },
		}
	},
	{
		name = 'isEmpty',
		func = testMethod,
		args = {
			{ lib.new(), 'isEmpty', },
			{ lib.new{ x = 'foo' }, 'isEmpty' },
		},
		expect = {
			{ true, true },
			{ true, false },
		}
	},
	{
		name = 'count',
		func = testMethod,
		args = {
			{ lib.new(), 'count', },
			{ lib.new{ x = 'foo' }, 'count' },
			{ lib.new{ x = 'foo', y = 'bar' }, 'count' },
			{ lib.new{ x = 'foo', y = 'bar', z = 'baz' }, 'count' },
		},
		expect = {
			{ true, 0 },
			{ true, 1 },
			{ true, 2 },
			{ true, 3 },
		}
	},
}

return testframework.getTestProvider( tests )
