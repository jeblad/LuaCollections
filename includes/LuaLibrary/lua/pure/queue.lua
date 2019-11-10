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
	local obj = setmetatable( {}, queue )

	-- keep in exposed structure
	local len = select( '#', ... )
	for i,v in ipairs{ ... } do
		obj[len-i+1] = v
	end

	return obj
end

--- Create a new instance.
-- @function stack.new
-- @tparam vararg ... arguments to be passed on
-- @treturn self
function queue.new( ... )
	return makeQueue( ... )
end

--- Enqueue zero or more items into the queue.
-- @function queue:enqueue
-- @nick unshift
-- @nick insert
-- @tparam vararg ...
-- @treturn self
function queue:enqueue( ... )
	for _,v in ipairs{ ... } do
		table.insert( self, 1, v )
	end

	return self
end
queue.unshift = queue.enqueue
queue.insert = queue.enqueue

--- Dequeue one or more items out of the queue.
-- @function queue:dequeue
-- @nick shift
-- @tparam number n levels to be popped
-- @tparam nil|boolean pack result in table
-- @treturn vararg
function queue:dequeue( n, pack )
	checkType( 'queue:dequeue', 1, n, 'number', true )
	checkType( 'queue:dequeue', 2, pack, 'boolean', true )

	local t = {}
	for i = 1, ( n or 1 ) do
		t[i] = table.remove( self )
	end

	if not pack then
		return unpack( t )
	end

	return t
end
queue.shift = queue.dequeue

--- Drop one or more items off the queue.
-- @function queue:drop
-- @nick remove
-- @tparam number n levels to be dropped
-- @treturn self
function queue:drop( n )
	checkType( 'queues:drop', 1, n, 'number', true )

	for _ = 1, ( n or 1 ) do
		table.remove( self )
	end

	return self
end
queue.remove = queue.drop

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
