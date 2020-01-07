local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local server_info = {
    [0] = 211545.71875, 
    [1] = 176000.828125
}
local rules = {
    [0] = 211545.75,
    [1] = 175600.484375
}
function SetupSpawn() 
    -- Server info section
    CreateText3D("Server Information", 17, server_info[0], server_info[1], 2050, 0, 0, 0)
    tips = "Type /tips to see some quick tips"
    CreateText3D(tips, 9, server_info[0], server_info[1], 2000, 0, 0, 0)
    tips = "Please type /info to view rules, key shortcuts, commands. and server information"
    CreateText3D(tips, 9, server_info[0], server_info[1], 1950, 0, 0, 0)

    -- Rules section
    CreateText3D("Rules", 17, rules[0], rules[1], 2050, 0, 0, 0)
    CreateText3D("No Random Killing", 9, rules[0], rules[1], 2000, 0, 0, 0)
    CreateText3D("NOS vehicle mod is illegal", 9, rules[0], rules[1], 1950, 0, 0, 0)
    CreateText3D("No Real Threats to anyone", 9, rules[0], rules[1], 1900, 0, 0, 0)
end

AddEvent("OnPackageStart", SetupSpawn)