--- Class for a queue.
-- This is a semi-open structure, to make it easy to extend and adapt.
-- That is, the queue can be abused by manipulating it as an ordinary table.
-- Items can be added to one end of a queue, and later removed from the opposite end.
-- See also Wikipedias page on [queue](https://en.wikipedia.org/wiki/Queue_(abstract_data_type)).
-- @module Queue

-- pure libs
local colUtil = require 'collectionUtil'
local libUtil = require 'libraryUtil'

-- lookup
local checkType = libUtil.checkType
local makeCheckSelfFunction = libUtil.makeCheckSelfFunction

-- @var metatable for queues
local queue = {}

-- loop indexing back to metatable
queue.__index = queue

-- called when …
function queue.__call( t, value )
	if value then
		table.insert( t, 1, value )
	end

	return t[#t]
end

--- Internal creator function.
-- @local
-- @tparam vararg ... arguments to be collected
-- @treturn self
local function makeQueue( ... )
	local inner = setmetatable( {}, queue )
	inner.__index = inner
	local outer = setmetatable( {}, inner )

	--- Check whether method is part of self.
	-- @local
	-- @function checkSelf
	-- @raise if called from a method not part of self
	local checkSelf = makeCheckSelfFunction( 'queue', 'obj', outer, 'queue object' )

	-- keep in closure
	local _length = 0

	-- keep in exposed structure
	local len = select( '#', ... )
	for i,v in ipairs{ ... } do
		_length = _length + 1
		outer[len-i+1] = v
	end

	--- Enqueue zero or more items into the queue.
	-- @function queue:enqueue
	-- @nick unshift
	-- @nick insert
	-- @tparam vararg ...
	-- @treturn self
	function inner:enqueue( ... )
		checkSelf( self, 'enqueue' )

		for _,v in ipairs{ ... } do
			_length = _length + 1
			table.insert( self, 1, v )
		end

		return self
	end
	inner.unshift = inner.enqueue
	inner.insert = inner.enqueue

	--- Dequeue one or more items out of the queue.
	-- @function queue:dequeue
	-- @nick shift
	-- @tparam number n levels to be popped
	-- @tparam nil|boolean pack result in table
	-- @treturn vararg
	function inner:dequeue( n, pack )
		checkSelf( self, 'dequeue' )
		checkType( 'queue:dequeue', 1, n, 'number', true )
		checkType( 'queue:dequeue', 2, pack, 'boolean', true )

		local t = {}
		for i = 1, ( n or 1 ) do
			_length = _length - 1
			t[i] = table.remove( self )
		end

		if not pack then
			return unpack( t )
		end

		return t
	end
	inner.shift = inner.dequeue

	--- Drop one or more items off the queue.
	-- @function queue:drop
	-- @nick remove
	-- @tparam number n levels to be dropped
	-- @treturn self
	function inner:drop( n )
		checkSelf( self, 'drop' )
		checkType( 'queues:drop', 1, n, 'number', true )

		for _ = 1, ( n or 1 ) do
			_length = _length - 1
			table.remove( self )
		end

		return self
	end
	inner.remove = inner.drop

	--- Length of structure.
	-- @function queue:length
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
function queue.new( ... )
	return makeQueue( ... )
end

--- Is the queue empty.
-- Checks by counting items whether queue is empty.
-- @function queue:isEmpty
-- @treturn boolean
queue.isEmpty = colUtil.empty

--- Count number of entries in queue.
-- @function queue:count
-- @treturn number
queue.count = colUtil.count

-- Return the final lib
return queue
