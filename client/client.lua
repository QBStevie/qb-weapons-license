
local QBCore = exports['qb-core']:GetCoreObject()
local isInZone = false

-- Configuration
local Config = {
    MarkerLocation = vector3(156.5225, -915.8291, 30.1466), -- Replace with your desired location
    ZoneSize = 2.0, -- Radius of the zone
}

-- Create PolyZone
CreateThread(function()
    local weaponLicenseZone = CircleZone:Create(Config.MarkerLocation, Config.ZoneSize, {
        name = "weapon_license_zone",
        debugPoly = false, -- Disable debug for production
    })

    weaponLicenseZone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            isInZone = true
            exports['qb-core']:DrawText("Press [E] to purchase a Weapons License", "left")
        else
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
    exports['qb-menu']:openMenu({
        {
            header = "Weapons License Menu",
            isMenuHeader = true, -- Marks the header
        },
        {
            header = "Buy Weapons License (Meta)",
            txt = "Cost: $100",
            params = {
                event = "custom-licenses:server:buyWeaponLicenseMeta",
            }
        },
        {
            header = "Buy Weapons License (Item)",
            txt = "Cost: $50",
            params = {
                event = "custom-licenses:server:buyWeaponLicenseItem",
            }
        },
        {
            header = "Close Menu",
            params = {
                event = "qb-menu:closeMenu",
            }
        },
    })
end
