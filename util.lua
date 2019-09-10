--- Utils to support Expect.
-- @module util
-- @author John Erling Blad < jeblad@gmail.com >

-- @var Table holding the modules exported members
local util = {}

--- Raw count of all the items in the provided table.
-- Variant of
-- ['count()'](https://github.com/Yonaba/Moses/blob/master/moses.lua#L308-L322)
-- from [Yonaba/Moses](https://github.com/Yonaba/Moses).
-- @tparam table t has its entries counted
-- @treturn number raw entries
function util.count( t )
	local i = 0
	for _,_ in pairs( t ) do
		i = i + 1
	end
	return i
end

--- Size based on the raw count.
-- Variant of
-- ['size()'](https://github.com/Yonaba/Moses/blob/master/moses.lua#L802-L813)
-- from [Yonaba/Moses](https://github.com/Yonaba/Moses).
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
-- Variant of
-- ['isEqual()'](https://github.com/Yonaba/Moses/blob/master/moses.lua#L2775-L2815)
-- from [Yonaba/Moses](https://github.com/Yonaba/Moses).
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

--- Checks if a table contains the arg.
-- Variant of
-- ['includes()'](https://github.com/Yonaba/Moses/blob/master/moses.lua#L526-L541)
-- from [Yonaba/Moses](https://github.com/Yonaba/Moses).
-- @tparam table t searched for the arg
-- @param arg any item to be searched for
-- @treturn boolean result of the operation
function util.contains( t, arg )
	-- inlined code from '_.toBoolean' and '_.detect' from "Moses"
	local cmp = ( type( arg ) == 'function' ) and arg or util.deepEqual
	for k,v in pairs( t ) do
		if cmp( v, arg ) then
			return k
		end
	end
	return false
end

-- return the export table
return util
