QBCore = exports['qb-core']:GetCoreObject()

-- Steam Hex alma callback'i
QBCore.Functions.CreateCallback('getSteamHex', function(source, cb)
    local identifiers = GetPlayerIdentifiers(source)
    for _, id in ipairs(identifiers) do
        if string.sub(id, 1, 6) == "steam:" then
            cb(id)
            return
        end
    end
    cb(nil)
end)

-- Yetkisiz araç kullanımında Discord'a log gönderme
RegisterNetEvent("customcar:logUnauthorizedUse", function(vehicleModel)
    local src = source
    local name = GetPlayerName(src)
    local identifiers = GetPlayerIdentifiers(src)
    
    local steam, discord, license, ip = "N/A", "N/A", "N/A", "N/A"

    for _, v in pairs(identifiers) do
        if string.sub(v, 1, 6) == "steam:" then steam = v
        elseif string.sub(v, 1, 8) == "discord:" then discord = "<@" .. string.sub(v, 9) .. ">"
        elseif string.sub(v, 1, 7) == "license" then license = v
        elseif string.sub(v, 1, 3) == "ip:" then ip = v
        end
    end

    local embed = {
        {
            ["color"] = 16711680,
            ["title"] = "🚨 Yetkisiz Özel Araç Kullanımı",
            ["description"] = "@everyone\nBir oyuncu izinsiz özel araca binmeye çalıştı!",
            ["fields"] = {
                {["name"] = "İsim", ["value"] = name, ["inline"] = true},
                {["name"] = "Araç Modeli", ["value"] = vehicleModel, ["inline"] = true},
                {["name"] = "Steam", ["value"] = steam, ["inline"] = false},
                {["name"] = "Discord", ["value"] = discord, ["inline"] = false},
                {["name"] = "License", ["value"] = license, ["inline"] = false},
                {["name"] = "IP", ["value"] = ip, ["inline"] = false}
            },
            ["footer"] = {
                ["text"] = "Custom Car Guard"
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }

    PerformHttpRequest(Config.CustomCarWebhook, function(err, text, headers) end, 'POST', json.encode({
        username = "🚔 Araç Güvenliği",
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end)
