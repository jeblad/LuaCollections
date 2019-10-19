--- Class for a bag.
-- This is an open structure, to make it easilly extensible.
-- That is, the queue can be abused by manipulating it as an ordinary table.
-- Items can be added to a bag, but not removed.
-- @see https://en.wikipedia.org/wiki/Set_(abstract_data_type)#Multiset
-- @module Bag

-- pure libs
local util = require 'tableUtil'

-- @var metatable for bags
local bag = {}

-- loop indexing back to metatable
bag.__index = bag

--- Create a new instance.
-- @function bag.new
-- @tparam vararg ... arguments to be passed on
-- @treturn self
function bag.new( ... )
	local new = setmetatable( {}, bag )
	for i,v in ipairs{ ... } do
		new[i] = v
	end
	return new
end

--- Add an item to the bag.
-- This method can be called as a function.
-- @function bag:add
-- @tparam any item
-- @treturn self
function bag:add( item )
	table.insert( self, item )
	return self
end

--- Find an item in the bag.
-- There might be several items.
-- Equality is shallow.
-- This method can be called as a function.
-- @function bag:find
-- @nick has
-- @tparam any item
-- @treturn any
function bag:find( item )
	for _,v in ipairs( self ) do
		if v == item then
			return v
		end
	end
	return nil
end
bag.has = bag.find

--- Is the bag empty.
-- Checks by counting items whether bag is empty.
-- This method can be called as a function.
-- @function bag:isEmpty
-- @treturn boolean
function bag:isEmpty()
	return util.count( self ) == 0
end

--- Count number of entries in bag.
-- This method can be called as a function.
-- @function bag:count
-- @treturn number
function bag:count()
	return util.count( self )
end

-- Return the final lib
return bag
