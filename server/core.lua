
_RegisterCommand = RegisterCommand
function RegisterCommand(command, callback)
    _RegisterCommand(command, function(...)
        local args = {...}

        if not Player(args[1]).state.inRoyale and not Player(args[1]).state.inPvp then
            return callback(table.unpack(args))
        end
    end)
end

local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
local trunks = module('vrp','cfg/inventory')
vRP = Proxy.getInterface('vRP')
vRPC = Tunnel.getInterface('vRP')
vRPclient = Tunnel.getInterface("vRP")

API = {}
Tunnel.bindInterface('inventory',API)
local _itens = itens
iCL = Tunnel.getInterface('inventory')

API.BlockInteractItens = {
    -- ["ticketbronze"] = true,
    -- ["ticketprata"] = true,
    -- ["ticketouro"] = true,
    -- ["ticketdiamante"] = true,
    -- ["ticketarcoiris"] = true,
    ["fichadepescariaorgulhosa"] = true, 
    ["fichadepescaria"] = true, 
    -- ["vehicleluckybox"] = true,
    -- ["itemluckybox"] = true,
    -- ["cashluckybox"] = true,
    -- ["carrovip1"] = true,
    -- ["carrovip2"] = true,
    -- ["carrovip3"] = true,
    -- ["carrovip4"] = true,
}

local webHooks = {
    ['attachs'] = 'https://discord.com/api/webhooks/1096499766763978863/AkSnkb5uVcksLiP0yZzAs96VEIKgSDuoruJyy3ht_uH3ONFPTlMFWYn7YjtoqV34k4xr',
    ['Hotbar Colocou'] = 'https://discord.com/api/webhooks/1096507008124993536/bRprCmK51k-whGhB26R1H5s6NpHf2pjNeRqpKMmu6KR49NcwRRC-nxlfBBTgFbmG6pQh',
    ['Hotbar Retirou'] = 'https://discord.com/api/webhooks/1096507058137874452/xuACKq6gxuY5tsEge3-qGMHUAJZhkkWHUu5L7JOMEcOQTmL0jKeQi2vvm1nJe6tz3HTV',
}

API.wbhClient = function(title,hookInfo)
    local source = source
    local user_id = vRP.getUserId(source)
    if title == 'attachs' then
        if hookInfo.model then
            if hookInfo.tintIndex then
                sendWebhook('Attachs Pintura','**Id:** '..user_id..'\n**Arma**: '..hookInfo.model..'\n**Pintura**: '..hookInfo.tintIndex,webHooks[title])
            elseif hookInfo.attachModel then
                sendWebhook('Attachs Equip.','**Id:** '..user_id..'\n**Arma**: '..hookInfo.model..'\n**Attachs**: '..hookInfo.attachModel,webHooks[title])
            end
        end
    elseif title == 'Hotbar Colocou' or title == 'Hotbar Retirou' then
        if hookInfo.item and hookInfo.amount and hookInfo.slot then
            sendWebhook(title,'**Id:** '..user_id..'\n**Slot**: '..hookInfo.slot..'\n**Item**: '..hookInfo.item..'\n**Quantidade**: '..hookInfo.amount,webHooks[title])
        end
    end
end

sendWebhook = function(title,text,link)
    PerformHttpRequest(link, function(err, text, headers)
    end, 'POST',
    json.encode({
    username = 'Sistema Style',
    embeds =  {{["color"] = 16777215,
                ["author"] = {["name"] = title,
                ["icon_url"] = 'https://i.imgur.com/Jq676iR.jpg'},
                ["description"] = text,
                }
                },
    avatar_url = 'https://i.imgur.com/Jq676iR.jpg'
    }),
    {['Content-Type'] = 'application/json'
    })
end

getArraySize = function(array)
    local counting = 0
    for k,v in next,array do
        counting = counting+1
    end
    return counting
end

API.hasPermission = function(type,index)
    local source =source
    local user_id = vRP.getUserId(source)
    if user_id then
        if type == 'chest' then
            return HasPermission(user_id,chests[index].permission)
        elseif type == 'craft' then
            return HasPermission(user_id,index)
        end
    end
end

actived = {}

RegisterCommand('item',function(source,args,rawCommand)
    if source == 0 then
        local user = tonumber(args[3])
        vRP.giveInventoryItem(user,args[1],parseInt(args[2]))
        print("item enviado")
        return
    end
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"admin.acess") then
        if args[1] and args[2] and itens[args[1]] then
            vRP.giveInventoryItem(user_id,args[1],parseInt(args[2]))

            TriggerClientEvent("Notify",source,"sucesso"," "..args[2].." "..args[1].." adicionado(s) ao seu inventário.")
            --SendWebhookMessage(webhookitem,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GEROU ITEM]: "..args[1].." \n[QUANTIDADE]: "..vRP.format(numberParser(args[2])).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        end
    end
end)

RegisterCommand('itemid',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"admin.acess") then
        if args[1] and args[2] and itens[args[1]] and args[3] then
            vRP.giveInventoryItem(tonumber(args[3]),args[1],parseInt(args[2]))

            TriggerClientEvent("Notify",source,"sucesso"," "..args[2].." "..args[1].." adicionado(s) ao inventário do id "..args[3])
            --SendWebhookMessage(webhookitem,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GEROU ITEM]: "..args[1].." \n[QUANTIDADE]: "..vRP.format(numberParser(args[2])).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        end
    end
end)


RegisterCommand('clinv',function(source,args)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.acess") then
        if user_id and args[1] then
            vRP.clearInventory(tonumber(args[1]))
            TriggerClientEvent("Notify",source,"sucesso","Você limpou o inventário do id "..args[1]..' !' )
        else
            vRP.clearInventory(user_id)
            TriggerClientEvent("Notify",source,"sucesso","Você limpou seu próprio inventário!")
        end
    end
end)


Citizen.CreateThread(function()
    vRP.exportItens(itens)

    -- SetSrvData("chest:u2veh_adder",{})
    -- local src = vRP.getUserSource(8)
    -- vRPC.replaceWeapons(src,{})
    --vRP.addUserGroup(24,'CEO')
    -- print(trunks)
end)

function GetPlayerInfos(user_id)
    local infos = {}
    local i = vRP.getUserIdentity(user_id)

    infos.phone = i.phone
    infos.bank = vRP.getMoney(user_id)
    infos.vip = vRP.getBankMoney(user_id)

    return infos
end

function GetPlayerWeapon(source,weapon)
    local weapons = vRPclient.getWeapons(source)
    -- print(json.encode(weapons))
    return weapons
end

local copsOnService = {
    'comando',
    'coronel',
    'tenentecoronel',
    'major',
    'capitao',
    'primeirotenente',
    'segundotenente',
    'aspirante',
    'subtenente',
    'primeirosargento',
    'segundosargento',
    'terceirosargento',
    'cabo',
    'soldado',
    'delegadocivil',
    'adjuntocivil',
    'diretorcivil',
    'escrivaocivil',
    'investigadorcivil',
    'peritocivil',
}

checkGarmas = function(source)
    local user_id = vRP.getUserId(source)
    for k,v in next,copsOnService do
        if vRP.hasGroup(user_id,v) then
            return true
        end
    end
end

function Garmas(source,tipo,tipoId)
    local checkGarmasVar = checkGarmas(source)
    if not checkGarmasVar then
        local new = {}
        local _ = vRPclient.replaceWeapons(source,{})
        for k,v in pairs(_) do
            if weapon_model[k] then
                new[weapon_model[k][1]] = v.ammo
            end
        end
        
        local saveTxt = '**Id:** '..vRP.getUserId(source)..'\n**Guardou:** '
        local countDown = 0
        for k,v in next,new do
            countDown = countDown+1
            if countDown == getArraySize(new) then
                saveTxt = saveTxt..'x'..v..' '..k..'\n**Motivo:** '..tipo..', '..tipoId
            else
                saveTxt = saveTxt..'x'..v..' '..k..', '
            end
        end
        if countDown >= 1 then
            sendWebhook('Garmas',saveTxt,'https://discord.com/api/webhooks/1096145878743535616/wvwrdcwCq8JedjLgk2pqW8SHS9yRKOFhc1V0nT3kkn_QIlgOCqZgFdvudgYcW5-fvweg')
        end
        return new
    else
        TriggerClientEvent('Notify', source, 'negado', 'Suas armas não podem retornar à mochila pois você está em expediente.', 5733)
        return false
    end
end

function HasPermission(user_id,perm)
    return vRP.hasPermission(user_id,perm)
end

function GetNearestPlayer(source)
    return vRPclient.getNearestPlayer(source,2)
end

function GetOwnerVehicle(plate)
    return vRP.getVehiclePlate(plate)
end

function GetTrunkSize(model,gc)
    if gc then return 5 end
    return trunks.chestweight[model] or 100
end

function GetVehInfo(source)
    local a,b,c,d,e,g,h,i,j = vRPclient.vehList(source,7)
    return {vname,plate}
end

function SetSrvData(key,data)
    vRP.setSData(key,json.encode(data))
end

function GetSrvData(key)
    return json.decode(vRP.getSData(key)) or {}
end

function GerateAsideWeight(Object)
    local n = 0
    for k,v in pairs(Object) do
        local nameItem = splitString(k,"-")
        n = n + (GetItemWeight(nameItem[1]) * v.amount)
    end
    return n
end

function GetInventory(user_id)
    return vRP.getInventory(user_id)
end

function GetMaxWeight(user_id)
    return vRP.getInventoryMaxWeight(user_id)
end

function GetWeight(user_id)
    return vRP.getInventoryWeight(user_id)
end

function TryItem(user_id,item,amount,use)
    return vRP.tryGetInventoryItem(user_id,item,amount,use)
end

function GiveItem(user_id,item,amount,duration,usage)
    vRP.giveInventoryItem(user_id,item,amount,duration,usage)
end

function GetItemAmount(user_id,item)
    return vRP.getInventoryItemAmount(user_id,item)
end

function GetTableSize(table)
    local n = 0
    for k,v in pairs(table) do
        n = n + 1
    end
    return n
end

function StorePayment(user_id,price)
    return vRP.tryFullPayment(user_id,price)
end

function GetUserName(user_id)
    local i = vRP.getUserIdentity(user_id)
    return i.name..' '..i.firstname
end

PlayAnim = function(source,status,table,bool)
    vRPclient.playAnim(source,status,table,bool)
end

StopAnim = function(source)
    vRPclient.stopAnim(source,false)
end
