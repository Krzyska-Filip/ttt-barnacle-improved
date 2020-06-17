util.AddNetworkString("ttt_barnacle_halo_push")
local traitorList = {}
local index = 0

--Get list of traitors in order send them information about barnacle
local function createTraitorList()
    local players = player.GetAll()
    for i = 1, #players do
        local p = players[i]
        if not p:IsTraitor() then continue end
        traitorList[#traitorList + 1] = p
    end
end
hook.Add( "TTTBeginRound", "TraitorList", createTraitorList)

--Clear list of traitor
hook.Add( "TTTPrepareRound", "ClearTraitorList", function()
    table.Empty(traitorList)
    index = 0
end)

--Check if created entity is barnacle, if so send message to all traitors.
hook.Add( "OnEntityCreated", "BarnacleHalo", function( ent )
    if ent:GetClass() ~= "npc_barnacle" then return end
    if table.IsEmpty(traitorList) then return end

    net.Start("ttt_barnacle_halo_push")
    net.WriteEntity(ent)
    net.WriteBool(true)
    net.Send(traitorList)
end)

--Check if killed NPC was barnacle, if so send message to all traitors
hook.Add("OnNPCKilled", "BarnacleAlive", function(npc)
    if npc:GetClass() ~= "npc_barnacle" then return end
    if table.IsEmpty(traitorList) then return end
    net.Start("ttt_barnacle_halo_push")
    net.WriteEntity(npc)
    net.WriteBool(false)
    net.Send(traitorList)
end)