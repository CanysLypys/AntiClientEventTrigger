RegisterNetEvent("foundYa:ban")
AddEventHandler("foundYa:ban", function(pSrc, grund, extendedData)
    print("^5[AntiClientEvent]^1 Player detected\n^2Name: ^5"..GetPlayerName(pSrc).."^0 \n"..extendedData)
    AntiBan(pSrc, grund, extendedData)
end)

AntiClientEventBanRegenerate = function()
    local o = LoadResourceFile(GetCurrentResourceName(), "banlist.json")

    if not o or o == "" then
        SaveResourceFile(GetCurrentResourceName(), "banlist.json", "[]", -1)
    else
        local p = json.decode(o)
		if not p then
			SaveResourceFile(GetCurrentResourceName(), "banlist.json", "[]", -1)
			p = {}
		end
    end
end

AntiBan = function(source, grund, extendedData)
    local file = LoadResourceFile(GetCurrentResourceName(), "banlist.json")
    local data = json.decode(file)

    if file == nil then
        AntiClientEventBanRegenerate()
        return
    end

    if GetPlayerName(source) == nil then
        return
    end

    if source == nil then
        return
    end

    if source == -1 then
        return
    end

    if extendedData == nil then
        return
    end

    if extendedData == "" then
        return
    end

   

    local myid = GetIdentifier(source);

    local playerSteam = myid.steam;
    local playerLicense = myid.license;
    local playerXbl = myid.xbl;
    local playerLive = myid.live;
    local playerDiscord = myid.discord;
    local playerIp = myid.ip;
    local playerHwid = GetPlayerToken(source, 0);

    local banInfo = {};

    banInfo['ID'] = tonumber(GetAndBanID());
    banInfo['reason'] = grund;
    banInfo['license'] = "N/A";
    banInfo['steam'] = "N/A";
    banInfo['xbl'] = "N/A";
    banInfo['live'] = "N/A";
    banInfo['discord'] = "N/A";
    banInfo["ip"] = "N/A";
    banInfo["hwid"] = "N/A";


    if playerLicense ~= nil and playerLicense ~= "nil" and playerLicense ~= "" then 
        banInfo['license'] = tostring(playerLicense);
    end
    if playerSteam ~= nil and playerSteam ~= "nil" and playerSteam ~= "" then 
        banInfo['steam'] = tostring(playerSteam);
    end
    if playerXbl ~= nil and playerXbl ~= "nil" and playerXbl ~= "" then 
        banInfo['xbl'] = tostring(playerXbl);
    end
    if playerLive ~= nil and playerLive ~= "nil" and playerLive ~= "" then 
        banInfo['live'] = tostring(playerLive);
    end
    if playerDiscord ~= nil and playerDiscord ~= "nil" and playerDiscord ~= "" then 
        banInfo['discord'] = tostring(playerDiscord);
    end
    if playerIp ~= nil and playerIp ~= "nil" and playerIp ~= "" then
        banInfo["ip"] = tostring(playerIp);
    end
    if playerHwid ~= nil and playerHwid ~= "nil" and playerHwid ~= "" then
        banInfo["hwid"] = tostring(playerHwid);
    end

    data[tostring(GetPlayerName(source))] = banInfo;
    SaveResourceFile(GetCurrentResourceName(), "banlist.json", json.encode(data, { indent = true }), -1)

    DropPlayer(source, grund)
end

function getBanned(source)
    local file = LoadResourceFile(GetCurrentResourceName(), "banlist.json")
    local data = json.decode(file)

    if file == nil then
        AntiClientEventBanRegenerate()
        return
    end
    
	local myid = GetIdentifier(source);
    local playerSteam = myid.steam;
    local playerLicense = myid.license;
    local playerXbl = myid.xbl;
    local playerLive = myid.live;
    local playerDisc = myid.discord;
    local playerIp = myid.ip;
    local playerHwid = GetPlayerToken(source, 0);


    for k, bigData in pairs(data) do 
        local reason = bigData['reason']
        local id = bigData['ID']
        local license = bigData['license']
        local steam = bigData['steam']
        local xbl = bigData['xbl']
        local live = bigData['live']
        local discord = bigData['discord']
        local ip = bigData["ip"]
        local hwid = bigData["hwid"]

        if tostring(license) == tostring(playerLicense) then return { ['banID'] = id, ['reason'] = reason } end;
        if tostring(steam) == tostring(playerSteam) then return { ['banID'] = id, ['reason'] = reason } end;
        if tostring(xbl) == tostring(playerXbl) then return { ['banID'] = id, ['reason'] = reason } end;
        if tostring(live) == tostring(playerLive) then return { ['banID'] = id, ['reason'] = reason } end;
        if tostring(discord) == tostring(playerDisc) then return { ['banID'] = id, ['reason'] = reason } end;
        if tostring(ip) == tostring(playerIp) then return { [ "banID"] = id, ["reason"] = reason } end;
        if tostring(hwid) == tostring(playerHwid) then return { [ "banID"] = id, ["reason"] = reason } end;
    end
    return false;
end

local function OnPlayerConnecting(name, setKickReason, deferrals)
    local banned = false;
    local ban = getBanned(source);
    local ip = tostring(GetPlayerEndpoint(source))
	local ids = GetIdentifier(source);
    local name = GetPlayerName(source);
    deferrals.defer();

    Wait(100);
    
   
	if ban then
        local reason = ban['reason'];
        deferrals.done("\n\nYou are permanently banned from this server. Reason: "..reason.."\nBanID: "..ban['banID']);
        banned = true;
        CancelEvent();
		return;
    end

    if not banned then
        deferrals.done()
    end
end

AddEventHandler("playerConnecting", OnPlayerConnecting)

function GetIdentifier(source)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end

function GetAndBanID()
    local file = LoadResourceFile(GetCurrentResourceName(), "banlist.json")
    local data = json.decode(file)
    local banID = 0;
    for k, v in pairs(data) do 
        banID = banID + 1;
    end
    return (banID + 1);
end
