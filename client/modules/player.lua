iCL.openRevistar = function(Data,Object)
    Data = BuildInventory(Data)
    SendReactMessage('frontType', 'aside')
    SendReactMessage('frontMode', 'aside')
    SendReactMessage('showHeader',true)

    SendReactMessage('resetAside')
    SendReactMessage('updateAside', {
        itens = Data,
        infos = { 
            max =  Object['max'], 
            current = Object['current'],
            name = Object['name'],
            text = 'Revistando',
            type = 'revistar'
        },
        -- asideType = 'revistar'
    })
    asideType = 'revistar'
    UpdateInventory()
    toggleNuiFrame(true)
end

iCL.openRoubar = function(Data,Object)
    Data = BuildInventory(Data)
    SendReactMessage('frontType', 'aside')
    SendReactMessage('frontMode', 'aside')
    SendReactMessage('showHeader',true)

    SendReactMessage('resetAside')
    SendReactMessage('updateAside', {
        itens = Data,
        infos = { 
            max =  Object['max'], 
            current = Object['current'],
            name = Object['name'],
            text = 'Roubando',
            type = 'roubar'
        },
        -- asideType = 'roubar'
    })
    asideType = 'roubar'
    UpdateInventory()
    toggleNuiFrame(true)
end

iCL.openApreender = function(Data,Object)
    Data = BuildInventory(Data)
    SendReactMessage('frontType', 'aside')
    SendReactMessage('frontMode', 'aside')
    SendReactMessage('showHeader',true)

    SendReactMessage('resetAside')
    SendReactMessage('updateAside', {
        itens = Data,
        infos = { 
            max =  Object['max'], 
            current = Object['current'],
            name = Object['name'],
            text = 'Apreendendo',
            type = 'apreender'
        },
        -- asideType = 'apreender'
    })
    asideType = 'apreender'
    UpdateInventory()
    toggleNuiFrame(true)
end

local txt = {
    ['roubar'] = 'Roubando',
    ['apreender'] = 'Apreendendo',
    ['revistar'] = 'Revistando'
}

function UpdateInspect(Data,Object)
    Data = BuildInventory(Data)
    SendReactMessage('resetAside')
    SendReactMessage('updateAside', {
        itens = Data,
        infos = { 
            max =  Object['max'], 
            current = Object['current'],
            name = Object['name'],
            text = txt[asideType],
            type = asideType
        },
        -- asideType = asideType
    })
end

RegisterNetEvent('aside:player',UpdateInspect)
