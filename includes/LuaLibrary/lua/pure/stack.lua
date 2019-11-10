--- Class for a stack.
-- This is a semi-open structure, to make it easy to extend and adapt.
-- That is, the stack can be abused by manipulating it as an ordinary table.
-- Items can be added to one end of a queue, and later removed from the same end.
-- See also Wikipedias page on [stack](https://en.wikipedia.org/wiki/Stack_(abstract_data_type)).
-- @module Stack

-- pure libs
local colUtil = require 'collectionUtil'
local libUtil = require 'libraryUtil'

-- lookup
local checkType = libUtil.checkType

-- @var metatable for stacks
local stack = {}

-- loop indexing back to metatable
stack.__index = stack

-- called when …
function stack.__call( t, value )
	if value then
		table.insert( t, value )
	end

	return t[#t]
end

--- Internal creator function.
-- @local
-- @tparam vararg ... arguments to be collected
-- @treturn self
local function makeStack( ... )
	local obj = setmetatable( {}, stack )

	-- keep in exposed structure
	for i,v in ipairs{ ... } do
		obj[i] = v
	end

	return obj
end

--- Create a new instance.
-- @function stack.new
-- @tparam vararg ... arguments to be passed on
-- @treturn self
function stack.new( ... )
	return makeStack( ... )
end

--- Push zero or more items on the stack.
-- @function stack:push
-- @nick insert
-- @tparam vararg ...
-- @treturn self
function stack:push( ... )
	for _,v in ipairs{ ... } do
		table.insert( self, v )
	end

	return self
end
stack.insert = stack.push

--- Pop one or more items off the stack.
-- @function stack:pop
-- @tparam number n levels to be popped
-- @tparam nil|boolean pack result in table
-- @treturn varag
function stack:pop( n, pack )
	checkType( 'stack:pop', 2, pack, 'boolean', true )

	local t = {}
	for i = 1, ( n or 1 ) do
		t[i] = table.remove( self )
	end

	if not pack then
		return unpack( t )
	end

	return t
end

--- Drop one or more items off the stack.
-- @function stack:drop
-- @nick remove
-- @tparam number n levels to be dropped
-- @treturn self
function stack:drop( n )
	checkType( 'stack:drop', 1, n, 'number', true )

	for _ = 1, ( n or 1 ) do
		table.remove( self )
	end

	return self
end
stack.remove = stack.drop

--- Is the stack empty.
-- Checks by counting items whether stack is empty.
-- @function stack:isEmpty
-- @treturn boolean
stack.isEmpty = colUtil.empty

--- Count number of entries in stack.
-- @function stack:count
-- @treturn number
stack.count = colUtil.count

-- Return the final lib
return stack
