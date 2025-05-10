QBCore = exports['qb-core']:GetCoreObject()
local PlayerHex = nil

-- Steam Hex alma
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.TriggerCallback('getSteamHex', function(hex)
        PlayerHex = hex
    end)
end)

-- Araç kontrol döngüsü
CreateThread(function()
    while true do
        Wait(Config.CheckInterval)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            local driver = GetPedInVehicleSeat(veh, -1)
            if driver == ped then
                local modelHash = GetEntityModel(veh)
                local modelName = GetVehicleModelNameFromHash(modelHash):lower()

                local allowedHex = Config.AllowedVehicles[modelName]
                if allowedHex and PlayerHex ~= allowedHex then
                    TaskLeaveVehicle(ped, veh, 16)
                    QBCore.Functions.Notify("Bu aracı süremezsin AHAHAHAHAH!!!", "error", 4000)
                    TriggerServerEvent("customcar:logUnauthorizedUse", modelName)
                end
            end
        end
    end
end)

-- Hash'ten model adını al (config'ten çözümleme)
function GetVehicleModelNameFromHash(hash)
    for name, _ in pairs(Config.AllowedVehicles) do
        if GetHashKey(name) == hash then
            return name
        end
    end
    return "unknown"
end
