ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback("aty:ChairChecked", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemCount = xPlayer.getInventoryItem("chair").count
    if itemCount >= 1 then
        xPlayer.removeInventoryItem('chair', 1)
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent("addChair")
AddEventHandler("addChair", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem('chair', 1)
end)