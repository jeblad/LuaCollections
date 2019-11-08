--- Tests for the queue module.

local testframework = require 'Module:TestFramework'

local lib = require 'queue'
assert( lib )

local function testCreateAndSinglecall( name, ... )
	local obj = lib.new( ... )
	return pcall( function() return obj[name]( obj ) end )
end

local function testCreateAndMulticall( name, ... )
	local results = {}
	for i,v in ipairs{ ... } do
		local obj = lib.new( unpack( v ) )
		results[i] = { pcall( function() return obj[name]( obj ) end ) }
		if not results[i][1] then
			return results[i][2]
		end
	end
	return unpack( results )
end

local function testMethod( obj, into, outof, ... )
	local results = {}
	for _,v in ipairs{ ... } do
		local res,err = pcall( function( ... ) obj[into]( obj, ... ) end, unpack( v ) )
		if not res then
			return err
		end
	end
	for i,_ in ipairs{ ... } do
		results[i] = { pcall( function() return obj[outof]( obj ) end ) }
		if not results[i][1] then
			return results[i][2]
		end
	end
	return unpack( results )
end

local tests = {
	{
		name = 'Create – dequeue',
		func = testCreateAndMulticall,
		args = { 'dequeue',
			{ nil },
			{ 'foo' },
			{ 'bar', 'baz' },
		},
		expect = {
			{ true, },
			{ true, 'foo' },
			{ true, 'bar' },
		}
	},
	{
		name = 'Enqueue – dequeue',
		func = testMethod,
		args = { lib.new(), 'enqueue', 'dequeue',
			{ nil },
			{ 'foo' },
			{ 'bar', 'baz' },
		},
		expect = {
			{ true, 'foo' },
			{ true, 'bar' },
			{ true, 'baz' },
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
			{ nil },
			{ 'foo' },
			{ 'bar', 'baz' },
		},
		expect = { true, 3 }
	},
}

return testframework.getTestProvider( tests )
