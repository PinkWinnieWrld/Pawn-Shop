local QBCore = exports['qb-core']:GetCoreObject()
local inv = exports.ox_inventory

DailyPrices = {}

-- Generate random daily prices
local function GenerateDailyPrices()
    DailyPrices = {}

    for item, data in pairs(Config.Items) do
        DailyPrices[item] = math.random(data.min, data.max)
    end

    print("^2[PawnShop] Daily prices generated.^7")
    TriggerClientEvent('pawnshop:setPrices', -1, DailyPrices)
end

CreateThread(function()
    GenerateDailyPrices()
end)

AddEventHandler('playerJoining', function()
    local src = source
    TriggerClientEvent('pawnshop:setPrices', src, DailyPrices)
end)

-- SELL ITEM
RegisterNetEvent('pawnshop:sellItem', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local price = DailyPrices[item]
    if not price then return end

    if inv:Search(src, 'count', item) > 0 then
        inv:RemoveItem(src, item, 1)

        -- okokBanking deposit
        exports['okokBanking']:AddMoney(src, price)

        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Pawn Shop',
            description = 'You sold 1x ' .. item .. ' for $' .. price .. ' (bank deposit)',
            type = 'success'
        })

        -- Random police alert chance
        if price >= Config.AlertValue then
            local roll = math.random(1, 100)
            if roll <= Config.AlertChance then
                TriggerEvent('pawnshop:policeAlert', src, item, price)
            end
        end
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Pawn Shop',
            description = 'You do not have this item',
            type = 'error'
        })
    end
end)

-- FD_DISPATCH POLICE ALERT
RegisterNetEvent('pawnshop:policeAlert', function(src, item, price)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local coords = GetEntityCoords(GetPlayerPed(src))

    TriggerEvent('fd_dispatch:server:notify', {
        code = '10-90',
        title = 'Suspicious Pawn Activity',
        description = Player.PlayerData.charinfo.firstname ..
            " sold a high‑value item (" .. item .. ") worth $" .. price,
        coords = coords,
        sprite = 431,
        color = 1,
        scale = 1.0,
        priority = 2
    })
end)
