local resourceSet = {}
local allResources = GetNumResources()

for i = 0, allResources - 1 do
    local resource_name = GetResourceByFindIndex(i)
    if resource_name and GetResourceState(resource_name) == "started" then
        resourceSet[resource_name] = true
    end
end

RegisterNetEvent("foundYa:proceedData")
AddEventHandler("foundYa:proceedData", function(getResource, clientEvents)
    if not resourceSet[getResource] then
        print("^5[AntiClientEvent]^1 Player detected\n^2Name: ^5"..GetPlayerName(source).."^0 \nResource: "..getResource.."\nClientEvent: "..clientEvents)
	-- Add your ban system here. e.g export...
			
    end
end)
