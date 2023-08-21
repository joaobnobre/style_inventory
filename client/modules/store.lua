local open_stores = {}

iCL.returnOpenStores = function()
    return open_stores
end

local function GetStoreItens(index)
    local content = {}
    for k,v in pairs(stores[index].itens) do
        if itens[k] then
            content[k] = {
                ['image'] = GetItemImage(k),
                ['weight'] = itens[k]['buyableItem'][2],
                ['name'] = GetItemName(k),
                ['key'] = k,
                ['amount'] = itens[k]['buyableItem'][3],
            }
        end
    end
    return content
end

local function UpdateStore()
    local content = GetStoreItens(open_stores[storeIndex].index)
    SendReactMessage('frontType', 'aside')
    SendReactMessage('resetAside')
    SendReactMessage('showHeader',true)

    SendReactMessage('updateAside', {
        itens = content,
        infos = { 
            max =  0, 
            current = weight,
            name = open_stores[storeIndex].name,
            type = 'store'
        },
    })
end

Citizen.CreateThread(function()
    for k,v in pairs(stores) do
        for _,cds in pairs(v.cds) do
            table.insert(open_stores, {permissions = v.permissions,cds = cds, index = k,name = v.name, webhook = {v.webhook[1],v.webhook[2]}})
        end
    end
end)

local function GetDistance()
    for k,v in pairs(open_stores) do
        local distance = #(GetEntityCoords(PlayerPedId()) - v.cds)
        if distance <= 5 then
            storeIndex = k
            storeKey = v.index
        end
    end
end

local helper = {}
Citizen.CreateThread(function()
    while true do
        local idle = 1000
        for k,v in pairs(open_stores) do
            idle = 1
            local dist = #(GetEntityCoords(PlayerPedId()) - open_stores[k].cds)
            if dist <= 5 then
                if not helper[k] then
                    TriggerEvent("snt/registerTextHelper",{open_stores[k].cds.x,open_stores[k].cds.y,open_stores[k].cds.z},"E","Acessar loja",1.5)
                    helper[k] = true
                end
			    DrawMarker(23,open_stores[k].cds.x,open_stores[k].cds.y,open_stores[k].cds.z-0.98,0,0,0,0,0,0,0.8,0.8,0.8,0,50,150,155,0,0,0,0)
                if IsControlJustPressed(0,38) and dist <= 2.0 and not LocalPlayer["state"].Cancel then
                    storeKey = v.index
                    storeIndex = k
                    if open_stores[k].permissions[1] then
                        if API.checkStorePermissions(open_stores[k].permissions) then
                            asideType = 'store'
                            OpenInventory()
                            UpdateStore()
                            toggleNuiFrame(true)
                        end
                    else
                        asideType = 'store'
                        OpenInventory()
                        UpdateStore()
                        toggleNuiFrame(true)
                    end
                    
                end
            end
            if dist > 1.5 and helper[k] then
                helper[k] = nil
            end
        end
        
        Wait(idle)
    end
end)