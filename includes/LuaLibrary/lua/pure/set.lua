--- Class for a set.
-- This is an open structure, to make it easilly extensible.
-- That is, the queue can be abused by manipulating it as an ordinary table.
-- Items can be added to a set, but not removed.
-- @module set

-- pure libs
local util = require 'tableUtil'

-- @var metatable for sets
local set = {}

-- loop indexing back to metatable
set.__index = set

--- Create a new instance.
-- @function set.new
-- @tparam vararg ... arguments to be passed on
-- @treturn self
function set.new( ... )
	local new = setmetatable( {}, set )
	for _,v in ipairs{ ... } do
		new[v] = v
	end
	return new
end

--- Add an item to the set.
-- This method can be called as a function.
-- @function set:add
-- @nick inject
-- @tparam any item
-- @treturn self
function set:add( item )
	self[item] = item
	return self
end
set.inject = set.add

--- Find an item in the set.
-- This method can be called as a function.
-- @function set:find
-- @nick has
-- @tparam any item
-- @treturn any
function set:find( item )
	return self[item]
end
set.has = set.find

--- Is the set empty.
-- Checks by counting items whether set is empty.
-- This method can be called as a function.
-- @function set:isEmpty
-- @treturn boolean
function set:isEmpty()
	return util.count( self ) == 0
end

--- Count number of entries in set.
-- This method can be called as a function.
-- @function set:count
-- @treturn number
function set:count()
	return util.count( self )
end

-- Return the final lib
return set
