--- Class for a map.
-- This is an open structure, to make it easy to extend and adapt.
-- That is, the queue can be abused by manipulating it as an ordinary table.
-- Items can be added to the map, and removed.
-- See also Wikipedias page on [map](https://en.wikipedia.org/wiki/map_(abstract_data_type)).
-- @module Map

-- pure libs
local colUtil = require 'collectionUtil'

-- @var metatable for maps
local map = {}

-- loop indexing back to metatable
map.__index = map

--- Internal creator function.
-- @local
-- @tparam vararg ... arguments to be collected
-- @treturn self
local function makeMap( ... )
	local obj = setmetatable( {}, map )

	-- keep in exposed structure
	for _,v in ipairs{ ... } do
		for k, w in pairs( v ) do
			obj[k] = w
		end
	end

	return obj
end

--- Create a new instance.
-- @function map.new
-- @tparam vararg ... arguments to be passed on
-- @treturn self
function map.new( ... )
	return makeMap( ... )
end

--- Insert zero or more items into the map.
-- @function map:insert
-- @nick inject
-- @tparam vararg ...
-- @treturn self
function map:insert( ... )
	for _,v in ipairs{ ... } do
		for k, w in pairs( v ) do
			self[k] = w
		end
	end

	return self
end
map.inject = map.insert

--- Reject zero or more items by value from the map.
-- @function map:reject
-- @tparam vararg ...
-- @treturn table
function map:reject( ... )
	local values = {}
	for _,v in ipairs{ ... } do
		values[v] = true
	end

	local t = {}
	for k,v in pairs( self ) do
		if values[v] then
			table.insert( t, { k, v } )
			self[k] = nil
		end
	end

	return t
end

--- Remove zero or more items by key from the map.
-- @function map:remove
-- @tparam vararg ...
-- @treturn table
function map:remove( ... )
	local t = {}
	for i,v in ipairs{ ... } do
		if type( self[v] ) ~= 'nil' then
			table.insert( t, { i, v } )
			self[v] = nil
		end
	end

	return t
end

--- Copy zero or more items by key from the map.
-- @function map:copy
-- @tparam vararg ...
-- @treturn table
function map:copy( ... )
	local t = {}
	for _,v in ipairs{ ... } do
		t[v] = self[v]
	end

	return t
end

--- Is the map empty.
-- Checks by counting items whether map is empty.
-- @function map:isEmpty
-- @treturn boolean
map.isEmpty = colUtil.empty

--- Count number of entries in map.
-- @function map:count
-- @treturn number
map.count = colUtil.count

-- Return the final lib
return map
