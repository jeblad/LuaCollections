--- Tests for the map module.

local testframework = require 'Module:TestFramework'

local lib = require 'map'
assert( lib )

local function testCreateAndSinglecall( name, ... )
	local obj = lib.new( ... )
	return pcall( function() return obj[name]( obj ) end )
end

local function testCreateAndMulticall( name, arguments, ... )
	local results = {}
	for i,v in ipairs{ ... } do
		local obj = lib.new( v )
		results[i] = { pcall( function() return obj:length(), obj[name]( obj, unpack(arguments) ), obj:length() end ) }
		if not results[i][1] then
			return results[i][2]
		end
	end
	return unpack( results )
end

local function testMethod( obj, into, outof, arguments, ... )
	local results = {}
	for _,v in ipairs{ ... } do
		local res,err = pcall( function( ... ) obj[into]( obj, ... ) end, v )
		if not res then
			return err
		end
	end
	for i,_ in ipairs{ ... } do
		results[i] = { pcall( function() return obj:length(), obj[outof]( obj, unpack( arguments ) ) end ) }
		if not results[i][1] then
			return results[i][2]
		end
	end
	return unpack( results )
end

local tests = {
	{
		name = 'Create – remove',
		func = testCreateAndMulticall,
		args = { 'remove', { 'y' },
			{ nil },
			{ x = 'foo' },
			{ y = 'bar', z = 'baz' },
		},
		expect = {
			{ true, 0, {}, 0 },
			{ true, 1, {}, 1 },
			{ true, 2, { 'bar' }, 1 },
		}
	},
	{
		name = 'Create – find',
		func = testCreateAndMulticall,
		args = { 'find', { 'y' },
			{ nil },
			{ x = 'foo' },
			{ y = 'bar', z = 'baz' },
		},
		expect = {
			{ true, 0, {}, 0 },
			{ true, 1, {}, 1 },
			{ true, 2, { y = 'bar' }, 2 },
		}
	},
	{
		name = 'Insert – remove',
		func = testMethod,
		args = { lib.new(), 'insert', 'remove', { 'y' },
			{ nil },
			{ x = 'foo' },
			{ y = 'bar', z = 'baz' },
		},
		expect = {
			{ true, 3, { 'bar' } },
			{ true, 2, {} },
			{ true, 2, {} },
		}
	},
	{
		name = 'Create – isEmpty',
		func = testCreateAndSinglecall,
		args = { 'isEmpty' },
		expect = { true, true }
	},
	{
		name = 'Create – isEmpty',
		func = testCreateAndSinglecall,
		args = { 'isEmpty',
			{ nil },
			{ 'foo' },
			{ 'bar', 'baz' },
		},
		expect = { true, false }
	},
	{
		name = 'Create – count',
		func = testCreateAndSinglecall,
		args = { 'count' },
		expect = { true, 0 }
	},
	{
		name = 'Create – count',
		func = testCreateAndSinglecall,
		args = { 'count',
			{ a = nil },
			{ b = false },
			{ c = true },
			{ x = 'foo' },
			{ y = 'bar', z = 'baz' },
		},
		expect = { true, 5 }
	},
	{
		name = 'Create – length',
		func = testCreateAndSinglecall,
		args = { 'length' },
		expect = { true, 0 }
	},
	{
		name = 'Create – length',
		func = testCreateAndSinglecall,
		args = { 'length',
			{ a = nil },
			{ b = false },
			{ c = true },
			{ x = 'foo' },
			{ y = 'bar', z = 'baz' },
		},
		expect = { true, 5 }
	},
}

return testframework.getTestProvider( tests )
