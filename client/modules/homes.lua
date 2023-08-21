cache.home = {}

local function UpdateHomes(Object,opened)
    cache.home['index'] = Object['index']
    local content = Object['data']
    content = BuildInventory(content)
    SendReactMessage('frontType', 'aside')
    SendReactMessage('frontMode', 'aside')
    SendReactMessage('resetAside')
    SendReactMessage('showHeader',true)

    SendReactMessage('updateAside', {
        itens = content,
        infos = { 
            max =  Object['weight']['max'], 
            current = Object['weight']['current'],
            name = Object['name'],
            type = 'homes'
        },
    })
    asideType = 'homes'
    UpdateInventory()
    if opened then
        toggleNuiFrame(true)
    end
end

RegisterNetEvent('aside:updateHomes',UpdateHomes)
