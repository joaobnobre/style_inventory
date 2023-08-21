local props = global.binProps
local drops = {}

local entitybucket = 0

iCL.RegisterDrop = function(content)
    drops[tostring(content.id)] = content
    local id = content.prop_id
    while not NetworkDoesNetworkIdExist(id) do
        Wait(1)
    end
    local net = NetToEnt(id)
    if DoesEntityExist(net) then
        PlaceObjectOnGroundProperly(net)
        SetEntityCollision(net,false,false)
    end
end

iCL.RemoveDrop = function(id)
    drops[tostring(id)] = nil
end

CreateThread(function()
    while true do
        local idle = 5000
        entitybucket = API.getentitydimension()
        Wait(idle)
    end
end)

local cooldown = 0

CreateThread(function()
    while true do
        local idle = 500
        local pCoord = GetEntityCoords(PlayerPedId())
        for k,v in next,drops do
            if entitybucket == tonumber(v.dimension) then
                if v.coords then
                    local distance = #(pCoord - v.coords)
                    if distance <= 1.5 then 
                        idle = 1
                        DrawText3D(v.coords,v.name.."~w~ - "..v.amount)
                        if distance <= 1.2 and IsControlJustPressed(0,38) and cooldown == 0 then
                            cooldown = 2
                            API.TakeDrop(v.id)
                        end
                    end
                end
            end
        end
        Wait(idle)
    end
end)

CreateThread(function()
    while true do
        if cooldown > 0 then
            cooldown = cooldown -1 
        end
        Wait(1000)
    end
end)

function DrawText3D(vec, text)
    local onScreen,_x,_y=World3dToScreen2d(vec.x,vec.y,vec.z-0.7)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

-- Citizen.CreateThread(function()
--     while true do
--         Wait(5000)
--     end
-- end)

-- GetDropsInArea = function()
--     local tbl = {}
--     local n = 0
--     local pcds = GetEntityCoords(PlayerPedId())
--     for k,v in pairs(drops) do
--         if #(pcds - v.coords) <= 5 then
--             n = n + 1
--             v.slot = n
--             table.insert(tbl,v)
--         end
--     end
--     return tbl
-- end

local function GetNearestBin()
    local ped = PlayerPedId()
    local cds = GetEntityCoords(ped)
    for k,v in pairs(props) do
        local obj = GetClosestObjectOfType(cds,2.0,v, false,false,false)
        if obj ~= 0 then
            local distance = #(cds - GetEntityCoords(obj))
            if distance <= 2 then
                return true
            end
        end
    end
end

RegisterNUICallback('removeItem',function(data,cb)
    local item,amount,duration,usage = data.key,data.amount,tonumber(data.duration),data.usage
    local ostime = API.updateOstime()
    if duration and ostime and ostime >= duration then
        API.RemoveItem(item,duration)
        UpdateInventory()
        -- if GetNearestBin() then
        --     API.RemoveItem(item,duration)
        --     UpdateInventory()
        -- else
        --     TriggerEvent('Notify','negado','Você precisa estar proximo a uma lixeira')
        -- end
    else
        if API.CreateDrop(item,amount,duration,usage) then
            UpdateInventory()
        end
    end
    cb({})
end)

CreateThread(function()
    -- for k,v in pairs(props) do
    --     print(v)
    -- end
end)