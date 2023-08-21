RegisterNetEvent('round6:inGame', function(bool)
	inRound6 = bool
end)

_RegisterCommand = RegisterCommand
function RegisterCommand(command, callback)
    _RegisterCommand(command, function(...)
        if not LocalPlayer.state.inRoyale and not inRound6 and not LocalPlayer.state.inPvp then
            return callback(...)
        end
    end)
end

_IsControlJustPressed = IsControlJustPressed
function IsControlJustPressed(...)
    if LocalPlayer.state.inRoyale or inRound6 or LocalPlayer.state.inPvp then
        return false
    else
        return _IsControlJustPressed(...)
    end
end

local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
vRP = Proxy.getInterface('vRP')
vRPC = Tunnel.getInterface('vRP')

API = Tunnel.getInterface('inventory')
iCL = {}
Tunnel.bindInterface('inventory',iCL)



-- Type of aside
asideType = nil

cache = {}

-- Index opened chest
chestIndex = nil

-- Store index
storeIndex = nil
storeKey = nil

-- Craft index
craftIndex = nil

--Trade
inTrade = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBAL FUNCTIONS INVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function BuildInventory(Object)
    for k,v in pairs(Object) do
        Object[k]['image'] = GetItemImage(k)
        Object[k]['weight'] = GetItemWeight(k)
        Object[k]['name'] = GetItemName(k)
        Object[k]['key'] = k
        Object[k]['type'] = GetItemType(k)
    end
    return Object
end
-- function BuildInventory(Object)
--     for k,v in pairs(Object) do
--         local nameItem = splitString(k,"-")
--         local item,duration = nameItem[1],nameItem[2]
--         if item and GetItemBody(item) then
--             Object[k]['image'] = GetItemImage(item)
--             Object[k]['weight'] = GetItemWeight(item)
--             Object[k]['name'] = GetItemName(item)
--             Object[k]['key'] = item
--             Object[k]['type'] = GetItemType(item)
--             Object[k]['duration'] = tonumber(duration) or nil
--         end
--     end
--     return Object
-- end



function UpdateInventory()
    local data = API.GetInventory()
    data = BuildInventory(data)
    SendReactMessage('resetInventory')
    SendReactMessage('updateInventory',data)
    UpdateWeapon()
    UpdatePlayerInfos()
    SendReactMessage('updateHotBar', HOTBAR)
end

function UpdatePlayerInfos()
    local infos = API.GetPlayerInfos()
    SendReactMessage('updatePlayerInfos',infos)
end

function UpdateWeapon()
    local player = PlayerPedId()
	local myweapons = {}
    for k,v in pairs(weapons) do
        local hash = GetHashKey(v[1])
        if HasPedGotWeapon(player,hash) then
            -- print(GetItemImage(k),GetItemName(k),GetAmmoInPedWeapon(player,hash))
            if GetWeaponModel(k) then
                table.insert(myweapons,{
                    key = k,
                    image = GetItemImage(k),
                    name = GetItemName(k),
                    maxAmmo = v[3],
                    ammo = GetAmmoInPedWeapon(player,hash)
                })
            end
        end
    end
    SendReactMessage('updateWeapon',myweapons)
end

function OpenInventory()
    UpdateInventory()
    SendReactMessage('frontType', 'inventory')
    SendReactMessage('showAttachs',API.attachasOnline())
    SendReactMessage('showInventoryHeader',true)
    SendReactMessage('showHeader',true)
    UpdatePlayerInfos()
    -- SendReactMessage('updateGround',GetDropsInArea())
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBAL FUNCTIONS ASIDE
-----------------------------------------------------------------------------------------------------------------------------------------
-- ATUALIZA O ASIDE ITENS/INFOS
function UpdateAside()
    if asideType == 'chest' then
        TriggerEvent('aside:updateChest')
    elseif asideType == 'trunk' then
        TriggerEvent('aside:updateTrunk')
    elseif asideType == 'homes' then
        TriggerEvent('aside:updateHomes')
    end
end

RegisterNUICallback('aside:store',function(data,cb)
    local item,amount,duration,itemAmount,usage = data.key,data.amount,data.duration,data.itemAmount,data.usage
    if itemAmount and itemAmount < amount and itemAmount > 0 then
        amount = itemAmount
    end
    if asideType == 'chest' then
        if API.StoreChest(chestIndex,item,tonumber(amount),duration,usage) then
            UpdateInventory()
            UpdateAside()
        end
    elseif asideType == 'trunk' then
        if API.StoreTrunk(cache.trunk,item,tonumber(amount),duration,usage) then
            UpdateInventory()
            UpdateAside()
        end
    elseif asideType == 'store' then
        if API.SellItem(storeKey,item,tonumber(amount),storeIndex) then
            UpdateInventory()
        end
    elseif asideType == 'homes' then
        local data = API.StoreHomes(cache.home['index'],item,tonumber(amount),duration,usage)
        if data then
            UpdateInventory()
            TriggerEvent('aside:updateHomes',data)
        end
    end
    cb('ok')
end)

RegisterNUICallback('aside:take',function(data,cb)
    local item,amount,duration,itemAmount,usage = data.key,data.amount,data.duration,data.itemAmount,data.usage
    if itemAmount and itemAmount < amount and itemAmount > 0 then
        amount = itemAmount
    end
    if asideType == 'chest' then
        if API.TakeChest(chestIndex,item,tonumber(amount),duration,usage) then
            UpdateInventory()
            UpdateAside()
        end
    elseif asideType == 'trunk' then
        if API.TakeTrunk(cache.trunk,item,tonumber(amount),duration) then
            UpdateInventory()
            UpdateAside()
        end
    elseif asideType == 'store' then
        if API.BuyItem(item,storeIndex) then
            UpdateInventory()
            UpdatePlayerInfos()
        end
    elseif asideType == 'homes' then
        local data = API.TakeHomes(cache.home['index'],item,tonumber(amount),duration,usage)
        if data then
            UpdateInventory()
            TriggerEvent('aside:updateHomes',data)
        end
    elseif asideType == 'roubar' or asideType == 'apreender' then
        local Status,Data,Object = API.TakePlayer(item,tonumber(amount),duration,asideType)
        if Status then
            UpdateInventory()
            TriggerEvent('aside:player',Data,Object)
        end
        -- if API.TakePlayer(item,tonumber(amount),duration) then
        --     UpdateInventory()
        --     TriggerEvent('aside:player')
        -- end
    end
    cb('ok')

end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBAL FUNCTIONS HOTBAR
-----------------------------------------------------------------------------------------------------------------------------------------
HOTBAR = {}
local Cooldown = 0

function UseItem(bind)
    if Cooldown == 0 then
        Cooldown = 15
        API.UseItem(HOTBAR[bind].key)
    end
end

-- nuiShowing = false

Citizen.CreateThread(function()
    --RemoveAllPedWeapons(PlayerPedId(),true)
    -- GiveWeaponToPed(PlayerPedId(),GetHashKey('WEAPON_PISTOL_MK2'),200,false,true)
    --- vRP.giveWeapons({['WEAPON_PISTOL_MK2'] = { ammo = 250 }})
    while true do
        -- print(MumbleIsConnected())
        -- print(NetworkIsCableConnected())
        if Cooldown > 0 then
            Cooldown = Cooldown - 1
        end
        Wait(1000)
    end
end)