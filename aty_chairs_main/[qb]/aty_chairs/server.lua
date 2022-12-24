local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback("aty:ChairChecked", function(source, cb)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if xPlayer.Functions.RemoveItem("chair", 1) then
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent("addChair")
AddEventHandler("addChair", function()
    local xPlayer = QBCore.Functions.GetPlayer(source)
    xPlayer.Functions.AddItem('chair', 1)
end)