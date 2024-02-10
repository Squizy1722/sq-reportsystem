local QBCore = exports['qb-core']:GetCoreObject()

sendreport = {}
admininreport = {}
inreport = {}

QBCore.Commands.Add('report', 'need help?', {{name='reason', help='Reason'}}, false, function(source, args)
    local src = source
    local msg = table.concat(args, ' ')
    local Player = QBCore.Functions.GetPlayer(source)
    local PlayerCitizenID = Player.PlayerData.citizenid
    if sendreport[PlayerCitizenID] ~= 1 then
        TriggerEvent('sq-report:server:reportcooldown', src)
        TriggerClientEvent('sq-report:client:SendReport', -1, GetPlayerName(src), src, msg)
        TriggerEvent('qb-log:server:CreateLog', 'sqreport', 'report', 'red', '**Member: **'..GetPlayerName(src) ..' (Name: '.. Player.PlayerData.charinfo.firstname ..' '.. Player.PlayerData.charinfo.lastname ..' | CitizenID: '.. Player.PlayerData.citizenid ..' | ID: **'.. src .. '**)\n**Reason: **'.. msg, false)
    else
        TriggerClientEvent('QBCore:Notify', src, 'report cooldown wait!', 'error', 5000) 
    end
end)

RegisterNetEvent('sq-report:server:reportcooldown', function(src)
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerCitizenID = Player.PlayerData.citizenid
    sendreport[PlayerCitizenID] = 1
    Wait(1000*60*Config.cooldowntime)
    sendreport[PlayerCitizenID] = 0
end)

RegisterNetEvent('sq-report:server:SendReport', function(name, targetSrc, msg)
    local src = source
    if QBCore.Functions.HasPermission(src, 'admin') or QBCore.Functions.HasPermission(src, 'god') then
        if QBCore.Functions.IsOptin(src) then
         --   TriggerClientEvent('chat:addMessage', src, {
         --       color = {255, 0, 0},
         --       multiline = true,
        --        args = {'Admin Report - '..name..' ('..targetSrc..')', msg}
        --    })
            TriggerClientEvent('chat:addMessage', src, {template = '<div class="chat-message error"><strong>{0}:</strong> {1} </div>',args = {  'Admin Report - '..name..' ('..targetSrc..')', msg } }) 
        end
    end
end)

QBCore.Commands.Add('adminsit', 'go help!', {{name='id', help='Player id'}}, false, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local target = tonumber(args[1])
    local targi = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if targi ~= nil then
        local targicid = targi.PlayerData.citizenid
        local Playercid = Player.PlayerData.citizenid
   --     if sendreport[targicid] == 1 and inreport[Playercid] ~= 1 and admininreport[targicid] ~= 1 then
   if sendreport[targicid] == 1 then
    if inreport[Playercid] ~= 1 then
        if admininreport[targicid] ~= 1 then
        local ped = GetPlayerPed(target)
        local playerCoords = GetEntityCoords(ped)
        TriggerClientEvent('sq-report:client:adminsit',src,playerCoords,target)
        TriggerClientEvent('qb-admin:client:SendStaffChat', -1, GetPlayerName(src), target)
        inreport[Playercid] = 1
        admininreport[targicid] = 1
        else
            TriggerClientEvent('QBCore:Notify', src, 'someone already helping the player', 'error', 5000) 
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'you already in report', 'error', 5000) 
    end
else
    TriggerClientEvent('QBCore:Notify', src, 'player did not ask for help', 'error', 5000) 
end
    else
        TriggerClientEvent('QBCore:Notify', src, 'player not found', 'error', 5000) 
    end
end, 'admin')

QBCore.Commands.Add('endsit', 'end sit!', {}, false, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Playercid = Player.PlayerData.citizenid
    if inreport[Playercid] == 1 then
    TriggerClientEvent('sq-report:client:endsit',src)
    TriggerEvent('qb-log:server:CreateLog', 'sqreport', 'endsit', 'green', '**Admin: **'..GetPlayerName(source)..' (CitizenID: '..Player.PlayerData.citizenid..' | ID: **'..source..'**)', false)
    else
        TriggerClientEvent('QBCore:Notify', src, 'your not in a report', 'error', 5000)     
end
end, 'admin')

RegisterNetEvent('sq-report:server:endsit', function(playerid)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local target = playerid
    local targi = QBCore.Functions.GetPlayer(playerid)
    local targicid = targi.PlayerData.citizenid
    local Playercid = Player.PlayerData.citizenid
    inreport[Playercid] = 0
    admininreport[targicid] = 0
end)