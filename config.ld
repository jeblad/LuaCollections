project = 'LuaCollections'
title = 'LuaCollections documentation'
description = 'Collections for Lua code embedded within Mediawiki.'
use_markdown_titles = true
format = 'markdown'
dir = 'docs'
--output = 'mw.collections'
-- all = true

readme = {
	-- 'topics/collections.md',
	'topics/introduction.md',
	'topics/vagrant.md',
	-- 'topics/databases.md',
	-- 'topics/delayed.md',
	-- 'topics/hello-world.md',
	-- 'topics/translatewiki.md',
	'topics/vscode.md',
	'CONTRIBUTING.md',
	'CODE_OF_CONDUCT.md',
	'SECURITY.md',
	'TRANSLATING.md'
}

examples = {
	'examples'
}

-- new_type( 'macro', 'Macros' )
custom_tags = {
	{
		'nick',
		title = 'Nicknames',
		hidden = false,
		format = nil
	},
}

custom_display_name_handler = function(item, default_handler)
	-- show a label beside functions tagged with @delayed.
	if item.type == 'lfunction' or item.type == 'function' then
		return item.name .. ' ()'
	end
	return default_handler(item)
end
