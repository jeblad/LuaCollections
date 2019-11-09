--- Tests for the stack module.

local testframework = require 'Module:TestFramework'

local lib = require 'stack'
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
			{ 'foo' },
			{ 'bar', 'baz' },
			{ 1, 2, 3, 4, 5, 6, 7, 8, 9 },
		},
		expect = {
			{ true, {} },
			{ true, { 'foo' } },
			{ true, { 'bar', 'baz' } },
			{ true, { 1, 2, 3, 4, 5, 6, 7, 8, 9 } },
		}
	},
	{
		name = 'push',
		func = testMethod,
		args = {
			{ lib.new(), 'push', },
			{ lib.new(), 'push', 'foo' },
			{ lib.new(), 'push', 'bar', 'baz' },
			{ lib.new(), 'push', 1, 2, 3, 4, 5, 6, 7, 8, 9 },
		},
		expect = {
			{ true, {} },
			{ true, { 'foo' } },
			{ true, { 'bar', 'baz' } },
			{ true, { 1, 2, 3, 4, 5, 6, 7, 8, 9 } },
		}
	},
	{
		name = 'pop',
		func = testMethod,
		args = {
			{ lib.new(), 'pop', },
			{ lib.new( 'foo', 'bar' ), 'pop', },
			{ lib.new( 'foo', 'bar', 'baz' ), 'pop', 2 },
			{ lib.new( 1, 2, 3, 4, 5, 6, 7, 8, 9 ), 'pop', 3, true },
		},
		expect = {
			{ true, },
			{ true, 'bar' },
			{ true, 'baz', 'bar' },
			{ true, { 9, 8, 7 } },
		}
	},
	{
		name = 'drop',
		func = testMethod,
		args = {
			{ lib.new(), 'drop', },
			{ lib.new( 'foo', 'bar' ), 'drop', },
			{ lib.new( 'foo', 'bar', 'baz' ), 'drop', 2 },
			{ lib.new( 1, 2, 3, 4, 5, 6, 7, 8, 9 ), 'drop', 3 },
		},
		expect = {
			{ true, {} },
			{ true, { 'foo' } },
			{ true, { 'foo' } },
			{ true, { 1, 2, 3, 4, 5, 6 } },
		}
	},
	{
		name = 'isEmpty',
		func = testMethod,
		args = {
			{ lib.new(), 'isEmpty', },
			{ lib.new( 'foo' ), 'isEmpty' },
		},
		expect = {
			{ true, true },
			{ true, false },
		}
	},
	{
		name = 'length',
		func = testMethod,
		args = {
			{ lib.new(), 'length', },
			{ lib.new( 'foo' ), 'length' },
			{ lib.new( 'foo', 'bar' ), 'length' },
			{ lib.new( 'foo', 'bar', 'baz' ), 'length' },
		},
		expect = {
			{ true, 0 },
			{ true, 1 },
			{ true, 2 },
			{ true, 3 },
		}
	},
	{
		name = 'count',
		func = testMethod,
		args = {
			{ lib.new(), 'count', },
			{ lib.new( 'foo' ), 'count' },
			{ lib.new( 'foo', 'bar' ), 'count' },
			{ lib.new( 'foo', 'bar', 'baz' ), 'count' },
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
