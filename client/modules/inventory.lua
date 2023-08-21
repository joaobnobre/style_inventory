RegisterCommand('inv',function()
    if LocalPlayer["state"].Cancel then return end
    if not (GetEntityHealth(PlayerPedId()) > 101) then return end
    if vRP.isHandcuffed() then TriggerEvent('Notify','negado','Você não pode acessar sua mochila algemado.') return end
    OpenInventory()
    SendReactMessage('frontType', 'inventory')
    SendReactMessage('frontMode', 'inventory')
    toggleNuiFrame(true)
end)
RegisterKeyMapping('inv', 'Abrir inventario', 'keyboard', "Oem_3")

RegisterNUICallback('useItem',function(data,cb)
    toggleNuiFrame(false)
    API.UseItem(data.key,data.duration)
    cb({})
end)

RegisterNUICallback('inventory:gweapon',function(data,cb)
    local item = data.key
    if API.gweapon(item) then
        UpdateInventory()
    end
    cb({})
end)

RegisterNUICallback('inventory:equipweapon',function(data,cb)
    local item,duration = data.key,data.duration
    item = string.gsub(item, "%s", "")
    if not item then return end
    if GetItemType(item) == 'weapon' then
        if API.equipweapon(item,duration) then
            UpdateInventory()
        end
    elseif GetItemType(item) == 'ammo' then
        local amount = data.amount
        local weapon = GetWeaponFromAmmo(item)
        local current = GetAmmoInPedWeapon(PlayerPedId(),GetWeaponHash(weapon))
        if current >= GetMaxAmmoWeapon(weapon) then cb({}) return end
        if current + amount > GetMaxAmmoWeapon(weapon) and  weapon ~= 'gasolina' then
            amount = GetMaxAmmoWeapon(weapon) - current
        end
        if API.equipammo(item,amount) then
            AddAmmoToPed(PlayerPedId(),GetWeaponHash(weapon),amount)
            UpdateInventory()
        end
    end
    cb({})
end)

RegisterNetEvent('inventory:update',UpdateInventory)



