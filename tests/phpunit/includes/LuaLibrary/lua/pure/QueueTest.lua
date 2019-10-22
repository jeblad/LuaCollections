--- Tests for the queue module.

local testframework = require 'Module:TestFramework'

local lib = require 'queue'
assert( lib )

local function testExists()
	return type( lib )
end

local function testFunction( obj, into, outof, ... )
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
		name = 'Verify the lib is loaded and exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	{
		name = 'Enqueue – dequeue',
		func = testFunction,
		args = { lib.new(), 'enqueue', 'dequeue',
			{ nil },
			{ 'foo' },
			{ 'bar', 'baz' },
		},
		expect = {
			{ true, nil },
			{ true, 'foo' },
			{ true, 'bar', 'baz' },
		}
	},
}

return testframework.getTestProvider( tests )
