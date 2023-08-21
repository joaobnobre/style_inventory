API.checkStorePermissions = function(array,storeKey,storeCds)
    local source = source
    local user_id = vRP.getUserId(source)
    if array then
        if storeKey and storeKey == 'Bebidas' then
            for k,v in next,stores['Bebidas'].cds do
                if vec3(storeCds.x,storeCds.y,storeCds.z) == v then
                    if vRP.hasPermission(user_id,stores['Bebidas'].permissions[tonumber(k)]) then
                        return true
                    end
                end
            end
        else
            if json.encode(array) == "[]" then return true end
            for k,v in next,array do
            
                if vRP.hasPermission(user_id,v) then
                    return true
                end
            end
        end
    end
    return false
end

API.BuyItem = function(item,storeIndex)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id and item then
        local i = itens[item]['buyableItem']
        if i[1] and i[2] and i[3] then
            local buy_weight = GetItemWeight(item) * i[3]
            local inv_weight = GetWeight(user_id)
            local open_stores = iCL.returnOpenStores(source) 
            if open_stores.OnlySellWithNoOne then
                for k,v in pairs(open_stores.permissions) do
                    if #vRP.getUsersByPermission(v) > 0 then
                        TriggerClientEvent('inventory:close',source)
                        TriggerClientEvent('Notify',source,'negado','Existem trabalhadores em serviço!')
                        return false
                    end
                end
            end
            if (inv_weight + buy_weight) <= GetMaxWeight(user_id) then
                if StorePayment(user_id,i[2]) then
				    GiveItem(user_id,item,i[3])
                    TriggerClientEvent('style-audios:source',source,'coins','0.5')
                    TriggerClientEvent('inventory:update',source)
                    
                    local pedCoords = GetEntityCoords(GetPlayerPed(source))
                    sendWebhook('Shop Comprou','**Id:** *'..user_id..'*\n**Item:** '..item..'.\n**Quantidade:** '..i[3]..'\n**Preço:** R$'..i[2]..'.\n**Loja:** *('..pedCoords[1]..','..pedCoords[2]..','..pedCoords[3]..')*','https://discord.com/api/webhooks/1096495544374931486/wEWe3tiSB6duAXyOvkQlmhbBNuTgPHO7RbKJxxT-2RFOeIXIJIA1n3r3hZPFcrzEoAUi')
                    if open_stores[storeIndex] then
                        sendWebhook('Shop Comprou','**Id:** *'..user_id..'*\n**Item:** '..item..'.\n**Quantidade:** '..i[3]..'\n**Preço:** R$'..i[2]..'.\n**Loja:** *('..pedCoords[1]..','..pedCoords[2]..','..pedCoords[3]..')*',open_stores[storeIndex].webhook[1])
                    end
                    return true
                else
                    TriggerClientEvent('inventory:close',source)
                    TriggerClientEvent('Notify',source,'negado','Você não tem dinheiro suficiente')
                end
            else
                TriggerClientEvent('inventory:close',source)
                TriggerClientEvent('Notify',source,'negado','Seu inventário está cheio')
            end
        end
    end
end

API.SellItem = function(store,item,amount,storeIndex)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local i = itens[item]['sellableItem']
        if i[1] then
            if stores[store]['itens'][item] then
                local temp = item
                if duration then
                    item = item..'-'..duration
                end
                if TryItem(user_id,item,amount) then
                    --GiveItem(user_id,'dollars',amount * i[2],false)
                    TriggerClientEvent('Notify',source,'sucesso','Voce vendeu '..amount..'x '..GetItemName(temp)..' por R$'..amount * i[2])
                    TriggerClientEvent('inventory:update',source)

                    local pedCoords = GetEntityCoords(GetPlayerPed(source))
                    sendWebhook('Shop Vendeu','**Id:** *'..user_id..'*\n**Item:** '..item..'.\n**Quantidade:** '..amount..'\n**Preço:** R$'..amount*i[2]..'.\n**Loja:** '..storeIndex..' *('..pedCoords[1]..','..pedCoords[2]..','..pedCoords[3]..')*','https://discord.com/api/webhooks/1096495630022615241/OQZGqMmKfQ1tVx_RMjNOABUaGSrB62s-nVAo1sSvXlUQHfkwjkcetrxgI1yEBuSRbN62')
                    local open_stores = iCL.returnOpenStores(source) 
                    if open_stores[storeIndex] then
                        sendWebhook('Shop Vendeu','**Id:** *'..user_id..'*\n**Item:** '..item..'.\n**Quantidade:** '..amount..'\n**Preço:** R$'..amount*i[2]..'.\n**Loja:** *('..pedCoords[1]..','..pedCoords[2]..','..pedCoords[3]..')*',open_stores[storeIndex].webhook[2])
                    end
                    return true
                end
            else
                TriggerClientEvent('inventory:close',source)
                TriggerClientEvent('Notify',source,'negado','Este item não está a venda')
            end
        end
    end
end

