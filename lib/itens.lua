GetItemImage = function(item)
    if item == '' then
        return item
    end
    if not itens[item] then
        return
    end
    return itens[item]['image']
end

GetItemName = function(item)
    if not itens[item] then
        return 'Error'
    end
    return itens[item]['name']
end

GetItemWeight = function(item)
    if not itens[item] then
        return 0
    end
    return itens[item]['weight']
end

GetItemMaxAmount = function(item)
    if not itens[item] then
        return
    end
    return itens[item]['maxAmount']
end

GetItemPrice = function(item)
    if not itens[item] then
        return
    end
    return itens[item]['price']
end

GetItemSell = function(item)
    if not itens[item] then
        return
    end
    return itens[item]['sell']
end

GetItemProp = function(item)
    if not itens[item] then
        return
    end
    return itens[item]['prop']
end

GetItemType = function(item)
    if not itens[item] then
        return
    end
    return itens[item]['type']
end

GetItemDurability = function(item)
    if itens[item] then
        return itens[item]['durability']
    end
end

GetItemBody = function(item)
    if itens[item] then
        return itens[item]
    end
end

GetMaxUse = function(item)
    if itens[item] then
        return itens[item]['usage']
    end
end

RepairCancel = function(status)
    onAnim = on
end

local tempStamina
RegisterNetEvent('tempStamina')
AddEventHandler('tempStamina', function(sec)
    if not tempStamina then
        local playerId = PlayerId()

        tempStamina = true
        SetRunSprintMultiplierForPlayer(playerId, 1.15)

        SetTimeout(sec * 1000, function()
            tempStamina = false
            SetRunSprintMultiplierForPlayer(playerId, 1.0)
        end)

        Citizen.CreateThreadNow(function()
            while tempStamina do
                RestorePlayerStamina(playerId, 1.0)
                Wait(1)
            end
        end)
    end
end)

