--- Class for a map.
-- This is an open structure, to make it easy to extend and adapt.
-- That is, the queue can be abused by manipulating it as an ordinary table.
-- Items can be added to the map, but not removed.
-- See also Wikipedias page on [map](https://en.wikipedia.org/wiki/map_(abstract_data_type)).
-- @module map

-- pure libs
local colUtil = require 'collectionUtil'
local libUtil = require 'libraryUtil'

-- lookup
--local checkType = libUtil.checkType
local makeCheckSelfFunction = libUtil.makeCheckSelfFunction

-- @var metatable for maps
local map = {}

-- loop indexing back to metatable
map.__index = map

--- Internal creator function.
-- @local
-- @tparam vararg ... arguments to be collected
-- @treturn self
local function makeMap( ... )
	local inner = setmetatable( {}, map )
	inner.__index = inner
	local outer = setmetatable( {}, inner )

	--- Check whether method is part of self.
	-- @local
	-- @function checkSelf
	-- @raise if called from a method not part of self
	local checkSelf = makeCheckSelfFunction( 'map', 'obj', outer, 'map object' )

	-- keep in closure
	local _length = 0

	-- keep in exposed structure
	for _,v in ipairs{ ... } do
		for k, w in pairs( v ) do
			if type( outer[k] ) == 'nil' and type( w ) ~= 'nil' then
				_length = _length + 1
			elseif type( outer[k] ) ~= 'nil' and type( w ) == 'nil' then
				_length = _length - 1
			end
			outer[k] = w
		end
	end

	--- Insert items to the map.
	-- @function map:insert
	-- @nick inject
	-- @tparam vararg ...
	-- @treturn self
	function inner:insert( ... )
		checkSelf( self, 'insert' )

		for _,v in ipairs{ ... } do
			for k, w in pairs( v ) do
				if type( outer[k] ) == 'nil' and type( w ) ~= 'nil' then
					_length = _length + 1
				elseif type( outer[k] ) ~= 'nil' and type( w ) == 'nil' then
					_length = _length - 1
				end
				self[k] = w
			end
		end

		return self
	end
	inner.inject = inner.insert

	--- Remove items from the map.
	-- @function map:remove
	-- @nick reject
	-- @tparam vararg ...
	-- @treturn self
	function inner:remove( ... )
		checkSelf( self, 'remove' )

		local t = {}
		for _,v in ipairs{ ... } do
			if type( outer[v] ) ~= 'nil' then
				_length = _length - 1
			end
			t[v] = self[v]
			self[v] = nil
		end

		return t
	end
	inner.reject = inner.remove

	--- Drop one or more items off the map.
	-- @function map:drop
	-- @tparam vararg ...
	-- @treturn self
	function inner:drop( ... )
		checkSelf( self, 'drop' )

		for _,v in ipairs{ ... } do
			if self[v] then
				_length = _length - 1
			end
			self[v] = nil
		end

		return self
	end

	--- Find an item in the map.
	-- @function map:find
	-- @nick has
	-- @tparam vararg ...
	-- @treturn any
	function inner:find( ... )
		checkSelf( self, 'find' )

		local t = {}
		for _,v in ipairs{ ... } do
			t[v] = self[v]
		end

		return t
	end
	inner.has = inner.find

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
-- @function map.new
-- @tparam vararg ... arguments to be passed on
-- @treturn self
function map.new( ... )
	return makeMap( ... )
end

--- Is the map empty.
-- Checks by counting items whether map is empty.
-- @function map:isEmpty
-- @treturn boolean
map.isEmpty = colUtil.empty

--- Count number of entries in map.
-- @function map:count
-- @treturn number
map.count = colUtil.count

-- Return the final lib
return map
