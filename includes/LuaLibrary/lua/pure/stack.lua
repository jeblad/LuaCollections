--- Class for a stack.
-- This is an open structure, to make it easilly extensible.
-- That is, the stack can be abused by manipulating it as an ordinary table.
-- Items can be added to one end of a queue, and later removed from the same end.
-- @module stack

-- pure libs
local util = require 'tableUtil'

-- @var metatable for stacks
local stack = {}

-- loop indexing back to metatable
stack.__index = stack

--- Create a new instance.
-- @function stack.new
-- @tparam vararg ... arguments to be passed on
-- @treturn self
function stack.new( ... )
	local new = setmetatable( {}, stack )
	for i,v in ipairs{ ... } do
		new[i] = v
	end
	return new
end

--- Push an item on the stack.
-- This method can be called as a function.
-- @function stack:push
-- @tparam any item
-- @treturn self
function stack:push( item )
	table.insert( self, item )
	return self
end

--- Pop an item off the stack.
-- This method can be called as a function.
-- @function stack:pop
-- @nick drop
-- @treturn any
function stack:pop()
	return table.remove( self )
end
stack.drop = stack.pop

--- Is the stack empty.
-- Checks by counting items whether stack is empty.
-- This method can be called as a function.
-- @function stack:isEmpty
-- @treturn boolean
function stack:isEmpty()
	return util.count( self ) == 0
end

--- Count number of entries in stack.
-- This method can be called as a function.
-- @function stack:count
-- @treturn number
function stack:count()
	return util.count( self )
end

-- Return the final lib
return stack
