-- [ ADD ITEM FROM HOTBAR ]
RegisterNUICallback('addHotbar',function(data,cb)
    local item,amount,slot,duration = data.item.key,data.item.amount,data.slot,data.item.duration
    if not item then return end
    if not amount then return end
    if not slot then return end
    if duration then
        item = item..'-'..duration
    end
    HOTBAR[slot] = { key = item, amount = amount, slot = slot,image = GetItemImage(data.item.key),name = GetItemName(data.item.key) }
    API.wbhClient('Hotbar Colocou',{item=item,amount=amount,slot=slot})
    SendReactMessage('updateHotBar', HOTBAR)
    cb({})
end)

-- [ REMOVE ITEM FROM HOTBAR ]
RegisterNUICallback('removeHotbar',function(data,cb)
    local slot = data
    if not slot then return end
    API.wbhClient('Hotbar Retirou',{item=HOTBAR[slot].name,amount=HOTBAR[slot].amount,slot=slot})

    HOTBAR[slot] = { name = '',key = "", amount = 0, slot = slot,image = ''}
    SendReactMessage('updateHotBar', HOTBAR)
    cb({})
end)

CreateThread(function()
    Wait(1000)
    for i=1,5 do
        RegisterCommand('+bind'..i,function()
            UseItem(i)
        end)
        RegisterKeyMapping('+bind'..i, 'Acesso rapido', 'keyboard', tostring(i))
    end
end)

RegisterNetEvent('Hotbar:removeItem')
AddEventHandler('Hotbar:removeItem',function(slot)
    HOTBAR[slot] = { name = '',key = "", amount = 0, slot = slot,image = ''}
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISABLE TAB
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    HOTBAR = {
        [1] = { name = '', key = "", amount = 0, slot = 1,image = ''},
        [2] = { name = '', key = "", amount = 0, slot = 2,image = ''},
        [3] = { name = '', key = "", amount = 0, slot = 3,image = ''},
        [4] = { name = '', key = "", amount = 0, slot = 4,image = ''},
        [5] = { name = '', key = "", amount = 0, slot = 5,image = ''},
    }
    -- while true do
    --     DisableControlAction(2, 37,  true)
    --     DisableControlAction(1, 37,  true)
    --     HudForceWeaponWheel(false)
    --     HideHudComponentThisFrame(19)
    --     SetPedConfigFlag(PlayerPedId(), 48, true)
    --     Wait(0)
    -- end
end)




















