function SendReactMessage(action, data)
    SendNUIMessage({
        action = action,
        data = data,
    })
end

toggleNuiFrame = function(shouldShow)
    SetNuiFocus(shouldShow, shouldShow)
    SendReactMessage('setVisible', shouldShow)
    if shouldShow then
        -- nuiShowing = true
        StartScreenEffect('MenuMGSelectionIn', 0, true)
        SendReactMessage('ostime', API.updateOstime())
    else
        -- nuiShowing = false
        StopScreenEffect('MenuMGSelectionIn')
        if inTrade then
            inTrade = false
            TriggerServerEvent('trade:close')
        elseif asideType == 'trunk' then
            local vnetid,plate,vname = cache.trunk.vnetid,cache.trunk.plate,cache.trunk.vname
            TriggerServerEvent('closeTrunk:anim', vnetid,plate,vname)
        elseif asideType == 'apreender' or asideType == 'roubar' or asideType == 'revistar' then
            TriggerServerEvent('player:close')
        end
    end
end

RegisterNUICallback('hideFrame', function(data, cb)
    if not LocalPlayer["state"]['inCraft'] then
        toggleNuiFrame(false)
    end
    cb({})
end)

RegisterNetEvent('inventory:close',function()
    toggleNuiFrame(false)
end)

