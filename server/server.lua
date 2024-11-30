
local QBCore = exports['qb-core']:GetCoreObject()

-- Configuration
local Config = {
    LicensePrice = 100, -- Price for the metadata weapons license
    LicenseItemPrice = 50, -- Price for the weapons license item
    LicenseItem = "weaponlicense", -- Item name for the weapons license
}

-- Handle menu selection for buying a weapons license (metadata)
RegisterNetEvent('custom-licenses:server:buyWeaponLicenseMeta', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    -- Check if the player already has the metadata license
    local licenses = Player.PlayerData.metadata["licences"] or {}
    if licenses["weapon"] then
        TriggerClientEvent('QBCore:Notify', src, 'You already have a weapons license!', 'error')
        return
    end

    -- Deduct money
    if not Player.Functions.RemoveMoney('cash', Config.LicensePrice, 'weapons license purchase') then
        TriggerClientEvent('QBCore:Notify', src, ('You don\'t have enough money. You need $%s cash.'):format(Config.LicenseItemPrice), 'error')
        return
    end

    -- Update metadata
    licenses["weapon"] = true
    Player.Functions.SetMetaData("licences", licenses)

    -- Notify the player
    TriggerClientEvent('QBCore:Notify', src, 'You have successfully purchased a weapons license!', 'success')
end)

-- Handle menu selection for buying a weapons license item
RegisterNetEvent('custom-licenses:server:buyWeaponLicenseItem', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    -- Deduct money
    if not Player.Functions.RemoveMoney('cash', Config.LicenseItemPrice, 'weapons license item purchase') then
        TriggerClientEvent('QBCore:Notify', src, ('You don\'t have enough money. You need $%s cash.'):format(Config.LicenseItemPrice), 'error')
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
        return
    end

    -- Notify the player
    TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[Config.LicenseItem], 'add')
    TriggerClientEvent('QBCore:Notify', src, 'You have successfully purchased a weapons license item!', 'success')
end)
