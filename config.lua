Config = {}

-- Chance (0–100) that a high‑value sale triggers a police alert
Config.AlertChance = 15 -- 15% chance


Config.PawnShop = {
    coords = vector3(410.965, 318.051, 107.567),
    ped = 'cs_bankman',
    heading = 160.0,
    blip = {
        enabled = true,
        sprite = 434,
        color = 5,
        scale = 0.8,
        label = "Pawn Shop"
    }
}

-- RANDOMIZED DAILY PRICE RANGES
Config.Items = {
    screwdriverset = { min = 40, max = 70 },
    fitbit = { min = 600, max = 1000 },
    samsungphone = { min = 800, max = 1500 },
    diamond = { min = 1900, max = 2500 },
    rolex = { min = 600, max = 900 },
    iPhone = { min = 1200, max = 2000 }
}

-- Police alert threshold
Config.AlertValue = 25000
