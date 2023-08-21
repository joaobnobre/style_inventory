

local function UpdateTrunk()
    local content,weight,max,owner = API.getTrunkItens(cache.trunk,IsPedInAnyVehicle(PlayerPedId()))
    content = BuildInventory(content)
    SendReactMessage('frontType', 'aside')
    SendReactMessage('frontMode', 'aside')
    SendReactMessage('showHeader',true)

    SendReactMessage('resetAside')
    SendReactMessage('updateAside', {
        itens = content,
        infos = { 
            max =  max, 
            current = weight,
            name = cache.trunk.vname,
            type = 'trunk',
            text = PedInVehicle()
        },
    })
end

function PedInVehicle()
    if IsPedInAnyVehicle(PlayerPedId()) then
        return 'Porta-luvas'
    else
        return 'Porta-malas'
    end
end

RegisterNetEvent('aside:updateTrunk',UpdateTrunk)

RegisterCommand('+trunk',function()
    if LocalPlayer["state"].Cancel then return end
    local vehicle,vnetid,placa,model,lock = vRP.vehList(5)
    if not vehicle or not vnetid or not placa or not model or lock >= 2 then return end
    cache.trunk = {
        vehicle = vehicle,
        vnetid = vnetid,
        plate = placa,
        vname = model
    }
    
    if API.OpenTrunk(cache.trunk,IsPedInAnyVehicle(PlayerPedId())) then
        asideType = 'trunk'
        TriggerEvent('aside:updateTrunk')
        UpdateInventory()
        toggleNuiFrame(true)
    else
        cache.trunk = {}
    end
end)
RegisterKeyMapping('+trunk', 'Abrir porta malas', 'keyboard', "PAGEUP")

OpenTrunk = function(vehid,trunk)
    if NetworkDoesNetworkIdExist(vehid) then
		local v = NetToVeh(vehid)
		if DoesEntityExist(v) and IsEntityAVehicle(v) then
			if trunk then
				SetVehicleDoorShut(v,5,0)
			else
				SetVehicleDoorOpen(v,5,0,0)
			end
		end
	end
end

RegisterNetEvent('openTrunk:anim',OpenTrunk)
