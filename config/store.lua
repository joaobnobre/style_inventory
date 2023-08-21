stores = {
    ['Conveniencia'] = {
        name = 'Loja de Conveniência',
        itens = {
            ['agua'] = true,
            ['alcool'] = true,
            ['controleremoto'] = true,
            ['telefonedesligado'] = true,
            ['fogos'] = true,
            ['cigarro'] = true,
            ['blocodenotas'] = true,
            ['garrafavaziadeleite'] = true,
            ['bandagem'] = true,
            ['postit'] = true,
            ['vassoura'] = true,
            ['urso'] = true,
            ['livro'] = true,
            ['caixa'] = true,
            ['rosa'] = true,
            ['tacosinuca'] = true,
            ['chocolate'] = true,
            ['cenoura'] = true,
            ['corda'] = true,
        },
        permissions = {},
        cds = {
            vec3(26.22,-1346.04,29.5),
            vec3(-707.4,-914.6,19.22),
            vec3(-1820.48,792.7,138.12),
            vec3(1729.94,6415.54,35.04),
            vec3(547.48,2670.02,42.16),
            vec3(1961.08,3741.87,32.35),
            vec3(2677.9,3281.49,55.25),
            vec3(1697.98,4924.43,42.07),
            vec3(374.51,327.14,103.57),
            vec3(-48.32,-1757.93,29.43),
            vec3(-3040.59,585.84,7.91),
            vec3(-103.42,992.09,235.76), -- ar2
            vec3(-3243.29,1001.81,12.84),
            vec3(162.28,6640.82,31.7),
            vec3(1316.78,-750.16,67.21),
            vec3(-1233.89,786.85,192.9), -- mansão jaguar
            vec3(-3224.69,802.01,8.93), -- mansao malibu
            vec3(1318.68,-748.44,67.21), -- fv2
        },
        webhook = {'',''}
    },
    ['Bebidas'] = {
        name = 'Loja de Bebidas',
        -- OnlySellWithNoOne = true,
        itens = {
            ['conhaque'] = true,
            ['absinto'] = true,
            ['whisky'] = true,

            ['vodka'] = true,
            ['monster'] = true,
            ['redbull'] = true,
            ['aguavoss'] = true,
            ['cocacola'] = true,
            ['sprite'] = true,
            ['tequila'] = true,
            ['sucotropical'] = true,
            ['frapuccino'] = true,
            ['sucodetox'] = true,
            ['cerveja'] = true,
        },
        permissions = {'bebidas.acess'},
        --'lla1.acess','lla2.acess','funcionario.esmerald','funcionario.pearls','funcionario.catcafe','funcionario.train','funcionario.yellow'
        cds = {
            ---== VANILLA ==---
            vec3(97.22,-1272.18,21.12), --'lla1.acess'
            ---== BAHAMAS ==---
            vec3(-1400.85,-597.77,30.32), --,'lla2.acess'
            ---== ESMERALD ==---
            vec3(-114.47,389.28,113.28), --,'funcionario.esmerald'
            ---== PSYCHOSTYLE ==---
            vec3(185.47,-247.97,54.08), --,'funcionario.psycho'
            ---== PEARLS ==---
            vec3(-1837.37,-1190.37,14.31), --,'funcionario.pearls'
            ---== KAWAI CAFE ==---
            vec3(-590.37,-1058.46,22.35), --,'funcionario.catcafe'
            ---== TRAIN BURGUER  ==---
            vec3(-313.67,6117.38,34.23), --,'funcionario.train'
            ---== YELLOW JACK  ==---
            vec3(1982.15,3053.1,47.22), --,'funcionario.yellow'

            -- club 77
            vec3(258.69,-3160.19,-0.18), 
        },
        webhook = {'',''}
    },


    ['Ammunation'] = {
        name = 'Loja de Armas',
        itens = {
            ['repairkit'] = true,
            ['garrafadevidro'] = true,
            ['martelo'] = true,
            ['tacodegolf'] = true,
            ['pedecabra'] = true,
            ['machado'] = true,
            ['tacodebeisebol'] = true,
            ['socoingles'] = true,
            ['machete'] = true,
            ['faca'] = true,
            ['radio'] = true,
            ['pendrive'] = true,
            ['serra'] = true,
            -- ['attachs'] = true,
            -- ['spray'] = true,
            ['canivete'] = true,
            ['machadodebatalha'] = true,
            ['tacodebar'] = true,
            ['machadodepedra'] = true,
            ['paraquedas'] = true,
            ['lanterna'] = true,
            ['tesoura'] = true,
            ['prancheta'] = true,
            ['provamath1'] = true,
            ['provamath2'] = true,
            ['provamath3'] = true,
            ['provamath4'] = true,
            ['provamath5'] = true,
        },
        permissions = {},
        cds = {
            -- vec3(16.33,-1109.14,29.8), -- Ammu Praca
            -- vec3(814.75,-2153.48,29.62), -- Ammu Porto
            -- vec3(842.91,-1030.18,28.2), -- Ammunation Mecanica
            -- vec3(248.55,-50.1,69.95), -- Ammunation Central
            -- vec3(-1308.85,-392.97,36.7), -- Ammunation Praia
            -- vec3(-1695.67,3757.17,34.71), -- Ammunation Sandy
            -- vec3(-328.24,6080.89,31.46), -- Ammunation Paleto
            -- vec3(1695.82,3757.16,34.71), 
            -- vec3(-660.93,-938.32,21.83),
            -- vec3(-1114.86,2697.29,18.56),

            vec3(21.92,-1106.61,29.8),
            vec3(-3172.78,1086.72,20.84),
            vec3(811.25,-2157.67,29.62),
            vec3(2568.77,293.96,108.74),
            vec3(-1118.77,2698.17,18.56),
            vec3( -1305.15,-393.17,36.7),
            vec3(-663.4,-934.88,21.83),
            vec3(-331.58,6083.1,31.46),
            vec3(843.27,-1033.94,28.2),
            vec3(252.87,-49.2,69.95),
            vec3(1692.72,3759.46,34.71),
        },
        webhook = {'',''}
    },


    ['Megamall'] = {
        name = 'Loja do Megamall',
        itens = {

            -- ['skate'] = true,
            ['corda'] = true,
            ['rosa'] = true,
            ['fogos'] = true,
            ['repairkit'] = true,
            ['tesoura'] = true,
            ['spray'] = true,
            ['prancheta'] = true,
            ['provamath1'] = true,
            ['provamath2'] = true,
            ['provamath3'] = true,
            ['provamath4'] = true,
            ['provamath5'] = true,
            ['c4'] = true,


        },
        permissions = {},
        cds = {
            vec3(46.47,-1749.57,29.64),

        },
        webhook = {'',''}
    },

    ['Roupas'] = {
        name = 'Loja de Roupa',
        itens = {
            ['mochila'] = true,
            ['pano'] = true,

            ['urso'] = true,
            ['bolsaderoupas'] = true,
        },
        permissions = {},
        cds = {
            vec3(79.55,-1390.27,29.38),
            vec3(-818.22,-1075.96,11.34),
            vec3(-1195.8,-775.89,17.33),
            vec3(-1449.75,-236.89,49.82),
            vec3(-710.36,-152.12,37.42),
            vec3(-163.8,-303.8,39.74),
            vec3(123.63,-215.81,54.56),
            vec3(421.47,-808.78,29.5),
            vec3(-3172.02,1051.78,20.87),
            vec3(-1096.85,2709.32,19.12),
            vec3(619.4,2756.37,42.09),
            vec3(1199.31,2706.21,38.23),
            vec3(1690.22,4819.7,42.07),
            vec3(0.26,6513.62,31.89),
        },
        webhook = {'',''}
    },


    ['Joalheria'] = {
        name = 'Joalheria',
        itens = {
            ['alianca'] = true,
            ['aneldecompromisso'] = true,
            ['aneldecasamento'] = true,
            ['aneldenoivado'] = true,

        },
        permissions = {},
        cds = {
            vec3(-620.93,-228.59,38.06),
        },
        webhook = {'',''}
    },
    ['Contrabando'] = {
        name = 'Contrabando',
        itens = {
            ['manualfuradeira'] = true,
            ['manualnotebook'] = true,
            ['manualalgemas'] = true,
            ['manualchavealgemas'] = true,
            ['manualcorrida'] = true,
            ['manuallockpick'] = true,
            ['manualc4'] = true,
            ['manualadrenalina2'] = true,
            ['manualserra'] = true,
            ['manualadrenalina1'] = true,
            ['manualpendrive'] = true,
            ['manualplaca'] = true,

        },
        permissions = {},
        cds = {
            vec3(5137.8,-5123.65,2.95),
        },
        webhook = {'https://discord.com/api/webhooks/1099242669131190282/nn5txJfN8hb_hzdp2pGqCzX0Y7o_bfooMvXBZWo5vD8CHpq-mmK9CrC5Aa3IK8ZuO4-b','https://discord.com/api/webhooks/1099242669131190282/nn5txJfN8hb_hzdp2pGqCzX0Y7o_bfooMvXBZWo5vD8CHpq-mmK9CrC5Aa3IK8ZuO4-b'}
    },


    ['IngredientesPier'] = {
        name = 'Loja de Ingredientes',
        -- OnlySellWithNoOne = true,
        itens = {
            ['camaraofresco'] = true,
            ['temperofresco'] = true,
            ['ervasfinas'] = true,

            ['caranguejofresco'] = true,
            ['temperopicante'] = true,
            ['ervasseletas'] = true,

            ['lagostafresca'] = true,
            ['temperomarinho'] = true,
            ['ervasverdes'] = true,

        },
        permissions = {'funcionario.pearls'},
        --'lla1.acess','lla2.acess','funcionario.esmerald','funcionario.pearls','funcionario.catcafe','funcionario.train','funcionario.yellow'
        cds = {
            vec3(-1848.43,-1198.17,14.31), --'lla1.acess'
        },
        webhook = {'',''}
    },

    ['IngredientesTrain'] = {
        name = 'Loja de Ingredientes',
        -- OnlySellWithNoOne = true,
        itens = {
            ['hamburguercaseiro'] = true,
            ['legumesfrescos'] = true,
            ['paobrioche'] = true,

            ['batatafresca'] = true,
            ['salfino'] = true,
            ['oleodefritura'] = true,

            ['massadepastel'] = true,
            ['frios'] = true,

        },
        permissions = {'funcionario.train'},
        --'lla1.acess','lla2.acess','funcionario.esmerald','funcionario.pearls','funcionario.catcafe','funcionario.train','funcionario.yellow'
        cds = {
            vec3(-310.22,6116.67,34.23),

        },
        webhook = {'',''}
    },

    ['IngredientesKawai'] = {
        name = 'Loja de Ingredientes',
        -- OnlySellWithNoOne = true,
        itens = {
            ['farinhafina'] = true,
            ['confetisortido'] = true,
            ['formadecookie'] = true,

            ['farinhaespecial'] = true,
            ['corantecomestivel'] = true,
            ['acucarrefinado'] = true,

            ['cacauempo'] = true,
            ['manteiga'] = true,
            ['leitecondensado'] = true,

        },
        permissions = {'funcionario.catcafe'},
        --'lla1.acess','lla2.acess','funcionario.esmerald','funcionario.pearls','funcionario.catcafe','funcionario.train','funcionario.yellow'
        cds = {
            vec3(-590.5,-1062.98,22.36), --'lla1.acess'
        },
        webhook = {'',''}
    },

    ['IngredientesEsmerald'] = {
        name = 'Loja de Ingredientes',
        -- OnlySellWithNoOne = true,
        itens = {
            ['chocolatemeioamargo'] = true,
            ['farinhatrigo'] = true,
            ['ovosfrescos'] = true,

            ['massaespecial'] = true,
            ['molhotomate'] = true,
            ['temperodacasa'] = true,

            ['baguetepequena'] = true,
            ['azeitefino'] = true,
            ['tomatefresco'] = true,

        },
        permissions = {'funcionario.esmerald'},
        --'lla1.acess','lla2.acess','funcionario.esmerald','funcionario.pearls','funcionario.catcafe','funcionario.train','funcionario.yellow'
        cds = {
            vec3(-109.29,393.49,113.28), --'lla1.acess'

        },
        webhook = {'',''}
    },

    ['IngredientesPsycho'] = {
        name = 'Loja de Ingredientes',
        -- OnlySellWithNoOne = true,
        itens = {
            ['achocolatado'] = true,
            ['leitecondensado'] = true,
            ['ervasmisteriosas'] = true,

            ['tortilhas'] = true,
            ['legumesfrescos'] = true,
            ['ervasmisteriosas'] = true,

            ['massadechocolate'] = true,
            ['formadecookie'] = true,
            ['ervasmisteriosas'] = true,

        },
        permissions = {'funcionario.psycho'},
        --'lla1.acess','lla2.acess','funcionario.esmerald','funcionario.pearls','funcionario.catcafe','funcionario.train','funcionario.yellow'
        cds = {
            vec3(180.33,-243.9,54.08), --'lla1.acess'

        },
        webhook = {'',''}
    },

    ['IngredientesSweet'] = {
        name = 'Loja de Ingredientes',
        -- OnlySellWithNoOne = true,
        itens = {
            ['farinhasweet'] = true,
            ['confetisweet'] = true,

            ['acucarsweet'] = true,
            ['corantesweet'] = true,

            ['massasweet'] = true,
            ['nutelasweet'] = true,

            ['leitesweet'] = true,
            ['achocolatadosweet'] = true,

            ['sorvetesweet'] = true,
            ['leitesweet'] = true,

            ['leiteemposweet'] = true,
            ['mamadeirasweet'] = true,

        },
        permissions = {'autorizado.sweet'},
        --'lla1.acess','lla2.acess','funcionario.esmerald','funcionario.pearls','funcionario.catcafe','funcionario.train','funcionario.yellow'
        cds = {
            vec3(549.51,117.4,96.58), --'lla1.acess'

        },
        webhook = {'',''}
    },

    ['IngredientesYJ'] = {
        name = 'Loja de Ingredientes',
        -- OnlySellWithNoOne = true,
        itens = {
            ['carnemoida'] = true,
            ['farinharosca'] = true,
            ['azeitefino'] = true,

            ['frango'] = true,
            ['temperodacasa'] = true,
            ['farinhatrigo'] = true,

            ['calabresa'] = true,
            ['cebola'] = true,
            ['oleodefritura'] = true,

        },
        permissions = {'funcionario.yellow'},
        --'lla1.acess','lla2.acess','funcionario.esmerald','funcionario.pearls','funcionario.catcafe','funcionario.train','funcionario.yellow'
        cds = {
            vec3(1982.32,3053.26,47.22), --'lla1.acess'

        },
        webhook = {'',''}
    },

    ['Ingredientes77'] = {
        name = 'Loja de Ingredientes',
        -- OnlySellWithNoOne = true,
        itens = {
            ['carnemoida'] = true,
            ['farinharosca'] = true,
            ['azeitefino'] = true,

            ['frango'] = true,
            ['temperodacasa'] = true,
            ['farinhatrigo'] = true,

            ['calabresa'] = true,
            ['cebola'] = true,
            ['oleodefritura'] = true,

        },
        permissions = {'club77.acess'},
        --'lla1.acess','lla2.acess','funcionario.esmerald','funcionario.pearls','funcionario.catcafe','funcionario.train','funcionario.yellow'
        cds = {
            vec3(257.32,-3157.52,-0.18), --'lla1.acess'

        },
        webhook = {'',''}
    },

    -- ['Custom'] = {
    --     name = 'Loja de peças',
    --     -- OnlySellWithNoOne = true,
    --     itens = {
    --         ['tintared'] = true,
    --         ['alca'] = true,
    --         ['metal'] = true,

    --         ['ferramenta'] = true,
    --         ['rgb'] = true,

    --     },
    --     permissions = {'mechanic.acess'},
    --     --'lla1.acess','lla2.acess','funcionario.esmerald','funcionario.pearls','funcionario.catcafe','funcionario.train','funcionario.yellow'
    --     cds = {
    --         vec3(2706.07,3481.85,55.27), --'lla1.acess'
    --     },
    --     webhook = {'',''}
    -- },

    ['Tuning'] = {
        name = 'Loja de peças',
        -- OnlySellWithNoOne = true,
        itens = {
            ['tintared'] = true,
            ['alca'] = true,
            ['metal'] = true,

            ['ferramenta'] = true,
            ['molas'] = true,
            ['rgb'] = true,

        },
        permissions = {'tuning.acess'},
        --'lla1.acess','lla2.acess','funcionario.esmerald','funcionario.pearls','funcionario.catcafe','funcionario.train','funcionario.yellow'
        cds = {
            vec3(2726.28,3505.53,55.26), 

        },
        webhook = {'',''}
    },

    ['Hospital'] = {
        name = 'Loja de medicamentos',
        -- OnlySellWithNoOne = true,
        itens = {
            ['gaze'] = true,
            ['relaxantemuscular'] = true,
            ['antiinflamatorio'] = true,
        },
        permissions = {'hpall.acess'},
        --'lla1.acess','lla2.acess','funcionario.esmerald','funcionario.pearls','funcionario.catcafe','funcionario.train','funcionario.yellow'
        cds = {
            vec3(-256.23,6327.65,32.43), -- hpn
            vec3(1150.45,-1555.73,35.39), -- hps

        },
        webhook = {'',''}
    },

    ['NPCPearls'] = {
        name = 'NPC Pearls',
        OnlySellWithNoOne = true,
        itens = {
            ['camarao'] = true,
            ['caranguejo'] = true,
            ['lagosta'] = true,
            ['agua'] = true,
        },
        permissions = {'funcionario.pearls'},
        cds = {
            vec3(-1809.73,-1189.57,13.02),
        },
        webhook = {'',''}
    },
    ['NPCTrain'] = {
        name = 'NPC Train',
        OnlySellWithNoOne = true,
        itens = {
            ['hamburguer'] = true,
            ['batatafrita'] = true,
            ['pastel'] = true,
            ['agua'] = true,
        },
        permissions = {'funcionario.train'},
        cds = {
            vec3(-290.25,6126.82,31.5),
        },
        webhook = {'',''}
    },
    ['NPCKawai'] = {
        name = 'NPC Cat Café',
        OnlySellWithNoOne = true,
        itens = {
            ['cupcake'] = true,
            ['macarron'] = true,
            ['brigadeiro'] = true,
            ['agua'] = true,
        },
        permissions = {'funcionario.catcafe'},
        cds = {
            vec3(-584.51,-1070.71,22.33),
        },
        webhook = {'',''}
    },
    ['NPCEmerald'] = {
        name = 'NPC Emerald',
        OnlySellWithNoOne = true,
        itens = {
            ['grandgateau'] = true,
            ['spaghetti'] = true,
            ['bruschetta'] = true,
            ['agua'] = true,
        },
        permissions = {'funcionario.emerald'},
        cds = {
            vec3(-121.08,376.24,112.89),
        },
        webhook = {'',''}
    },

}