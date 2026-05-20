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

    -- Sync to all players
    TriggerClientEvent('pawnshop:setPrices', -1, DailyPrices)
end

-- Generate prices on resource start
CreateThread(function()
    GenerateDailyPrices()
end)

-- Sync prices to joining players
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

        -- Deposit into bank using okokBanking
        exports['okokBanking']:AddMoney(src, price)

        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Pawn Shop',
            description = 'You sold 1x ' .. item .. ' for $' .. price .. ' (bank deposit)',
            type = 'success'
        })

        -- Police alert
        if price >= Config.AlertValue then
            TriggerEvent('pawnshop:policeAlert', src, item, price)
        end
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Pawn Shop',
            description = 'You do not have this item',
            type = 'error'
        })
    end
end)

-- POLICE ALERT
RegisterNetEvent('pawnshop:policeAlert', function(src, item, price)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local coords = GetEntityCoords(GetPlayerPed(src))

    for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if v.PlayerData.job.name == 'police' and v.PlayerData.job.onduty then
            TriggerClientEvent('ox_lib:notify', v.PlayerData.source, {
                title = 'Suspicious Pawn Sale',
                description = Player.PlayerData.charinfo.firstname ..
                    " sold a high‑value item (" .. item .. ") worth $" .. price,
                type = 'warning'
            })

            TriggerClientEvent('qb-police:client:policeAlert', v.PlayerData.source, coords)
        end
    end
end)
