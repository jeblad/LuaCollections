--- Tests for the queue module.

local testframework = require 'Module:TestFramework'

local lib = require 'queue'
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
			{ true, { 'baz', 'bar' } },
			{ true, { 9, 8, 7, 6, 5, 4, 3, 2, 1 } },
		}
	},
	{
		name = 'enqueue',
		func = testMethod,
		args = {
			{ lib.new(), 'enqueue', },
			{ lib.new(), 'enqueue', 'foo' },
			{ lib.new(), 'enqueue', 'bar', 'baz' },
			{ lib.new(), 'enqueue', 1, 2, 3, 4, 5, 6, 7, 8, 9 },
		},
		expect = {
			{ true, {} },
			{ true, { 'foo' } },
			{ true, { 'baz', 'bar' } },
			{ true, { 9, 8, 7, 6, 5, 4, 3, 2, 1 } },
		}
	},
	{
		name = 'dequeue',
		func = testMethod,
		args = {
			{ lib.new(), 'dequeue', },
			{ lib.new( 'foo', 'bar' ), 'dequeue', },
			{ lib.new( 'foo', 'bar', 'baz' ), 'dequeue', 2 },
			{ lib.new( 1, 2, 3, 4, 5, 6, 7, 8, 9 ), 'dequeue', 3, true },
		},
		expect = {
			{ true, },
			{ true, 'foo' },
			{ true, 'foo', 'bar' },
			{ true, { 1, 2, 3 } },
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
			{ true, { 'bar' } },
			{ true, { 'baz' } },
			{ true, { 9, 8, 7, 6, 5, 4 } },
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
