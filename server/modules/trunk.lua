local trunks = {}
local trunkLog = {}


API.OpenTrunk = function(veh,inVeh)
    local source = source
    local user_id = vRP.getUserId(source)
    local plate, vname = veh.plate, veh.vname
    if user_id and plate and vname then
        local owner_veh = GetOwnerVehicle(plate)
        if owner_veh and not trunks[vname..'-'..plate] then
            trunks[vname..'-'..plate] = true
            trunkLog[user_id] = vname..'-'..plate
            SetTimeout(15000, function()
                if trunks[vname..'-'..plate] then
                    trunks[vname..'-'..plate] = false
                    trunkLog[user_id] = false
                end
            end)
            if not inVeh then 
                TriggerClientEvent('openTrunk:anim',-1,veh.vnetid,false)
            end
            return true
        end
    end    
end

local function PedInVehicle(source,vehicle)
    local ped = GetPlayerPed(source)
    if ped then
        return GetVehiclePedIsIn(ped,vehicle) ~= 0
    end
end

RegisterServerEvent('closeTrunk:anim',function(vnetid,plate,vname)
    if vnetid and plate and vname then
        local user_id = vRP.getUserId(source)
        trunks[vname..'-'..plate] = nil
        trunkLog[user_id] = nil
        TriggerClientEvent('openTrunk:anim',-1,vnetid,true)
    end
end)

AddEventHandler("playerDropped",function(reason)
	local source = source
	local user_id = vRP.getUserId(source)
    if trunkLog[user_id] then
        local index = trunkLog[user_id]
        trunks[index] = nil
        trunkLog[user_id] = nil
    end
end)

GetTrunkWeight = function(data)
    local n = 0
    for k,v in pairs(data) do
        if itens[v.item] then
            n = n + parseInt(GetItemWeight(v.item) * v.amount)
        end
    end
    return n
end

API.getTrunkItens = function(veh,inVeh)
    local source = source
    local user_id = vRP.getUserId(source)
    local plate, vname = veh.plate, veh.vname
    if user_id and plate and vname then
        local owner_veh = GetOwnerVehicle(plate)
        if not owner_veh then return end
        local dataIndex = ''
        if inVeh then dataIndex = "chest:u"..owner_veh.."veh_gc"..vname end
        if not inVeh then dataIndex = "chest:u"..owner_veh.."veh_"..vname end

        local data = GetSrvData(dataIndex)
        if data then
            return data,GerateAsideWeight(data),GetTrunkSize(vname,inVeh),owner_veh
        end
    end
end

API.StoreTrunk = function(veh,item,amount,duration)
    local source = source
    local user_id = vRP.getUserId(source)
    local plate, vname = veh.plate, veh.vname
    if user_id and plate and vname and not actived[user_id] and item and amount then
        if API.BlockInteractItens[item] then
            TriggerClientEvent('Notify', source, 'negado', 'Item náo pode ser guardado!')
            return false
        end
        actived[user_id] = true
        local owner_veh = GetOwnerVehicle(plate)
        if not owner_veh then actived[user_id] = nil return false end
        local dataIndex = ''
        local inVeh = PedInVehicle(source,veh.vnetid)
        if inVeh then
            dataIndex = "chest:u"..owner_veh.."veh_gc"..vname
        else
            dataIndex = "chest:u"..owner_veh.."veh_"..vname
        end
        local data = GetSrvData(dataIndex)
        if data then
            local trunk_weight = GerateAsideWeight(data)
            local store_item = GetItemWeight(item) * amount
            if (trunk_weight + store_item) <= GetTrunkSize(vname,inVeh) then
                if vRP.tryGetInventoryItem(user_id,item,amount) then
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
                    SetSrvData(dataIndex,data)
                    actived[user_id] = nil

                    if inVeh then
                        sendWebhook('Porta-luvas Guardar','**Id:** *'..user_id..'*\n**Veículo:** *'..vname..'*\n**Placa:** *'..plate..'*\n**Item:** *'..item..'.*\n**Quantidade:** *'..amount..'.*','https://discord.com/api/webhooks/1007259225665318964/B1BqA07LH6caAFr0-sFisr1aocy-be7f3BWAjrsqT3zTtbFgSni6OqNWoCNmz7076KYl')
                    else
                        sendWebhook('Porta-malas Guardar','**Id:** *'..user_id..'*\n**Veículo:** *'..vname..'*\n**Placa:** *'..plate..'*\n**Item:** *'..item..'.*\n**Quantidade:** *'..amount..'.*','https://discord.com/api/webhooks/1007259311828893736/s3q3Qrntj3pyxmRoH6H6c-pHJMTXCk2vfPZHoO-Brmp5pQ3hx7o7Fk9hDguVTfr70sd7')
                    end
                    return true
                end
            else
                TriggerClientEvent('Notify',source,'negado','O bau não tem espaço para este item')
            end
        end
        actived[user_id] = nil

    end
end

API.TakeTrunk = function(veh,item,amount,duration)
    local source = source
    local user_id = vRP.getUserId(source)
    local plate, vname = veh.plate, veh.vname
    if user_id and plate and vname and not actived[user_id] then
        actived[user_id] = true
        local owner_veh = GetOwnerVehicle(plate)
        if not owner_veh then actived[user_id] = nil return false end
        local dataIndex = ''
        local inVeh = PedInVehicle(source,veh.vnetid)
        if inVeh then
            dataIndex = "chest:u"..owner_veh.."veh_gc"..vname
        else
            dataIndex = "chest:u"..owner_veh.."veh_"..vname
        end
        local data = GetSrvData(dataIndex)
        -- local data = GetSrvData("chest:u"..owner_veh.."veh_"..vname)
        if data and data[item] and data[item].amount >= amount then
            local item_data = data[item]
            local take_item = GetItemWeight(item) * amount
            local inv_weight = GetWeight(user_id)
            if (inv_weight + take_item) <= GetMaxWeight(user_id) then
                vRP.giveInventoryItem(user_id,item,amount)
                item_data.amount = item_data.amount - amount
                if item_data.amount == 0 then
                    data[item] = nil
                end
                SetSrvData(dataIndex,data)
                actived[user_id] = nil

                if inVeh then
                    sendWebhook('Porta-luvas Pegar','**Id:** *'..user_id..'*\n**Veículo:** *'..vname..'*\n**Placa:** *'..plate..'*\n**Item:** *'..item..'.*\n**Quantidade:** *'..amount..'.*','https://discord.com/api/webhooks/1007259264210960485/ANU1TjI5sKthfXcJQpDjT7AiwOL5mkZsabJg3ppsYSlyfdrayCCkt6CB8TuAUS_al6oI')
                else
                    sendWebhook('Porta-malas Pegar','**Id:** *'..user_id..'*\n**Veículo:** *'..vname..'*\n**Placa:** *'..plate..'*\n**Item:** *'..item..'.*\n**Quantidade:** *'..amount..'.*','https://discord.com/api/webhooks/1007259338630500412/UaUiqiIt4_zb_8WbrN15sG2NX2NCL-GlqvBx6ZvasXm7G0_fhjwXVT190cVw2xHJ1SYc')
                end
                return true
            end
        end
        actived[user_id] = nil
    end
end
