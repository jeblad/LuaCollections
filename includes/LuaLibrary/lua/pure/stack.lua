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
local makeCheckSelfFunction = libUtil.makeCheckSelfFunction

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
	local inner = setmetatable( {}, stack )
	inner.__index = inner
	local outer = setmetatable( {}, inner )

	--- Check whether method is part of self.
	-- @local
	-- @function checkSelf
	-- @raise if called from a method not part of self
	local checkSelf = makeCheckSelfFunction( 'stack', 'obj', outer, 'stack object' )

	-- keep in closure
	local _length = 0

	-- keep in exposed structure
	for i,v in ipairs{ ... } do
		_length = _length + 1
		outer[i] = v
	end

	--- Push items on the stack.
	-- @function stack:push
	-- @tparam vararg ...
	-- @treturn self
	function inner:push( ... )
		checkSelf( self, 'push' )

		for _,v in ipairs{ ... } do
			_length = _length + 1
			table.insert( self, v )
		end

		return self
	end

	--- Pop one or more items off the stack.
	-- @function stack:pop
	-- @tparam number n levels to be popped
	-- @treturn varag
	function inner:pop( n )
		checkSelf( self, 'pop' )
		checkType( 'stack:pop', 1, n, 'number', true )

		local t = {}
		for i = 1, ( n or 1 ) do
			_length = _length - 1
			t[i] = table.remove( self )
		end

		if not n then
			return unpack( t )
		end

		return t
	end

	--- Drop one or more items off the stack.
	-- @function stack:drop
	-- @tparam number n levels to be dropped
	-- @treturn self
	function inner:drop( n )
		checkSelf( self, 'drop' )
		checkType( 'stack:drop', 1, n, 'number', true )

		for i = 1, ( n or 1 ) do
			_length = _length - 1
			table.remove( self )
		end

		return self
	end

	--- Length of structure.
	-- @function stack:length
	-- @treturn number
	function inner:length()
		checkSelf( self, 'length' )
		return _length
	end

	return outer
end

--- Create a new instance.
-- @function stack.new
-- @tparam vararg ... arguments to be passed on
-- @treturn self
function stack.new( ... )
	return makeStack( ... )
end

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
