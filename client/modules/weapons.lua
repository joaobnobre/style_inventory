iCL.GetAmmoWeapon = function(weapon)
    local v = GetAmmoInPedWeapon(PlayerPedId(),GetHashKey(weapon))
    SetPedAmmo(PlayerPedId(), GetHashKey(weapon),0)
    return v
end

iCL.GetAmmoWeaponNumber = function(weapon)
    local v = GetAmmoInPedWeapon(PlayerPedId(),GetHashKey(weapon))
    return v
end

local whitelistWeaponTypes = {
    '-728555052',
    -- '',
    -- GetWeapontypeGroup(GetHashKey(weapon_model))
}

iCL.checkWeaponTypeEquiped = function(weapon)
    local weaponType = GetWeapontypeGroup(GetHashKey(weapon))
    for _,w in next,whitelistWeaponTypes do
        if tostring(weaponType) == w then
            return true
        end
    end
    for k,v in next,vRP.getWeapons() do
        if GetWeapontypeGroup(GetHashKey(k)) == weaponType then
            return false
        end
    end
    return true
end

local skins = {
    ['init'] = {
        ['0'] = '#000',
        ['1'] = '#029939',
        ['2'] = '#ffd700',
        ['3'] = '#ff80ed',
        ['4'] = '#ffe4e1',
        ['5'] = '#0000ff',
        ['6'] = '#ffc100',
        ['7'] = '#E5E4E2',
    },
    ['mk2'] = {
        ['0'] = '#000',
        ['1'] = '#808080',
        ['2'] = '#000',
        ['3'] = '#fff',
        ['4'] = '#F5F5DC',
        ['5'] = '#029939',
        ['6'] = '#0000FF',
        ['7'] = '#4f4cb0',
        ['8'] = '#8d5524',
        ['9'] = '#d62d20',
        ['10'] = '#0057e7',
        ['11'] = '#ffe700',
        ['12'] = '#ffa700',
        ['13'] = '#f000ff',
        ['14'] = '#b967ff',
        ['15'] = '#ffa700',
        ['16'] = '#05ffa1',
        ['17'] = '#ff0000',
        ['18'] = '#000',
        ['19'] = '#000',
        ['20'] = '#000',
        ['21'] = '#000',
        ['22'] = '#000',
        ['23'] = '#000',
        ['24'] = '#000',
        ['25'] = '#000',
        ['26'] = '#000',
        ['27'] = '#000',
        ['28'] = '#000',
        ['29'] = '#000',
        ['30'] = '#000',
        ['31'] = '#000',
        ['32'] = '#ff0000',
    }
}

local function UpdateAttachs(weapon)
    print(weapon)
    local model = GetWeaponModel(weapon)
    print(model)
    local custom = attachs[model]
    print(custom)
    local content = {}
    for k,v in pairs(custom) do
        local component = HasPedGotWeaponComponent(PlayerPedId(),GetHashKey(model),GetHashKey(v))
        if attachsConfig[v] then
            print(component)
            table.insert(content,{
                ['name'] = attachsConfig[v].name,
                ['image'] = attachsConfig[v].image,
                ['item'] = attachsConfig[v].item,
                ['equiped'] = component == 1,
                ['model'] = v,
                ['weapon'] = weapon
            })
        end
    end
    local nameItem = splitString(model,"_")
    SendReactMessage('updateWeaponAttachs',content)
end

RegisterNUICallback('attachs:get',function(data,cb)
    
    local modelWeapon = GetWeaponModel(data.key)
    local custom = attachs[modelWeapon]
    local content = {}
    for k,v in pairs(custom) do
        local component = HasPedGotWeaponComponent(PlayerPedId(),GetHashKey(modelWeapon),GetHashKey(v))
        if attachsConfig[v] then
            table.insert(content,{
                ['name'] = attachsConfig[v].name,
                ['image'] = attachsConfig[v].image,
                ['item'] = attachsConfig[v].item,
                ['equiped'] = component == 1,
                ['model'] = v,
                ['weapon'] = data.key
            })
        end
    end
    local nameItem = splitString(modelWeapon,"MK2")
    if not nameItem then
        SendReactMessage('updateWeaponSkins',skins['init'])
    else
        SendReactMessage('updateWeaponSkins',skins['mk2'])
    end
    SendReactMessage('updateWeaponAttachs',content)
    
    cb('')

end)

RegisterNUICallback('attachs:equipe',function(data,cb)
    local drop,attach = data.drop,data.attach
    if drop.key == attach.item then
        local modelWeapon = GetWeaponModel(attach.weapon)
        local ped = PlayerPedId()
		GiveWeaponComponentToPed(ped,GetHashKey(modelWeapon),GetHashKey(attach.model))
        UpdateAttachs(attach.weapon)
        API.wbhClient('attachs',{model = modelWeapon,attachModel = attach.model})
    end
    cb('')

end)

RegisterNUICallback('attachs:skin',function(data,cb)
    local tintIndex,weapon = data.index,data.weapon
    if tintIndex and weapon then
        local model = GetWeaponModel(weapon)
        SetPedWeaponTintIndex(PlayerPedId(),GetHashKey(model),tintIndex)
        API.wbhClient('attachs',{model = model,tintIndex = tintIndex})
    end
    cb('')

end)