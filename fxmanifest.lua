 fx_version "bodacious"
lua54 'yes'

games {
  "gta5"
}

ui_page 'web/build/index.html'

client_scripts {
    '@vrp/lib/utils.lua',
    'config/itens.lua',
    'lib/itens.lua',
    'lib/weapons.lua',
    'config/chests.lua',
    'config/store.lua',
    'config/craft.lua',
    'config/global.lua',
    'client/*.lua',
    'client/modules/*.lua',
}

server_scripts {
    '@vrp/lib/utils.lua',
    'config/itens.lua',
    'config/chests.lua',
    'config/store.lua',
    'lib/*.lua',
    'config/craft.lua',
    'config/global.lua',
    'server/*.lua',
    'server/modules/*.lua',
    -- 'server/modules/cache.txt',
}


files {
	'web/build/index.html',
    'web/src/fonts/*.otf',
	'web/build/**/*',
}