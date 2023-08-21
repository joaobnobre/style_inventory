local homes_size = {}

function GetHomeMaxWeight(homeIndex,max,name)
    if not homes_size[homeIndex] then
        homes_size[homeIndex] = {homeIndex,max,name}
    end
    return homes_size[homeIndex][2]
end

RegisterNetEvent("heyyImob:server:requestChestOpen", function(data)
    local source = source
    TriggerEvent("inventory:openHome", source, data.chestName, { max = data.chestSize, name = data.chestName })
end)

RegisterServerEvent('inventory:openHome')
AddEventHandler('inventory:openHome',function(source,homeIndex,homeInfo)
    local Object = {}
    Object['data'] = GetSrvData("homes:"..homeIndex)
    Object['weight'] = {
        max = GetHomeMaxWeight(homeIndex,homeInfo['max'],homeInfo['name']),
        current = GerateAsideWeight(Object['data'])
    }
    Object['name'] = homeInfo['name']
    Object['index'] = homeIndex
    TriggerClientEvent('aside:updateHomes',source,Object,true)
end)

API.StoreHomes = function(homeIndex,item,amount,duration,usage)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id and not actived[user_id] then
        if API.BlockInteractItens[item] then
            TriggerClientEvent('Notify', source, 'negado', 'Item náo pode ser guardado!')
            return false
        end
        actived[user_id] = nil
        local data = GetSrvData("homes:"..homeIndex)
        if data then
            local home_weight = GerateAsideWeight(data)
            local store_item = GetItemWeight(item) * amount
            if (home_weight + store_item) <= homes_size[homeIndex][2] then
                if TryItem(user_id,item,amount,false)then
                    if data[item] then
                        data[item].amount = data[item].amount + amount
                        if data[item]['usage'] then
                            data[item]['usage'] = data[item]['usage'] + usage
                        elseif data[item]['duration'] then 
                            data[item]['duration'] =  data[item]['duration'] + GetItemDurability(item)
                        end
                    else
                        data[item] = {amount = amount, usage = usage or false,duration = duration or false}
                    end
                    SetSrvData("homes:"..homeIndex,data)
                    actived[user_id] = false

                    sendWebhook('Casa Guardar','**Id:** *'..user_id..'*\n**Item:** '..item..'.\n**Quantidade:** '..amount..'.\n**Casa:** '..homeIndex,'https://discord.com/api/webhooks/1096493047681925210/PD6RmdUoPX81APmJLUkCLCzo4mazOCDXckaC16ioUmz7w7rWM8aAY5ndmb-DawzZez2Q')
                    return {
                        ['index'] = homeIndex,
                        ['data'] = data,
                        ['weight'] = {
                            max = homes_size[homeIndex][2],
                            current = home_weight + store_item
                        },
                        ['name'] = homes_size[homeIndex][3]
                    }
                end
            else
                TriggerClientEvent('inventory:close',source)
                TriggerClientEvent('Notify',source,'negado','O bau não tem espaço para este item')
            end
        end
        active[user_id] = false
    end
end

API.TakeHomes = function(homeIndex,item,amount,duration,usage)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local data = GetSrvData("homes:"..homeIndex)
        local idname = item
        if duration then
            idname = item..'-'..duration
        end
        if data and data[item] and data[item].amount >= amount then
            local home_weight = GerateAsideWeight(data)
            local idata = data[item]

            if duration and duration <= os.time() then
                amount = idata.amount
                idata = nil
                SetSrvData("homes:"..homeIndex,data)
                TriggerClientEvent('Notify',source,'negado','Este item está vencido')
                GiveItem(user_id,item,amount,duration,usage)
                return {
                    ['index'] = homeIndex,
                    ['data'] = data,
                    ['weight'] = {
                        max = homes_size[homeIndex][2],
                        current = home_weight - GetItemWeight(item) * amount
                    },
                    ['name'] = homes_size[homeIndex][3]
                }
            end

            local take_item = GetItemWeight(item) * amount
            if (GetWeight(user_id) + take_item) <= GetMaxWeight(user_id) then
                idata.amount = idata.amount - amount
                if idata.usage then
                    idata.usage = idata.usage - (GetMaxUse(item)*amount)
                end
                if idata.amount == 0 then
                    data[item] = nil
                end
                SetSrvData("homes:"..homeIndex,data)
                GiveItem(user_id,item,amount,duration,usage)

                sendWebhook('Casa Pegar','**Id:** *'..user_id..'*\n**Item:** '..item..'.\n**Quantidade:** '..amount..'.\n**Casa:** '..homeIndex,'https://discord.com/api/webhooks/1096493247674716301/qo4Wm_Hh8mCZKp7Sum2TsZaS94AECp6C73bulem0fcEJTdlK9Cz3h4tOp5KRNuHA_WHA')
                return {
                    ['index'] = homeIndex,
                    ['data'] = data,
                    ['weight'] = {
                        max = homes_size[homeIndex][2],
                        current = home_weight - take_item
                    },
                    ['name'] = homes_size[homeIndex][3]
                }
            end
        end
    end
end

RegisterCommand('hm',function(source)
    TriggerEvent('inventory:openHome',source,'pm_1',{
        name = 'Casa',
        max = 100
    })
end)