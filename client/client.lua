local QBCore = exports['qb-core']:GetCoreObject()

-- Receive daily prices from server
DailyPrices = {}

RegisterNetEvent('pawnshop:setPrices', function(prices)
    DailyPrices = prices
end)

CreateThread(function()
    local cfg = Config.PawnShop

    -- Blip
    if cfg.blip.enabled then
        local blip = AddBlipForCoord(cfg.coords)
        SetBlipSprite(blip, cfg.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, cfg.blip.scale)
        SetBlipColour(blip, cfg.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(cfg.blip.label)
        EndTextCommandSetBlipName(blip)
    end

    -- Ped
    RequestModel(cfg.ped)
    while not HasModelLoaded(cfg.ped) do Wait(10) end

    local ped = CreatePed(0, cfg.ped, cfg.coords.x, cfg.coords.y, cfg.coords.z - 1.0, cfg.heading, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    -- ox_target
    exports.ox_target:addLocalEntity(ped, {
        {
            name = 'pawnshop_sell',
            icon = 'fa-solid fa-coins',
            label = 'Sell Items',
            onSelect = function()
                TriggerEvent('pawnshop:sellMenu')
            end
        }
    })
end)

RegisterNetEvent('pawnshop:sellMenu', function()
    local options = {}

    for item, _ in pairs(Config.Items) do
        options[#options+1] = {
            title = item .. " - $" .. DailyPrices[item],
            description = "Sell your " .. item,
            icon = "fa-solid fa-money-bill",
            onSelect = function()
                TriggerServerEvent('pawnshop:sellItem', item)
            end
        }
    end

    lib.registerContext({
        id = 'pawnshop_sell',
        title = 'Pawn Shop',
        options = options
    })

    lib.showContext('pawnshop_sell')
end)
