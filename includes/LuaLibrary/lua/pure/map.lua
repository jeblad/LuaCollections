--- Class for a map.
-- This is an open structure, to make it easy to extend and adapt.
-- That is, the queue can be abused by manipulating it as an ordinary table.
-- Items can be added to the map, and removed.
-- See also Wikipedias page on [map](https://en.wikipedia.org/wiki/map_(abstract_data_type)).
-- @module Map

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

	--- Insert zero or more items into the map.
	-- @function map:insert
	-- @nick inject
	-- @tparam vararg ...
	-- @treturn self
	function inner:insert( ... )
		checkSelf( self, 'insert' )

		for _,v in ipairs{ ... } do
			for k, w in pairs( v ) do
				if type( self[k] ) == 'nil' and type( w ) ~= 'nil' then
					_length = _length + 1
				elseif type( self[k] ) ~= 'nil' and type( w ) == 'nil' then
					_length = _length - 1
				end
				self[k] = w
			end
		end

		return self
	end
	inner.inject = inner.insert

	--- Reject zero or more items by value from the map.
	-- @function map:reject
	-- @tparam vararg ...
	-- @treturn table
	function inner:reject( ... )
		checkSelf( self, 'reject' )

		local values = {}
		for _,v in ipairs{ ... } do
			values[v] = true
		end

		local t = {}
		for k,v in pairs( self ) do
			if values[v] then
				_length = _length - 1
				table.insert( t, { k, v } )
				self[k] = nil
			end
		end

		return t
	end

	--- Remove zero or more items by key from the map.
	-- @function map:remove
	-- @tparam vararg ...
	-- @treturn table
	function inner:remove( ... )
		checkSelf( self, 'remove' )

		local t = {}
		for i,v in ipairs{ ... } do
			if type( self[v] ) ~= 'nil' then
				_length = _length - 1
				table.insert( t, { i, v } )
				self[v] = nil
			end
		end

		return t
	end

	--- Copy zero or more items by key from the map.
	-- @function map:copy
	-- @tparam vararg ...
	-- @treturn table
	function inner:copy( ... )
		checkSelf( self, 'copy' )

		local t = {}
		for _,v in ipairs{ ... } do
			t[v] = self[v]
		end

		return t
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
