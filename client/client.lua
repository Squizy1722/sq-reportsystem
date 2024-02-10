local QBCore = exports['qb-core']:GetCoreObject()

adminlocation = false
playerhelpingid = 0

RegisterNetEvent('sq-report:client:SendReport', function(name, src, msg)
    TriggerServerEvent('sq-report:server:SendReport', name, src, msg)
end)

RegisterNetEvent('sq-report:client:adminsit', function(pcoords, playerid)
    local ped = PlayerPedId()
local currentPos = GetEntityCoords(ped)
    adminlocation = currentPos
    playerhelpingid = playerid
SetEntityCoords(ped, pcoords.x, pcoords.y, pcoords.z, false, false, false, true)
 end)

 RegisterNetEvent('sq-report:client:endsit', function()
    local ped = PlayerPedId()
    SetEntityCoords(ped, adminlocation.x, adminlocation.y, adminlocation.z, false, false, false, true)
        TriggerServerEvent('sq-report:server:endsit',playerhelpingid)
 end)
