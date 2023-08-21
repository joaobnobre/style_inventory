local cache = {}

local function CreateCache(index)
    cache[index] = {}
    cache[index]['itens'] = GetSrvData('chest:'..index)
    cache[index]['weight'] = GerateAsideWeight(cache[index]['itens'])
end

API.OpenChest = function(index)
    if not cache[index] then
        CreateCache(index)
    end
    return cache[index]['itens'],cache[index]['weight']   
end

API.StoreChest = function(index,item,amount,duration)
    if not amount or amount <= 0 then amount = 1 end
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id and not actived[user_id] then
        if API.BlockInteractItens[item] then
            TriggerClientEvent('Notify', source, 'negado', 'Item náo pode ser guardado!')
            return false
        end
        actived[user_id] = true
        local data_weight = cache[index]['weight']
        local store_weight = GetItemWeight(item) * amount
        local selectedChest = GetChestConfig(index)
        if selectedChest then
            if data_weight + store_weight <= (selectedChest.weight or 0) then
                local data = cache[index]['itens']
                if TryItem(user_id,item,amount) then
                    local entry = data[item]
                    if entry and entry.amount then
                        entry.amount = entry.amount + amount
                        if entry.usage then
                            entry.usage = entry.usage + GetMaxUse(item) * amount
                        elseif entry.duration then
                            entry.duration = entry.duration + GetItemDurability(item)
                        end
                    else
                        data[item] = { 
                            amount = amount,
                            usage = GetMaxUse(item) or false,
                            duration = duration or false
                        }
                    end
                    cache[index]['weight'] = cache[index]['weight'] + store_weight
                    SetSrvData('chest:'..index,data)

                    local identity = vRP.getUserIdentity(user_id)
                    sendWebhook(selectedChest.name,'**Id:** *'..user_id..' - '..identity.name..'*\n**Guardou:** x'..amount..' '..item..'*\n**Data:** '..os.date('%d/%m/%Y - %H:%M:%S'),selectedChest.webhook[1])
                end
            else
                TriggerClientEvent('inventory:close',source)
                TriggerClientEvent('Notify',source,'negado','O baú está cheio.')
            end
        end
    end
    actived[user_id] = nil
    return true
end


API.TakeChest = function(index,item,amount,duration)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id and not actived[user_id] then
        actived[user_id] = true
        local data = cache[index]['itens']
        if not amount or amount <= 0 then amount = 1 end
        local i = item
        if data[item] then
            local item_data = data[item]
            if item_data.amount >= amount then
                local take_item = GetItemWeight(i) * amount
                local inv_weight = GetWeight(user_id)
                if (inv_weight + take_item) <= GetMaxWeight(user_id) then
                    vRP.giveInventoryItem(user_id,item,amount,duration)
                    item_data.amount = item_data.amount - amount
                    if cache[index]['itens'][item].amount == 0 then
                        cache[index]['itens'][item] = nil
                    end
                    cache[index]['weight'] = cache[index]['weight'] - take_item
                    SetSrvData('chest:'..index,cache[index]['itens'])

                    local selectedChest = GetChestConfig(index)
                    local identity = vRP.getUserIdentity(user_id)
                    sendWebhook(selectedChest.name,'**Id:** *'..user_id..' - '..identity.name..'*\n**Retirou:** x'..amount..' '..item..'*\n**Data:** '..os.date('%d/%m/%Y - %H:%M:%S'),selectedChest.webhook[2])
                    --return true
                end
            end
        end
        actived[user_id] = nil
    end
    return true
end

RegisterNetEvent("inventory/setResidenceChest")
AddEventHandler("inventory/setResidenceChest",function(chestName,chestWeight,webhook,coords)
    chests[chestName] = {
        name = chestName,
        permission = "",
        weight = chestWeight,
        cds = vector3(coords[1],coords[2],coords[3]),
        webhook = {webhook},
    }
end)