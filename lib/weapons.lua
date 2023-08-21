weapons = {
    ['glock'] = {'WEAPON_COMBATPISTOL','m-glock'},
    ['m1911'] = {'WEAPON_PISTOL','m-m1911'},
    ['bullpup'] = {'WEAPON_BULLPUPRIFLE','m-bullpup'},
    ['deagle'] = {'WEAPON_PISTOL50','m-deagle'},
    ['fiveseven'] = {'WEAPON_PISTOL_MK2','m-fiveseven'},
    ['revolver2'] = {'WEAPON_REVOLVER_MK2','m-revolver2'},
    ['appistol'] = {'WEAPON_APPISTOL','m-appistol'},
    ['snspistol'] = {'WEAPON_SNSPISTOL','m-snspistol'},
    ['revolver'] = {'WEAPON_REVOLVER','m-revolver'},
    ['fajuta'] = {'WEAPON_SNSPISTOL_MK2','m-fajuta'},
    ['desert'] = {'WEAPON_HEAVYPISTOL','m-desert'},
    ['fn1922'] = {'WEAPON_VINTAGEPISTOL','m-fn1922'},
    ['tec9'] = {'WEAPON_MACHINEPISTOL','m-tec9'},
    ['sigsauer'] = {'WEAPON_COMBATPDW','m-sigsauer'},
    ['mtar'] = {'WEAPON_ASSAULTSMG','m-mtar'},
    ['thompson'] = {'WEAPON_GUSENBERG','m-thompson'},
    ['microuzi'] = {'WEAPON_MICROSMG','m-microuzi'},
    ['mp5'] = {'WEAPON_SMG','m-mp5'},
    ['mp5k'] = {'WEAPON_SMG_MK2','m-mp5k'},
    ['scorpion'] = {'WEAPON_MINISMG','m-scorpion'},
    ['m4'] = {'WEAPON_CARBINERIFLE','m-m4'},
    ['m4K'] = {'WEAPON_CARBINERIFLE_MK2','m-m4k'},
    ['g36'] = {'WEAPON_SPECIALCARBINE','m-g36'},
    ['g36k'] = {'WEAPON_SPECIALCARBINE_MK2','m-g36k'},
    ['ak103'] = {'WEAPON_ASSAULTRIFLE_MK2','m-ak103'},
    ['ak74'] = {'WEAPON_ASSAULTRIFLE','m-ak74'},
    ['minidraco'] = {'WEAPON_COMPACTRIFLE','m-minidraco'},
    ['sawn'] = {'WEAPON_SAWNOFFSHOTGUN','m-sawn'},
    ['pumpshotgun'] = {'WEAPON_PUMPSHOTGUN_MK2','m-pumpshotgun'},
    ['mossberg'] = {'WEAPON_PUMPSHOTGUN','m-mossberg'},
    ['uts15'] = {'WEAPON_ASSAULTSHOTGUN','m-uts15'},
    ['ksg'] = {'WEAPON_BULLPUPSHOTGUN','m-ksg'},
    ['saiga12'] = {'WEAPON_HEAVYSHOTGUN','m-saiga12'},
    ['zabala'] = {'WEAPON_DBSHOTGUN','m-zabala'},
    ['combatshotgun'] = {'WEAPON_COMBATSHOTGUN','m-combatshotgun'},
    ['raypistol'] = {'WEAPON_RAYPISTOL','m-raypistol'},
    ['tcg2'] = {'WEAPON_MARKSMANPISTOL','m-tcg2'},
    ['doubleaction'] = {'WEAPON_DOUBLEACTION','m-doubleaction'},
    ['kochp7'] = {'WEAPON_CERAMICPISTOL','m-kochp7'},
    ['colt1851'] = {'WEAPON_NAVYREVOLVER','m-colt1851'},
    ['pericopistol'] = {'WEAPON_GADGETPISTOL','m-pericopistol'},
    ['raycarbine'] = {'WEAPON_RAYCARBINE','m-raycarbine'},

    ['aug'] = {'WEAPON_MILITARYRIFLE','m-militaryrifle'},
    ['m16'] = {'WEAPON_TACTICALRIFLE','m-tacticalrifle'},
    ['scar-h'] = {'WEAPON_HEAVYRIFLE','m-heavyrifle'},
    ['hk45'] = {'WEAPON_PISTOLXM3','m-pistolxm3'},
    ['rifleprecision'] = {'WEAPON_PRECISIONRIFLE','m-precisionrifle'},

    
    ['garrafadevidro'] = {'WEAPON_BOTTLE',''},
    ['martelo'] = {'WEAPON_HAMMER',''},
    ['tacodegolf'] = {'WEAPON_GOLFCLUB',''},
    ['pedecraba'] = {'WEAPON_CROWBAR',''},
    ['machado'] = {'WEAPON_HATCHET',''},
    ['tacodebeisebol'] = {'WEAPON_BAT',''},
    ['socoingles'] = {'WEAPON_KNUCKLE',''},
    ['machete'] = {'WEAPON_MACHETE',''},
    ['faca'] = {'WEAPON_KNIFE',''},
    ['canivete'] = {'WEAPON_SWITCHBLADE',''},
    ['machadodebatalha'] = {'WEAPON_BATTLEAXE',''},
    ['tacodebar'] = {'WEAPON_POOLCUE',''},
    ['chavedegrifo'] = {'WEAPON_WRENCH',''},
    ['machadodepedra'] = {'WEAPON_STONE_HATCHET',''},
    ['paraquedas'] = {'GADGET_PARACHUTE',''},
    ['taser'] = {'WEAPON_STUNGUN',''},
    ['lanterna'] = {'WEAPON_FLASHLIGHT',''},
    ['cassetete'] = {'WEAPON_NIGHTSTICK',''},
    ['extintor'] = {'WEAPON_FIREEXTINGUISHER',''},
    ['sinalizador'] = {'WEAPON_FLAREGUN',''},
    ['gasolina'] = {'WEAPON_PETROLCAN','m-gasolina'}
}

weapon_model = {}
for k,v in pairs(weapons) do
    weapon_model[v[1]] = {k,v[2]}
end

GetWeaponHash = function(item)
    if weapons[item] then
        return GetHashKey(weapons[item][1])
    end
end

GetWeaponModel = function(item)
    if weapons[item] then
        return weapons[item][1]
    end
end


--DESCOBRE O MAXIMO DE MUNICAO DA ARMA
function GetMaxAmmoWeapon(item)
    if weapons[item] then
        return weapons[item][3]
    end
end

-- DESCOBRE A CLASSE DA ARMA
function GetWeaponType(item)
    if weapons[item] then
        return weapons[item][4]
    end
end

-- DESCOBRE A ARMA DA MUNICAO INFORMADA / CRIA UM CACHE DISSO
local AmmosToWeapon = {}
function GetWeaponFromAmmo(ammo)
    if not AmmosToWeapon[ammo] then
        for k,v in pairs(weapons) do
            if v[2] == ammo then
                AmmosToWeapon[ammo] = k
                return AmmosToWeapon[ammo]
            end
        end
    else
        return AmmosToWeapon[ammo]
    end
end

CreateThread(function()
    if not IsDuplicityVersion() then
        Wait(1000)
        for k,v in pairs(weapons) do
            if weapons[k] then
                local hash = GetHashKey(v[1])
                local _,maxAmmo = GetMaxAmmo(PlayerPedId(),hash)
                weapons[k][3] = maxAmmo
            end
        end
    end
end)

attachs = {
	["WEAPON_PISTOL"] = {
		"COMPONENT_AT_PI_FLSH", -- Lanterna
        "COMPONENT_PISTOL_CLIP_02", -- Carregador Extendido
        "COMPONENT_AT_PI_SUPP_02", -- Supressor
        -- textura
        "COMPONENT_PISTOL_VARMOD_LUXE" -- Yusuf Amir Luxury
	},
	["WEAPON_HEAVYPISTOL"] = {
		"COMPONENT_AT_PI_FLSH", -- Lanterna
        "COMPONENT_HEAVYPISTOL_CLIP_02", -- Carregador Extendido
        "COMPONENT_AT_PI_SUPP", -- Supressor
        -- textura
        "COMPONENT_HEAVYPISTOL_VARMOD_LUXE" -- Yusuf Amir Luxury
	},

	["WEAPON_COMBATPISTOL"] = {
		"COMPONENT_AT_PI_FLSH", -- Lanterna
        "COMPONENT_COMBATPISTOL_CLIP_02", -- Carregador Extendido
        "COMPONENT_AT_PI_SUPP", -- Supressor
        -- textura
        "COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER" -- Yusuf Amir Luxury
	},
	["WEAPON_APPISTOL"] = {
		"COMPONENT_AT_PI_FLSH", -- Lanterna
        "COMPONENT_APPISTOL_CLIP_02", -- Carregador Extendido
        "COMPONENT_AT_PI_SUPP", -- Supressor
        -- textura
        "COMPONENT_APPISTOL_VARMOD_LUXE" -- Yusuf Amir Luxury
	},
	["WEAPON_MICROSMG"] = {
		"COMPONENT_AT_PI_FLSH",
		"COMPONENT_AT_SCOPE_MACRO",
        "COMPONENT_MICROSMG_CLIP_02",
        "COMPONENT_AT_AR_SUPP_02",
        -- textura
        "COMPONENT_MICROSMG_VARMOD_LUXE" -- Yusuf Amir Luxury
	},
	["WEAPON_SMG"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MACRO_02",
		"COMPONENT_AT_PI_SUPP"
	},
	["WEAPON_ASSAULTSMG"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MACRO",
		"COMPONENT_AT_AR_SUPP_02",
        "COMPONENT_SMG_CLIP_02",
        "COMPONENT_SMG_CLIP_03",
        "COMPONENT_AT_PI_SUPP",
        -- textura
        "COMPONENT_SMG_VARMOD_LUXE" -- Yusuf Amir Luxury
	},
	["WEAPON_COMBATPDW"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_AR_AFGRIP",
		"COMPONENT_AT_SCOPE_SMALL",
        "COMPONENT_COMBATPDW_CLIP_02",
        "COMPONENT_COMBATPDW_CLIP_03"
	},
	["WEAPON_PUMPSHOTGUN"] = {
		"COMPONENT_AT_AR_FLSH",
        "COMPONENT_AT_SR_SUPP",
        -- textura
        "COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER" -- Yusuf Amir Luxury
	},
	["WEAPON_CARBINERIFLE"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MEDIUM",
		"COMPONENT_AT_AR_AFGRIP",
        "COMPONENT_CARBINERIFLE_CLIP_02",
        "COMPONENT_CARBINERIFLE_CLIP_03",
        "COMPONENT_AT_AR_SUPP",
        -- textura
        "COMPONENT_CARBINERIFLE_VARMOD_LUXE" -- Yusuf Amir Luxury
	},
	["WEAPON_ASSAULTRIFLE"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MACRO",
		"COMPONENT_AT_AR_AFGRIP",
        "COMPONENT_ASSAULTRIFLE_CLIP_02",
        "COMPONENT_ASSAULTRIFLE_CLIP_03",
        "COMPONENT_AT_AR_SUPP_02",
        -- textura
        "COMPONENT_ASSAULTRIFLE_VARMOD_LUXE" -- Yusuf Amir Luxury
	},
	["WEAPON_MACHINEPISTOL"] = {
		"COMPONENT_AT_PI_SUPP",
        "COMPONENT_MACHINEPISTOL_CLIP_02",
        "COMPONENT_MACHINEPISTOL_CLIP_03"
	},
	["WEAPON_ASSAULTRIFLE_MK2"] = {
		"COMPONENT_AT_AR_AFGRIP_02", -- grip
		"COMPONENT_AT_AR_FLSH", -- lanterna
        "COMPONENT_AT_SIGHTS", -- mira holografica
        "COMPONENT_AT_SCOPE_MACRO_MK2", -- mira ecope pequena
        "COMPONENT_AT_SCOPE_MEDIUM_MK2", -- mira escope
        "COMPONENT_ASSAULTRIFLE_MK2_CLIP_02", -- carregador extendido
        "COMPONENT_AT_AR_SUPP_02", -- supressor 
        "COMPONENT_AT_MUZZLE_02",  -- quebra chamadas
        "COMPONENT_AT_MUZZLE_04", -- cano longo
        -- textura
        "COMPONENT_ASSAULTRIFLE_MK2_CAMO", -- Yusuf Amir Luxury
        "COMPONENT_ASSAULTRIFLE_MK2_CAMO_02", -- Yusuf Amir Luxury
        "COMPONENT_ASSAULTRIFLE_MK2_CAMO_03", -- Yusuf Amir Luxury
        "COMPONENT_ASSAULTRIFLE_MK2_CAMO_04", -- Yusuf Amir Luxury
        "COMPONENT_ASSAULTRIFLE_MK2_CAMO_05", -- Yusuf Amir Luxury
        "COMPONENT_ASSAULTRIFLE_MK2_CAMO_06", -- Yusuf Amir Luxury
        "COMPONENT_ASSAULTRIFLE_MK2_CAMO_07", -- Yusuf Amir Luxury
        "COMPONENT_ASSAULTRIFLE_MK2_CAMO_08", -- Yusuf Amir Luxury
        "COMPONENT_ASSAULTRIFLE_MK2_CAMO_09", -- Yusuf Amir Luxury
        "COMPONENT_ASSAULTRIFLE_MK2_CAMO_10", -- Yusuf Amir Luxury
        "COMPONENT_ASSAULTRIFLE_MK2_CAMO_IND_01" -- Yusuf Amir Luxury
	},
	["WEAPON_PISTOL50"] = {
		"COMPONENT_AT_PI_FLSH",
        "COMPONENT_PISTOL50_CLIP_02",
        "COMPONENT_AT_AR_SUPP_02",
        -- textura
        "COMPONENT_PISTOL50_VARMOD_LUXE"
	},
	["WEAPON_SNSPISTOL_MK2"] = {
		"COMPONENT_AT_PI_FLSH_03",
		"COMPONENT_AT_PI_RAIL_02",
		"COMPONENT_AT_PI_COMP_02",
        "COMPONENT_SNSPISTOL_MK2_CLIP_02",
        "COMPONENT_AT_PI_SUPP_02"
	},
	["WEAPON_SMG_MK2"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2",
		"COMPONENT_AT_MUZZLE_01",
        "COMPONENT_AT_SIGHTS_SMG",
        "COMPONENT_AT_SCOPE_SMALL_SMG_MK2",
        "COMPONENT_SMG_MK2_CLIP_02",
        "COMPONENT_AT_PI_SUPP",
        "COMPONENT_AT_MUZZLE_02",
        "COMPONENT_AT_MUZZLE_04"
	},
	["WEAPON_BULLPUPRIFLE"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_SMALL",
		"COMPONENT_AT_AR_SUPP",
        "COMPONENT_BULLPUPRIFLE_CLIP_02",
        "COMPONENT_AT_AR_AFGRIP"
	},
	["WEAPON_BULLPUPRIFLE_MK2"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MACRO_02_MK2",
		"COMPONENT_AT_MUZZLE_01",
        "COMPONENT_AT_SIGHTS",
        "COMPONENT_AT_SCOPE_MACRO_02_MK2",
        "COMPONENT_AT_SCOPE_SMALL_MK2",
        "COMPONENT_BULLPUPRIFLE_MK2_CLIP_02",
        "COMPONENT_AT_AR_AFGRIP_02",
        "COMPONENT_AT_AR_SUPP",
        "COMPONENT_AT_MUZZLE_02"
	},
	["WEAPON_SPECIALCARBINE"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MEDIUM",
		"COMPONENT_AT_AR_AFGRIP",
        "COMPONENT_SPECIALCARBINE_CLIP_03",
        "COMPONENT_AT_SCOPE_MEDIUM",
        "COMPONENT_SPECIALCARBINE_CLIP_02",
        "COMPONENT_AT_AR_AFGRIP",
        "COMPONENT_AT_AR_SUPP_02"
	},
	["WEAPON_SPECIALCARBINE_MK2"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MEDIUM_MK2",
		"COMPONENT_AT_MUZZLE_01",
        "COMPONENT_AT_SIGHTS",
        "COMPONENT_AT_SCOPE_MACRO_MK2",
        "COMPONENT_SPECIALCARBINE_MK2_CLIP_02",
        "COMPONENT_AT_AR_AFGRIP_02",
        "COMPONENT_AT_AR_SUPP_02",
        "COMPONENT_AT_MUZZLE_02",
        "COMPONENT_AT_MUZZLE_04"
	},
    ["WEAPON_PISTOL_MK2"] = {
		"COMPONENT_AT_PI_RAIL",
		"COMPONENT_AT_PI_FLSH_03",
		"COMPONENT_AT_PI_COMP",
        "COMPONENT_PISTOL_MK2_CAMO_08",
        "COMPONENT_AT_PI_SUPP_02",
        "COMPONENT_AT_PI_COMP_02",
        "COMPONENT_SNSPISTOL_MK2_CLIP_02"
	},

    ["WEAPON_SWITCHBLADE"] = {
		"COMPONENT_SWITCHBLADE_VARMOD_VAR1", -- Variant
		"COMPONENT_SWITCHBLADE_VARMOD_VAR2" -- Bodyguard Variant
	},
    ["WEAPON_KNUCKLE"] = {
		"COMPONENT_KNUCKLE_VARMOD_PIMP", -- Pimp
		"COMPONENT_KNUCKLE_VARMOD_BALLAS", -- Ballas 
        "COMPONENT_KNUCKLE_VARMOD_DOLLAR", -- Hustler
        "COMPONENT_KNUCKLE_VARMOD_DIAMOND", -- rock
        "COMPONENT_KNUCKLE_VARMOD_HATE", -- hater
        "COMPONENT_KNUCKLE_VARMOD_LOVE", -- lover
        "COMPONENT_KNUCKLE_VARMOD_PLAYER", -- player
        "COMPONENT_KNUCKLE_VARMOD_KING", -- king
        "COMPONENT_KNUCKLE_VARMOD_VAGOS" -- vagos
	},
}

attachsConfig = {
    -- Lanterna
    ["COMPONENT_AT_AR_FLSH"] = {
        ['name'] = 'Lanterna',
        ['image'] = 'lanterna',
        ['item'] = 'lanterna'
    },
    -- Ponta do cano
    ["COMPONENT_AT_MUZZLE_01"] = {
        ['name'] = 'Ponta de cano',
        ['image'] = 'mira',
        ['item'] = 'mira'
    },
    -- Mira holografica
    ["COMPONENT_AT_SIGHTS"] = {
        ['name'] = 'Mira Holográfica',
        ['image'] = 'miraholografica',
        ['item'] = 'miraholografica'
    },
    -- Compensador
    ["COMPONENT_AT_PI_COMP_02"] = {
        ['name'] = 'Compensador',
        ['image'] = 'compensador',
        ['item'] = 'compensador'
    },
    -- Cano longo
    ["COMPONENT_AT_MUZZLE_04"] = {
        ['name'] = 'Cano Longo',
        ['image'] = 'canolongo',
        ['item'] = 'canolongo'
    },
    -- Quebra chamas
    ["COMPONENT_AT_MUZZLE_02"] = {
        ['name'] = 'Quebra Chamas',
        ['image'] = 'quebrachamas',
        ['item'] = 'quebrachamas'
    },
    -- Supressor
    ["COMPONENT_AT_AR_SUPP_02"] = {
        ['name'] = 'Supressor',
        ['image'] = 'supressor',
        ['item'] = 'supressor'
    },
    ["COMPONENT_AT_PI_SUPP"] = {
        ['name'] = 'Supressor',
        ['image'] = 'supressor',
        ['item'] = 'supressor'
    },
    -- Grip
    ["COMPONENT_AT_AR_AFGRIP_02"] = {
        ['name'] = 'Grip',
        ['image'] = 'grip',
        ['item'] = 'grip'
    },
    -- Mira Scope
    ["COMPONENT_AT_SCOPE_MEDIUM_MK2"] = {
        ['name'] = 'Mira Scope',
        ['image'] = 'mirascope',
        ['item'] = 'mirascope'
    },
    -- Mira Scope Pequena
    ["COMPONENT_AT_SCOPE_MACRO_MK2"] = {
        ['name'] = 'Mira Scope Pequena',
        ['image'] = 'mirascopepequena',
        ['item'] = 'mirascopepequena'
    },
    -- Munição traçante
    ["COMPONENT_CARBINERIFLE_MK2_CLIP_TRACER"] = {
        ['name'] = 'Munição Traçante',
        ['image'] = 'municacaotracante',
        ['item'] = 'municacaotracante'
    },
    -- Munição Incendiaria
    ["COMPONENT_CARBINERIFLE_MK2_CLIP_INCENDIARY"] = {
        ['name'] = 'Munição Incendiária',
        ['image'] = 'municaoincendiaria',
        ['item'] = 'municaoincendiaria'
    },
    -- Drum Mag
    ["COMPONENT_SPECIALCARBINE_CLIP_03"] = {
        ['name'] = 'Drum Mag',
        ['image'] = 'drummag',
        ['item'] = 'drummag'
    },
    ["COMPONENT_COMPACTRIFLE_CLIP_03"] = {
        ['name'] = 'Drum Mag',
        ['image'] = 'drummag',
        ['item'] = 'drummag'
    },

    -- Carregador Extendido
    ["COMPONENT_SPECIALCARBINE_MK2_CLIP_02"] = {
        ['name'] = 'Carregado Extendido',
        ['image'] = 'carregadorextendido',
        ['item'] = 'carregadorextendido'
    },
    ["COMPONENT_COMPACTRIFLE_CLIP_02"] = {
        ['name'] = 'Carregador Extendido',
        ['image'] = 'carregadorextendido',
        ['item'] = 'carregadorextendido'
    },
    ["COMPONENT_MILITARYRIFLE_CLIP_02"] = {
        ['name'] = 'Carregador Extendido',
        ['image'] = 'carregadorextendido',
        ['item'] = 'carregadorextendido'
    },
    ["COMPONENT_BULLPUPRIFLE_MK2_CLIP_02"] = {
        ['name'] = 'Carregador Extendido',
        ['image'] = 'carregadorextendido',
        ['item'] = 'carregadorextendido'
    },
    ["COMPONENT_BULLPUPRIFLE_CLIP_02"] = {
        ['name'] = 'Carregador Extendido',
        ['image'] = 'carregadorextendido',
        ['item'] = 'carregadorextendido'
    },
    ["COMPONENT_SPECIALCARBINE_CLIP_02"] = {
        ['name'] = 'Carregador Extendido',
        ['image'] = 'carregadorextendido',
        ['item'] = 'carregadorextendido'
    },
    ["COMPONENT_PISTOL_CLIP_02"] = {
        ['name'] = 'Carregador Extendido',
        ['image'] = 'carregadorextendido',
        ['item'] = 'carregadorextendido'
    },
    ["COMPONENT_COMBATPISTOL_CLIP_02"] = {
        ['name'] = 'Carregador Extendido',
        ['image'] = 'carregadorextendido',
        ['item'] = 'carregadorextendido'
    },
    ["COMPONENT_APPISTOL_CLIP_02"] = {
        ['name'] = 'Carregador Extendido',
        ['image'] = 'carregadorextendido',
        ['item'] = 'carregadorextendido'
    },
    ["COMPONENT_PISTOL50_CLIP_02"] = {
        ['name'] = 'Carregador Extendido',
        ['image'] = 'carregadorextendido',
        ['item'] = 'carregadorextendido'
    },
    ["COMPONENT_SNSPISTOL_CLIP_02"] = {
        ['name'] = 'Carregador Extendido',
        ['image'] = 'carregadorextendido',
        ['item'] = 'carregadorextendido'
    },
    ["COMPONENT_HEAVYPISTOL_CLIP_02"] = {
        ['name'] = 'Carregador Extendido',
        ['image'] = 'carregadorextendido',
        ['item'] = 'carregadorextendido'
    },
    ["COMPONENT_SNSPISTOL_MK2_CLIP_02"] = {
        ['name'] = 'Carregador Extendido',
        ['image'] = 'carregadorextendido',
        ['item'] = 'carregadorextendido'
    },
    ["COMPONENT_PISTOL_MK2_CLIP_02"] = {
        ['name'] = 'Carregador Extendido',
        ['image'] = 'carregadorextendido',
        ['item'] = 'carregadorextendido'
    },
    ["COMPONENT_VINTAGEPISTOL_CLIP_02"] = {
        ['name'] = 'Carregador Extendido',
        ['image'] = 'carregadorextendido',
        ['item'] = 'carregadorextendido'
    },
    ["COMPONENT_CERAMICPISTOL_CLIP_02"] = {
        ['name'] = 'Carregador Extendido',
        ['image'] = 'carregadorextendido',
        ['item'] = 'carregadorextendido'
    },
    ["COMPONENT_MICROSMG_CLIP_02"] = {
        ['name'] = 'Carregador Extendido',
        ['image'] = 'carregadorextendido',
        ['item'] = 'carregadorextendido'
    },
    ["COMPONENT_SMG_CLIP_02"] = {
        ['name'] = 'Carregador Extendido',
        ['image'] = 'carregadorextendido',
        ['item'] = 'carregadorextendido'
    },


}