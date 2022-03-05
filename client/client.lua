local resourceList = {}
local allResources = GetNumResources()
for i = 0, allResources, 1 do
    local resource_name = GetResourceByFindIndex(i)
    if resource_name and GetResourceState(resource_name) == "started" then
        table.insert(resourceList, resource_name)
    end
end

for k, clientEvents in pairs(Config.ProtectTheseClientEvents) do
    RegisterNetEvent(clientEvents)
    AddEventHandler(clientEvents, function()
        local getResource = GetInvokingResource()
        
        TriggerServerEvent("foundYa:proceedData", getResource, clientEvents)
    end)
end
