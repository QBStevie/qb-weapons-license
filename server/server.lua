
local QBCore = exports['qb-core']:GetCoreObject()

-- Debug function
local function DebugPrint(msg)
    if Config.Debug then
        print("[DEBUG][Server]: " .. msg)
    end
end

RegisterNetEvent('custom-licenses:server:buyWeaponLicenseMeta', function()
    local src = source
    DebugPrint("[DEBUG] Server-side event triggered: custom-licenses:server:buyWeaponLicenseMeta by Player ID " .. src)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        DebugPrint("[ERROR] Player not found for source ID: " .. src)
        return
    end
    -- Check if the player already has the metadata license
    local licenses = Player.PlayerData.metadata["licences"] or {}
    if licenses["weapon"] then
        TriggerClientEvent('QBCore:Notify', src, 'You already have a weapons license!', 'error')
        DebugPrint("[DEBUG] Player already has a weapons license.")
        return
    end
    -- Deduct money
    if not Player.Functions.RemoveMoney('cash', Config.LicensePrice, 'weapons license purchase') then
        TriggerClientEvent('QBCore:Notify', src, ('You don\'t have enough money. You need $%s cash.'):format(Config.LicensePrice), 'error')
        DebugPrint("[DEBUG] Player does not have enough money for the metadata license.")
        return
    end
    -- Update metadata
    licenses["weapon"] = true
    Player.Functions.SetMetaData("licences", licenses)
    -- Notify the player
    TriggerClientEvent('QBCore:Notify', src, 'You have successfully purchased a weapons license!', 'success')
    DebugPrint("[DEBUG] Weapons license metadata successfully added.")
end)


RegisterNetEvent('custom-licenses:server:buyWeaponLicenseItem', function()
    local src = source
    DebugPrint("[DEBUG] Server-side event triggered: custom-licenses:server:buyWeaponLicenseItem by Player ID " .. src)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        DebugPrint("[ERROR] Player not found for source ID: " .. src)
        return
    end
    -- Deduct money
    if not Player.Functions.RemoveMoney('cash', Config.LicenseItemPrice, 'weapons license item purchase') then
        TriggerClientEvent('QBCore:Notify', src, ('You don\'t have enough money. You need $%s cash.'):format(Config.LicenseItemPrice), 'error')
        DebugPrint("[DEBUG] Player does not have enough money for the license item.")
        return
    end
    -- Prepare item metadata
    local info = {
        firstname = Player.PlayerData.charinfo.firstname,
        lastname = Player.PlayerData.charinfo.lastname,
        birthdate = Player.PlayerData.charinfo.birthdate,
    }
    -- Add the item to inventory
    if not Player.Functions.AddItem(Config.LicenseItem, 1, nil, info) then
        TriggerClientEvent('QBCore:Notify', src, 'Not enough space in your inventory for the weapons license!', 'error')
        DebugPrint("[DEBUG] Failed to add license item to inventory.")
        return
    end
    -- Notify the player
    TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[Config.LicenseItem], 'add')
    TriggerClientEvent('QBCore:Notify', src, 'You have successfully purchased a weapons license item!', 'success')
    DebugPrint("[DEBUG] Weapons license item successfully purchased.")
end)

QBCore.Functions.CreateCallback('custom-licenses:server:checkLicenseMeta', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then
        DebugPrint("[ERROR] Player not found for source ID: " .. source)
        cb(false)
        return
    end
    local licenses = Player.PlayerData.metadata["licences"] or {}
    if licenses["weapon"] then
        DebugPrint("[DEBUG] Player has metadata license.")
        cb(true) -- Player has the metadata license
    else
        DebugPrint("[DEBUG] Player does not have metadata license.")
        cb(false) -- Player does not have the metadata license
    end
end)
