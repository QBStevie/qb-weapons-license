# qb-weapons-license
A FiveM resource for managing weapons licenses in your server, built for QBCore.

---

## Features
- Purchase a weapons license as an item.
- Purchase a weapons license as metadata.
- Fully integrated with QBCore's player and inventory systems.
- Configurable prices and options.
- PolyZone-based interaction zone.
- Debugging options for development.

---

## Installation

### 1. Download and Install Required Resources
Ensure you have the following resources installed:
- [QBCore Framework](https://github.com/qbcore-framework/qb-core)
- [PolyZone](https://github.com/mkafrin/PolyZone)
- [qb-menu](https://github.com/qbcore-framework/qb-menu)

### 2. Add the Resource
Copy the `qb-weapons-license` folder to your `resources` directory.

### 3. Update `server.cfg`
Add the following lines to your `server.cfg`:
```cfg
ensure qb-core
ensure PolyZone
ensure qb-menu
ensure qb-weapons-license
```

### 4. Configure Prices and Debugging
Open `config.lua` to set your custom prices and toggle debug mode:
```lua
Config.LicensePrice = 100 -- Price for metadata license
Config.LicenseItemPrice = 50 -- Price for item license
Config.Debug = true -- Enable/disable debug mode
```

---

## Usage

### Interaction Zone
- Players can interact with the zone at the configured location to purchase a license.
- Default location is `vector3(156.5225, -915.8291, 30.1466)`.

### Commands
- `/testmenu`: Opens the license menu for testing.

### License Options
1. **Metadata License**:
   - Adds a "weapons" metadata field to the player's licenses.
2. **Item License**:
   - Adds a physical "weaponlicense" item to the player's inventory.

---

## Debugging

1. Set `Config.Debug = true` in `config.lua`.
2. Use the console logs to track client and server interactions:
   - `[DEBUG][Client]:` for client-side events.
   - `[DEBUG][Server]:` for server-side events.

---

## Dependencies
- [QBCore Framework](https://github.com/qbcore-framework/qb-core)
- [PolyZone](https://github.com/mkafrin/PolyZone)
- [qb-menu](https://github.com/qbcore-framework/qb-menu)

