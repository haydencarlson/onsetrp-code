local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local server_info = {
    [0] = 212462, 
    [1] = 175600
}
local rules = {
    [0] = 212462,
    [1] = 176016
}
function SetupSpawn() 
    -- Server info section
    CreateText3D("Server Information", 17, server_info[0], server_info[1], 1700, 0, 0, 0)
    tips = "Type /tips to see some quick tips"
    CreateText3D(tips, 9, server_info[0], server_info[1], 1650, 0, 0, 0)
    tips = "Type /info to view server information and for help"
    CreateText3D(tips, 9, server_info[0], server_info[1], 1600, 0, 0, 0)

    -- Rules section
    CreateText3D("Rules", 17, rules[0], rules[1], 1700, 0, 0, 0)
    CreateText3D("No Random Killing", 9, rules[0], rules[1], 1650, 0, 0, 0)
    CreateText3D("No Advertising", 9, rules[0], rules[1], 1600, 0, 0, 0)
    CreateText3D("No Real Threats to anyone", 9, rules[0], rules[1], 1550, 0, 0, 0)
end

AddEvent("OnPackageStart", SetupSpawn)