--- Class for a map.
-- This is an open structure, to make it easilly extensible.
-- That is, the queue can be abused by manipulating it as an ordinary table.
-- Items can be added to the map, but not removed.
-- See also Wikipedias page on [map](https://en.wikipedia.org/wiki/map_(abstract_data_type)).
-- @module map

-- pure libs
local util = require 'collectionUtil'

-- @var metatable for maps
local map = {}

-- loop indexing back to metatable
map.__index = map

--- Create a new instance.
-- @function map.new
-- @tparam vararg ... arguments to be collected
-- @treturn self
function map.new( ... )
	local new = setmetatable( {}, map )
	for _,v in ipairs{ ... } do
		for k, w in pairs( v ) do
			new[k] = w
		end
	end
	return new
end

--- Add items to the map.
-- @function map:add
-- @nick inject
-- @tparam vararg ...
-- @treturn self
function map:add( ... )
	for _,v in ipairs{ ... } do
		for k, w in pairs( v ) do
			self[k] = w
		end
	end
	return self
end
map.inject = map.add

--- Find an item in the map.
-- @function map:find
-- @nick has
-- @tparam any key
-- @treturn any
function map:find( key )
	return self[key]
end
map.has = map.find

--- Is the map empty.
-- Checks by counting items whether map is empty.
-- @function map:isEmpty
-- @treturn boolean
function map:isEmpty()
	return util.empty( self )
end

--- Count number of entries in map.
-- @function map:count
-- @treturn number
function map:count()
	return util.count( self )
end

-- Return the final lib
return map
