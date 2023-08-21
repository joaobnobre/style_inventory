local Trade = {}
local inTrade = {}

-- primary e quem inicia o trade
-- secondary e quem recebe o convite de trade
RegisterCommand('trade',function(source)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local nplayer = GetNearestPlayer(source)
        local uname = GetUserName(user_id)
        if nplayer and uname then
            local nuser_id = vRP.getUserId(nplayer)
            if nuser_id then
                local nname = GetUserName(nuser_id)
                if nname and vRP.request(nplayer,'Deseja iniciar um troca com '..uname..'?',15) then 
                    local token = #Trade + 1
                    if not Trade[token] and not inTrade[user_id] and not inTrade[nuser_id] then
                        Trade[token] = {
                            owner = user_id,
                            ids = {user_id,nuser_id},
                            srcs = {source,nplayer},
                            names = {uname,nname},
                            status = {0,0},
                            primaryItens = {},
                            secondaryItens = {},
                            weight={GetWeight(user_id),GetWeight(nuser_id)},
                            maxWeight={GetMaxWeight(user_id),GetMaxWeight(nuser_id)}
                        }
                        inTrade[user_id] = token
                        inTrade[nuser_id] = token
                        iCL.OpenTrade(source,Trade[token],true)
                        iCL.OpenTrade(nplayer,Trade[token],false)
                    end
                end
            end
        end
    end
end)

API.startTradeExport = function(source)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local nplayer = GetNearestPlayer(source)
        local uname = GetUserName(user_id)
        if nplayer and uname then
            local nuser_id = vRP.getUserId(nplayer)
            if nuser_id then
                local nname = GetUserName(nuser_id)
                if nname and vRP.request(nplayer,'Deseja iniciar um troca com '..uname..'?',15) then 
                    local token = #Trade + 1
                    if not Trade[token] and not inTrade[user_id] and not inTrade[nuser_id] then
                        Trade[token] = {
                            owner = user_id,
                            ids = {user_id,nuser_id},
                            srcs = {source,nplayer},
                            names = {uname,nname},
                            status = {0,0},
                            primaryItens = {},
                            secondaryItens = {},
                            weight={GetWeight(user_id),GetWeight(nuser_id)},
                            maxWeight={GetMaxWeight(user_id),GetMaxWeight(nuser_id)}
                        }
                        inTrade[user_id] = token
                        inTrade[nuser_id] = token
                        iCL.OpenTrade(source,Trade[token],true)
                        iCL.OpenTrade(nplayer,Trade[token],false)
                    end
                end
            end
        end
    end
end

API.TradeAddItem = function(item,amount,duration)
    local source = source
    local user_id = vRP.getUserId(source)
    local token = inTrade[user_id]
    if user_id and token then
        if Trade[token] then
            if API.BlockInteractItens[item] then
                TriggerClientEvent('Notify', source, 'negado', 'Item náo pode ser trocado!')
                return false
            end
            local CloneItem = vRP.CloneItem(user_id,item)
            if CloneItem and CloneItem.duration and CloneItem.duration <= os.time() then
                TriggerClientEvent('Notify',source,'aviso','Este item está vencido e foi jogado fora!')
                --vRP.DeleteItem(user_id,item)
                TriggerClientEvent('trade:close',owner_src)
                Wait(300)
                TriggerClientEvent('trade:close',other_src)
                return
            end
            local i = Trade[token]
            local owner_src,other_src = i['srcs'][1],i['srcs'][2]
            if TryItem(user_id,item,amount) then
                if i['owner'] == user_id then
                    local take_item = GetItemWeight(item) * amount
                    local inv_weight = i['weight'][2]
                    if (inv_weight + take_item) <= i['maxWeight'][2] then
                        i['primaryItens'][item] = {amount = amount,duration = CloneItem.duration,usage = CloneItem.usage}
                        i['weight'][2] = i['weight'][2] + take_item
                        i['weight'][1] = i['weight'][1] - take_item
                        TriggerClientEvent('trade:setPrimaryItens',owner_src,i['primaryItens'])
                        TriggerClientEvent('trade:setItensSecondary',other_src,i['primaryItens'])
                    else
                        GiveItem(user_id,item,amount)
                        TriggerClientEvent('inventory:close',source)
                        TriggerClientEvent('Notify',source,'negado','A pessoa nao tem espaço para este item') 
                    end
                else
                    local take_item = GetItemWeight(item) * amount
                    local inv_weight = i['weight'][1]
                    if (inv_weight + take_item) <= i['maxWeight'][1] then
                        i['secondaryItens'][item] = {amount = amount,duration = CloneItem.duration,usage = CloneItem.usage}
                        i['weight'][1] = i['weight'][1] + take_item
                        i['weight'][2] = i['weight'][2] - take_item
                        TriggerClientEvent('trade:setPrimaryItens',other_src,i['secondaryItens'])
                        TriggerClientEvent('trade:setItensSecondary',owner_src,i['secondaryItens']) 
                    else
                        GiveItem(user_id,item,amount)
                        TriggerClientEvent('inventory:close',source)
                        TriggerClientEvent('Notify',source,'negado','A pessoa nao tem espaço para este item') 
                    end
                end
            end
        end
    end
end

API.RemoveItemFromTrade  = function(item,duration)
    local source = source
    local user_id = vRP.getUserId(source)
    local token = inTrade[user_id]
    if user_id and token and Trade[token] then
        local i = Trade[token]
        local owner_src,other_src = i['srcs'][1],i['srcs'][2]
        if i['owner'] == user_id then
            local ITEM_TRADE = i['primaryItens'][item]
            if ITEM_TRADE then
                GiveItem(user_id,item,ITEM_TRADE['amount'],ITEM_TRADE['duration'],ITEM_TRADE['usage'])
                i['primaryItens'][item] = nil
                TriggerClientEvent('trade:setPrimaryItens',owner_src,i['primaryItens'])
                TriggerClientEvent('trade:setItensSecondary',other_src,i['primaryItens']) 
            end
        else
            local ITEM_TRADE = i['secondaryItens'][item]
            if ITEM_TRADE then
                i['secondaryItens'][item] = nil
                GiveItem(user_id,item,ITEM_TRADE['amount'],ITEM_TRADE['duration'],ITEM_TRADE['usage'])
                TriggerClientEvent('trade:setPrimaryItens',other_src,i['secondaryItens'])
                TriggerClientEvent('trade:setItensSecondary',owner_src,i['secondaryItens']) 
            end

        end
    end
end

API.SetStateTrade = function(state)
    local source = source
    local user_id = vRP.getUserId(source)
    local token = inTrade[user_id]
    if user_id and token then
        if Trade[token] then
            local T = Trade[token]
            if user_id == T['owner'] then
                if T['status'][2] == 0 and state == 1 then
                    T['status'][1] = 0
                else
                    T['status'][1] = state + 1
                end
                TriggerClientEvent('trade:status',T['srcs'][1],0,T['status'][1])
                TriggerClientEvent('trade:status',T['srcs'][2],1,T['status'][1])
            else
                if T['status'][1] == 0 and state == 1 then
                    T['status'][2] = 0
                else
                    T['status'][2] = state + 1
                end
                
                TriggerClientEvent('trade:status',T['srcs'][2],0,T['status'][2])
                TriggerClientEvent('trade:status',T['srcs'][1],1,T['status'][2])
            end
        end
    end
end

API.CompleteTrade = function()
    local source = source
    local token = inTrade[vRP.getUserId(source)]
    if token and Trade[token] then
        local T = Trade[token]
        Trade[token] = nil
        local user_id,nuser_id = T['ids'][1],T['ids'][2]
        local source,nplayer = T['srcs'][1],T['srcs'][2]
        

        local saveTxt = '**Id Primário:** *'..nuser_id..'*\n**Recebeu:** '
        local countDown = 0
        for k,v in pairs(T['primaryItens']) do
            countDown = countDown+1
            if countDown == getArraySize(T['primaryItens']) then
                saveTxt = saveTxt..'x'..v.amount..' '..tostring(k)
            else
                saveTxt = saveTxt..'x'..v.amount..' '..tostring(k)..', '
            end

            GiveItem(nuser_id,k,v.amount,v.duration,v.usage)
            T['primaryItens'][k] = nil
        end
        
        saveTxt = saveTxt..'\n\n**Id Secundário:** *'..user_id..'*\n**Recebeu:** '
        countDown = 0
        for k,v in pairs(T['secondaryItens']) do
            countDown = countDown+1
            if countDown == getArraySize(T['secondaryItens']) then
                saveTxt = saveTxt..'x'..v.amount..' '..tostring(k)
            else
                saveTxt = saveTxt..'x'..v.amount..' '..tostring(k)..', '
            end
            
            GiveItem(user_id,k,v.amount,v.duration,v.usage)
            T['secondaryItens'][k] = nil
        end
        sendWebhook('Trade Itens',saveTxt,'https://discord.com/api/webhooks/1096134238664921198/MIwoSW2PCkAjajcOw9m98Q7rxRA99oUDHwQ-bMTbHLZEhAzHGOet-bJh0t39BOec-Hh-')
        
        inTrade[user_id] = nil
        inTrade[nuser_id] = nil
        PlayAnim(source, true,{{"mp_common", "givetake1_a"}},false)
        PlayAnim(nplayer, true,{{"mp_common", "givetake1_a"}},false)
        TriggerClientEvent('trade:close',source)
        TriggerClientEvent('trade:close',nplayer)
        Wait(100)
        TriggerClientEvent('Notify',source,'sucesso','Trade feito com sucesso!')
        TriggerClientEvent('Notify',nplayer,'sucesso','Trade feito com sucesso!')

    end
end

RegisterServerEvent('trade:close')
AddEventHandler('trade:close',function()
    local user_id = vRP.getUserId(source)
    local token = inTrade[user_id]
    if not token then return end
    if not Trade[token] then
        inTrade[user_id] = nil
    else
        if Trade[token]['owner'] == user_id then
            local T = Trade[token]
            Trade[token] = nil
            local nuser_id,nplayer = T['ids'][2],T['srcs'][2]

            for k,v in pairs(T['primaryItens']) do
                GiveItem(user_id,k,v.amount,v.duration,v.usage)
                T['primaryItens'][k] = nil
            end

            for k,v in pairs(T['secondaryItens']) do
                GiveItem(nuser_id,k,v.amount,v.duration,v.usage)
                T['secondaryItens'][k] = nil
            end
            inTrade[user_id] = nil
            TriggerClientEvent('trade:close',nplayer)
            
        else
            local T = Trade[token]
            Trade[token] = nil
            local nuser_id,nplayer = T['ids'][1],T['srcs'][1]

            for k,v in pairs(T['secondaryItens']) do
                GiveItem(user_id,k,v.amount,v.duration,v.usage)
                T['secondaryItens'][k] = nil
            end

            for k,v in pairs(T['primaryItens']) do
                GiveItem(nuser_id,k,v.amount,v.duration,v.usage)
                T['primaryItens'][k] = nil
            end
            inTrade[user_id] = nil
            TriggerClientEvent('trade:close',nplayer)
        end
    end
end)