local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

Licenses = {
    driver_license = 1500,
    gun_license = 6000,
    helicopter_license = 30000
}
LicensesNpcLocation = { x = 183400, y = 182513, z = 1290, h = 0 }
LicensesNpc = {}

AddEvent("OnPackageStart", function()
    LicensesNpc = CreateNPC(LicensesNpcLocation.x, LicensesNpcLocation.y, LicensesNpcLocation.z, LicensesNpcLocation.h)
    CreateText3D(_("license_shop").."\n".._("press_e"), 18, LicensesNpcLocation.x, LicensesNpcLocation.y, LicensesNpcLocation.z + 120, 0, 0, 0)
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "LicenseSetup", LicensesNpc)
end)

AddRemoteEvent("LicenseInteract", function(player)
    local availableLicenses = {}

    for k, v in pairs(Licenses) do
        if PlayerData[player][k] == 0 then
            availableLicenses[k] = v
        end
    end

    CallRemoteEvent(player, "OpenLicenses", availableLicenses)
end)

AddRemoteEvent("BuyLicense", function (player, license)
    local price = Licenses[license]

    if GetPlayerCash(player) < price then
        CallRemoteEvent(player, 'KNotify:Send', _("not_enought_cash"), "#f00")
    else
        RemoveBalanceFromAccount(player, 'cash', price)
        PlayerData[player][license] = 1
        CallRemoteEvent(player, 'KNotify:Send', _("shop_success_buy", "1",_("license").._(license), _("price_in_currency", price)), "#0f0")
    end
end)

AddEvent("OnNPCDamage", function(npc)
    SetNPCHealth( npc, 100 )
end)