iCL.OpenTrade = function(Object,Boolean)
    asideType = 'trade'
    UpdateInventory()
    SendReactMessage('frontType', 'trade')
    SendReactMessage('frontMode', 'trade')

    SendReactMessage('setOwner', Boolean)
    SendReactMessage('setItensPrimary', {})
    SendReactMessage('setItensSecondary',{})
    SendReactMessage('setTradeState',{pos = 0,value = 0})
    SendReactMessage('setTradeState',{pos = 1,value = 0})


    if Boolean then
        SendReactMessage('setPlayerName',Object['names'][2])
    else
        SendReactMessage('setPlayerName',Object['names'][1])
    end
    inTrade = true
    SendReactMessage('showHeader',false)
    toggleNuiFrame(true)
end

RegisterNetEvent('trade:setPrimaryItens')
AddEventHandler('trade:setPrimaryItens',function(Data)
    SendReactMessage('setItensPrimary', BuildInventory(Data))
    UpdateInventory()
end)

RegisterNetEvent('trade:setItensSecondary')
AddEventHandler('trade:setItensSecondary',function(Data)
    SendReactMessage('setItensSecondary', BuildInventory(Data))
end)

RegisterNUICallback('trade:addItem',function(data,cb)
    local item,amount,duration,itemAmount = data.key,data.amount,data.duration,data.itemAmount
    if itemAmount and itemAmount < amount and itemAmount > 0 then
        amount = itemAmount
    end
    API.TradeAddItem(item,amount,duration)
    cb('')
end)
RegisterNUICallback('trade:finish',function(data,cb)
    API.CompleteTrade()
    cb('')
end)

RegisterNUICallback('trade:removeItem',function(data,cb) 
    local item,duration = data.key,data.duration
    if item and duration then
        API.RemoveItemFromTrade(item,duration)
    end
    cb('')
end)

RegisterNetEvent('trade:status')
AddEventHandler('trade:status',function(p,v)
    SendReactMessage('setTradeState',{pos = p,value = v})
end)

RegisterNetEvent('trade:close')
AddEventHandler('trade:close',function()
    toggleNuiFrame(false)
end)

RegisterNUICallback('trade:send',function(data,cb)
    local state = data
    API.SetStateTrade(state)
    cb('')
end)