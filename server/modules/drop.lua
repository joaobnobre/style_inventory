local drops = {}
local dropActive = {}
local lastID = 0

API.CreateDrop = function(item,amount,duration,usage)
    local source = source
    local user_id = vRP.getUserId(source)
    if API.BlockInteractItens[item] then
        TriggerClientEvent('Notify', source, 'negado', 'Item não pode ser dropado!')
        return false
    end
    if user_id then
        if vRP.tryGetInventoryItem(user_id,item,amount,false) then
            local ped = GetPlayerPed(source)
            local coords = GetEntityCoords(ped)
            local prop_model = GetItemProp(item)
            if not prop_model or prop_model == '' then prop_model = 'prop_paper_bag_small' end
            
            -- (Old z method) local prop_id = CreateObject(GetHashKey(prop_model),coords.x,coords.y,coords.z - 1,true,true)
            local prop_id = CreateObject(GetHashKey(prop_model),coords.x,coords.y,coords.z,true,true)
            while not DoesEntityExist(prop_id) do
                Wait(1)
            end
            lastID = lastID + 1
            local drop_content = {
                item = {
                    item = item,
                    duration = duration,
                    usage = usage,
                    amount = amount
                },
                amount = amount,
                dimension = GetPlayerRoutingBucket(source),
                prop_id = prop_id,
                timer = 180,
                usage = usage
            }
            drops[tostring(lastID)] = drop_content
            local reducer = {prop_id = NetworkGetNetworkIdFromEntity(prop_id),coords = coords,dimension = GetPlayerRoutingBucket(source), id = lastID,name = GetItemName(item), amount = amount}
            iCL.RegisterDrop(-1,reducer)
            vRPclient.playAnim(source,true,{{"pickup_object","pickup_low"}},false)
            sendWebhook('Soltar Itens','**Id:** *'..user_id..'*\n**Item:** *'..item..'.*\n**Quantidade:** *'..amount..'.*\n**Coordenada:** '..coords.x..','..coords.y..','..coords.z,'https://discord.com/api/webhooks/1096129994817798245/HL5lB9YXP5G3l7JXtYMS1jUKqXRUo8jnAhzKgqBoCBGB0tgvUio7P1XWhn9MM1s05hWK')
            return true
        end
    end
end

API.TakeDrop = function(id)
    local source = source
    local user_id = vRP.getUserId(source)
    local x,y,z = vRPclient.getPosition(source)
    if user_id then
        local drop = drops[tostring(id)]
        if drop then
            local item,duration,usage = drop['item']['item'],drop['item']['duration'],drop['item']['usage']
            local take_item = GetItemWeight(item) * drop['amount']
            local inv_weight = GetWeight(user_id)
            local qntvaipegar = drop['amount']
            if (inv_weight+take_item) > GetMaxWeight(user_id) then
                qntvaipegar = getmaxcancarry(user_id,inv_weight,take_item,drop['amount'],item)
                take_item = GetItemWeight(item) * qntvaipegar
                if qntvaipegar == 0 then
                    TriggerClientEvent('Notify', source, 'negado', 'Sua mochila está cheia!')
                    return 
                end
            end
            if (inv_weight+take_item) <= GetMaxWeight(user_id) then
                if drops[tostring(id)] and not dropActive[tostring(id)] then
                    if qntvaipegar < drop['amount'] then
                        API.CreateDropRemaing(item,drop['amount'] - qntvaipegar,duration,usage,source)
                    end
                    dropActive[tostring(id)] = true
                    
                    drops[tostring(id)] = nil
                    iCL.RemoveDrop(-1,id)
                    DeleteEntity(drop['prop_id'])
                    vRP.giveInventoryItem(user_id,item,qntvaipegar,duration,usage)
                    dropActive[tostring(id)] = nil
                    vRPclient.playAnim(source,true,{{"pickup_object","pickup_low"}},false)
                    sendWebhook('Pegar Itens','**Id:** *'..user_id..'*\n**Item:** *'..item..'.*\n**Quantidade:** *'..drop['amount']..'.*\n**Coordenada:** '..x..','..y..','..z,'https://discord.com/api/webhooks/1096129902090141756/hTyXOBq7gpVeAKnS37blJOIEOWMaUILtWOsFDSuM5pxBK2HGyX5fm_p9Xv4oLb1I843d')
                    return true
                end
            else
                TriggerClientEvent('Notify', source, 'negado', 'Sua mochila está cheia!')
            end
        end
    end
end

API.CreateDropRemaing = function(item,amount,duration,usage,source)
    local user_id = vRP.getUserId(source)
    if user_id then
        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)
        local prop_model = GetItemProp(item)
        
        if not prop_model or prop_model == '' then prop_model = 'prop_paper_bag_small' end
        
        -- (Old z method) local prop_id = CreateObject(GetHashKey(prop_model),coords.x,coords.y,coords.z - 1,true,true)
        local prop_id = CreateObject(GetHashKey(prop_model),coords.x,coords.y,coords.z,true,true)
        while not DoesEntityExist(prop_id) do
            Wait(1)
        end
        lastID = lastID + 1
        local drop_content = {
            item = {
                item = item,
                duration = duration,
                usage = usage,
                amount = amount
            },
            amount = amount,
            prop_id = prop_id,
            dimension = GetPlayerRoutingBucket(source),
            timer = 180,
            usage = usage
        }
        drops[tostring(lastID)] = drop_content
        local reducer = {prop_id = NetworkGetNetworkIdFromEntity(prop_id),coords = coords,dimension = GetPlayerRoutingBucket(source), id = lastID,name = GetItemName(item), amount = amount}
        iCL.RegisterDrop(-1,reducer)
        vRPclient.playAnim(source,true,{{"pickup_object","pickup_low"}},false)
        sendWebhook('Soltar Itens','**Id:** *'..user_id..'*\n**Item:** *'..item..'.*\n**Quantidade:** *'..amount..'.*','https://discord.com/api/webhooks/1096129994817798245/HL5lB9YXP5G3l7JXtYMS1jUKqXRUo8jnAhzKgqBoCBGB0tgvUio7P1XWhn9MM1s05hWK')
        return true
    end
end

API.getentitydimension = function()
    local source = source
    return GetPlayerRoutingBucket(source)
end

function getmaxcancarry(user_id,inv_weight,take_item,amount,item)
    local quantovaipegar = 0
    if (inv_weight+take_item) > GetMaxWeight(user_id) then
        for i = 1,amount do
            take_item = GetItemWeight(item) * i
            if (inv_weight+take_item) > GetMaxWeight(user_id) then
                quantovaipegar = i-1
                return quantovaipegar
            end
        end
    end
end

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(drops) do
            if v['timer'] > 0 then
                v['timer'] = v['timer'] - 1
            end
            if v['timer'] == 0 then
                drops[k] = nil
                iCL.RemoveDrop(-1,v['id'])
                DeleteEntity(v['prop_id'])
            end
        end
        Wait(1000)
    end
end)