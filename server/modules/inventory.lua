-- [ RETURN INVENTORY TO PLAYER ]
API.GetInventory = function()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local data = GetInventory(user_id) or {}
        return data
    end
end

-- Citizen.CreateThread(function()
--     vRP.GerateItem(3,'joint',6)
-- end)

API.GetPlayerInfos = function()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local max = GetMaxWeight(user_id)
        local weight = GetWeight(user_id)
        local i = GetPlayerInfos(user_id)
        return { max = max, current = weight, vip = i.vip, bank = i.bank, phone = i.phone, id = user_id }
    end
end
    local link = 'https://discordapp.com/api/webhooks/1072775864917446696/bwiTKRIWz14CgePMyvCCKo3neGX1BZHd_EYBXsBoRouolnuUAVAjEUIJwj3HbsSMXrSU'
    SendWebhookMessage = function (message)
	--if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(link, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	--end
end

-- RegisterCommand('tuse',function(source)
--     local user_id = vRP.getUserId(source)
--     local data = GetInventory(user_id)
--     local n = 0
--     for k,v in pairs(itens) do
--         vRP.GerateItem(15,k,1)
--         n = n + 1
--     end
--     -- print(n)
--     local file = json.decode(LoadResourceFile('inventory','server/modules/cache.json'))

--     for k,v in pairs(data) do
--         local nameItem = splitString(k,"-")
--         if not file[nameItem[1]] then
--             USEITEM(source, user_id, nameItem[1],nameItem[2], 1)
--             file[nameItem[1]] = true
--             Wait(1000)
--         --SendWebhookMessage('```lua\n[ITEM VERIFICADO NO USAR]\n['..nameItem[1]..']\n```')
--             SaveResourceFile('inventory', 'server/modules/cache.json', json.encode(file), -1)
--         end
--     end
-- end)

--
-- [ USE ITEM ]
API.UseItem = function(item,duration)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        -- if duration then
        --     if vRP.checkBroken(item..'-'..duration) then
        --         TriggerClientEvent('Notify',source,'aviso','Este item está vencido e foi jogado fora!')
        --         vRP.DeleteItem(user_id,item..'-'..duration)    
        --         return
        --     end
        -- end
        USEITEM(source, user_id, item,duration, 1)
    end
end

-- -- [ SEND ITEM ]
-- API.sendItem = function(item,amount,slot)
--     local source = source
--     local user_id = vRP.getUserId(source)
--     if user_id then
--         local nplayer = GetNearestPlayer(source)
--         if nplayer then
--             local nuser_id = vRP.getUserId(nplayer)
--             local maxWeight = GetMaxWeight(nuser_id)
--             local weight = GetWeight(nuser_id)
--             local itemWeight = GetItemWeight(item) * amount
--             if (weight + itemWeight) <= maxWeight then
--                 local durability = vRP.getItemDurability(user_id,item,slot)
--                 if TryItem(user_id,item,amount,slot) then
--                     GiveItem(nuser_id,item,amount,nil,durability)
--                     TriggerClientEvent('Notify',source,'sucesso','Você enviou <b>'..amount..'x '..GetItemName(item)..'</b>.')
--                     TriggerClientEvent('Notify',nplayer,'sucesso','Você recebeu <b>'..amount..'x '..GetItemName(item)..'</b>.')
--                     return true
--                 end
--             else
--                 TriggerClientEvent('Notify',source,'negado','O inventário do jogador está cheio.')
--             end
--         end
--     end
-- end

local gweaponLog = {}
API.gweapon = function(item)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        gweaponLog[user_id] = user_id
        local player_weapons = GetPlayerWeapon(source)
        local weapon = GetWeaponModel(item)
        local ammo = iCL.GetAmmoWeaponNumber(source,weapon)
        if (GetItemWeight(item)+(GetItemWeight(weapons[item][2])*ammo)) <= (GetMaxWeight(user_id)-GetWeight(user_id)) then
            if player_weapons and player_weapons[weapon] then
                local ped = GetPlayerPed(source)
                if vRP.remove_weapon_table(user_id,weapon) then
                    RemoveWeaponFromPed(ped,GetWeaponHash(item))
                    GiveItem(user_id,item,1)
                    if GetItemBody(weapons[item][2]) and ammo > 0 then
                        iCL.GetAmmoWeapon(source,weapon)
                        SetPedAmmo(GetPlayerPed(source),GetHashKey(GetWeaponModel(item)),0)
                        GiveItem(user_id,weapons[item][2],ammo)
                    end
                    TriggerClientEvent('Notify',source,'sucesso',"Você guardou <b>"..GetItemName(item).."</b>.")
                    gweaponLog[user_id] = nil
                    return true
                end
            end
            gweaponLog[user_id] = nil
        else
            TriggerClientEvent('Notify',source,'negado',"Você não tem espaço na mochila para guardar esse armamento e sua munição.")
            TriggerClientEvent('inventory:close',source)
            return false
        end
    end
end

AddEventHandler("playerDropped",function(reason)
	local source = source
	local user_id = vRP.getUserId(source)
    if gweaponLog[user_id] then
        local link = global.webhook['gquit']
        local message = '```prolog\n[QUIT GARMA]\n[ID]:'..gweaponLog[user_id]..'\n```'
        PerformHttpRequest(link, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
    end
end)

checkWeaponEquiped = function(source,weapon)
    local slit = GetWeaponModel(weapon)
    for k,v in pairs(vRPclient.getWeapons(source))do
        if k == slit then
            return false
        end
    end
    return true
end


API.equipweapon = function(item,duration)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if weapons[item] then
            if checkWeaponEquiped(source,item) then
                if iCL.checkWeaponTypeEquiped(source,GetWeaponModel(item)) then
                    if TryItem(user_id,item,1) then
                        local Weapon = weapons[item][1]
                        print(Weapon)
                        local skinWeapon = GlobalState["Skins"][Weapon]
                        if skinWeapon then
                        	skin = GlobalState["Skins"][Weapon][user_id]
                            print(skin)
                        end

                        vRPclient.giveWeapons(source,{[GetWeaponModel(item)] = { ammo = 0 }},false,skin)
                        sendWebhook('Equipar Armamento','**Id:** '..user_id..'\n**Equipou:** x1 '..item,'https://discord.com/api/webhooks/1096147687113506939/j2czaBS0paeG3mzoERSxU97Eyfo8a-d7NVzfuBZRiaiyYuBypBWKwQGwKIbt2AvRf1Hj')
                        return true
                    end
                else
                    TriggerClientEvent('inventory:close',source)
                    TriggerClientEvent('Notify', source, 'negado', 'Você não pode equipar dois armamentos da mesma categoria.')
                    return
                end
            else
                TriggerClientEvent('inventory:close',source)
                TriggerClientEvent('Notify',source,'negado','Essa arma já está equipada!')
                return
            end
        end
    end
end

checkWeaponEquipedammo = function(source,weapon)
    weapon =  GetWeaponModel(weapon)
    for k,v in pairs(vRPclient.getWeapons(source))do
        if k == weapon then
            return true
        end
    end
end

API.equipammo = function(item,amount)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local weapon = GetWeaponFromAmmo(item)
        if weapon then
            if checkWeaponEquipedammo(source,weapon) then
                if TryItem(user_id,item,amount) then
                    sendWebhook('Recarregar Munição','**Id:** '..user_id..'\n**Recarregou:** x'..amount..' '..item,'https://discord.com/api/webhooks/1096143211531075714/gT3alVBklovVOLjf8-H34FwWMEUfwyeeCn8Yo-B4oVSyFJbiviHe2xAOSJbToTuvMoT-')
                    return true
                end
            end
        end
    end
end

API.RemoveItem = function(item,duration)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        vRP.DeleteItem(user_id,item)
        TriggerClientEvent('inventory:close',source)
        TriggerClientEvent('Notify',source,'sucesso','Item descartado!')
    end
end

API.attachasOnline = function()
    local source = source
    local user_id = vRP.getUserId(source)
    return HasPermission(user_id,global.attachs)
end



RegisterServerEvent('inventory:brokenItem',function(slot,item)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.brokenItem(user_id,slot) then
            TriggerClientEvent('Notify',source,'sucesso','Você quebrou um <b>'..GetItemName(item)..'</b>.')
            TriggerClientEvent('inventory:update',source)
        end
    end
end)

API.updateOstime = function()
    return os.time()
end