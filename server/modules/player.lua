local inspect = {}

local function BuildPlayerInfos(user_id)
    local max = GetMaxWeight(user_id)
    local weight = GetWeight(user_id)
    return { max = max, current = weight, name = GetUserName(user_id) }
end

RegisterCommand('revistar',function(source)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local nplayer = GetNearestPlayer(source)
        if nplayer then
            local nuser_id = vRP.getUserId(nplayer)
            if nuser_id then
                local wp = Garmas(nplayer,'revistar',user_id)
                if wp then
                    for k,v in pairs(wp) do
                        GiveItem(nuser_id,k,1)
                        if v > 0 and weapons[k][2] ~= '' then
                            GiveItem(nuser_id,weapons[k][2],v)
                        end
                    end
                    local ninv = GetInventory(nuser_id)
                    
                    Player(source)["state"]['Cancel'] = true
                    Player(nplayer)["state"]['Cancel'] = true
                    PlayAnim(source,false,{{"misscarsteal4@director_grip","end_loop_grip"}},true)
                    PlayAnim(nplayer,false,{{"random@mugging3","handsup_standing_base"}},true)
                    inspect[source] = nplayer
                    
                    iCL.openRevistar(source,ninv,BuildPlayerInfos(nuser_id))
                    TriggerClientEvent('inventory:close',nplayer)
                    
                    local saveTxt = '**Id:** '..user_id..'\n**Revistado:** '..nuser_id..'\n**Itens Encontrados:** '
                    local countDown = 0
                    for k,v in next,ninv do
                        countDown = countDown+1
                        if countDown == getArraySize(ninv) then
                            saveTxt = saveTxt..'x'..v.amount..' '..k
                        else
                            saveTxt = saveTxt..'x'..v.amount..' '..k..', '
                        end
                    end
                    sendWebhook('Revistar',saveTxt,'https://discord.com/api/webhooks/1096154254475022387/yTZ73s8fkf0dBrAc0wGheld-3bnuLGQHm_Pr4-eDWbhSHsPKJ8yl8whTSY1xkUgNAJFz')
                else
                    
                end
            end
        end
    end
end)

RegisterCommand('admrevistar',function(source,args)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local nplayer = vRP.getUserSource(tonumber(args[1]))
        if nplayer then
            local nuser_id = vRP.getUserId(nplayer)
            if nuser_id then
                -- local wp = Garmas(nplayer,'revistar',user_id)
                -- if wp then
                    -- for k,v in pairs(wp) do
                    --     GiveItem(nuser_id,k,1)
                    --     if v > 0 and weapons[k][2] ~= '' then
                    --         GiveItem(nuser_id,weapons[k][2],v)
                    --     end
                    -- end
                    local ninv = GetInventory(nuser_id)
                    
                    -- Player(source)["state"]['Cancel'] = true
                    -- Player(nplayer)["state"]['Cancel'] = true
                    -- PlayAnim(source,false,{{"misscarsteal4@director_grip","end_loop_grip"}},true)
                    -- PlayAnim(nplayer,false,{{"random@mugging3","handsup_standing_base"}},true)
                    inspect[source] = nplayer
                    
                    iCL.openRevistar(source,ninv,BuildPlayerInfos(nuser_id))
                    TriggerClientEvent('inventory:close',nplayer)
                    
                    local saveTxt = '**Id:** '..user_id..'\n**Revistado:** '..nuser_id..'\n**Itens Encontrados:** '
                    local countDown = 0
                    for k,v in next,ninv do
                        countDown = countDown+1
                        if countDown == getArraySize(ninv) then
                            saveTxt = saveTxt..'x'..v.amount..' '..k
                        else
                            saveTxt = saveTxt..'x'..v.amount..' '..k..', '
                        end
                    end
                    sendWebhook('Revistar',saveTxt,'https://discord.com/api/webhooks/1096154254475022387/yTZ73s8fkf0dBrAc0wGheld-3bnuLGQHm_Pr4-eDWbhSHsPKJ8yl8whTSY1xkUgNAJFz')
                -- else
                    
                -- end
            end
        end
    end
end)


RegisterCommand('roubar',function(source)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local nplayer = GetNearestPlayer(source)
        if nplayer then
            local nuser_id = vRP.getUserId(nplayer)
            if nuser_id then
                local request = false
                local ped = GetPlayerPed(nplayer)
                if GetEntityHealth(ped) > 101 then
                    request = vRP.request(nplayer,'Você está sendo roubado, deseja aceitar o roubo?',15)
                    if not request then
                        TriggerClientEvent('Notify',source,'negado','A pessoa negou o roubo!')
                        TriggerClientEvent('Notify',nplayer,'aviso','Você negou o roubo!')
                        return
                    end
                else
                    request = true
                end
                if request then
                    if (#vRP.get_estafinalizado(nuser_id) > 0) then
                        TriggerClientEvent('Notify',source,'negado','A pessoa já está finalizada!')
                        return
                    end

                    local moneyAmount = vRP.getMoney(nuser_id)
                    if moneyAmount > 0 then
                        vRP.tryPayment(nuser_id,moneyAmount)
                        vRP.giveMoney(user_id,moneyAmount)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Você encontrou R$'..moneyAmount..' no bolso da vítima.')
                    end

                    local wp = Garmas(nplayer,'roubar',user_id)
                    for k,v in pairs(wp) do
                        GiveItem(nuser_id,k,1)
                        if v > 0 and weapons[k][2] ~= '' then
                            GiveItem(nuser_id,weapons[k][2],v)
                        end
                    end
                    local ninv = GetInventory(nuser_id)

                    Player(source)["state"]['Cancel'] = true
                    Player(nplayer)["state"]['Cancel'] = true
                    if GetEntityHealth(ped) > 101 then
                        PlayAnim(source,false,{{"misscarsteal4@director_grip","end_loop_grip"}},true)
                        PlayAnim(nplayer,false,{{"random@mugging3","handsup_standing_base"}},true)
                    else
                        PlayAnim(source,false,{{"amb@medic@standing@tendtodead@idle_a","idle_a"}},true)
                    end
                    inspect[source] = nplayer
                    TriggerClientEvent('inventory:close',nplayer)

                    iCL.openRoubar(source,ninv,BuildPlayerInfos(nuser_id))
                end
            end
        end
    end
end)


RegisterCommand('apreender',function(source)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id and HasPermission(user_id,global.apreender) then
        local nplayer = GetNearestPlayer(source)
        if nplayer then
            local nuser_id = vRP.getUserId(nplayer)
            if nuser_id then
                if (GetMaxWeight(user_id)-GetWeight(user_id)) < 1 then
                    TriggerClientEvent('Notify', source, 'sucesso', 'Sua mochila está cheia!')
                    return
                end
                local wp = Garmas(nplayer,'apreender',user_id)
                for k,v in pairs(wp) do
                    GiveItem(nuser_id,k,1)
                    if v > 0 and weapons[k][2] ~= '' then
                        GiveItem(nuser_id,weapons[k][2],v)
                    end
                end
                
                Player(source)["state"]['Cancel'] = true
                Player(nplayer)["state"]['Cancel'] = true
                PlayAnim(source,false,{{"misscarsteal4@director_grip","end_loop_grip"}},true)
                PlayAnim(nplayer,false,{{"random@mugging3","handsup_standing_base"}},true)
                inspect[source] = nplayer
                TriggerClientEvent('inventory:close',nplayer)
                
                local ninv = GetInventory(nuser_id)
                iCL.openApreender(source,ninv,BuildPlayerInfos(nuser_id))
            end
        end
    end
end)

API.TakePlayer = function(item,amount,duration,tipo)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local nplayer = GetNearestPlayer(source)
        if nplayer then
            local nuser_id = vRP.getUserId(nplayer)
            if nuser_id then
                local i = item
                -- if duration then
                --     item = item..'-'..duration
                -- end
                local take_item = GetItemWeight(item) * amount
                local inv_weight = GetWeight(user_id)
                if (inv_weight + take_item) > GetMaxWeight(user_id) then
                    return false
                end
                if not duration then
                    if TryItem(nuser_id,item,amount) then
                        GiveItem(user_id,item,amount)
                        TriggerClientEvent('Notify',source,'sucesso','Você roubou <b>'..amount..'x '..GetItemName(i)..'</b> do cidadão.')
                        TriggerClientEvent('Notify',nplayer,'importante','Você foi roubado <b>'..amount..'x '..GetItemName(i)..'</b>')
                        
                        if tipo == 'apreender' then
                            sendWebhook('Apreender Itens','**Id:** '..user_id..'\n**Vitima:** '..nuser_id..'\n**Item:** x'..amount..' '..item,'https://discord.com/api/webhooks/1096166199009755136/KlCVYQZ4zBbrSX2QRKhgKofrQtuMuKkCISLPgCcEBAP6z4HgR1GT8LBmzekPDAoB9T1o')
                        else
                            sendWebhook('Roubar Itens','**Id:** '..user_id..'\n**Vitima:** '..nuser_id..'\n**Item:** x'..amount..' '..item,'https://discord.com/api/webhooks/1096164811705954384/pwuyhWqLmq_f9o8IN_KX19ZRPS5m2HBoII_lucp2DmqU8A2BjAKcYFXU1UWXc9ymbQKi')
                        end

                        local ninv = GetInventory(nuser_id)
                        return true,ninv,BuildPlayerInfos(nuser_id)
                    else
                        TriggerClientEvent('inventory:close',source)
                        TriggerClientEvent('Notify',source,'negado','O cidadão não tem <b>'..amount..'x '..GetItemName(i)..'</b> em mãos.')
                        return false
                    end
                end
                if os.time() <= duration then
                    if TryItem(nuser_id,item,amount) then
                        GiveItem(user_id,item,amount)
                        TriggerClientEvent('Notify',source,'sucesso','Você roubou <b>'..amount..'x '..GetItemName(i)..'</b> do cidadão.')
                        TriggerClientEvent('Notify',nplayer,'importante','Você foi roubado <b>'..amount..'x '..GetItemName(i)..'</b>')
                        local ninv = GetInventory(nuser_id)
                        return true,ninv,BuildPlayerInfos(nuser_id)
                    else
                        TriggerClientEvent('inventory:close',source)
                        TriggerClientEvent('Notify',source,'negado','O cidadão não tem <b>'..amount..'x '..GetItemName(i)..'</b> em mãos.')
                    end
                else
                    TriggerClientEvent('inventory:close',source)
                    TriggerClientEvent('Notify',source,'negado','O item está vencido.')
                    TriggerClientEvent('Notify',nplayer,'aviso',amount..'x '..GetItemName(i)..' por estar vencido!')
                    vRP.DeleteItem(nuser_id,item)
                    local ninv = GetInventory(nuser_id)
                    return true,ninv,BuildPlayerInfos(nuser_id)
                end
            end
        end
    end
end

RegisterServerEvent('player:close',function()
    local source = source
    if inspect[source] then
        local nplayer = inspect[source]

        Player(source)["state"]['Cancel'] = false
        Player(nplayer)["state"]['Cancel'] = false
        StopAnim(source,false)
        StopAnim(nplayer,false)
        inspect[source] = nil
    end
end)

AddEventHandler("playerDropped",function(reason)
	local source = source
    if inspect[source] then
        local nplayer = inspect[source]
        Player(nplayer)["state"]['Cancel'] = false
        StopAnim(nplayer,false)
        inspect[source] = nil
    end
end)