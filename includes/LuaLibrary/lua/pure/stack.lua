--- Class for a stack.
-- This is an open structure, to make it easilly extensible.
-- That is, the stack can be abused by manipulating it as an ordinary table.
-- Items can be added to one end of a queue, and later removed from the same end.
-- See also Wikipedias page on [stack](https://en.wikipedia.org/wiki/Stack_(abstract_data_type)).
-- @module Stack

-- pure libs
local util = require 'collectionUtil'

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

--- Push items on the stack.
-- This method can be called as a function.
-- @function stack:push
-- @tparam vararg ...
-- @treturn self
function stack:push( ... )
	for _,v in ipairs{ ... } do
		table.insert( self, v )
	end
	return self
end

--- Pop one or more items off the stack.
-- This method can be called as a function.
-- @function stack:pop
-- @nick drop
-- @tparam number n levels to be popped
-- @treturn varag
function stack:pop( n )
	local t = {}
	for i = 1, ( n or 1 ) do
		t[i] = table.remove( self )
	end
	return unpack( t )
end
stack.drop = stack.pop

--- Is the stack empty.
-- Checks by counting items whether stack is empty.
-- This method can be called as a function.
-- @function stack:isEmpty
-- @treturn boolean
function stack:isEmpty()
	return util.empty( self )
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
