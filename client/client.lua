for k, clientEvents in pairs(Config.ProtectTheseClientEvents) do
    RegisterNetEvent(clientEvents)
    AddEventHandler(clientEvents, function()
        local getResource = GetInvokingResource()
        
        TriggerServerEvent("foundYa:proceedData", getResource, clientEvents)
    end)
end
