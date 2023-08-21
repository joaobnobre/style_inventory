local groups = {}
LocalPlayer['state']:set('inCraft',false,true)

Citizen.CreateThread(function()
    for k,v in pairs(craft) do
        for _,group in pairs(v.groups) do
            if not groups[group] then
                groups[group] = {
                    [k] = true
                }
            end
            if not groups[group][k] then
                groups[group][k] = true
            end
        end
    end
end)

local function CreateReceitas(group)
    if group then
        if groups[group] then
            local receitas = {}
            for k,v in next,groups[group] do
                table.insert(receitas,{
                    name = GetItemName(craft[k].item),
                    item = k,
                    image = GetItemImage(craft[k].item),
                    avaliable = false
                })
            end
            return receitas
        end
    end
end

RegisterNUICallback('GetItemCraft',function(data,cb)
    local item = craft[data.item]
    local config = {
        item = { time = craft[data.item].time, name = GetItemName(item.item), image = GetItemImage(item.item), item = item.item, avaliable = false },
        receita = item.receita,
    }
    cb(config)
end)

local function GetDistance()
    for k,v in pairs(open_craft) do
        local dist = #(GetEntityCoords(PlayerPedId()) - v)
        if dist <= 5 then
            craftIndex = k
        end
    end
end

CreateThread(function()
    while true do
        local idle = 1000
        if not craftIndex then
            GetDistance()
        else
            idle = 1
            local dist = #(GetEntityCoords(PlayerPedId()) - open_craft[craftIndex])
            if dist <= 5 then
			    DrawMarker(23,open_craft[craftIndex].x,open_craft[craftIndex].y,open_craft[craftIndex].z-0.98,0,0,0,0,0,0,0.8,0.8,0.8,0,50,150,155,0,0,0,0)
                if IsControlJustPressed(0,38) and dist <= 1.5 and not LocalPlayer["state"].Cancel and API.hasPermission('craft',craftIndex) then
                    asideType = 'craft'
                    UpdateInventory()
                    SendReactMessage('frontType', 'craft')
                    SendReactMessage('frontMode', 'craft')
                    SendReactMessage('showInventoryHeader',false)
                
                    SendReactMessage('setReceitas', CreateReceitas(craftIndex))
                    toggleNuiFrame(true)
                end
            end
            if dist > 5 then
                craftIndex = nil
            end
        end
        Wait(idle)
    end
end)

RegisterNUICallback('craft:createItem',function(data,cb)
    local item = data.item
    if item then
        if API.CraftItem(item,craftIndex) and not LocalPlayer["state"]['inCraft'] then
            LocalPlayer["state"]['inCraft'] = true
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterNUICallback('craft:update',function(data,cb)
    UpdateInventory()
    SendReactMessage('setReceitas', CreateReceitas(craftIndex))
    LocalPlayer["state"]['inCraft'] = false
    cb('')
end)

