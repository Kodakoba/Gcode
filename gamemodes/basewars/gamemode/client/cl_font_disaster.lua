--it's so fuckin' big
local fontName = "BaseWars.MoneyPrinter"

local families = {
    ["Roboto"] = "R",
    ["Roboto Light"] = "RL",

    ["Titillium Web"] = "TW",
    ["Titillium Web SemiBold"] = "TWB",

    ["Open Sans"] = "OS",
    ["Open Sans SemiBold"] = "OSB",
    ["Open Sans Light"] = "OSL",

    ["Arial"] = "A",
    ["Helvetica"] = "HL",
    ["Montserrat"] = "MR"
}

FontFamilies = families
local sizes = {12, 14, 16, 18, 20, 24, 28, 32, 36, 48, 64, 72, 128}

for k,v in pairs(families) do 

    for _, size in pairs(sizes) do
        surface.CreateFont(v .. size, {
            font = k,
            size = size,
            weight = 400,
        })
    end

end

surface.CreateFont(fontName, {

        font = "Roboto",
        size = 20,
        weight = 800,

    })

    surface.CreateFont(fontName .. ".Huge", {

        font = "Roboto",
        size = 64,
        weight = 800,

    })


    surface.CreateFont(fontName .. ".Big", {

        font = "Roboto",
        size = 32,
        weight = 800,

    })

    surface.CreateFont(fontName .. ".MedBig", {

        font = "Roboto Light",
        size = 24,
        weight = 800,

    })

    surface.CreateFont(fontName .. ".Med", {

        font = "Roboto Light",
        size = 18,
        weight = 800,

    })

local fontName = "VaultFont"
    surface.CreateFont(fontName..".Title", {
        font = "Roboto",
        size = 96,
        weight = 800,
    })

    surface.CreateFont(fontName, {
        font = "Roboto",
        size = 64,
        weight = 800,
    })

    surface.CreateFont(fontName..".Small", {
        font = "Roboto Light",
        size = 48,
        weight = 600,
    })
