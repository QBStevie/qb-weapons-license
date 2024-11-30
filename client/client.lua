local QBCore = exports['qb-core']:GetCoreObject()
local isInZone = false

-- Debug function
local function DebugPrint(msg)
    if Config.Debug then
        print("[DEBUG][Client]: " .. msg)
        RegisterCommand('testmenu', function()
            OpenLicenseMenu()
        end)
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
                DebugPrint("Player pressed [E] in zone.")
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
    -- Fetch player license data from the server
    QBCore.Functions.TriggerCallback('custom-licenses:server:checkLicenseMeta', function(hasMetaLicense)
        DebugPrint("Opening Weapons License Menu.")
        local menuOptions = {
            {
                header = "Weapons License Menu",
                isMenuHeader = true
            }
        }
        -- Add metadata license option if the player doesn't already have it
        if not hasMetaLicense then
            table.insert(menuOptions, {
                header = "Buy Weapons License (Meta)",
                txt = "Cost: $" .. Config.LicensePrice,
                params = {
                    isServer = true, -- Specify it's a server-side event
                    event = "custom-licenses:server:buyWeaponLicenseMeta",
                    args = { type = "meta" }
                }
            })
        else
            DebugPrint("Player already has the metadata license. Not showing the option.")
        end
        -- Always show the item license option
        table.insert(menuOptions, {
            header = "Buy Weapons License (Item)",
            txt = "Cost: $" .. Config.LicenseItemPrice,
            params = {
                isServer = true, -- Specify it's a server-side event
                event = "custom-licenses:server:buyWeaponLicenseItem",
                args = { type = "item" }
            }
        })
        -- Add a close menu option
        table.insert(menuOptions, {
            header = "Close Menu",
            params = {
                event = "qb-menu:closeMenu"
            }
        })
        -- Open the menu
        exports['qb-menu']:openMenu(menuOptions)
    end)
end

