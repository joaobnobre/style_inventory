API.CraftItem = function(item,craftPoint)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local checkReceitaBool,receitaMsg = CheckReceita(item,user_id)
        if checkReceitaBool and not receitaMsg then
            TriggerClientEvent('inventory:close',source)
            vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
            TriggerClientEvent('inventory:update',source)
            TriggerClientEvent('cancelando', source, true)
            TriggerClientEvent("progress", source, craft[item].time * 1000, "Craftando")
            TriggerClientEvent('freezeped',source,true,"amb@prop_human_parking_meter@female@idle_a","idle_a_female",true)
            
            SetTimeout(craft[item].time * 1000,function()
                vRP._stopAnim(source,false)
                vRP.giveInventoryItem(user_id,craft[item].item,craft[item].amount)
                TriggerClientEvent('Notify',source,'sucesso','Voce fez <b>'..craft[item].amount..'x '..craft[item].item..'</b>.')
                TriggerClientEvent('inventory:update',source)
                Player(source)["state"]['inCraft'] = false
                TriggerClientEvent('cancelando', source, false)
                TriggerClientEvent('freezeped',source,false)
                TriggerClientEvent('stopfreeze',source,false)
            end)

            sendWebhook('Craft Itens','**Id:** *'..user_id..'*\n**Item:** '..craft[item].item..'.\n**Quantidade:** '..craft[item].amount..'.\n**Ponto de Craft:** '..craftPoint,'https://discord.com/api/webhooks/1096492111228055682/gLnaVmLoL1YOsEDquQxMs7PQm7FYdswTj3eRyeGaBQR97h_8jjzPtLt-G4C-8GCYURlb')
            if craft_hooks[craftPoint] then
                sendWebhook('Craft Itens','**Id:** *'..user_id..'*\n**Item:** '..craft[item].item..'.\n**Quantidade:** '..craft[item].amount..'.',craft_hooks[craftPoint])
            end
            
            return true
        elseif not checkReceitaBool and receitaMsg == 'weightBlock' then
            TriggerClientEvent('inventory:close',source)
            TriggerClientEvent('Notify',source,'negado','Você <b>não possui espaço na mochila para criar '..GetItemName(craft[item].item)..'</b>.')
            return false
        else
            TriggerClientEvent('inventory:close',source)
            TriggerClientEvent('Notify',source,'negado','Você <b>não possui todos os itens para criar '..GetItemName(craft[item].item)..'</b>.')
            return false
        end
    end
end

CheckReceita = function(item,user_id)
    if user_id then
        if craft[item] then
            local receita = craft[item]['receita']
            local aproved_itens = GetTableSize(receita)
            local itens = 0

            for k,v in pairs(receita) do
                if GetItemAmount(user_id,v.item) >= v.amount then
                    itens = itens + 1
                end
            end

            if (GetWeight(user_id)+(GetItemWeight(craft[item].item)*craft[item].amount)) > GetMaxWeight(user_id) then
                itens = 0
                return false,'weightBlock'
            end

            if itens == aproved_itens then
                for k,v in next,receita do
                    if TryItem(user_id,v.item,v.amount,false) then
                        itens = itens - 1
                    end
                end

                return itens == 0
            end
        end
    end
end