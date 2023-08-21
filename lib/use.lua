local Tunnel = module("vrp", "lib/Tunnel")
local Tools = module("vrp", "lib/Tools")
local idgens = Tools.newIDGenerator()
local vRPclient = Tunnel.getInterface("vRP")
vGARAGE = Tunnel.getInterface("vrp_garages")
vTASKBAR = Tunnel.getInterface("style-taskbar")
vADMIN = Tunnel.getInterface('core_admin')

local pick = {}

local bandagem = {}

consumeItem = {}
exports("ConsumeItem", function(user_id)
    return consumeItem[user_id]
end)

CreateThread(function()
    vRP._prepare('selectGaragem', 'SELECT garage FROM vrp_user_identities WHERE user_id=@user_id')
    vRP._prepare('updateTamanhoGaragem', 'UPDATE vrp_user_identities SET garage=@garagem WHERE user_id=@user_id')

    vRP._prepare('updateNome',
        'UPDATE vrp_user_identities SET name = @name,firstname = @firstname WHERE user_id = @user_id')

    vRP._prepare('selectAllNumbers', 'SELECT phone FROM vrp_user_identities')
    vRP._prepare('updateNumber', 'UPDATE vrp_user_identities SET phone = @phone WHERE user_id = @user_id')

    vRP._prepare('selectAllRgs', 'SELECT registration FROM vrp_user_identities')
    vRP._prepare('updateRg', 'UPDATE vrp_user_identities SET registration = @registration WHERE user_id = @user_id')
    vRP._prepare('secondUpdateRg', 'UPDATE vrp_srv_data SET dkey = @dkey WHERE dkey LIKE @specVar')
    vRP._prepare('selectUpdateRg', 'SELECT * FROM vrp_srv_data WHERE dkey LIKE @specVar')
end)

webhook = function(webhook, message)
    if webhook ~= nil and webhook ~= "" then
        PerformHttpRequest(webhook, function(err, text, headers)
        end, 'POST', json.encode({
            content = message
        }), {
            ['Content-Type'] = 'application/json'
        })
    end
end
local Stockade = {}
local Active = {}

USEITEM = function(source, user_id, item, duration)
    if source and user_id and item then
        local ostime = API.updateOstime()
        if not consumeItem[user_id] then
            -- [ CARROS ] --
            if item == 'suspensaoar' then
                TriggerClientEvent('inventory:close', source)
                TriggerClientEvent('zo_install_suspe_ar', source)

            elseif item == "uvlight" then
                TriggerClientEvent("kg_evidence:checkForFingerprints", source)

            elseif item == "notebookprotegido" then
                TriggerClientEvent("show-nuiRaces", source)

            elseif item == 'moduloneon' then
                TriggerClientEvent('inventory:close', source)
                TriggerClientEvent('zo_install_mod_neon', source)

            elseif item == 'moduloxenon' then
                TriggerClientEvent('inventory:close', source)
                TriggerClientEvent('zo_install_mod_xenon', source)

                -- [ PIERCER ] --
            elseif item == 'vape' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source, 'anim@heists@humane_labs@finale@keycards', 'ped_a_enter_loop',
                        'ba_prop_battle_vape_01', 49, 18905, 0.08, -0.00, 0.03, -150.0, 90.0, -10.0)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('progress', source, 60000, 'fumando')
                    SetTimeout(60000, function()
                        -- TriggerClientEvent('energeticos', src, true)
                        TriggerClientEvent('cancelando', source, false)
                    end)
                else
                    TriggerClientEvent('Notify', source, 'negado', 'Você não tem um Vape para fumar')
                end

                -- [ ITENS PARA TROCAR INFOS (SQL) ] --
            elseif item == 'kitdemergulho' then
                if vRP.getInventoryItemAmount(user_id, item) >= 1 then
                    TriggerClientEvent('inventory:close', source)

                    if GetEntityModel(ped) == GetHashKey('mp_m_freemode_01') then
                        vRP._playAnim(true, {{'clothingshirt', 'try_shirt_positive_d'}}, false)
                        Wait(2500)
                        ClearPedTasks(ped)
                        local ped = GetPlayerPed(source)
                        SetPedScubaGearVariation(ped)
                        SetEnableScuba(ped, true)
                        SetPedComponentVariation(ped, 8, 123, 0, 2)
                    elseif GetEntityModel(ped) == GetHashKey('mp_f_freemode_01') then
                        vRP._playAnim(true, {{'clothingshirt', 'try_shirt_positive_d'}}, false)
                        Wait(2500)
                        ClearPedTasks(ped)
                        local ped = GetPlayerPed(source)
                        SetPedScubaGearVariation(ped)
                        SetEnableScuba(ped, true)
                        SetPedComponentVariation(ped, 8, 123, 0, 2)
                    end
                end
            elseif item == 'garagem' then
                if vRP.getInventoryItemAmount(user_id, 'garagem') >= 1 then
                    TriggerClientEvent("+invClose", source)

                    local actualGaragem = vRP.query('selectGaragem', {
                        user_id = user_id
                    })
                    if actualGaragem[1] then
                        vRP.tryGetInventoryItemByUse(user_id, 'garagem', 1)
                        vRP.execute('updateTamanhoGaragem', {
                            user_id = user_id,
                            garagem = actualGaragem[1].garage + 1
                        })
                        TriggerClientEvent('Notify', source, 'sucesso',
                            'Você recebeu uma vaga adicional em sua garagem!')
                    end
                end
            elseif item == 'certidao' then
                if vRP.getInventoryItemAmount(user_id, 'certidao') >= 1 then
                    TriggerClientEvent("+invClose", source)

                    local newName = vRP.prompt(source, 'Digite seu novo nome', '')
                    if newName and tostring(newName) and #newName >= 3 then
                        local newFirstName = vRP.prompt(source, 'Digite seu novo sobrenome', '')
                        if newFirstName and tostring(newFirstName) and #newFirstName >= 3 then
                            vRP.tryGetInventoryItemByUse(user_id, 'certidao', 1)
                            vRP.execute('updateNome', {
                                user_id = user_id,
                                name = newName,
                                firstname = newFirstName
                            })
                            TriggerEvent('identity:atualizar', user_id)
                            TriggerClientEvent('Notify', source, 'sucesso', 'Você atualizou seu nome com sucesso!')
                        else
                            webhook(webhookidentidade,
                                '```ini\n[CERTIDÃO]:\n[ID]: ' .. user_id .. ' ' .. identity.name .. ' ' ..
                                    identity.firstname .. '\n[ALTEROU O NOME PARA]: ' .. user_id .. ' ' .. nome .. ' ' ..
                                    sobrenome .. ' ' .. os.date('\n[DATA]: %d/%m/%Y [Hora]: %H:%M:%S') .. ' \r```')
                            TriggerClientEvent('Notify', source, 'negado', 'Digite um sobrenome válido.')
                        end
                    else
                        TriggerClientEvent('Notify', source, 'negado', 'Digite um nome válido.')
                    end
                end
            elseif item == 'placavip' then
                if vRP.getInventoryItemAmount(user_id, 'placavip') >= 1 then
                    TriggerClientEvent("+invClose", source)

                    local newRg = vRP.prompt(source, 'Digite seu novo registro', '')
                    if newRg and tostring(newRg) and #newRg >= 3 then
                        local allRgs = vRP.query('selectAllRgs')

                        for k, v in next, allRgs do
                            if tostring(v.registration) == tostring(newRg) then
                                TriggerClientEvent('Notify', source, 'negado', 'Esse registro já está em uso.')
                                return false
                            end
                        end

                        local resultData = vRP.query('selectUpdateRg', {
                            specVar = '%customVehicle:u' .. user_id .. '%'
                        })
                        if resultData[1] then
                            local identity = vRP.getUserIdentity(user_id)
                            local oldRg = identity.registration
                            local changeable = resultData[1].dkey
                            changeable = string.gsub(changeable, 'placa_' .. oldRg, 'placa_' .. newRg)
                            vRP.execute('secondUpdateRg', {
                                dkey = changeable,
                                specVar = '%customVehicle:u' .. user_id .. '%'
                            })
                        end

                        vRP.execute('updateRg', {
                            user_id = user_id,
                            registration = newRg
                        })

                        vRP.tryGetInventoryItemByUse(user_id, 'placavip', 1)
                        TriggerEvent('identity:atualizar', user_id)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Você atualizou seu registro com sucesso!')
                    else
                        TriggerClientEvent('Notify', source, 'negado', 'Digite um registro válido.')
                    end
                end

            elseif item == 'chipvip' then
                if vRP.getInventoryItemAmount(user_id, 'chipvip') >= 1 then
                    TriggerClientEvent("+invClose", source)

                    local newNumber = vRP.prompt(source, 'Digite seu novo número', '')
                    if newNumber and tonumber(newNumber) and #newNumber >= 1 then
                        local allNumbers = vRP.query('selectAllNumbers')

                        for k, v in next, allNumbers do
                            if tonumber(v.phone) == tonumber(newNumber) then
                                TriggerClientEvent('Notify', source, 'negado', 'Esse número já está em uso.')
                                return false
                            end
                        end

                        vRP.tryGetInventoryItemByUse(user_id, 'chipvip', 1)
                        vRP.execute('updateNumber', {
                            user_id = user_id,
                            phone = newNumber
                        })
                        TriggerEvent('identity:atualizar', user_id)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Você atualizou seu número com sucesso!')
                    else
                        TriggerClientEvent('Notify', source, 'negado', 'Digite um número válido.')
                    end
                end

                -- [ ITENS PARA ANIMAÇÃO ] --
            elseif item == 'bong' then
                if vRP.getInventoryItemAmount(user_id, item) >= 1 then
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('emotes', source, 'bong')
                end

            elseif item == 'pano' then
                if vRP.getInventoryItemAmount(user_id, item) >= 1 then
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('emotes', source, 'pano')
                end

            elseif item == 'binoculos' then
                if vRP.getInventoryItemAmount(user_id, item) >= 1 then
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('emotes', source, 'binoculos')
                end

            elseif item == 'radio2' then
                if vRP.getInventoryItemAmount(user_id, item) >= 1 then
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('emotes', source, 'radio2')
                end

            elseif item == 'tablet' then
                if vRP.getInventoryItemAmount(user_id, item) >= 1 then
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('emotes', source, 'tablet')
                end

            elseif item == 'prancheta' then
                if vRP.getInventoryItemAmount(user_id, item) >= 1 then
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('emotes', source, 'prancheta')
                end

            elseif item == 'vassoura' then
                if vRP.getInventoryItemAmount(user_id, item) >= 1 then
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('emotes', source, 'vassoura')
                end

            elseif item == 'varapesca' then
                if vRP.getInventoryItemAmount(user_id, item) >= 1 then
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('pescador', source)
                end

            elseif item == 'radio' then
                if vRP.getInventoryItemAmount(user_id, item) >= 1 and not vRPclient.isHandCuffed(source) then
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('radioGui', source)
                end

            elseif item == 'malaviagem' then
                if vRP.getInventoryItemAmount(user_id, item) >= 1 then
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('emotes', source, 'bolsa5')
                end

            elseif item == 'rosa' then
                if vRP.getInventoryItemAmount(user_id, item) >= 1 then
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('emotes', source, 'rosa')
                end

            elseif item == 'microfone' then
                if vRP.getInventoryItemAmount(user_id, item) >= 1 then
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('emotes', source, 'mic')
                end

            elseif item == 'caixa' then
                if vRP.getInventoryItemAmount(user_id, item) >= 1 then
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('emotes', source, 'caixa')
                end

            elseif item == 'urso' then
                if vRP.getInventoryItemAmount(user_id, item) >= 1 then
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('emotes', source, 'urso')
                end

            elseif item == 'livro' then
                if vRP.getInventoryItemAmount(user_id, item) >= 1 then
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('emotes', source, 'livro')
                end

            elseif item == 'fogos' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('frobski-fireworks:start', source)
                end

            elseif item == 'baseado' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('emotes', source, 'fumar4')
                    TriggerClientEvent('ocelot_drugeffects:maconha', source)
                    TriggerClientEvent('style-audios:source', source, 'tosse', 0.5)
                    vRPclient.setHealth(source, (vRPclient.getHealth(source) + 30))
                end

            elseif item == 'blocodenotas' then
                if vRP.getInventoryItemAmount(user_id, item) >= 1 then
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('emotes', source, 'anotar')
                end

            elseif item == 'cigarro' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('emotes', source, 'fumar5')
                    TriggerClientEvent('style-audios:source', source, 'tosse', 0.5)
                end

            elseif item == 'postit' then
                if vRP.getInventoryItemAmount(user_id, item, 1) then
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent("style-notepad:createNotepad", source)
                end

                -- [ DROGAS ] --
            elseif item == 'cocaina' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    consumeItem[user_id] = true
                    vRPclient._playAnim(source, true,
                        {{"anim@amb@nightclub@peds@", "missfbi3_party_snort_coke_b_male3"}}, true)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', source, true)
                    TriggerClientEvent('progress', source, 10000, 'cheirando')
                    SetTimeout(10000, function()
                        consumeItem[user_id] = nil
                        TriggerClientEvent('tempStamina', source, 300)
                        vRPclient._stopAnim(source, false)
                        vRPclient.playScreenEffect(source, 'RaceTurbo', 10)
                        vRPclient.playScreenEffect(source, 'DrugsTrevorClownsFight', 10)
                        TriggerClientEvent('cancelando', source, false)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Cocaína utilizada com sucesso.', 8000)
                    end)
                end

            elseif item == 'rivotril' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    vRPclient._playAnim(source, true,
                        {{"anim@amb@nightclub@peds@", "missfbi3_party_snort_coke_b_male3"}}, true)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', source, true)
                    TriggerClientEvent('progress', source, 10000, 'cheirando')
                    SetTimeout(10000, function()
                        consumeItem[user_id] = nil
                        TriggerClientEvent('acid', source)
                        vRPclient._stopAnim(source, false)
                        vRPclient.playScreenEffect(source, 'RaceTurbo', 10)
                        vRPclient.playScreenEffect(source, 'DrugsTrevorClownsFight', 10)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Rivotril utilizada com sucesso.', 8000)
                    end)
                end

            elseif item == 'skunk' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('emotes', source, 'fumar4')
                    TriggerClientEvent('style-audios:source', source, 'tosse', 0.5)
                    -- vRPclient._playAnim(source,true,{{"amb@world_human_aa_smoke@male@idle_a","idle_c","prop_cs_ciggy_01",49,28422}},true)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('progress', source, 10000, 'fumando')
                    SetTimeout(10000, function()
                        consumeItem[user_id] = nil
                        -- TriggerClientEvent('acid',source)
                        vRPclient._stopAnim(source, false)
                        -- vRPclient.playScreenEffect(source,'RaceTurbo',10)
                        -- vRPclient.playScreenEffect(source,'DrugsTrevorClownsFight',10)
                        exports["snt_modules2"]:setCharacterResidueTime(user_id, "marihuana")
                        TriggerClientEvent('ocelot_drugeffects:brisaboa', source)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Skunk utilizada com sucesso.', 8000)
                    end)
                end

            elseif item == 'prensado' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('emotes', source, 'fumar4')
                    TriggerClientEvent('style-audios:source', source, 'tosse', 0.5)
                    -- vRPclient._playAnim(source,true,{{"amb@world_human_aa_smoke@male@idle_a","idle_c","prop_cs_ciggy_01",49,28422}},true)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('progress', source, 10000, 'fumando')
                    SetTimeout(10000, function()
                        consumeItem[user_id] = nil
                        -- TriggerClientEvent('acid',source)
                        vRPclient._stopAnim(source, false)
                        -- vRPclient.playScreenEffect(source,'RaceTurbo',10)
                        -- vRPclient.playScreenEffect(source,'DrugsTrevorClownsFight',10)
                        TriggerClientEvent('ocelot_drugeffects:brisaleve', source)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Prensadinho utilizada com sucesso.', 8000)
                    end)
                end

            elseif item == 'heroina' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    vRPclient._playAnim(source, true,
                        {{"anim@amb@nightclub@peds@", "missfbi3_party_snort_coke_b_male3"}}, true)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('progress', source, 10000, 'injetando')
                    SetTimeout(10000, function()
                        consumeItem[user_id] = nil
                        vRPclient._stopAnim(source, false)
                        -- vRPclient.playScreenEffect(source,'RaceTurbo',10)
                        -- vRPclient.playScreenEffect(source,'DrugsTrevorClownsFight',10)
                        TriggerClientEvent('ocelot_drugeffects:heroina', source)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Heroina utilizada com sucesso.', 8000)
                    end)
                end

            elseif item == 'metanfetamina' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    vRPclient._playAnim(source, true,
                        {{"anim@amb@nightclub@peds@", "missfbi3_party_snort_coke_b_male3"}}, true)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('progress', source, 10000, 'usando')
                    SetTimeout(10000, function()
                        consumeItem[user_id] = nil
                        TriggerClientEvent('acid', source)
                        vRPclient._stopAnim(source, false)
                        vRPclient.playScreenEffect(source, 'RaceTurbo', 10)
                        vRPclient.playScreenEffect(source, 'DrugsTrevorClownsFight', 10)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Metanfetamina utilizada com sucesso.', 8000)
                    end)
                end

            elseif item == 'lsd' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    vRPclient._playAnim(source, true, {{'mp_suicide', 'pill'}}, true)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('progress', source, 10000, 'colocando na boca')
                    SetTimeout(10000, function()
                        consumeItem[user_id] = nil
                        -- TriggerClientEvent('acid',source)
                        vRPclient._stopAnim(source, false)
                        -- vRPclient.playScreenEffect(source,'RaceTurbo',10)
                        -- vRPclient.playScreenEffect(source,'DrugsTrevorClownsFight',10)
                        TriggerClientEvent('ocelot_drugeffects:lsd', source)
                        TriggerClientEvent('Notify', source, 'sucesso', 'LSD utilizado com sucesso.', 8000)
                    end)
                end

            elseif item == 'haxixe' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    vRPclient._playAnim(source, true, {{"amb@world_human_aa_smoke@male@idle_a", "idle_c",
                                                        "prop_cs_ciggy_01", 49, 28422}}, true)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('progress', source, 10000, 'fumando')
                    SetTimeout(10000, function()
                        consumeItem[user_id] = nil
                        -- TriggerClientEvent('acid',source)
                        vRPclient._stopAnim(source, false)
                        -- vRPclient.playScreenEffect(source,'RaceTurbo',10)
                        -- vRPclient.playScreenEffect(source,'DrugsTrevorClownsFight',10)
                        TriggerClientEvent('ocelot_drugeffects:maconha', source)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Haxixe utilizado com sucesso.', 8000)
                    end)
                end

            elseif item == 'lanca' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source, 'amb@incar@male@smoking@enter', 'enter', 'mah_lanca', 49, 28422)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('progress', source, 30000, 'baforando')
                    SetTimeout(30000, function()
                        vRPclient.playScreenEffect(source, 'RaceTurbo', 180)
                        vRPclient.playScreenEffect(source, 'DrugsTrevorClownsFight', 180)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Lança utilizado com sucesso.', 8000)

                        vthirst = -10
                        vRP.varyThirst(user_id, vthirst)
                    end)
                end

            elseif item == 'lancab' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source, 'amb@incar@male@smoking@enter', 'enter', 'mah_lanca_02', 49, 28422)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('progress', source, 30000, 'baforando')
                    SetTimeout(30000, function()
                        vRPclient.playScreenEffect(source, 'RaceTurbo', 180)
                        vRPclient.playScreenEffect(source, 'DrugsTrevorClownsFight', 180)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Lança utilizado com sucesso.', 8000)

                        vthirst = -10
                        vRP.varyThirst(user_id, vthirst)
                    end)
                end

                -- [ PELUCIAS ] --
            elseif item == 'coelho1' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source, 'impexp_int-0', 'mp_m_waremech_01_dual-0', 'bag_bunny', 49, 24817)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('progress', source, 10000, 'bebendo')
                    SetTimeout(50000, function()
                        -- TriggerClientEvent('energeticos', src, true)
                        TriggerClientEvent('cancelando', source, false)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Você bebeu um <b>Monster</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', source, 'negado', 'Você não tem um Monster para beber')
                end

                -- [ HOSPITAL ] --
            elseif item == 'bandagem' then
                -- if vRPclient.getHealth(source) > 101 then
                --     if bandagem[user_id] == 0 or not bandagem[user_id] then
                local hh = vRPclient.getHealth(source)
                if hh > 101 and hh < 337 then
                    -- if bandagem[user_id] == 0 or not bandagem[user_id] then
                    if not vRPclient.isInVehicle(source) then
                        if vRP.getInventoryItemAmount(user_id, "bandagem") >= 1 then

                            local source = source
                            local taskSetup = {
                                type = 11,
                                dificulty = 3,
                                title = "Bandagem", -- caso seja nulo, o script irá utilizar o padrão
                                description = "" -- caso seja nulo, o script irá utilizar o padrão
                            }

                            local resposta = vRP.task(source, taskSetup)

                            if resposta then

                                bandagem[user_id] = 120
                                consumeItem[user_id] = true
                                vRPclient._CarregarObjeto(source, 'amb@world_human_clipboard@male@idle_a', 'idle_c',
                                    'v_ret_ta_firstaid', 49, 60309)
                                TriggerClientEvent('inventory:close', source)
                                TriggerClientEvent('+invUpdate', source, 'inventory')
                                TriggerClientEvent('cancelando', source, true)
                                TriggerClientEvent('progress', source, 20000, 'bandagem')
                                TriggerClientEvent('style_audios:source', source, 'bandage', 0.5)
                                SetTimeout(20000, function()
                                    consumeItem[user_id] = nil
                                    vRP.tryGetInventoryItem(user_id, "bandagem", 1)
                                    TriggerClientEvent('bandagem', source)
                                    TriggerClientEvent('cancelando', source, false)
                                    vRPclient._DeletarObjeto(source)
                                    TriggerClientEvent('Notify', source, 'sucesso', 'Bandagem utilizada com sucesso.',
                                        8000)
                                    Citizen.Wait(10000)
                                end)
                            end
                        end
                    else
                        -- TriggerClientEvent('Notify',source,'importante','Aguarde '..vRPclient.getTimeFunction(source,parseInt(bandagem[user_id]))..'.',8000)
                        TriggerClientEvent('Notify', source, 'importante', 'Não é possível utilizar em veículos!',
                            8000)
                    end
                else
                    TriggerClientEvent('Notify', source, 'negado',
                        'Você não pode utilizar com mais de 75% de vida ou nocauteado.', 8000)
                end

            elseif item == 'adrenalina1' then
                if vRP.tryGetInventoryItem(user_id, "adrenalina1", 1) then
                    TriggerClientEvent('cancelando', source, true)
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    vRPclient._playAnim(source, true, {{'mp_player_intdrink', 'loop_bottle'}}, true)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('progress', source, 10000, 'Usando Adrenalina I')
                    SetTimeout(10000, function()
                        TriggerClientEvent('tempStamina', source, 1800)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._stopAnim(source, false)

                        vthirst = 25
                        vRP.varyThirst(user_id, vthirst)
                        vhunger = 25
                        vRP.varyHunger(user_id, vhunger)

                        TriggerClientEvent('Notify', source, 'sucesso', 'Adrenalina utilizado com sucesso.', 8000)
                        TriggerClientEvent('Notify', source, 'sucesso', 'O efeito da Adrenalina I irá durar 30min.',
                            8000)
                    end)
                end

            elseif item == 'adrenalina2' then
                if vRP.tryGetInventoryItem(user_id, "adrenalina2", 1) then
                    TriggerClientEvent('cancelando', source, true)
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    vRPclient._playAnim(source, true, {{'mp_player_intdrink', 'loop_bottle'}}, true)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('progress', source, 8000, 'Usando Adrenalina II')
                    SetTimeout(8000, function()
                        TriggerClientEvent('tempStamina', source, 2100)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._stopAnim(source, false)

                        vthirst = 20
                        vRP.varyThirst(user_id, vthirst)
                        vhunger = 20
                        vRP.varyHunger(user_id, vhunger)

                        TriggerClientEvent('Notify', source, 'sucesso', 'Adrenalina utilizado com sucesso.', 8000)
                        TriggerClientEvent('Notify', source, 'sucesso', 'O efeito da Adrenalina II irá durar 35min.',
                            8000)
                    end)
                end

            elseif item == 'adrenalina3' then
                if vRP.tryGetInventoryItem(user_id, "adrenalina3", 1) then
                    TriggerClientEvent('cancelando', source, true)
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    vRPclient._playAnim(source, true, {{'mp_player_intdrink', 'loop_bottle'}}, true)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('progress', source, 6000, 'Usando Adrenalina III')
                    SetTimeout(6000, function()
                        TriggerClientEvent('tempStamina', source, 2400)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._stopAnim(source, false)

                        vthirst = 15
                        vRP.varyThirst(user_id, vthirst)
                        vhunger = 15
                        vRP.varyHunger(user_id, vhunger)

                        TriggerClientEvent('Notify', source, 'sucesso', 'Adrenalina utilizado com sucesso.', 8000)
                        TriggerClientEvent('Notify', source, 'sucesso', 'O efeito da Adrenalina III irá durar 40min.',
                            8000)
                    end)
                end

                -- [ HOSPITAL ILEGAL ] --
                -- elseif item == 'anabolizante' then
                --     if  vRP.tryGetInventoryItemByUse(user_id, item, 1,true) then
                --         TriggerClientEvent('cancelando', source, true)
                --         TriggerClientEvent('+invUpdate', source, 'inventory')
                --         vRPclient._playAnim(source, true, {{'mp_player_intdrink', 'loop_bottle'}}, true)
                --         TriggerClientEvent('inventory:close',source)
                --         TriggerClientEvent('progress', source, 5000, 'INJETANDO O ANABOLIZANTE')
                --         SetTimeout(5000, function()
                --             TriggerClientEvent('energeticos', source, true)
                --             TriggerClientEvent('cancelando', source, false)
                --             vRPclient._stopAnim(source, false)
                --             TriggerClientEvent('Notify', source, 'sucesso', 'Anabolizante injetada com sucesso.', 8000)
                --         end)
                --     end

                -- [ LAVAR MÃOS COM POLVORA ] --
            elseif item == 'alcool' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)

                    vRPclient.playAnim(source, true, {{"switch@franklin@chopshop", "wipehands"}}, true)
                    TriggerClientEvent("progress", source, 5000, "Limpando as mãos")
                    SetTimeout(5000, function()
                        vRPclient._stopAnim(source, false)
                        -- TriggerServerEvent('powder_washhands')
                    end)
                end

                -- [ REMOVER CAPUZ COM TESOURA ] --
            elseif item == 'tesoura' then
                TriggerClientEvent('+invUpdate', source, 'inventory')
                TriggerClientEvent('inventory:close', source)

                local nearestP = vRPclient.getNearestPlayer(source, 2)
                if nearestP then
                    if vRPclient.isCapuz(nearestP) then
                        if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                            vRPclient.setCapuz(nearestP)
                            TriggerClientEvent('Notify', source, 'sucesso', 'Capuz removido.')
                        end
                    else
                        TriggerClientEvent('Notify', source, 'negado', 'A pessoa não está com um capuz na cabeça.')
                    end
                end

                -- [ BEBIDAS ALCOOLICAS ] --
            elseif item == 'conhaque' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a',
                        'prop_amb_beer_bottle', 49, 28422)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('progress', source, 30000, 'bebendo')
                    vthirst = -10
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(30000, function()
                        vRPclient.playScreenEffect(source, 'RaceTurbo', 180)
                        vRPclient.playScreenEffect(source, 'DrugsTrevorClownsFight', 180)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Conhaque utilizado com sucesso.', 8000)
                    end)
                end

            elseif item == 'absinto' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a',
                        'prop_amb_beer_bottle', 49, 28422)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('progress', source, 30000, 'bebendo')
                    vthirst = -10
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(30000, function()
                        vRPclient.playScreenEffect(source, 'RaceTurbo', 180)
                        vRPclient.playScreenEffect(source, 'DrugsTrevorClownsFight', 180)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Absinto utilizado com sucesso.', 8000)
                    end)
                end

            elseif item == 'whisky' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a',
                        'p_whiskey_notop', 49, 28422)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('progress', source, 30000, 'bebendo')
                    vthirst = -10
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(30000, function()
                        vRPclient.playScreenEffect(source, 'RaceTurbo', 180)
                        vRPclient.playScreenEffect(source, 'DrugsTrevorClownsFight', 180)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Whisky utilizado com sucesso.', 8000)
                    end)
                end

            elseif item == 'vodka' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a',
                        'prop_amb_beer_bottle', 49, 28422)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('progress', source, 30000, 'bebendo')
                    vthirst = -10
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(30000, function()
                        vRPclient.playScreenEffect(source, 'RaceTurbo', 180)
                        vRPclient.playScreenEffect(source, 'DrugsTrevorClownsFight', 180)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Vodka utilizada com sucesso.', 8000)
                    end)
                end

            elseif item == 'tequila' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a',
                        'prop_amb_beer_bottle', 49, 28422)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('progress', source, 30000, 'bebendo')
                    vthirst = -10
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(30000, function()
                        vRPclient.playScreenEffect(source, 'RaceTurbo', 180)
                        vRPclient.playScreenEffect(source, 'DrugsTrevorClownsFight', 180)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Tequila utilizada com sucesso.', 8000)
                    end)
                end

            elseif item == 'cerveja' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a',
                        'prop_amb_beer_bottle', 49, 28422)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('progress', source, 30000, 'bebendo')
                    vthirst = -10
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(30000, function()
                        vRPclient.playScreenEffect(source, 'RaceTurbo', 180)
                        vRPclient.playScreenEffect(source, 'DrugsTrevorClownsFight', 180)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Cerveja utilizada com sucesso.', 8000)
                    end)
                end

            elseif item == 'jackdaniels' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a',
                        'mah_daniels', 49, 28422)
                    TriggerClientEvent('progress', source, 30000, 'bebendo')
                    vthirst = -10
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(30000, function()
                        vRPclient.playScreenEffect(source, 'RaceTurbo', 180)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Jack Daniels utilizada com sucesso.', 8000)
                    end)
                end

            elseif item == 'heineken' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'mah_hein',
                        49, 28422)
                    TriggerClientEvent('progress', source, 30000, 'bebendo')
                    vthirst = -20
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(30000, function()
                        vRPclient.playScreenEffect(source, 'RaceTurbo', 180)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Heineken utilizada com sucesso.', 8000)
                    end)
                end

            elseif item == 'pineappledrink' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a',
                        'prop_yzze_drinkabacaxi', 49, 28422)
                    TriggerClientEvent('progress', src, 30000, 'bebendo')
                    vthirst = -35
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(30000, function()
                        vRPclient.playScreenEffect(source, 'RaceTurbo', 180)
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu um PineappleDrink.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um PineappleDrink para beber')
                end

            elseif item == 'tanqueray' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a',
                        'mah_tanqueray', 49, 28422)
                    TriggerClientEvent('progress', src, 30000, 'bebendo')
                    vthirst = -35
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(30000, function()
                        vRPclient.playScreenEffect(source, 'RaceTurbo', 180)
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu um Tranqueray.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Tranqueray para beber')
                end

            elseif item == 'chandom' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'mah_chandom',
                        49, 28422)
                    TriggerClientEvent('progress', src, 30000, 'bebendo')
                    vthirst = -35
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(30000, function()
                        vRPclient.playScreenEffect(source, 'RaceTurbo', 180)
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu um Chandom.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Chandom para beber')
                end

            elseif item == 'skolbeats' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'mah_beats',
                        49, 28422)
                    TriggerClientEvent('progress', src, 30000, 'bebendo')
                    vthirst = -35
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(30000, function()
                        vRPclient.playScreenEffect(source, 'RaceTurbo', 180)
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu um Skol Beats.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Skol Beats para beber')
                end

            elseif item == 'salute' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'mah_salute',
                        49, 28422)
                    TriggerClientEvent('progress', src, 30000, 'bebendo')
                    vthirst = -35
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(30000, function()
                        vRPclient.playScreenEffect(source, 'RaceTurbo', 180)
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu um Salute.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Salute para beber')
                end

            elseif item == 'skol' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'skol', 49,
                        28422)
                    TriggerClientEvent('progress', src, 30000, 'bebendo')
                    vthirst = -35
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(30000, function()
                        vRPclient.playScreenEffect(source, 'RaceTurbo', 180)
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu um Skol.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Skol para beber')
                end

            elseif item == 'mezcal' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'mezcal_prop',
                        49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'bebendo')
                    vthirst = -35
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(10000, function()
                        TriggerClientEvent('progress', src, 10000, 'bebendo')
                        TriggerClientEvent('+invUpdate', source, 'inventory')
                        TriggerClientEvent('inventory:close', source)
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>mezcal</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um mezcal para comer')
                end

            elseif item == 'michelada' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a',
                        'michelada_prop', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'COMENDO')
                    vthirst = -25
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu uma michelada.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um michelada para beber')
                end

                -- [ ENERGETICOS ] --
            elseif item == 'monster' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a',
                        'mah_monster', 49, 28422)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('progress', source, 10000, 'bebendo')
                    vthirst = -25
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(10000, function()
                        TriggerClientEvent('tempStamina', source, 300)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Você bebeu um <b>Monster</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', source, 'negado', 'Você não tem um Monster para beber')
                end

            elseif item == 'redbull' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a',
                        'mah_energetico', 49, 28422)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('progress', source, 10000, 'bebendo')
                    vthirst = -15
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(10000, function()
                        TriggerClientEvent('tempStamina', source, 30)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Você bebeu um <b>Red Bull</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', source, 'negado', 'Você não tem um Red Bull para beber')
                end

                -- [ BEBIDAS ] --
            elseif item == 'frappuccino' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'mah_frap',
                        49, 28422)
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('progress', source, 10000, 'bebendo')
                    vthirst = -25
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Você bebeu um <b>Frappuccino</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', source, 'negado', 'Você não tem um Frappuccino para beber')
                end

            elseif item == 'cocacola' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, 'cocacola', 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a', 'mah_coke',
                        49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'bebendo')
                    vthirst = -35
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(10000, function()
                        TriggerClientEvent('progress', src, 10000, 'bebendo')
                        TriggerClientEvent('tempStamina', source, 60)
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu uma <b>Coca Cola</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Coca Cola para beber')
                end

            elseif item == 'aguasuja' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_intdrink', 'loop_bottle', 'prop_ld_flow_bottle', 49, 60309)
                    vthirst = 20
                    vRP.varyThirst(user_id, vthirst)
                    TriggerClientEvent('progress', src, 15000, 'bebendo')
                    SetTimeout(15000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        vRP.giveInventoryItem(user_id, 'garrafavazia', 1)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu uma Água.')
                        vRPclient._setHealth(src, vRPclient.getHealth(src) - 300)
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Água para beber')
                end
            elseif item == 'aguatoxica' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_intdrink', 'loop_bottle', 'prop_ld_flow_bottle', 49, 60309)
                    TriggerClientEvent('progress', src, 15000, 'bebendo')
                    SetTimeout(15000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        vRP.giveInventoryItem(user_id, 'garrafavazia', 1)
                        TriggerClientEvent('Notify', src, 'sucesso',
                            'Você bebeu uma Água envenenada e começou a sentir nauseas.\n Você tem 120 segundos para encontrar o antidoto.')
                        TriggerClientEvent("aguaenvenenada", src, 120)
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Água para beber')
                end
            elseif item == 'antidoto' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_intdrink', 'loop_bottle', 'prop_ld_flow_bottle', 49, 60309)
                    TriggerClientEvent('progress', src, 15000, 'bebendo')
                    SetTimeout(15000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        vRP.giveInventoryItem(user_id, 'garrafavazia', 1)
                        TriggerClientEvent("antidoto", src)
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Água para beber')
                end
            elseif item == 'agua' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    --	vRPclient._CarregarObjeto(src,'amb@world_human_drinking@beer@male@idle_a','idle_a','ba_prop_club_water_bottle',49,28422)
                    vRPclient._CarregarObjeto(src, 'mp_player_intdrink', 'loop_bottle', 'prop_ld_flow_bottle', 49, 60309)
                    vthirst = -30
                    vRP.varyThirst(user_id, vthirst)
                    TriggerClientEvent('progress', src, 15000, 'bebendo')
                    SetTimeout(15000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        vRP.giveInventoryItem(user_id, 'garrafavazia', 1)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu uma Água.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Água para beber')
                end

            elseif item == 'leite' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a',
                        'prop_cs_milk_01', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'bebendo')
                    vthirst = -25
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(10000, function()
                        -- TriggerClientEvent('energeticos', src, true)
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu um <b>Leite</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Leite para beber')
                end

            elseif item == 'cafe' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a',
                        'prop_fib_coffee', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'bebendo')
                    vthirst = -25
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(10000, function()
                        TriggerClientEvent('tempStamina', source, 300)
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu um <b>Café</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Café para beber')
                end

            elseif item == 'sprite' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a',
                        'prop_energy_drink', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'bebendo')
                    vthirst = -15
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(10000, function()
                        TriggerClientEvent('tempStamina', source, 300)
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu uma <b>Sprite</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Sprite para beber')
                end

            elseif item == 'mamadeira' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@world_human_aa_coffee@idle_a', 'idle_a', 'mah_mamadeira', 49,
                        28422)
                    TriggerClientEvent('progress', src, 10000, 'bebendo')
                    vthirst = -70
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(10000, function()
                        -- TriggerClientEvent('energeticos', src, true)
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu uma <b>Mamadeira</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Mamadeira para beber')
                end

            elseif item == 'sucolaranja' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a',
                        'laranja_suco', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'bebendo')
                    vthirst = -25
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu um <b>Suco Laranja</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Suco Laranja para beber')
                end

            elseif item == 'toddynho' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@world_human_drinking@beer@male@idle_a', 'idle_a',
                        'mah_toddynho', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'bebendo')
                    vthirst = -80
                    vRP.varyThirst(user_id, vthirst)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu um <b>Toddynho</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Toddynho para beber')
                end

                -- [ LANCHES ] --

            elseif item == 'sanduiche' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c',
                        'prop_sandwich_01', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'COMENDO')
                    vhunger = -45
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Sanduiche</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Sanduiche para comer')
                end

            elseif item == 'hotdog' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c',
                        'mah_hotdog', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -45
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Cachorro Quente</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Cachorro Quente para comer')
                end
                -- [ MASSAS ] --
            elseif item == 'pizza' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_a',
                        'mah_pizza', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -45
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu uma <b>Pizza</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Pizza para comer')
                end

                -- [ FESTA JUNINA ] --
            elseif item == 'coxinha' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'bag_coxinha', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -25
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu uma Coxinha.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Coxinha para comer')
                end

            elseif item == 'bolinho' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_inteat@burger', 'mp_player_int_eat_burger',
                        'prop_bolinho', 49, 60309)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -25
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Bolinho.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Bolinho para comer')
                end

            elseif item == 'chocolate' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'prop_chocolate', 49, 28422)
                    -- vRPclient._CarregarObjeto(source,'amb@world_human_clipboard@male@idle_a','idle_c','v_ret_ta_firstaid',49,60309)
                    TriggerClientEvent('progress', src, 20000, 'comendo')
                    vhunger = -25
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(20000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Chocolate.')
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Chocolate para comer')
                end

            elseif item == 'maca' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 'prop_maca',
                        49, 60309)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -25
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu uma Maça do Amor.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Maça do Amor para comer')
                end

            elseif item == 'milho' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'prop_milho', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -20
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Milho.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Milho para comer')
                end

            elseif item == 'milho1' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'prop_milho1', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -20
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Milho.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Milho para comer')
                end

            elseif item == 'milho2' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'prop_milho2', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -20
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Milho.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Milho para comer')
                end

            elseif item == 'pamonha' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'prop_pamonha', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -20
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Pamonha.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Pamonha para comer')
                end

            elseif item == 'pastelj' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'prop_pastel', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -20
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Pastel.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Pastel para comer.')
                end

            elseif item == 'pipocaj' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'prop_pipoca', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -20
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu uma Pipoca.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Pipoca para comer.')
                end

            elseif item == 'quentao' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'prop_quentao', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -20
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu um Quentao.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Quentao para beber.')
                end

            elseif item == 'queijoj' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'prop_queijo', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -20
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Queijo do Juninão.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Queijo para comer')
                end

            elseif item == 'cha' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'offstore_cha', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -20
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu um Cha.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Cha para beber')
                end

            elseif item == 'varabambu' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'vara_bambu', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -20
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você usou uma Vara de Bambu.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Vara de Bambu.')
                end

                -- [ DOCES ] --
            elseif item == 'brigadeiro' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_a',
                        'mah_brigadeiro', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -35
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Brigadeiro</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Brigadeiro para comer')
                end

            elseif item == 'pacoca' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 'bag_pacoca',
                        49, 60309)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -15
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu uma <b>Paçoca</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Brigadeiro para comer')
                end

            elseif item == 'ovopascoa' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'impexp_int-0', 'mp_m_waremech_01_dual-0', 'ovoembrulhado3_prop', 49,
                        28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -2
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Ovo Pascoa</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Brigadeiro para comer')
                end

            elseif item == 'icecream' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_a',
                        'mah_picole', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -35
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Ice Cream</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Ice Cream para comer')
                end

            elseif item == 'donut' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c',
                        'mah_donut', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -35
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Donut</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Donut para comer')
                end

            elseif item == 'chocolate' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    -- vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_a','mah_chocolate', 49, 28422)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'prop_chocolate', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -35
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        -- TriggerClientEvent('energeticos', src, true)
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Chocolate</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um chocolate para comer')
                end

            elseif item == 'algodaodoce' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 'mah_doce',
                        49, 60309)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -35
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Algodão Doce</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Algodão Doce para comer')
                end

            elseif item == 'pirulito' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_inteat@burger', 'mp_player_int_eat_burger',
                        'mah_pirulito', 49, 60309)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -35
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você chupou um <b>Pirulito</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Pirulito para chupar')
                end

                -- [ COMIDA TIPICA ] -- 
                -- elseif item == 'pastel' then
                --     local src = source
                --     if  vRP.tryGetInventoryItemByUse(user_id, item, 1,true) then
                --         TriggerClientEvent('+invUpdate', source, 'inventory')
                --         TriggerClientEvent('inventory:close',source)
                --         TriggerClientEvent('cancelando', src, true)
                --         vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_a', 'mah_pastel',
                --             49, 28422)
                --         TriggerClientEvent('progress', src, 10000, 'comendo')
                --         vhunger = -45
                --         vRP.varyHunger(user_id, vhunger)
                --         SetTimeout(10000, function()
                --             TriggerClientEvent('cancelando', src, false)
                --             vRPclient._DeletarObjeto(src)
                --             TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Pastel</b>.')
                --         end)
                --     else
                --         TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Pastel para comer')
                --     end

            elseif item == 'noodles' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c',
                        'v_res_fa_potnoodle', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -25
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Cup Noodles</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Cup Noodles para comer')
                end

            elseif item == 'pipoca' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_drinking@beer@male@base', 'static',
                        'mah_popcorn', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -35
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu uma <b>Pipoca</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Pipoca para comer')
                end

            elseif item == 'batata' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_a',
                        'mah_batata', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -35
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu uma <b>Batata Frita</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Batata Frita para comer')
                end

            elseif item == 'espeto' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'mah_espeto', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -45
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Espeto</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Espeto para comer')
                end

            elseif item == 'frango' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 'mah_frango',
                        49, 60309)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -45
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Frango</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Frango para comer')
                end

            elseif item == 'paodequeijo' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'paodequeijo', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -45
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Pão de Queijo</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Pão de Queijo para comer')
                end

                -- [ COMIDA MEXICANA ] --
            elseif item == 'taco' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c',
                        'mah_taco', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'COMENDO')
                    vhunger = -45
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Taco</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Taco para comer')
                end

            elseif item == 'burrito' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_b',
                        'burrito_prop', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'COMENDO')
                    vhunger = -45
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>burrito</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um burrito para comer')
                end

            elseif item == 'churros1' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_b',
                        'churros1_prop', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'COMENDO')
                    vhunger = -35
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Churros de Chocolate.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Churros de Chocolate para comer')
                end

            elseif item == 'churros2' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_b',
                        'churros2_prop', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'COMENDO')
                    vhunger = -35
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Churros de Doce Leite.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Churros de Doce Leite para comer')
                end

            elseif item == 'nacho' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'impexp_int-0', 'mp_m_waremech_01_dual-0', 'nacho_prop', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'COMENDO')
                    vhunger = -45
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>nacho</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um nacho para comer')
                end

            elseif item == 'guacamole' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'impexp_int-0', 'mp_m_waremech_01_dual-0', 'guacamole_prop', 49,
                        28422)
                    TriggerClientEvent('progress', src, 10000, 'COMENDO')
                    vhunger = -45
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>guacamole</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um guacamole para comer')
                end

                -- [ COMIDA JAPONESA ] --
            elseif item == 'hotholl' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_a',
                        'hotholl_prop', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -45
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Hotholl</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Hotholl para comer')
                end

            elseif item == 'temaki' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'mah_temaki', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -45
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Temaki</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Temaki para comer')
                end

            elseif item == 'rolinho' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c',
                        'rolinho_prop', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -45
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Rolinho</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Rolinho para comer')
                end

            elseif item == 'sashimi' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c',
                        'sashimi_prop', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -45
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Sashimi</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Sashimi para comer')
                end

            elseif item == 'yakisoba' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'impexp_int-0', 'mp_m_waremech_01_dual-0', 'yakisoba_prop', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -45
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Yakisoba</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Yakisoba para comer')
                end

            elseif item == 'temaki2' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_c',
                        'temaki_prop', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -45
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Temaki</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Temaki para comer')
                end

                -- [ FRUTOS DO MAR ] --
            elseif item == 'camarao' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_a',
                        'prop_yzze_camarao', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -45
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Camarão</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Camarão para comer')
                end

            elseif item == 'lagosta' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_a',
                        'blossom_lagosta', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -45
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Lagosta</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Lagosta para comer')
                end

            elseif item == 'kashipan' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_a',
                        'blossom_kashipan', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -45
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Kashipan</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Kashipan para comer')
                end

            elseif item == 'croissant' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@male@idle_a', 'idle_a',
                        'mah_croissant', 49, 28422)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    vhunger = -45
                    vRP.varyHunger(user_id, vhunger)
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um <b>Croissant</b>.')
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Croissant para comer')
                end

                --------------------------------------
                ---------[RESTAURANTE PIER]-----------
                --------------------------------------

            elseif item == 'camarao' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'prop_yzze_camarao', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Camarão, nhumi nhumi!!!.')
                        vhunger = -50
                        vRP.varyHunger(user_id, vhunger)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Camarão para comer')
                end

            elseif item == 'caranguejo' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'blossom_lagosta', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Caranguejo, nhumi nhumi!!!.')
                        vhunger = -70
                        vRP.varyHunger(user_id, vhunger)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Camarão para comer')
                end

            elseif item == 'lagosta' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'blossom_lagosta', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu uma Lagosta, nhumi nhumi!!!.')
                        vhunger = -90
                        vRP.varyHunger(user_id, vhunger)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Camarão para comer')
                end

            elseif item == 'caipirinha' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._stopAnim(src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_intdrink', 'loop_bottle', 'prop_amb_beer_bottle', 49,
                        60309)
                    TriggerClientEvent('progress', src, 10000, 'bebendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        vRPclient._stopAnim(src, false)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu uma Caipirinha.')
                        vthirst = -50
                        vRP.varyThirst(user_id, vthirst)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Caipirinha para beber')
                end

            elseif item == 'aguavoss' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_intdrink', 'loop_bottle', 'prop_ld_flow_bottle', 49, 60309)
                    TriggerClientEvent('progress', src, 10000, 'bebendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        vRP.giveInventoryItem(user_id, 'garrafavazia', 1)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu uma Água Voss.')
                        vthirst = -70
                        vRP.varyThirst(user_id, vthirst)
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Água para beber')
                end

            elseif item == 'sucotropical' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_intdrink', 'loop_bottle', 'blossom_tropicalsuco', 49,
                        60309)
                    TriggerClientEvent('progress', src, 10000, 'bebendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu um Suco Tropical.')
                        vthirst = -90
                        vRP.varyThirst(user_id, vthirst)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Suco Tropical para beber')
                end

                --------------------------------------
                ------[RESTAURANTE TRAIN BURGER]------
                --------------------------------------

            elseif item == 'batatafrita' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'mah_batata', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu uma Batata Frita, nhumi nhumi!!!.')
                        vhunger = -50
                        vRP.varyHunger(user_id, vhunger)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Batata Fritas para comer')
                end

            elseif item == 'pastel' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'prop_pastel', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Pastel, nhumi nhumi!!!.')
                        vhunger = -70
                        vRP.varyHunger(user_id, vhunger)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Pastel para comer')
                end

            elseif item == 'hamburguer' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'mah_burger', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Hamburguer, nhumi nhumi!!!.')
                        vhunger = -90
                        vRP.varyHunger(user_id, vhunger)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Hamburguer para comer')
                end

            elseif item == 'monster' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._stopAnim(src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_intdrink', 'loop_bottle', 'mah_monster', 49, 60309)
                    TriggerClientEvent('progress', src, 10000, 'bebendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        vRPclient._stopAnim(src, false)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu um Monster.')
                        vthirst = -20
                        vRP.varyThirst(user_id, vthirst)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Monster para beber')
                end

            elseif item == 'cocacola' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._stopAnim(src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_intdrink', 'loop_bottle', 'mah_coke', 49, 60309)
                    TriggerClientEvent('progress', src, 10000, 'bebendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        vRPclient._stopAnim(src, false)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu uma Coca Cola.')
                        vthirst = -90
                        vRP.varyThirst(user_id, vthirst)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Coca Cola para beber')
                end

                --------------------------------------
                ------[RESTAURANTE KAWAI CAFÉ]--------
                --------------------------------------

            elseif item == 'brigadeiro' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'mah_brigadeiro', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Brigadeiro ka-ka-kawai!.')
                        vhunger = -50
                        vRP.varyHunger(user_id, vhunger)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Brigadeiro para comer')
                end

            elseif item == 'macarron' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'mah_brigadeiro', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Macarron ka-ka-kawai!.')
                        vhunger = -70
                        vRP.varyHunger(user_id, vhunger)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Macarron para comer')
                end

            elseif item == 'cupcake' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'mah_donut', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Cupcake ka-ka-kawai!.')
                        vhunger = -90
                        vRP.varyHunger(user_id, vhunger)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Cupcake para comer')
                end

            elseif item == 'frapuccino' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._stopAnim(src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_intdrink', 'loop_bottle', 'mah_frap', 49, 60309)
                    TriggerClientEvent('progress', src, 10000, 'bebendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        vRPclient._stopAnim(src, false)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu um Frapuccino otome!.')
                        vthirst = -50
                        vRP.varyThirst(user_id, vthirst)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Frapuccino para beber')
                end

            elseif item == 'milkshake' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._stopAnim(src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_intdrink', 'loop_bottle', 'weedmilkshake_midnight', 49,
                        60309)
                    TriggerClientEvent('progress', src, 10000, 'bebendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        vRPclient._stopAnim(src, false)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu um Milkshake kawai desu!.')
                        vthirst = -90
                        vRP.varyThirst(user_id, vthirst)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Milkshake para beber')
                end

                --------------------------------------
                -------[RESTAURANTE EMERALD]----------
                --------------------------------------

            elseif item == 'grandgateau' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'prop_sandwich_01', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso',
                            'Você comeu um chiquérrimo Grand Gateau, alto luxo!.')
                        vhunger = -50
                        vRP.varyHunger(user_id, vhunger)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Grand Gateau para comer')
                end

            elseif item == 'spaghetti' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'prop_sandwich_01', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso',
                            'Você comeu um chiquérrimo Spaghetti, alto luxo!.')
                        vhunger = -70
                        vRP.varyHunger(user_id, vhunger)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Spaghetti para comer')
                end

            elseif item == 'bruschetta' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'prop_sandwich_01', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso',
                            'Você comeu um chiquérrimo Bruschetta, não confunda as coisas!.')
                        vhunger = -90
                        vRP.varyHunger(user_id, vhunger)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Bruschetta para comer')
                end

            elseif item == 'royalsalute' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._stopAnim(src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_intdrink', 'loop_bottle', 'prop_amb_beer_bottle', 49,
                        60309)
                    TriggerClientEvent('progress', src, 10000, 'bebendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        vRPclient._stopAnim(src, false)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu um Royal Salute.')
                        vthirst = -50
                        vRP.varyThirst(user_id, vthirst)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Royal Salute para beber')
                end

            elseif item == 'champagne' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._stopAnim(src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_intdrink', 'loop_bottle', 'prop_amb_beer_bottle', 49,
                        60309)
                    TriggerClientEvent('progress', src, 10000, 'bebendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        vRPclient._stopAnim(src, false)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu um luxuoso Champagne!.')
                        vthirst = -90
                        vRP.varyThirst(user_id, vthirst)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Champagne para beber')
                end

                --------------------------------------
                ------[RESTAURANTE PSYCOSTYLE]--------
                --------------------------------------

            elseif item == 'brisadeiro' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'brisadeiro_prop', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        vRPclient.playScreenEffect(source, 'DrugsTrevorClownsFight', 30)
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso',
                            'Você comeu um Brisadeiro... e esses dragões voando???.')
                        vhunger = -50
                        vRP.varyHunger(user_id, vhunger)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Brisadeiro para comer')
                end

            elseif item == 'tacoweed' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'taco_prop', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        vRPclient.playScreenEffect(source, 'DrugsTrevorClownsFight', 40)
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um TacoWeed... arriba muchachos!!!.')
                        vhunger = -70
                        vRP.varyHunger(user_id, vhunger)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um TacoWeed para comer')
                end

            elseif item == 'cookieweed' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'weedcookie_midnight', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        vRPclient.playScreenEffect(source, 'DrugsTrevorClownsFight', 50)
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso',
                            'Você comeu um CookieWeed... que fofos esses telettubies!!!.')
                        vhunger = -90
                        vRP.varyHunger(user_id, vhunger)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um CookieWeed para comer')
                end

            elseif item == 'sucodetox' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._stopAnim(src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_intdrink', 'loop_bottle', 'sucodetox_pro', 49, 60309)
                    TriggerClientEvent('progress', src, 10000, 'bebendo')
                    SetTimeout(10000, function()
                        vRPclient.playScreenEffect(source, 'DrugsTrevorClownsFight', 0)
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        vRPclient._stopAnim(src, false)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu um Suco Detox, a onda passou!.')
                        vthirst = -50
                        vRP.varyThirst(user_id, vthirst)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Suco Detox para beber')
                end

            elseif item == 'milkshakeweed' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._stopAnim(src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_intdrink', 'loop_bottle', 'weedmilkshake_midnight', 49,
                        60309)
                    TriggerClientEvent('progress', src, 10000, 'bebendo')
                    SetTimeout(10000, function()
                        vRPclient.playScreenEffect(source, 'DrugsTrevorClownsFight', 0)
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        vRPclient._stopAnim(src, false)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu um Milkshake Weed, que brisa leve!.')
                        vthirst = -90
                        vRP.varyThirst(user_id, vthirst)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Milkshake Weed para beber')
                end

                --------------------------------------
                ------[RESTAURANTE STYLESWEET]--------
                --------------------------------------

            elseif item == 'donutsweet' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'mah_donut', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Donut Sweet, tão fofinho!!!.')
                        vhunger = -50
                        vRP.varyHunger(user_id, vhunger)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Donut Sweet para comer')
                end

            elseif item == 'algodaosweet' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c', '', 49,
                        28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Algodão Sweet, tão fofinho!!!.')
                        vhunger = -70
                        vRP.varyHunger(user_id, vhunger)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Algodão Sweet para comer')
                end

            elseif item == 'pizzasweet' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'mah_pizza', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu uma Pizza Sweet, tão fofinha!!!.')
                        vhunger = -90
                        vRP.varyHunger(user_id, vhunger)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Pizza Sweet para comer')
                end

            elseif item == 'toddysweet' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._stopAnim(src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_intdrink', 'loop_bottle', 'weedmilkshake_midnight', 49,
                        60309)
                    TriggerClientEvent('progress', src, 10000, 'bebendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        vRPclient._stopAnim(src, false)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu um ToddySweet, docinho docinho!.')
                        vthirst = -50
                        vRP.varyThirst(user_id, vthirst)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um ToddySweet para beber')
                end

            elseif item == 'milksweet' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._stopAnim(src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_intdrink', 'loop_bottle', 'weedmilkshake_midnight', 49,
                        60309)
                    TriggerClientEvent('progress', src, 10000, 'bebendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        vRPclient._stopAnim(src, false)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você bebeu um MilkSweet, docinho docinho!.')
                        vthirst = -70
                        vRP.varyThirst(user_id, vthirst)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um MilkSweet para beber')
                end

            elseif item == 'mamadeirasweet' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._stopAnim(src, true)
                    vRPclient._CarregarObjeto(src, 'mp_player_intdrink', 'loop_bottle', 'mamadeira', 49, 60309)
                    TriggerClientEvent('progress', src, 10000, 'bebendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._DeletarObjeto(src)
                        vRPclient._stopAnim(src, false)
                        TriggerClientEvent('Notify', src, 'sucesso',
                            'Você bebeu uma Mamadeira Sweet, feita pelos anjinhos!.')
                        vthirst = -90
                        vRP.varyThirst(user_id, vthirst)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Mamadeira Sweet para beber')
                end

                --------------------------------------
                ------[RESTAURANTE YELLOWJACK]--------
                --------------------------------------

            elseif item == 'croquetecarne' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'espetinho', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Croquete de Carne!.')
                        vhunger = -50
                        vRP.varyHunger(user_id, vhunger)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Croquete de Carne para comer')
                end

            elseif item == 'calabresaacebolada' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'calabresa', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu uma Calabresa Acebolada.')
                        vhunger = -70
                        vRP.varyHunger(user_id, vhunger)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Calabresa Acebolada para comer')
                end

            elseif item == 'frangopassarinho' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    -- if duration and ostime and ostime <= duration then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'frango', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Frango a Passarinho.')
                        vhunger = -90
                        vRP.varyHunger(user_id, vhunger)
                    end)
                    -- else
                    -- TriggerClientEvent('Notify', src, 'negado', 'Item está vencido e foi destruido.')
                    --  end
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem um Frango a Passarinho para comer')
                end

                --------------------------------------
                ------[ARRAIAL STYLE]--------
                --------------------------------------

            elseif item == 'bolofuba' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'bolofuba', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Bolo de Fubá, sô!.')
                        vhunger = -50
                        vRP.varyHunger(user_id, vhunger)
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Não há como comer algo que você não tem.')
                end

            elseif item == 'curau' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'curau', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Curau, sô!.')
                        vhunger = -50
                        vRP.varyHunger(user_id, vhunger)
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Não há como comer algo que você não tem.')
                end

            elseif item == 'arrozdoce' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'arrozdoce', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Arroz Doce, sô!.')
                        vhunger = -50
                        vRP.varyHunger(user_id, vhunger)
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Não há como comer algo que você não tem.')
                end

            elseif item == 'macadoamor' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'macadoamor', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu uma Maçã do Amor, sô!.')
                        vhunger = -50
                        vRP.varyHunger(user_id, vhunger)
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Não há como comer algo que você não tem.')
                end

            elseif item == 'bolodemilho' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'bolofuba', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Bolo de Milho, sô!.')
                        vhunger = -50
                        vRP.varyHunger(user_id, vhunger)
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Não há como comer algo que você não tem.')
                end

            elseif item == 'milhocozido' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'milho', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Milho Cozido, sô!.')
                        vhunger = -50
                        vRP.varyHunger(user_id, vhunger)
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Não há como comer algo que você não tem.')
                end

            elseif item == 'pacoca' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'pacoca', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu uma Paçoca, sô!.')
                        vhunger = -50
                        vRP.varyHunger(user_id, vhunger)
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Não há como comer algo que você não tem.')
                end

            elseif item == 'pamonha' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'pamonha', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu uma Pamonha, sô!.')
                        vhunger = -50
                        vRP.varyHunger(user_id, vhunger)
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Não há como comer algo que você não tem.')
                end

            elseif item == 'rapadura' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'pamonha', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu uma Rapadura, sô!.')
                        vhunger = -50
                        vRP.varyHunger(user_id, vhunger)
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Não há como comer algo que você não tem.')
                end

            elseif item == 'pedemoleque' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'pacoca', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Pé de Moleque, sô!.')
                        vhunger = -50
                        vRP.varyHunger(user_id, vhunger)
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Não há como comer algo que você não tem.')
                end

            elseif item == 'sagu' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'curau', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu um Sagu, sô!.')
                        vhunger = -50
                        vRP.varyHunger(user_id, vhunger)
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Não há como comer algo que você não tem.')
                end

            elseif item == 'canjica' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'curau', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você comeu uma Canjica, sô!.')
                        vhunger = -50
                        vRP.varyHunger(user_id, vhunger)
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Não há como comer algo que você não tem.')
                end

            elseif item == 'vinhoquente' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'prop_plastic_cup_02', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você tomou um Vinho Quente, sô!.')
                        vthirst = -50
                        vRP.varyThirst(user_id, vthirst)
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Não há como comer algo que você não tem.')
                end

            elseif item == 'quentao' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'prop_plastic_cup_02', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você tomou um Quentão, sô!.')
                        vthirst = -50
                        vRP.varyThirst(user_id, vthirst)
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Não há como comer algo que você não tem.')
                end

            elseif item == 'batidademaracuja' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'prop_plastic_cup_02', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você tomou uma Batida de Maracujá, sô!.')
                        vthirst = -50
                        vRP.varyThirst(user_id, vthirst)
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Não há como comer algo que você não tem.')
                end

            elseif item == 'batidadeamendoim' then
                local src = source
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)
                    vRPclient._CarregarObjeto(src, 'amb@code_human_wander_eating_donut@female@idle_a', 'idle_c',
                        'prop_plastic_cup_02', 49, 28422)
                    vRPclient._stopAnim(src, true)
                    TriggerClientEvent('progress', src, 10000, 'comendo')
                    SetTimeout(10000, function()
                        TriggerClientEvent('cancelando', src, false)
                        vRPclient._stopAnim(src, false)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent('Notify', src, 'sucesso', 'Você tomou uma Batida de Amendoim, sô!.')
                        vthirst = -50
                        vRP.varyThirst(user_id, vthirst)
                    end)
                else
                    TriggerClientEvent('Notify', src, 'negado', 'Não há como comer algo que você não tem.')
                end

                -- [ TELEFONE ] --
            elseif item == 'telefone' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('cancelando', source, true)
                    vRP.giveInventoryItem(user_id, 'telefoneligado', 1)
                    TriggerClientEvent('Notify', source, 'sucesso', 'Modo Avião: Desligado.', 8000)
                    TriggerClientEvent('cancelando', source, false)
                end

            elseif item == 'telefoneligado' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('cancelando', source, true)
                    vRP.giveInventoryItem(user_id, 'telefonedesligado', 1)
                    TriggerClientEvent('Notify', source, 'sucesso', 'Modo Avião: Ligado.', 8000)
                    TriggerClientEvent('cancelando', source, false)
                end

            elseif item == 'telefonedesligado' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('cancelando', source, true)
                    vRP.giveInventoryItem(user_id, 'telefoneligado', 1)
                    TriggerClientEvent('Notify', source, 'sucesso', 'Modo Avião: Desligado.', 8000)
                    TriggerClientEvent('cancelando', source, false)
                end

                -- [ JUDICIARIO ] --
                -- elseif item == 'certidao' then
                -- 	local user_id = vRP.getUserId(source)
                -- 	if vRP.tryGetInventoryItemByUse(itemertidao',1) then
                -- 		TriggerClientEvent("+invClose",source)
                -- 		consumeItem[user_id] = true
                -- 		local nome = vRP.prompt(source,'Nome:','')
                -- 		local sobrenome = vRP.prompt(source,'Sobrenome:','')
                -- 		if nome == '' or sobrenome == '' then
                -- 			return
                -- 		end

                -- 		local user_reg = vRP.getUserIdentity(parseInt(user_id))

                -- 		if user_reg then
                -- 			user_id = parseInt(user_id)
                -- 			local identity = vRP.getUserIdentity(user_id)
                -- 			webhook(webhookidentidade,'```ini\n[CERTIDÃO]:\n[ID]: '..user_id..' '..identity.name..' '..identity.firstname..'\n[ALTEROU O NOME PARA]: '..user_id..' '..nome..' '..sobrenome..' '..os.date('\n[DATA]: %d/%m/%Y [Hora]: %H:%M:%S')..' \r```')
                -- 			vRP.execute('update/Certidao',{ name = nome, firstname = sobrenome, user_id = parseInt(user_id) })
                -- 			TriggerClientEvent('Notify',source,'sucesso','O nome do passaporte <b>'..user_id..'</b> foi corrigido.')
                -- 			TriggerEvent('identity:atualizar',user_id)
                -- 			consumeItem[user_id] = nil
                -- 		else
                -- 			TriggerClientEvent('Notify',source,'negado','O passaporte <b>'..user_id..'</b> ainda não existe ou não foi aprovado.')
                -- 			consumeItem[user_id] = nil
                -- 		end
                -- 	else
                -- 		TriggerClientEvent('Notify',source,'negado','Você não possui um <b>Certidão</b> na sua mochila.')
                -- 	end

                -- [ MISC ] --
            elseif item == 'mochila' then
                if vRP.getInventoryMaxWeight(user_id) == 90 and not vRP.hasPermission(user_id, 'supremo.vip') and
                    not vRP.hasPermission(user_id, 'style.vip') then
                    TriggerClientEvent('Notify', source, 'negado',
                        'Você já atingiu a capacidade máxima de evolução de sua mochila.', 7337)
                    return
                end
                if tonumber(vRP.getExp(user_id, 'physical', 'strength')) >= 1950 and
                    not vRP.hasPermission(user_id, 'supremo.vip') and not vRP.hasPermission(user_id, 'style.vip') then
                    TriggerClientEvent('Notify', source, 'negado',
                        'Você já atingiu a capacidade máxima de evolução de sua mochila.', 7337)
                    return
                end
                if tonumber(vRP.getExp(user_id, 'physical', 'strength')) >= 3300 and
                    not vRP.hasPermission(user_id, 'supremo.vip') then
                    TriggerClientEvent('Notify', source, 'negado',
                        'Você já atingiu a capacidade máxima de evolução de sua mochila.', 7337)
                    return
                end
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    if tonumber(vRP.getExp(user_id, 'physical', 'strength')) < 1900 then
                        vRP.varyExp(user_id, 'physical', 'strength', 650)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Mochila utilizada com sucesso.', 8000)
                    elseif tonumber(vRP.getExp(user_id, 'physical', 'strength')) == 1900 then
                        vRP.setExp(user_id, 'physical', 'strength', 3300)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Mochila utilizada com sucesso.', 8000)
                    elseif tonumber(vRP.getExp(user_id, 'physical', 'strength')) == 2550 then
                        vRP.setExp(user_id, 'physical', 'strength', 3300)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Mochila utilizada com sucesso.', 8000)
                    elseif tonumber(vRP.getExp(user_id, 'physical', 'strength')) == 3300 then
                        vRP.setExp(user_id, 'physical', 'strength', 5100)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Mochila utilizada com sucesso.', 8000)
                    elseif tonumber(vRP.getExp(user_id, 'physical', 'strength')) == 2300 then
                        vRP.setExp(user_id, 'physical', 'strength', 3300)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Mochila utilizada com sucesso.', 8000)
                    elseif tonumber(vRP.getExp(user_id, 'physical', 'strength')) == 3250 then
                        vRP.setExp(user_id, 'physical', 'strength', 5100)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Mochila utilizada com sucesso.', 8000)
                    end
                end

            elseif item == 'colete' then
                if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                    local player = vRP.getUserSource(user_id)
                    if player then
                        vRPclient.playAnim(source, true, {{"clothingtie", "try_tie_negative_a"}}, true)
                        TriggerClientEvent('progress', source, 10000, 'Usando colete')
                        SetTimeout(10000, function()
                            vRPclient._stopAnim(source, false)
                            vRPclient.setArmour(player, 100)
                            TriggerClientEvent('Notify', player, 'sucesso', 'Colete equipado')
                            local webhookcolete =
                                'https://discord.com/api/webhooks/1118687510814539927/kTB_FMZqC8eVQaEQ7D1XrlHo-VRbEgm9YjsmjGrbuh6DH_SthLbty9wNajD-t13yyJ8L'
                            webhook(webhookcolete, '```ini\n[ID]: ' .. user_id .. '\n[USOU UM COLETE]' ..
                                os.date('\n[DATA]: %d/%m/%Y [Hora]: %H:%M:%S') .. ' \r```')
                        end)
                    end
                end

            elseif item == 'capuz' then

                local nplayer = vRPclient.getNearestPlayer(source, 2)
                local source = source
                local user_id = vRP.getUserId(source)
                if nplayer then
                    if not vRPclient.isCapuz(nplayer) then
                        if vRP.tryGetInventoryItemByUse(user_id, 'capuz', 1, true) then
                            vRPclient.setCapuz(nplayer)
                            vRP.closeMenu(nplayer)
                            TriggerClientEvent('Notify', source, 'sucesso', 'Capuz utilizado com sucesso.', 8000)
                        end
                    else
                        TriggerClientEvent('Notify', source, 'aviso', 'Player já está com capuz!')
                        TriggerClientEvent('Notify', source, 'aviso', 'Utilize uma tesoura para remover o capuz!')
                    end
                end

            elseif item == 'algemas' then
                local src = source
                if tonumber(vRPclient.getHealth(source)) >= 102 then
                    local user_id = vRP.getUserId(source)
                    local nplayer = vRPclient.getNearestPlayer(source, 2)
                    if vRP.tryGetInventoryItemByUse(user_id, 'algemas', 1, true) then
                        TriggerClientEvent('+invUpdate', source, 'inventory')
                        TriggerClientEvent('inventory:close', source)
                        TriggerClientEvent('cancelando', src, true)
                        if nplayer then
                            if not vRPclient.isHandcuffed(source) then
                                if not vRPclient.isHandcuffed(nplayer) then
                                    TriggerClientEvent('cancelando', source, true)
                                    TriggerClientEvent('cancelando', nplayer, true)
                                    TriggerClientEvent('carregar', nplayer, source)
                                    vRPclient._playAnim(source, false, {{'mp_arrest_paired', 'cop_p2_back_left'}}, false)
                                    vRPclient._playAnim(nplayer, false, {{'mp_arrest_paired', 'crook_p2_back_left'}},
                                        false)
                                    SetTimeout(5000, function()
                                        vRPclient._stopAnim(src, false)
                                        vRPclient.toggleHandcuff(nplayer)
                                        TriggerClientEvent('carregar', nplayer, source)
                                        TriggerClientEvent('cancelando', source, false)
                                        TriggerClientEvent('cancelando', nplayer, false)
                                        TriggerClientEvent('style-audios:source', source, 'cuff', 0.3)
                                        TriggerClientEvent('style-audios:source', nplayer, 'cuff', 0.3)
                                        TriggerClientEvent('setalgemas', nplayer)
                                    end)
                                    PerformHttpRequest(
                                        'https://discord.com/api/webhooks/1047542509653463131/DzkaPHSWyQo1s0KgsJx31WuG7gs-DTbhPhwT5jWlWsUdXaDtq4Q8XZ7zNq6-tvSQpnyX',
                                        function(err, text, headers)
                                        end, 'POST', json.encode({
                                            username = 'Algemar Logs',
                                            embeds = {{
                                                ["color"] = 16777215,
                                                ["author"] = {
                                                    ["name"] = 'Algemar',
                                                    ["icon_url"] = 'https://i.imgur.com/Jq676iR.jpg'
                                                },
                                                ["description"] = '> **Jogador:** ・' .. user_id .. '\n> **Algemou: **' ..
                                                    vRP.getUserId(nplayer)
                                            }},
                                            avatar_url = 'https://i.imgur.com/Jq676iR.jpg'
                                        }), {
                                            ['Content-Type'] = 'application/json'
                                        })
                                    TriggerClientEvent('Notify', source, 'sucesso', 'O player foi algemado!', 8000)
                                else
                                    TriggerClientEvent('Notify', source, 'aviso', 'O player já está algemado!', 8000)
                                    TriggerClientEvent('Notify', source, 'aviso',
                                        'Utiliza uma chave de algemas para soltá-lo!.', 8000)
                                end
                            end
                        end
                    else
                        TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Algema')
                    end
                end

            elseif item == 'chavedealgemas' then
                local src = source
                local user_id = vRP.getUserId(source)
                local nplayer = vRPclient.getNearestPlayer(source, 2)
                if vRP.tryGetInventoryItemByUse(user_id, 'chavedealgemas', 1, true) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('cancelando', src, true)

                    if vRPclient.getHealth(source) >= 102 then
                        if vRPclient.isHandcuffed(source) then
                            TriggerClientEvent('cancelando', source, true)
                            -- vRPclient._playAnim(source,false,{{'mp_arrest_paired',''}},false)
                            -- vRPclient._playAnim(source,false,{{'mp_arresting','a_uncuff'}},false)
                            -- vRPclient._playAnim(source,false,{{'mp_arrest_paired','cop_p2_back_left'}},false)
                            -- vRPclient._playAnim(nplayer,false,{{'mp_arrest_paired','crook_p2_back_left'}},false)
                            SetTimeout(3000, function()
                                vRPclient._stopAnim(src, false)
                                vRPclient.toggleHandcuff(source)
                                TriggerClientEvent('cancelando', source, false)
                                TriggerClientEvent('style-audios:source', source, 'cuff', 0.3)
                                TriggerClientEvent('removealgemas', source)
                            end)

                            PerformHttpRequest(
                                'https://discord.com/api/webhooks/1047542509653463131/DzkaPHSWyQo1s0KgsJx31WuG7gs-DTbhPhwT5jWlWsUdXaDtq4Q8XZ7zNq6-tvSQpnyX',
                                function(err, text, headers)
                                end, 'POST', json.encode({
                                    username = 'Algemar Logs',
                                    embeds = {{
                                        ["color"] = 16777215,
                                        ["author"] = {
                                            ["name"] = 'Algemar',
                                            ["icon_url"] = 'https://i.imgur.com/Jq676iR.jpg'
                                        },
                                        ["description"] = '> **Jogador:** ・' .. user_id ..
                                            '\n> **Se libertou das Algemas! **'
                                    }},
                                    avatar_url = 'https://i.imgur.com/Jq676iR.jpg'
                                }), {
                                    ['Content-Type'] = 'application/json'
                                })

                            TriggerClientEvent('Notify', source, 'sucesso', 'Seria o próprio Houdini?!', 8000)
                            TriggerClientEvent('Notify', source, 'sucesso', 'Você se libertou das algemas!.', 8000)

                        elseif nplayer then
                            if vRPclient.isHandcuffed(nplayer) then
                                TriggerClientEvent('cancelando', source, true)
                                TriggerClientEvent('cancelando', nplayer, true)
                                TriggerClientEvent('carregar', nplayer, source)
                                -- vRPclient._playAnim(source,false,{{'mp_arrest_paired','cop_p2_back_left'}},false)
                                -- vRPclient._playAnim(nplayer,false,{{'mp_arrest_paired','crook_p2_back_left'}},false)
                                vRPclient._playAnim(source, false, {{'mp_arresting', 'a_uncuff'}}, false)
                                SetTimeout(5000, function()
                                    vRPclient._stopAnim(src, false)
                                    vRPclient.toggleHandcuff(nplayer)
                                    TriggerClientEvent('carregar', nplayer, source)
                                    TriggerClientEvent('cancelando', source, false)
                                    TriggerClientEvent('cancelando', nplayer, false)
                                    TriggerClientEvent('style-audios:source', source, 'cuff', 0.3)
                                    TriggerClientEvent('style-audios:source', nplayer, 'cuff', 0.3)
                                    TriggerClientEvent('removealgemas', nplayer)
                                end)
                                PerformHttpRequest(
                                    'https://discord.com/api/webhooks/1047542509653463131/DzkaPHSWyQo1s0KgsJx31WuG7gs-DTbhPhwT5jWlWsUdXaDtq4Q8XZ7zNq6-tvSQpnyX',
                                    function(err, text, headers)
                                    end, 'POST', json.encode({
                                        username = 'Algemar Logs',
                                        embeds = {{
                                            ["color"] = 16777215,
                                            ["author"] = {
                                                ["name"] = 'Algemar',
                                                ["icon_url"] = 'https://i.imgur.com/Jq676iR.jpg'
                                            },
                                            ["description"] = '> **Jogador:** ・' .. user_id .. '\n> **Desalgemou: **' ..
                                                vRP.getUserId(nplayer)
                                        }},
                                        avatar_url = 'https://i.imgur.com/Jq676iR.jpg'
                                    }), {
                                        ['Content-Type'] = 'application/json'
                                    })
                                TriggerClientEvent('Notify', source, 'sucesso', 'O player foi desalgemado!', 8000)
                            end
                        end
                    end

                else
                    TriggerClientEvent('Notify', src, 'negado', 'Você não tem uma Chave de Algema!')
                end

            elseif item == 'lockpick' then
                local source = source
                if not vRPclient.isHandcuffed(source) then
                    local user_id = vRP.getUserId(source)
                    local identity = vRP.getUserIdentity(user_id)
                    local vehicle, vnetid, placa, vname, lock, banned, trunk, model, street = vRPclient.vehList(source,
                        7)
                    local policia = vRP.getUsersByPermission('pmall.acess')
                    if #policia < 0 then
                        TriggerClientEvent('Notify', source, 'aviso',
                            'Número insuficiente de policiais no momento para iniciar o roubo.')
                        return true
                    end
                    TriggerClientEvent('inventory:close', source)

                    if vehicle then
                        Wait(500)

                        local x, y, z = vRPclient.getPosition(source)

                        local taskSetup = {
                            type = 11,
                            dificulty = 4,
                            title = "Lockpick", -- caso seja nulo, o script irá utilizar o padrão
                            description = "" -- caso seja nulo, o script irá utilizar o padrão
                        }

                        local resposta = vRP.task(source, taskSetup)

                        if resposta then
                            if vRP.tryGetInventoryItem(user_id, "lockpick", 1) then
                                TriggerClientEvent('cancelando', source, true)
                                TriggerClientEvent('inventory:close', source)
                                vRPclient._playAnim(source, false, {{'missfbi_s4mop', 'clean_mop_back_player'}}, true)
                                TriggerClientEvent('progress', source, 5000, 'Usando Lockpick')

                                SetTimeout(5000, function()
                                    -- TriggerEvent('setPlateEveryone', placa)
                                    vGARAGE.vehicleClientLock(-1, vnetid, lock)
                                    -- TriggerClientEvent('style-audios:source', source, 'mission', 0.5)
                                    vRPclient.playSound(source, "Event_Message_Purple", "GTAO_FM_Events_Soundset")
                                    TriggerClientEvent('cancelando', source, false)
                                    vRPclient._stopAnim(source, false)
                                    sendWebhook('Lockpick',
                                        '```prolog\n[LOCKPICK]\n[LADRÃO]: ' .. user_id .. ' | ' .. identity.name .. ' ' ..
                                            identity.firstname .. '\n[LOCALIZAÇÃO]: ' .. street ..
                                            ' \n[MODELO DO CARRO]: ' .. model .. ' \n[PLACA]: ' .. placa .. ' \n[CDS]: ' ..
                                            x .. ',' .. y .. ',' .. z ..
                                            os.date('\n[DATA]: %d/%m/%Y - [HORA]: %H:%M:%S') .. ' \r```',
                                        'https://discord.com/api/webhooks/1105563432499032084/Injn8ZW95BGd7PVVA2WfycfDHuZJLgVatAzrFkU97PUtLcF5jHUhMivVU_qT3LK345Yr')
                                end)
                            end
                        else
                            TriggerClientEvent('Notify', source, 'negado', 'Roubo do veículo falhou.', 8000)
                            TriggerClientEvent('Notify', source, 'aviso',
                                'Os coxinhas foram avisados sobre a tentativa de roubo.', 8000)
                            local policia = vRP.getUsersByPermission('pmall.acess')

                            local x, y, z = vRPclient.getPosition(source)
                            for k, v in pairs(policia) do
                                local player = vRP.getUserSource(parseInt(v))
                                if player then
                                    async(function()
                                        local id = idgens:gen()
                                        -- TriggerClientEvent("style-audios:source", player, "deathcop", 1.0)
                                        vRPclient.playSound(source, "Event_Message_Purple", "GTAO_FM_Events_Soundset")
                                        TriggerClientEvent('chatMessage', player, '190', {64, 64, 255}, 'Roubo na ^1' ..
                                            street .. '^0 do veículo ^1' .. model .. '^0 de placa ^1' .. placa ..
                                            '^0 verifique o ocorrido.')
                                        pick[id] = vRPclient.addBlip(player, x, y, z, 10, 5, 'Ocorrência', 0.5, false)
                                        SetTimeout(20000, function()
                                            vRPclient.removeBlip(player, pick[id])
                                            idgens:free(id)
                                        end)
                                    end)
                                end
                            end
                        end
                    end
                else
                    local taskSetup = {
                        type = 11,
                        dificulty = 4,
                        title = "Lockpick ", -- caso seja nulo, o script irá utilizar o padrão
                        description = "Desalgemar" -- caso seja nulo, o script irá utilizar o padrão
                    }
                    local resposta = vRP.task(source, taskSetup)

                    if resposta then
                        vRPclient.toggleHandcuff(source)
                        TriggerClientEvent('removealgemas', source)
                        TriggerClientEvent('Notify', source, 'sucesso', 'Você conseguiu escapar das algemas!')
                    else
                        TriggerClientEvent('Notify', source, 'negado', 'Você falhou em escapar das algemas!')
                    end
                end

            elseif item == 'provaemoji1' then
                local source = source
                local user_id = vRP.getUserId(source)
                local identity = vRP.getUserIdentity(user_id)

                if vRP.tryGetInventoryItem(user_id, "provaemoji1", 1) then

                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('Notify', source, 'sucesso', 'A prova começará em 3 segundos, BOA SORTE!.',
                        4000)

                    Wait(3000)

                    local x, y, z = vRPclient.getPosition(source)

                    local taskSetup = {
                        type = 6,
                        dificulty = 1,
                        title = "Prova Emoji I", -- caso seja nulo, o script irá utilizar o padrão
                        description = "Selecione o icone de acordo com o apresentado abaixo" -- caso seja nulo, o script irá utilizar o padrão
                    }

                    local resposta = vRP.task(source, taskSetup)

                    if resposta then
                        TriggerClientEvent('Notify', source, 'sucesso', 'PARABÉNS! Você passou na Prova I.', 8000)
                    end
                else
                    TriggerClientEvent('Notify', source, 'negado', 'REPROVADO! Você precisa de mais prática.', 8000)
                end

            elseif item == 'provaemoji2' then
                local source = source
                local user_id = vRP.getUserId(source)
                local identity = vRP.getUserIdentity(user_id)

                if vRP.tryGetInventoryItem(user_id, "provaemoji2", 1) then

                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('Notify', source, 'sucesso', 'A prova começará em 3 segundos, BOA SORTE!.',
                        4000)

                    Wait(3000)
                    local x, y, z = vRPclient.getPosition(source)

                    local taskSetup = {
                        type = 6,
                        dificulty = 2,
                        title = "Prova Emoji II", -- caso seja nulo, o script irá utilizar o padrão
                        description = "Selecione o icone de acordo com o apresentado abaixo" -- caso seja nulo, o script irá utilizar o padrão
                    }

                    local resposta = vRP.task(source, taskSetup)

                    if resposta then
                        TriggerClientEvent('Notify', source, 'sucesso', 'PARABÉNS! Você passou na Prova II.', 8000)
                    end
                else
                    TriggerClientEvent('Notify', source, 'negado', 'REPROVADO! Você precisa de mais prática.', 8000)
                end

            elseif item == 'provaemoji3' then
                local source = source
                local user_id = vRP.getUserId(source)
                local identity = vRP.getUserIdentity(user_id)

                if vRP.tryGetInventoryItem(user_id, "provaemoji3", 1) then

                    TriggerClientEvent('inventory:close', source)

                    TriggerClientEvent('Notify', source, 'sucesso', 'A prova começará em 3 segundos, BOA SORTE!.',
                        4000)

                    Wait(3000)

                    local taskSetup = {
                        type = 6,
                        dificulty = 3,
                        title = "Prova Emoji III", -- caso seja nulo, o script irá utilizar o padrão
                        description = "Selecione o icone de acordo com o apresentado abaixo" -- caso seja nulo, o script irá utilizar o padrão
                    }

                    local resposta = vRP.task(source, taskSetup)

                    if resposta then
                        TriggerClientEvent('Notify', source, 'sucesso', 'PARABÉNS! Você passou na Prova III.', 8000)
                    end
                else
                    TriggerClientEvent('Notify', source, 'negado', 'REPROVADO! Você precisa de mais prática.', 8000)
                end

            elseif item == 'provaemoji4' then
                local source = source
                local user_id = vRP.getUserId(source)
                local identity = vRP.getUserIdentity(user_id)

                if vRP.tryGetInventoryItem(user_id, "provaemoji4", 1) then

                    TriggerClientEvent('inventory:close', source)

                    TriggerClientEvent('Notify', source, 'sucesso', 'A prova começará em 3 segundos, BOA SORTE!.',
                        4000)

                    Wait(3000)

                    local taskSetup = {
                        type = 6,
                        dificulty = 4,
                        title = "Prova Emoji IV", -- caso seja nulo, o script irá utilizar o padrão
                        description = "Selecione o icone de acordo com o apresentado abaixo" -- caso seja nulo, o script irá utilizar o padrão
                    }

                    local resposta = vRP.task(source, taskSetup)

                    if resposta then
                        TriggerClientEvent('Notify', source, 'sucesso', 'PARABÉNS! Você passou na Prova IV.', 8000)
                    end
                else
                    TriggerClientEvent('Notify', source, 'negado', 'REPROVADO! Você precisa de mais prática.', 8000)
                end

            elseif item == 'provaemoji5' then
                local source = source
                local user_id = vRP.getUserId(source)
                local identity = vRP.getUserIdentity(user_id)

                if vRP.tryGetInventoryItem(user_id, "provaemoji5", 1) then

                    TriggerClientEvent('inventory:close', source)

                    TriggerClientEvent('Notify', source, 'sucesso', 'A prova começará em 3 segundos, BOA SORTE!.',
                        4000)

                    Wait(3000)

                    local taskSetup = {
                        type = 6,
                        dificulty = 5,
                        title = "Prova Emoji V", -- caso seja nulo, o script irá utilizar o padrão
                        description = "Selecione o icone de acordo com o apresentado abaixo" -- caso seja nulo, o script irá utilizar o padrão
                    }

                    local resposta = vRP.task(source, taskSetup)

                    if resposta then
                        TriggerClientEvent('Notify', source, 'sucesso', 'PARABÉNS! Você passou na Prova V.', 8000)
                    end
                else
                    TriggerClientEvent('Notify', source, 'negado', 'REPROVADO! Você precisa de mais prática.', 8000)
                end

            elseif item == 'provamath1' then
                local source = source
                local user_id = vRP.getUserId(source)
                local identity = vRP.getUserIdentity(user_id)

                if vRP.tryGetInventoryItem(user_id, "provamath1", 1) then

                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('Notify', source, 'sucesso', 'A prova começará em 3 segundos, BOA SORTE!.',
                        4000)

                    Wait(3000)

                    local x, y, z = vRPclient.getPosition(source)

                    local taskSetup = {
                        type = 7,
                        dificulty = 1,
                        title = "Prova Math I", -- caso seja nulo, o script irá utilizar o padrão
                        description = "Resolva a equação abaixo" -- caso seja nulo, o script irá utilizar o padrão
                    }

                    local resposta = vRP.task(source, taskSetup)

                    if resposta then
                        TriggerClientEvent('Notify', source, 'sucesso', 'PARABÉNS! Você passou na Prova I.', 8000)
                    end
                else
                    TriggerClientEvent('Notify', source, 'negado', 'REPROVADO! Você precisa de mais prática.', 8000)
                end

            elseif item == 'provamath2' then
                local source = source
                local user_id = vRP.getUserId(source)
                local identity = vRP.getUserIdentity(user_id)

                if vRP.tryGetInventoryItem(user_id, "provamath2", 1) then

                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('Notify', source, 'sucesso', 'A prova começará em 3 segundos, BOA SORTE!.',
                        4000)

                    Wait(3000)
                    local x, y, z = vRPclient.getPosition(source)

                    local taskSetup = {
                        type = 7,
                        dificulty = 2,
                        title = "Prova Math II", -- caso seja nulo, o script irá utilizar o padrão
                        description = "Resolva a equação abaixo" -- caso seja nulo, o script irá utilizar o padrão
                    }

                    local resposta = vRP.task(source, taskSetup)

                    if resposta then
                        TriggerClientEvent('Notify', source, 'sucesso', 'PARABÉNS! Você passou na Prova II.', 8000)
                    end
                else
                    TriggerClientEvent('Notify', source, 'negado', 'REPROVADO! Você precisa de mais prática.', 8000)
                end

            elseif item == 'provamath3' then
                local source = source
                local user_id = vRP.getUserId(source)
                local identity = vRP.getUserIdentity(user_id)

                if vRP.tryGetInventoryItem(user_id, "provamath3", 1) then

                    TriggerClientEvent('inventory:close', source)

                    TriggerClientEvent('Notify', source, 'sucesso', 'A prova começará em 3 segundos, BOA SORTE!.',
                        4000)

                    Wait(3000)

                    local taskSetup = {
                        type = 7,
                        dificulty = 3,
                        title = "Prova Math III", -- caso seja nulo, o script irá utilizar o padrão
                        description = "Resolva a equação abaixo" -- caso seja nulo, o script irá utilizar o padrão
                    }

                    local resposta = vRP.task(source, taskSetup)

                    if resposta then
                        TriggerClientEvent('Notify', source, 'sucesso', 'PARABÉNS! Você passou na Prova III.', 8000)
                    end
                else
                    TriggerClientEvent('Notify', source, 'negado', 'REPROVADO! Você precisa de mais prática.', 8000)
                end

            elseif item == 'provamath4' then
                local source = source
                local user_id = vRP.getUserId(source)
                local identity = vRP.getUserIdentity(user_id)

                if vRP.tryGetInventoryItem(user_id, "provamath4", 1) then

                    TriggerClientEvent('inventory:close', source)

                    TriggerClientEvent('Notify', source, 'sucesso', 'A prova começará em 3 segundos, BOA SORTE!.',
                        4000)

                    Wait(3000)

                    local taskSetup = {
                        type = 7,
                        dificulty = 4,
                        title = "Prova Math IV", -- caso seja nulo, o script irá utilizar o padrão
                        description = "Resolva a equação abaixo" -- caso seja nulo, o script irá utilizar o padrão
                    }

                    local resposta = vRP.task(source, taskSetup)

                    if resposta then
                        TriggerClientEvent('Notify', source, 'sucesso', 'PARABÉNS! Você passou na Prova IV.', 8000)
                    end
                else
                    TriggerClientEvent('Notify', source, 'negado', 'REPROVADO! Você precisa de mais prática.', 8000)
                end

            elseif item == 'provamath5' then
                local source = source
                local user_id = vRP.getUserId(source)
                local identity = vRP.getUserIdentity(user_id)

                if vRP.tryGetInventoryItem(user_id, "provamath5", 1) then

                    TriggerClientEvent('inventory:close', source)

                    TriggerClientEvent('Notify', source, 'sucesso', 'A prova começará em 3 segundos, BOA SORTE!.',
                        4000)

                    Wait(3000)

                    local taskSetup = {
                        type = 7,
                        dificulty = 5,
                        title = "Prova Math V", -- caso seja nulo, o script irá utilizar o padrão
                        description = "Resolva a equação abaixo" -- caso seja nulo, o script irá utilizar o padrão
                    }

                    local resposta = vRP.task(source, taskSetup)

                    if resposta then
                        TriggerClientEvent('Notify', source, 'sucesso', 'PARABÉNS! Você passou na Prova V.', 8000)
                    end
                else
                    TriggerClientEvent('Notify', source, 'negado', 'REPROVADO! Você precisa de mais prática.', 8000)
                end

            elseif item == 'provacor1' then
                local source = source
                local user_id = vRP.getUserId(source)
                local identity = vRP.getUserIdentity(user_id)

                if vRP.tryGetInventoryItem(user_id, "provacor1", 1) then

                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('Notify', source, 'sucesso', 'A prova começará em 3 segundos, BOA SORTE!.',
                        4000)

                    Wait(3000)

                    local x, y, z = vRPclient.getPosition(source)

                    local taskSetup = {
                        type = 5,
                        dificulty = 1,
                        title = "Prova Cores I", -- caso seja nulo, o script irá utilizar o padrão
                        description = "Marque os numeros de acordo com a repetição das cores" -- caso seja nulo, o script irá utilizar o padrão
                    }

                    local resposta = vRP.task(source, taskSetup)

                    if resposta then
                        TriggerClientEvent('Notify', source, 'sucesso', 'PARABÉNS! Você passou na Prova I.', 8000)
                    end
                else
                    TriggerClientEvent('Notify', source, 'negado', 'REPROVADO! Você precisa de mais prática.', 8000)
                end

            elseif item == 'provacor2' then
                local source = source
                local user_id = vRP.getUserId(source)
                local identity = vRP.getUserIdentity(user_id)

                if vRP.tryGetInventoryItem(user_id, "provacor2", 1) then

                    TriggerClientEvent('inventory:close', source)
                    TriggerClientEvent('Notify', source, 'sucesso', 'A prova começará em 3 segundos, BOA SORTE!.',
                        4000)

                    Wait(3000)
                    local x, y, z = vRPclient.getPosition(source)

                    local taskSetup = {
                        type = 5,
                        dificulty = 2,
                        title = "Prova Cores II", -- caso seja nulo, o script irá utilizar o padrão
                        description = "Marque os numeros de acordo com a repetição das cores" -- caso seja nulo, o script irá utilizar o padrão
                    }

                    local resposta = vRP.task(source, taskSetup)

                    if resposta then
                        TriggerClientEvent('Notify', source, 'sucesso', 'PARABÉNS! Você passou na Prova II.', 8000)
                    end
                else
                    TriggerClientEvent('Notify', source, 'negado', 'REPROVADO! Você precisa de mais prática.', 8000)
                end

            elseif item == 'provacor3' then
                local source = source
                local user_id = vRP.getUserId(source)
                local identity = vRP.getUserIdentity(user_id)

                if vRP.tryGetInventoryItem(user_id, "provacor3", 1) then

                    TriggerClientEvent('inventory:close', source)

                    TriggerClientEvent('Notify', source, 'sucesso', 'A prova começará em 3 segundos, BOA SORTE!.',
                        4000)

                    Wait(3000)

                    local taskSetup = {
                        type = 5,
                        dificulty = 3,
                        title = "Prova Cores III", -- caso seja nulo, o script irá utilizar o padrão
                        description = "Marque os numeros de acordo com a repetição das cores" -- caso seja nulo, o script irá utilizar o padrão
                    }

                    local resposta = vRP.task(source, taskSetup)

                    if resposta then
                        TriggerClientEvent('Notify', source, 'sucesso', 'PARABÉNS! Você passou na Prova III.', 8000)
                    end
                else
                    TriggerClientEvent('Notify', source, 'negado', 'REPROVADO! Você precisa de mais prática.', 8000)
                end

            elseif item == 'provacor4' then
                local source = source
                local user_id = vRP.getUserId(source)
                local identity = vRP.getUserIdentity(user_id)

                if vRP.tryGetInventoryItem(user_id, "provacor4", 1) then

                    TriggerClientEvent('inventory:close', source)

                    TriggerClientEvent('Notify', source, 'sucesso', 'A prova começará em 3 segundos, BOA SORTE!.',
                        4000)

                    Wait(3000)

                    local taskSetup = {
                        type = 5,
                        dificulty = 4,
                        title = "Prova Cores IV", -- caso seja nulo, o script irá utilizar o padrão
                        description = "Marque os numeros de acordo com a repetição das cores" -- caso seja nulo, o script irá utilizar o padrão
                    }

                    local resposta = vRP.task(source, taskSetup)

                    if resposta then
                        TriggerClientEvent('Notify', source, 'sucesso', 'PARABÉNS! Você passou na Prova IV.', 8000)
                    end
                else
                    TriggerClientEvent('Notify', source, 'negado', 'REPROVADO! Você precisa de mais prática.', 8000)
                end

            elseif item == 'provacor5' then
                local source = source
                local user_id = vRP.getUserId(source)
                local identity = vRP.getUserIdentity(user_id)

                if vRP.tryGetInventoryItem(user_id, "provacor5", 1) then

                    TriggerClientEvent('inventory:close', source)

                    TriggerClientEvent('Notify', source, 'sucesso', 'A prova começará em 3 segundos, BOA SORTE!.',
                        4000)

                    Wait(3000)

                    local taskSetup = {
                        type = 5,
                        dificulty = 5,
                        title = "Prova Cores V", -- caso seja nulo, o script irá utilizar o padrão
                        description = "Marque os numeros de acordo com a repetição das cores" -- caso seja nulo, o script irá utilizar o padrão
                    }

                    local resposta = vRP.task(source, taskSetup)

                    if resposta then
                        TriggerClientEvent('Notify', source, 'sucesso', 'PARABÉNS! Você passou na Prova V.', 8000)
                    end
                else
                    TriggerClientEvent('Notify', source, 'negado', 'REPROVADO! Você precisa de mais prática.', 8000)
                end

            elseif item == 'repairkit' then
                -- local mecanicoreparo = vRP.getUsersByPermission("mechanic.acess")
                -- if #mecanicoreparo <= 4 then
                -- if hvCLIENT.getPedWeapon(source) == GetHashKey('weapon_wrench') then
                if not vRPclient.isInVehicle(source) then
                    if vRP.tryGetInventoryItem(user_id, "repairkit", 1) then
                        local vehicle = vRPclient.getNearestVehicle(source, 3.5)
                        if vehicle then

                            TriggerClientEvent('inventory:close', source)

                            local source = source
                            local taskSetup = {
                                type = 11,
                                dificulty = 3,
                                title = "Kit de Reparos", -- caso seja nulo, o script irá utilizar o padrão
                                description = "" -- caso seja nulo, o script irá utilizar o padrão
                            }

                            local resposta = vRP.task(source, taskSetup)

                            if resposta then
                                TriggerClientEvent('cancelando', source, true)
                                TriggerClientEvent('inventory:close', source)
                                vRPclient._playAnim(source, false, {{'mini@repair', 'fixing_a_player'}}, true)
                                TriggerClientEvent('progress', source, 25000, 'reparando veículo')
                                SetTimeout(25000, function()
                                    TriggerClientEvent('cancelando', source, false)
                                    TriggerClientEvent('reparar', source)
                                    vRPclient._stopAnim(source, false)
                                end)
                            end
                        end
                    end
                else
                    TriggerClientEvent('Notify', source, 'negado',
                        'Você não pode usar um kit de reparos dentro do veículo.')
                end
                -- else
                -- if vRP.hasPermission(user_id "mechanic.acess") or vRP.hasPermission(user_id "pmall.acess") then
                --     if vRP.tryGetInventoryItem(user_id,"repairkit",1) then
                --         if not vRPclient.isInVehicle(source) then
                --             local vehicle = vRPclient.getNearestVehicle(source, 3.5)
                --             if vehicle then

                --                 TriggerClientEvent('inventory:close',source)

                --                 local source = source
                --                 local taskSetup = {
                --                     type = 11,
                --                     dificulty = 3,
                --                     title = "Kit de Reparos", -- caso seja nulo, o script irá utilizar o padrão
                --                     description = "" -- caso seja nulo, o script irá utilizar o padrão
                --                 }

                --                 local resposta = vRP.task(source, taskSetup)

                --                 if resposta then
                --                     TriggerClientEvent('cancelando', source, true)
                --                     TriggerClientEvent('inventory:close',source)
                --                     vRPclient._playAnim(source, false, {{'mini@repair', 'fixing_a_player'}}, true)
                --                     TriggerClientEvent('progress', source, 25000, 'reparando veículo')
                --                     SetTimeout(25000, function()
                --                         TriggerClientEvent('cancelando', source, false)
                --                         TriggerClientEvent('reparar', source)
                --                         vRPclient._stopAnim(source, false)
                --                     end)
                --                 end
                --             end
                --         end
                --     end
                -- else
                --     TriggerClientEvent("Notify",source,"aviso","<b>Há mecânicos em serviço, faça um chamado.</b>")
                -- end
                -- end

            elseif item == 'pneu' then
                if not vRPclient.inVehicle(source) then
                    if GetPlayerRoutingBucket(source) ~= 0 then
                        TriggerClientEvent('Notify', source, 'aviso', 'Você não pode utilizar isso na garagem.', 7000)
                        return
                    end

                    -- if hvCLIENT.getPedWeapon(source) == GetHashKey('weapon_wrench') then
                    local vehicle, vehNet = vRPclient.vehList(source, 4)
                    if vehicle then
                        local pneu = vADMIN.GetClosestVehicleTire(source, vehicle)
                        if pneu then
                            if vADMIN.isVehicleTyreBurst(source, vehicle, pneu.tireIndex) then

                                TriggerClientEvent('+invUpdate', source, 'inventory')
                                TriggerClientEvent('cancelando', source, true)
                                TriggerClientEvent('inventory:close', source)
                                vRPclient._playAnim(source, false, {{'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                                                                     'machinic_loop_mechandplayer'}}, true)

                                local source = source
                                local taskSetup = {
                                    type = 2,
                                    dificulty = 3,
                                    title = "Troca de Pneu", -- caso seja nulo, o script irá utilizar o padrão
                                    description = "" -- caso seja nulo, o script irá utilizar o padrão
                                }

                                local resposta = vRP.task(source, taskSetup)

                                if resposta then
                                    if vRP.tryGetInventoryItem(user_id, "pneu", 1) then
                                        TriggerClientEvent('core_mechanic:repairTireExact', -1, vehNet, pneu.tireIndex)
                                        TriggerClientEvent('Notify', source, 'sucesso', 'Pneu trocado com sucesso!',
                                            6000)
                                    end
                                end

                                vRPclient._stopAnim(source, false)
                                TriggerClientEvent('cancelando', source, false)

                            else
                                TriggerClientEvent('Notify', source, 'negado', 'Esse pneu não está furado!', 6000)
                            end

                        else
                            TriggerClientEvent('Notify', source, 'negado', 'Nenhum pneu encontrado! Aproxime-se mais.',
                                6000)
                        end
                    end
                    -- else
                    --    TriggerClientEvent('Notify', source, 'negado', 'Você precisa de uma chave de grifo em suas mãos.')
                    --    return false
                    -- end
                end

            elseif item == 'notebook' then
                if vRPclient.isInVehicle(source) then
                    local vehicle, vnetid, placa, vname, lock, banned = vRPclient.vehList(source, 7)
                    if vehicle and placa then
                        consumeItem[user_id] = true
                        vGARAGE.freezeVehicleNotebook(source, vehicle)
                        TriggerClientEvent('cancelando', source, true)
                        TriggerClientEvent('progress', source, 59500, 'removendo rastreador')
                        TriggerClientEvent('inventory:close', source)
                        SetTimeout(60000, function()
                            consumeItem[user_id] = nil
                            TriggerClientEvent('cancelando', source, false)
                            local placa_user_id = vRP.getVehiclePlate(placa)
                            if placa_user_id then
                                local player = vRP.getUserSource(placa_user_id)
                                if player then
                                    vGARAGE.removeGpsVehicle(player, vname)
                                end
                            end
                        end)
                    end
                end

            elseif item == 'placa' then
                if vRPclient.GetVehicleSeat(source) then
                    if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                        local placa = vRP.generatePlate()
                        TriggerClientEvent('+invUpdate', source, 'inventory')
                        TriggerClientEvent('cancelando', source, true)
                        TriggerClientEvent('vehicleanchor', source)
                        TriggerClientEvent('progress', source, 59500, 'clonando')
                        TriggerClientEvent('inventory:close', source)
                        SetTimeout(60000, function()
                            TriggerClientEvent('cancelando', source, false)
                            TriggerClientEvent('cloneplates', source, placa)
                            -- TriggerEvent('setPlateEveryone',placa)
                            TriggerClientEvent('Notify', source, 'sucesso', 'Placa clonada com sucesso.', 8000)
                        end)
                    end
                end

            elseif item == 'skate' then
                if not vRPclient.inVehicle(source) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('cancelando', source, true)
                    TriggerClientEvent('inventory:close', source)
                    -- local taskResult = vTASKBAR.taskTwo(source)
                    -- if taskResult then
                    if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                        TriggerClientEvent('skate', source)
                    end
                    -- end
                    TriggerClientEvent('cancelando', source, false)
                end

            elseif item == 'analyzer' then
                if not vRPclient.inVehicle(source) then
                    if vRP.hasPermission(user_id, "pmall.acess") then
                        TriggerClientEvent('+invUpdate', source, 'inventory')
                        TriggerClientEvent('inventory:close', source)
                        Citizen.Wait(100)
                        TriggerClientEvent("snt/policeTests/openPoliceAnalyzer", source)
                    end
                end

            elseif item == 'alcoolgel' then
                if not vRPclient.inVehicle(source) then
                    TriggerClientEvent('+invUpdate', source, 'inventory')
                    TriggerClientEvent('inventory:close', source)
                    if vRP.tryGetInventoryItemByUse(user_id, item, 1, true) then
                        consumeItem[user_id] = true
                        TriggerClientEvent('cancelando', source, true)
                        TriggerClientEvent('progress', source, 10000, 'Limpando as mãos')
                        TriggerClientEvent('inventory:close', source)
                        vRPclient._playAnim(source, true, {{"missheist_agency3aig_23", "urinal_sink_loop"}}, true)
                        SetTimeout(10000, function()
                            consumeItem[user_id] = nil
                            TriggerClientEvent('cancelando', source, false)
                            vRPclient.stopAnim(source, false)

                            -- Limpar Apenas um \/
                            exports["snt_modules2"]:clearCharacterSpecificResidue(user_id, "gunpowder")
                            -- Limpar todos \/
                            -- exports["snt_modules2"]:clearAllCharacterResidues(user_id)

                            TriggerClientEvent("Notify", source, "sucesso", "Suas mãos foram limpas!", 5000)
                        end)
                    end
                end
            elseif item == 'resetchar' then
                if vRP.tryGetInventoryItem(user_id, item, 1, true) then
                    TriggerEvent('ResetChar', source)
                end
            elseif item == 'tracker' then
                TriggerEvent('item:tracker', source)
            elseif item == 'remtracker' then
                TriggerEvent('item:remtracker', source)
            elseif item == 'bloqueador' then
                TriggerEvent('item:bloqueador', source)
            elseif item == 'soap' then
                TriggerClientEvent('inventory:close', source)
                if vRP.tryGetInventoryItem(user_id, item, 1, true) then
                    vRPclient._playAnim(source, false, {{"amb@world_human_bum_wash@male@high@base", "base"}}, true)
                    TriggerClientEvent('progress', source, 10000, 'Se limpando...')
                    SetTimeout(10000, function()
                        TriggerClientEvent('clearped', source)
                    end)
                end
            elseif item == 'cashluckybox' then
                TriggerClientEvent('inventory:close', source)
                if vRP.tryGetInventoryItem(user_id, item, 1, true) then
                    local random = math.random(100)
                    local webhookcashluckybox =
                        'https://discord.com/api/webhooks/1127214002775273604/mBSsVCoh5t8nal4bhxIoOBkJiYCYBJtWJUqyGRx4CCVqACGl2ibJl6povSd3APDFXMOw' -- 'https://discord.com/api/webhooks/1118687416715313152/hONrWi6gLYdREp9-jmal7eGDxteI5WPq6hKHcTqufoVc1BWXEOqcGqm14J8FLKML0HZ4'
                    local identity = vRP.getUserIdentity(user_id)
                    if random >= 98 and random <= 99 then -- 2% de chance
                        vRP.giveBankMoney(user_id, 1000000)
                        -- TriggerClientEvent("Notify",source,"sucesso","Você ganhou R$500.000!",5000)
                        TriggerClientEvent('lootbox:initluckybox', source, {
                            type = 'itens',
                            name = 'R$1.000.000',
                            index = 'dinheiro'
                        })
                        webhook(webhookcashluckybox,
                            '```ini\n[ID]: ' .. user_id .. '\n[GANHOU NA LUCKYBOX]: R$1.000.000' ..
                                os.date('\n[DATA]: %d/%m/%Y [Hora]: %H:%M:%S') .. ' \r```')
                        TriggerClientEvent('rewardnotify', -1, 'cashbox', identity.name .. ' #' .. user_id, 'ganhou',
                            'R$1.000.000')

                    elseif random >= 94 and random <= 97 then -- 4% de chance
                        vRP.giveBankMoney(user_id, 500000)
                        TriggerClientEvent('lootbox:initluckybox', source, {
                            type = 'itens',
                            name = 'R$500.000',
                            index = 'dinheiro'
                        })
                        webhook(webhookcashluckybox,
                            '```ini\n[ID]: ' .. user_id .. '\n[GANHOU NA LUCKYBOX]: R$500.000' ..
                                os.date('\n[DATA]: %d/%m/%Y [Hora]: %H:%M:%S') .. ' \r```')
                        TriggerClientEvent('rewardnotify', -1, 'cashbox', identity.name .. ' #' .. user_id, 'ganhou',
                            'R$500.000')

                    elseif random >= 90 and random <= 95 then -- 6% de chance
                        vRP.giveBankMoney(user_id, 300000)
                        TriggerClientEvent('lootbox:initluckybox', source, {
                            type = 'itens',
                            name = 'R$300.000',
                            index = 'dinheiro'
                        })
                        webhook(webhookcashluckybox,
                            '```ini\n[ID]: ' .. user_id .. '\n[GANHOU NA LUCKYBOX]: R$300.000' ..
                                os.date('\n[DATA]: %d/%m/%Y [Hora]: %H:%M:%S') .. ' \r```')
                        TriggerClientEvent('rewardnotify', -1, 'cashbox', identity.name .. ' #' .. user_id, 'ganhou',
                            'R$300.000')

                    elseif random >= 75 and random <= 89 then -- 15% de chance
                        vRP.giveBankMoney(user_id, 150000)
                        TriggerClientEvent('lootbox:initluckybox', source, {
                            type = 'itens',
                            name = 'R$150.000',
                            index = 'dinheiro'
                        })
                        webhook(webhookcashluckybox,
                            '```ini\n[ID]: ' .. user_id .. '\n[GANHOU NA LUCKYBOX]: R$150.000' ..
                                os.date('\n[DATA]: %d/%m/%Y [Hora]: %H:%M:%S') .. ' \r```')

                    elseif random >= 50 and random <= 74 then -- 25% de chance
                        vRP.giveBankMoney(user_id, 60000)
                        TriggerClientEvent('lootbox:initluckybox', source, {
                            type = 'itens',
                            name = 'R$60.000',
                            index = 'dinheiro'
                        })
                        webhook(webhookcashluckybox,
                            '```ini\n[ID]: ' .. user_id .. '\n[GANHOU NA LUCKYBOX]: R$60.000' ..
                                os.date('\n[DATA]: %d/%m/%Y [Hora]: %H:%M:%S') .. ' \r```')

                    elseif random >= 1 and random <= 49 then -- 50% de chance
                        vRP.giveBankMoney(user_id, 30000)
                        TriggerClientEvent('lootbox:initluckybox', source, {
                            type = 'itens',
                            name = 'R$30.000',
                            index = 'dinheiro'
                        })
                        webhook(webhookcashluckybox,
                            '```ini\n[ID]: ' .. user_id .. '\n[GANHOU NA LUCKYBOX]: R$30.000' ..
                                os.date('\n[DATA]: %d/%m/%Y [Hora]: %H:%M:%S') .. ' \r```')
                        return true
                    end
                end

            elseif item == 'itemluckybox' then
                TriggerClientEvent('inventory:close', source)
                if vRP.tryGetInventoryItem(user_id, item, 1, true) then
                    local random = math.random(100)
                    local webhookitemluckybox =
                        'https://discord.com/api/webhooks/1126656156820045926/jYQRJscJpjBpo9yH6BOdTbFuB-uMfPTYoqQ_55GA3wNuAtBXn4A6R_7alz95dPz2Wbj_'
                    local identity = vRP.getUserIdentity(user_id)
                    if random >= 98 and random <= 99 then -- 2% de chance
                        vRP.giveInventoryItem(user_id, 'carrovip1', 1)
                        TriggerClientEvent('lootbox:initluckybox', source, {
                            type = 'itens',
                            name = 'CAR TIER 1 Loot Box',
                            index = 'carrovip1'
                        })
                        webhook(webhookitemluckybox,
                            '```ini\n[ID]: ' .. user_id .. '\n[GANHOU NA LUCKYBOX]: 01x CAR TIER 1 Loot Box' ..
                                os.date('\n[DATA]: %d/%m/%Y [Hora]: %H:%M:%S') .. ' \r```')
                        TriggerClientEvent('rewardnotify', -1, 'luckybox', identity.name .. ' #' .. user_id, 'ganhou',
                            'CAR TIER 1 Loot Box')

                    elseif random >= 94 and random <= 97 then -- 4% de chance
                        vRP.giveInventoryItem(user_id, 'cashluckybox', 2)
                        TriggerClientEvent('lootbox:initluckybox', source, {
                            type = 'itens',
                            name = 'Cash Lucky Box',
                            index = 'cashluckybox'
                        })
                        webhook(webhookitemluckybox,
                            '```ini\n[ID]: ' .. user_id .. '\n[GANHOU NA LUCKYBOX]: 02x Cash Lucky Box' ..
                                os.date('\n[DATA]: %d/%m/%Y [Hora]: %H:%M:%S') .. ' \r```')
                        TriggerClientEvent('rewardnotify', -1, 'luckybox', identity.name .. ' #' .. user_id, 'ganhou',
                            'Cash Lucky Box')

                    elseif random >= 90 and random <= 95 then -- 6% de chance
                        vRP.giveInventoryItem(user_id, 'vehicleluckybox', 1)
                        TriggerClientEvent('lootbox:initluckybox', source, {
                            type = 'itens',
                            name = 'Vehicle Lucky Box',
                            index = 'vehicleluckybox'
                        })
                        webhook(webhookitemluckybox,
                            '```ini\n[ID]: ' .. user_id .. '\n[GANHOU NA LUCKYBOX]: 01x Vehicle Lucky Box' ..
                                os.date('\n[DATA]: %d/%m/%Y [Hora]: %H:%M:%S') .. ' \r```')
                        TriggerClientEvent('rewardnotify', -1, 'luckybox', identity.name .. ' #' .. user_id, 'ganhou',
                            'Vehicle Lucky Box')

                    elseif random >= 75 and random <= 89 then -- 15% de chance
                        vRP.giveInventoryItem(user_id, 'colete', 1)
                        TriggerClientEvent('lootbox:initluckybox', source, {
                            type = 'itens',
                            name = 'Colete',
                            index = 'colete'
                        })
                        webhook(webhookitemluckybox,
                            '```ini\n[ID]: ' .. user_id .. '\n[GANHOU NA LUCKYBOX]: 01x Colete' ..
                                os.date('\n[DATA]: %d/%m/%Y [Hora]: %H:%M:%S') .. ' \r```')
                        TriggerClientEvent('rewardnotify', -1, 'luckybox', identity.name .. ' #' .. user_id, 'ganhou',
                            'Colete')

                    elseif random >= 61 and random <= 74 then -- 15% de chance
                        vRP.giveInventoryItem(user_id, 'milhocozido', 3)
                        TriggerClientEvent('lootbox:initluckybox', source, {
                            type = 'itens',
                            name = 'Milho Cozido',
                            index = 'milhocozido'
                        })
                        webhook(webhookitemluckybox,
                            '```ini\n[ID]: ' .. user_id .. '\n[GANHOU NA LUCKYBOX]: 03x Milho Cozido' ..
                                os.date('\n[DATA]: %d/%m/%Y [Hora]: %H:%M:%S') .. ' \r```')
                        -- TriggerClientEvent('rewardnotify', -1, 'luckybox',identity.name..' #'..user_id,'ganhou','Milho Cozido')

                    elseif random >= 41 and random <= 60 then -- 22% de chance
                        vRP.giveInventoryItem(user_id, 'quentao', 3)
                        TriggerClientEvent('lootbox:initluckybox', source, {
                            type = 'itens',
                            name = 'Quentão',
                            index = 'quentao'
                        })
                        webhook(webhookitemluckybox,
                            '```ini\n[ID]: ' .. user_id .. '\n[GANHOU NA LUCKYBOX]: 03x Quentão' ..
                                os.date('\n[DATA]: %d/%m/%Y [Hora]: %H:%M:%S') .. ' \r```')
                        -- TriggerClientEvent('rewardnotify', -1, 'luckybox',identity.name..' #'..user_id,'ganhou','Quentão')

                    elseif random >= 21 and random <= 40 then -- 22% de chance
                        vRP.giveInventoryItem(user_id, 'vinhoquente', 3)
                        TriggerClientEvent('lootbox:initluckybox', source, {
                            type = 'itens',
                            name = 'Vinho Quente',
                            index = 'vinhoquente'
                        })
                        webhook(webhookitemluckybox,
                            '```ini\n[ID]: ' .. user_id .. '\n[GANHOU NA LUCKYBOX]: 03x Vinho Quente' ..
                                os.date('\n[DATA]: %d/%m/%Y [Hora]: %H:%M:%S') .. ' \r```')
                        -- TriggerClientEvent('rewardnotify', -1, 'luckybox',identity.name..' #'..user_id,'ganhou','Vinho Quente')

                    elseif random <= 20 then -- 20% de chance
                        vRP.giveInventoryItem(user_id, 'fichadepescaria', 20)
                        TriggerClientEvent('lootbox:initluckybox', source, {
                            type = 'itens',
                            name = 'Ficha de Pescaria',
                            index = 'fichadepescaria'
                        })
                        webhook(webhookitemluckybox,
                            '```ini\n[ID]: ' .. user_id .. '\n[GANHOU NA LUCKYBOX]: 20x Ficha de Pescaria' ..
                                os.date('\n[DATA]: %d/%m/%Y [Hora]: %H:%M:%S') .. ' \r```')
                        -- TriggerClientEvent('rewardnotify', -1, 'luckybox',identity.name..' #'..user_id,'ganhou','Ficha de Pescaria')
                        return true
                    end
                end

            elseif item == 'vehicleluckybox' then
                TriggerClientEvent('inventory:close', source)
                if vRP.tryGetInventoryItem(user_id, item, 1, true) then
                    local webhookvehicleluckybox =
                        'https://discord.com/api/webhooks/1118687205733433354/yyIf12f5-Dqzx29lx0iixA6BwvklpUI8S5QqIyXJrSGYLurGhwfsAXe7gRzbrsvZFbCh'
                    local vehiclescanwin = {'italigto', 'italirsx', 'comet6', 'tezeract', 'jester3', 'sultan2',
                                            'zentorno', 'rhapsody', 'issi3', 'blista', 'blista2', 'brioso',
                                            'dilettante', 'issi2', 'isso7', 'panto', 'prairie', 'exemplar', 'f620',
                                            'zion2', 'oracle2', 'sentinel', 'sentinel2', 'windsor', 'windsor2',
                                            'guardian', 'akuma', 'avarus', 'bati', 'bati2', 'bf400', 'carbonrs',
                                            'chimera', 'cliffhanger', 'daemon', 'daemon2', 'defiler', 'diablous',
                                            'diablous2', 'enduro', 'esskey', 'faggio', 'faggio2', 'faggio3', 'fcr',
                                            'fcr2', 'hakuchou', 'lectro', 'manchez', 'manchez2', 'nemesis',
                                            'nightblade', 'pcj', 'sanchez2', 'sanctus', 'sovereign', 'shotaro',
                                            'ratbike', 'blade', 'buccaneer', 'chino', 'chino2', 'coquette3', 'deviant',
                                            'dominator', 'dominator2', 'dominator3', 'faction', 'faction2', 'faction3',
                                            'impaler', 'nightsade', 'bfinjection', 'bifta', 'dloader', 'dubsta3',
                                            'everon', 'freecrawler', 'kamacho', 'mesa3', 'sandking', 'sandking2',
                                            'rebel2', 'rancherxl', 'baller', 'baller2', 'baller3', 'baller4', 'baller5',
                                            'baller6', 'dubsta2', 'dubsta', 'granger', 'gresley', 'habanero', 'huntley',
                                            'mesa', 'toros', 'xls', 'xls2', 'novak', 'asea', 'cog552', 'cognoscenti',
                                            'cognoscenti2', 'emperor', 'emperor2', 'tailgater', 'banshee', 'bestiagts',
                                            'blista3', 'buffalo', 'buffalo2', 'buffalo3', 'carbonizzare', 'comet2',
                                            'comet3', 'comet5', 'coquette', 'elegy', 'elegy2', 'khamelion', 'kuruma',
                                            'lynx', 'massacro', 'massacro2', 'neon', 'omnis', 'pariah', 'rapidgt',
                                            'rapidgt2', 'schafter3', 'schafter4', 'schafter5', 'schlagen', 'schwarzer',
                                            'sentinel3', 'seven70', 'specter', 'specter2', 'streiter', 'sultan',
                                            'surano', 'sugoi', 'tampa2', 'growler', 'cheetah', 'coquette2', 'feltzer3',
                                            'gt500', 'fagaloa', 'mamba', 'manana', 'monroe', 'rapidgt3', 'stingergt',
                                            'tornado', 'tornado2', 'tornado6', 'cheburek', 'btype2', 'btype3', 'weevil',
                                            'infernus2', 'retinue', 'jester', 'feltzer2', 'ninef', 'ninef2', 'turismo2',
                                            'ztype', 'adder', 'banshee2', 'cheetah2', 'entityxf', 'entity2', 'fmj',
                                            'infernus', 'nero', 'nero2', 'italigtb', 'italigtb2', 'pfister811',
                                            'prototipo', 'reaper', 't20', 'tempesta', 'turismor', 'vacca', 'voltic',
                                            'osiris', 'tyrant', 'flashgt', 'taipan', 'cyclone', 'xa21', 'z190',
                                            'sadler', 'bison', 'bison2', 'burrito', 'burrito2', 'burrito3', 'minivan',
                                            'minivan2', 'paradise', 'pony', 'pony2', 'rumpo', 'rumpo3', 'zentorno'}
                    local identity = vRP.getUserIdentity(user_id)
                    local random = vehiclescanwin[math.random(#vehiclescanwin)]
                    if random then
                        exports["nation-garages"]:addUserVehicle(random, user_id, {}, {})
                        TriggerClientEvent('lootbox:initluckybox', source, {
                            type = 'vehicles',
                            name = random,
                            index = random
                        })
                        webhook(webhookvehicleluckybox,
                            '```ini\n[ID]: ' .. user_id .. '\n[GANHOU NA LUCKYBOX]: ' .. random ..
                                os.date('\n[DATA]: %d/%m/%Y [Hora]: %H:%M:%S') .. ' \r```')
                        TriggerClientEvent('rewardnotify', -1, 'luckybox', identity.name .. ' #' .. user_id,
                            'GANHOU UM', random)
                    end
                end
            elseif item == 'supervehicleluckybox' then
                TriggerClientEvent('inventory:close', source)
                if vRP.tryGetInventoryItem(user_id, item, 1, true) then
                    local webhooksupervehicleluckybox =
                        'https://discord.com/api/webhooks/1118687205733433354/yyIf12f5-Dqzx29lx0iixA6BwvklpUI8S5QqIyXJrSGYLurGhwfsAXe7gRzbrsvZFbCh'
                    local supervehiclescanwin = {"kuruma2", 'toyotasupra', 'skyline'}
                    local identity = vRP.getUserIdentity(user_id)
                    local random = supervehiclescanwin[math.random(#supervehiclescanwin)]
                    if random then
                        exports["nation-garages"]:addUserVehicle(random, user_id, {}, {})
                        TriggerClientEvent('lootbox:initluckybox', source, {
                            type = 'vehicles',
                            name = random,
                            index = random
                        })
                        webhook(webhooksupervehicleluckybox,
                            '```ini\n[ID]: ' .. user_id .. '\n[GANHOU NA SUPERLUCKYBOX]: ' .. random ..
                                os.date('\n[DATA]: %d/%m/%Y [Hora]: %H:%M:%S') .. ' \r```')
                        TriggerClientEvent('rewardnotify', -1, 'luckybox', identity.name .. ' #' .. user_id,
                            'GANHOU UM', random)
                    end
                end
            elseif item == 'carrovip1' then
                if vRP.tryGetInventoryItem(user_id, item, 1, true) then
                    TriggerClientEvent('lootbox:initlootbox', source, item, 3)
                end
            elseif item == 'carrovip2' then
                if vRP.tryGetInventoryItem(user_id, item, 1, true) then
                    TriggerClientEvent('lootbox:initlootbox', source, item, 7)
                end
            elseif item == 'carrovip3' then
                if vRP.tryGetInventoryItem(user_id, item, 1, true) then
                    TriggerClientEvent('lootbox:initlootbox', source, item, 15)
                end
            elseif item == 'carrovip4' then
                if vRP.tryGetInventoryItem(user_id, item, 1, true) then
                    TriggerClientEvent('lootbox:initlootbox', source, item, 30)
                end
            elseif item == 'pedecabra' then
                local canTheft, interiorTier = exports["snt_modules"]:checkHouseTheft(source)
                if not canTheft then
                    return
                end
                local chanceToBreak = 15
                if math.random(100) <= chanceToBreak then
                    TriggerClientEvent("Notify", source, "negado", "O Pé de Cabra <b>quebrou</b>.", 3000)
                    vRP.tryGetInventoryItem(user_id, item, 1, true)
                    return
                end
                local taskSetup = {
                    type = 11,
                    dificulty = 4,
                    title = "Pé de cabra", -- caso seja nulo, o script irá utilizar o padrão
                    description = "" -- caso seja nulo, o script irá utilizar o padrão
                }

                local resposta = vRP.task(source, taskSetup)
                vRPclient._playAnim(source, false, {{'missfbi_s4mop', 'clean_mop_back_player'}}, true)
                if resposta then
                    if vRP.tryGetInventoryItem(user_id, item, 1, true) then
                        vRPclient._stopAnim(source, false)
                        exports["snt_modules"]:createHouseTheft(source)
                    end
                else
                    TriggerClientEvent("Notify", source, "negado", "O Pé de Cabra <b>quebrou</b>.", 3000)
                end
            elseif item == "c4" then
                local Service = vRP.getUsersByPermission('pmall.acess')
                local source = source
                local vehicle, vnetid, Plate, vname, lock, banned, trunk, model, street = vRPclient.vehList(source, 7)
                local Passport = vRP.getUserId(source)
                if Passport and Plate and vname == 'stockade' then

                    if Stockade[Plate] == nil then
                        Stockade[Plate] = 0
                    end

                    if Stockade[Plate] >= 1 then
                        TriggerClientEvent("Notify", source, "aviso", "Vazio.", 5000)
                        return
                    end

                    Stockade[Plate] = Stockade[Plate] + 1
                    if vRP.tryGetInventoryItem(Passport, "c4", 1) then
                        Active[Passport] = os.time() + 15
                        Player(source)["state"]["Buttons"] = true
                        TriggerClientEvent("inventory:Close", source)
                        TriggerClientEvent("Progress", source, "Plantando", 15000)
                        vRPC.playAnim(source, false,
                            {{"anim@heists@ornate_bank@thermal_charge_heels", "thermal_charge"}}, true)
                        Wait(7000)
                        vRPC.stopAnim(source, false)

                        local Ped = GetPlayerPed(source)
                        local Coords = GetEntityCoords(Ped)
                        for _, v in pairs(Service) do
                            local Sources = vRP.getUserSource(parseInt(v))
                            async(function()
                                TriggerClientEvent("NotifyPush", Sources, {
                                    code = 31,
                                    title = "Denúncia de Roubo ao Carro Forte",
                                    x = Coords.x,
                                    y = Coords.y,
                                    z = Coords.z,
                                    badge = place or 'Roubo de Carro Forte'
                                })
                            end)
                        end
                        Wait(8000)
                        TriggerClientEvent('vRP:Explosion', source, vector3(Coords["x"], Coords["y"], Coords["z"] + 1))
                        repeat
                            if os.time() >= parseInt(Active[Passport]) then
                                Active[Passport] = nil
                                Player(source)["state"]["Buttons"] = false
                                vRP.giveInventoryItem(Passport, "dinheirosujo", math.random(60000, 120000))
                            end

                            Wait(100)
                        until Active[Passport] == nil
                        Wait(60000 * 5)
                        -- DeleteEntity(vnetid)
                        TriggerEvent("stockade:explodeVehicle")
                    end
                end
            end
        end
    end
end

