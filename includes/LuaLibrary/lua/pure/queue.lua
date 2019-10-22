--- Class for a queue.
-- This is an open structure, to make it easilly extensible.
-- That is, the queue can be abused by manipulating it as an ordinary table.
-- Items can be added to one end of a queue, and later removed from the opposite end.
-- See also Wikipedias page on [queue](https://en.wikipedia.org/wiki/Queue_(abstract_data_type)).
-- @module Queue

-- pure libs
--local util = require 'tableUtil'

-- @var metatable for queues
local queue = {}

-- loop indexing back to metatable
queue.__index = queue

--- Create a new instance.
-- @function queue.new
-- @tparam vararg ... arguments to be passed on
-- @treturn self
function queue.new( ... )
	local new = setmetatable( {}, queue )
	for _,v in ipairs{ ... } do
		table.insert( new, 1, v )
	end
	return new
end

--- Enqueue an item into the queue.
-- This method can be called as a function.
-- @function queue:enqueue
-- @nick unshift
-- @tparam vararg ...
-- @treturn self
function queue:enqueue( ... )
	table.insert( self, 1, { ... } )
	return self
end
queue.unshift = queue.enqueue

--- Dequeue an item out of the queue.
-- This method can be called as a function.
-- @function queue:dequeue
-- @nick shift
-- @treturn vararg
function queue:dequeue()
	return unpack( table.remove( self ) )
end
queue.shift = queue.dequeue

--- Is the queue empty.
-- Checks by counting items whether queue is empty.
-- This method can be called as a function.
-- @function queue:isEmpty
-- @treturn boolean
function queue:isEmpty()
	return util.count( self ) == 0
end

--- Count number of entries in queue.
-- This method can be called as a function.
-- @function queue:count
-- @treturn number
function queue:count()
	return util.count( self )
end

-- Return the final lib
return queue
