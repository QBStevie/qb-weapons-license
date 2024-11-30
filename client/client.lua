
local QBCore = exports['qb-core']:GetCoreObject()
local isInZone = false

-- Debug function
local function DebugPrint(msg)
    if Config.Debug then
        print("[DEBUG][Client]: " .. msg)
    end
end

-- Create PolyZone
CreateThread(function()
    local weaponLicenseZone = CircleZone:Create(Config.MarkerLocation, Config.ZoneSize, {
        name = "weapon_license_zone",
        debugPoly = Config.Debug,
    })
    weaponLicenseZone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            DebugPrint("Player entered the weapons license zone.")
            isInZone = true
            exports['qb-core']:DrawText("Press [E] to purchase a Weapons License", "left")
        else
            DebugPrint("Player exited the weapons license zone.")
            isInZone = false
            exports['qb-core']:HideText()
        end
    end)
end)

-- Key Controls
CreateThread(function()
    while true do
        Wait(0)
        if isInZone then
            if IsControlJustReleased(0, 38) then -- E key
                --DebugPrint("Player pressed [E] in zone.")
                OpenLicenseMenu()
                exports['qb-core']:HideText()
            end
        else
            Wait(500) -- Reduce loop intensity when not in the zone
        end
    end
end)

-- Open the menu
function OpenLicenseMenu()
    DebugPrint("Opening Weapons License Menu.")
    exports['qb-menu']:openMenu({
        {
            header = "Weapons License Menu",
            isMenuHeader = true
        },
        {
            header = "Buy Weapons License (Meta)",
            txt = "Cost: $" .. Config.LicensePrice,
            params = {
                isServer = true, -- Specify it's a server-side event
                event = "custom-licenses:server:buyWeaponLicenseMeta",
                args = { type = "meta" }
            }
        },
        {
            header = "Buy Weapons License (Item)",
            txt = "Cost: $" .. Config.LicenseItemPrice,
            params = {
                isServer = true, -- Specify it's a server-side event
                event = "custom-licenses:server:buyWeaponLicenseItem",
                args = { type = "item" }
            }
        },
        {
            header = "Close Menu",
            params = {
                event = "qb-menu:closeMenu"
            }
        }
    })
end


