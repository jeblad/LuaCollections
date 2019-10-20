--- Utils to add a few table functions.
-- @module util
-- @author John Erling Blad < jeblad@gmail.com >

-- @var Table holding the modules exported members
local util = {}

--- Raw table count of all the items.
-- Simplified variant of
-- ['count()'](https://github.com/Yonaba/Moses/blob/master/moses.lua#L308-L322)
-- ([doc](http://yonaba.github.io/Moses/doc/#count))
-- from [Yonaba: Moses](http://yonaba.github.io/Moses/).
-- Approximation of
-- ['size()'](https://github.com/jashkenas/underscore/blob/master/underscore.js#L481-L485)
-- ((doc)(https://underscorejs.org/#size))
-- from [jashkenas: Underscore.js](https://underscorejs.org/)
-- @tparam table t has its entries counted
-- @treturn nil|number raw entries, nil on no arg
function util.count( t )
	if not t then
		return nil
	end
	local i = 0
	for _,_ in pairs( t ) do
		i = i + 1
	end
	return i
end

--- Size based on the raw table count, or vararg count.
-- This is a slightly weird function, and is a bit spezialised for the moses lib.
-- Variant of
-- ['size()'](https://github.com/Yonaba/Moses/blob/master/moses.lua#L802-L813)
-- ((doc)[http://yonaba.github.io/Moses/doc/#size])
-- from [Yonaba: Moses](http://yonaba.github.io/Moses/).
-- @tparam[opt] table|any count entries if table, count varargs otherwise
-- @treturn number counted entries
function util.size( ... )
	local v = select( 1, ... )
	if v == nil then
		return 0
	elseif type( v ) == 'table' then
		return util.count( v )
	end
	return util.count( { ... } )
end

--- Test whether two objects are of equal type.
-- If the objects are of different type, return 'false'.
-- Unless type is 'table', compare the objects.
-- Otherwise return 'nil'.
-- @local
-- @param a any type of object
-- @param b any type of object
-- @treturn nil|boolean result of comparison
function util.isTypeEqual( a, b )
	local typeA = type( a )
	local typeB = type( b )

	if typeA ~= typeB then
		return false
	end

	if typeA ~= 'table' then
		return a == b
	end

	return nil
end

--- Test whether two objects are mt equal.
-- If any of the objects have an `__eq` method, then compare the objects with it.
-- Otherwise return 'nil'.
-- @local
-- @param a any type of object
-- @param b any type of object
-- @treturn nil|boolean result of comparison
function util.isMetatableEqual( a, b )
	local mtA = getmetatable( a )
	if mtA and mtA.__eq then
		return mtA.__eq( a, b )
	end

	local mtB = getmetatable( b )
	if mtB and mtB.__eq then
		return mtB.__eq( b, a )
	end

	return nil
end

--- Deep equal of two objects.
-- Simplified variant of
-- ['isEqual()'](https://github.com/Yonaba/Moses/blob/master/moses.lua#L2775-L2815)
-- ((doc)[http://yonaba.github.io/Moses/doc/#isEqual])
-- from [Yonaba: Moses](http://yonaba.github.io/Moses/).
-- Variant of
-- ['is_equal()'](https://github.com/mirven/underscore.lua/blob/master/lib/underscore.lua#L328-L352)
-- ((doc)[https://mirven.github.io/underscore.lua/#is_equal])
-- from [mirven: Underscore.lua](https://mirven.github.io/underscore.lua/).
-- Approximation of
-- ['isEqual()'](https://github.com/jashkenas/underscore/blob/master/underscore.js#L1295-L1298)
-- ((doc)(https://underscorejs.org/#isEqual))
-- from [jashkenas: Underscore.js](https://underscorejs.org/)
-- Variant of
-- ['deepcompare()'](https://github.com/stevedonovan/Penlight/blob/master/lua/pl/tablex.lua#L154-L64)
-- ((doc)[http://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#deepcompare])
-- from [Penlight: pl.tablex.lua](http://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html).
-- @param a any type of object
-- @param b any type of object
-- @tparam[opt=false] boolean useMt indicator for whether to include the meta table
-- @treturn boolean result of comparison
function util.deepEqual( a, b, useMt )
	local typeEqual = util.isTypeEqual( a, b )
	if typeEqual ~= nil then
		return typeEqual
	end

	if useMt then
		local metaEqual = util.isMetatableEqual( a, b )
		if metaEqual ~= nil then
			return metaEqual
		end
	end

	if util.size( a ) ~= util.size( b ) then
		return false
	end

	for i,v1 in pairs( a ) do
		local v2 = b[i]
		if v2 == nil or not util.deepEqual( v1, v2, useMt ) then
			return false
		end
	end

	for i,_ in pairs( b ) do
		local v = a[i]
		if v == nil then
			return false
		end
	end

	return true
end
util.deepequal = util.deepEqual
util.deep_equal = util.deepEqual
util.deepCompare = util.deepEqual
util.deepcompare = util.deepEqual
util.deep_compare = util.deepEqual
util.isEqual = util.deepEqual
util.isequal = util.deepEqual
util.is_equal = util.deepEqual

--- Checks if a table include the arg.
-- Simplified variant of
-- ['include()'](https://github.com/Yonaba/Moses/blob/master/moses.lua#L526-L541)
-- ((doc)[http://yonaba.github.io/Moses/doc/#include])
-- from [Yonaba: Moses](http://yonaba.github.io/Moses/).
-- Simplified variant (defunc) of
-- ['include()'](https://github.com/mirven/underscore.lua/blob/master/lib/underscore.lua#L150-L155)
-- ((doc)[https://mirven.github.io/underscore.lua/#include])
-- from [mirven: Underscore.lua](https://mirven.github.io/underscore.lua/).
-- Approximation of
-- ['contains()'](https://github.com/jashkenas/underscore/blob/master/underscore.js#L291-L297)
-- ((doc)(https://underscorejs.org/#contains))
-- from [jashkenas: Underscore.js](https://underscorejs.org/)
-- @tparam table t searched for the arg
-- @param arg any item to be searched for
-- @treturn boolean result of the operation
function util.include( t, arg )
	-- inlined code from '_.toBoolean' and '_.detect' from "Moses"
	local cmp = ( type( arg ) == 'function' ) and arg or util.deepEqual
	for k,v in pairs( t ) do
		if cmp( v, arg ) then
			return k
		end
	end
	return false
end
util.within = util.include
util.contain = util.include
util.contains = util.include

-- return the export table
return util
