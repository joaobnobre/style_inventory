local function UpdateChest()
    local content, weight = API.OpenChest(chestIndex)
    content = BuildInventory(content)
    SendReactMessage('frontType', 'aside')
    SendReactMessage('frontMode', 'aside')
    SendReactMessage('showHeader', true)

    SendReactMessage('resetAside')
    SendReactMessage('updateAside', {
        itens = content,
        infos = {
            max = chests[chestIndex].weight,
            current = weight,
            name = chests[chestIndex].name,
            type = 'chest'
        }
    })
end

RegisterNetEvent('aside:updateChest', UpdateChest)

local function GetDistance()
    for k, v in pairs(chests) do
        local distance = #(GetEntityCoords(PlayerPedId()) - v.cds)
        if distance <= 5 then
            chestIndex = k
        end
    end
end

local helper = {}
Citizen.CreateThread(function()
    while true do
        local idle = 1000
        if not chestIndex then
            GetDistance()
        else
            idle = 1
            local dist = #(GetEntityCoords(PlayerPedId()) - chests[chestIndex].cds)
            if dist <= 5 then
                if not helper[chestIndex] then
                    TriggerEvent("snt/registerTextHelper",
                        {chests[chestIndex].cds.x, chests[chestIndex].cds.y, chests[chestIndex].cds.z}, "E",
                        "Acessar bau", 1.5)
                    helper[chestIndex] = true
                end
                DrawMarker(23, chests[chestIndex].cds.x, chests[chestIndex].cds.y, chests[chestIndex].cds.z - 0.98, 0,
                    0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 0, 50, 150, 155, 0, 0, 0, 0)
                if IsControlJustPressed(0, 38) and dist <= 1.5 and not LocalPlayer["state"].Cancel and
                    API.hasPermission('chest', chestIndex) then
                    asideType = 'chest'
                    -- OpenInventory()
                    UpdateInventory()
                    TriggerEvent('aside:updateChest')
                    toggleNuiFrame(true)
                end
            end
            if dist > 1.5 and helper[chestIndex] then
                helper[chestIndex] = nil
            end
            if dist > 5 then
                chestIndex = nil
            end
        end
        Wait(idle)
    end
end)

RegisterNetEvent("inventory/openResidenceChest")
AddEventHandler("inventory/openResidenceChest", function(chestName, chestWeight, webhook, coords)
    chests[chestName] = {
        name = chestName,
        permission = "",
        weight = chestWeight,
        cds = vector3(coords[1], coords[2], coords[3]),
        webhook = {webhook}
    }
    if not LocalPlayer["state"].Cancel then
        chestIndex = chestName
        asideType = 'chest'
        UpdateInventory()
        TriggerEvent('aside:updateChest')
        toggleNuiFrame(true)
    end
end)
