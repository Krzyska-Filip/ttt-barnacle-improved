local brEnt = {}
local index = 0

--Display every barnacle
hook.Add("PreDrawHalos", "DrawBarnacle", function()
    if not GetGlobalBool("ttt_barnacle_draw_outline", true) then return end
    if table.IsEmpty(brEnt) then return end
    if TTT2 then
        for _, v in pairs(brEnt) do
            outline.Add(v, Color(255,0,0, 255), OUTLINE_MODE_VISIBLE)
        end
    else
        halo.Add(brEnt, Color(255,0,0, 255), 1, 1, 10, true, true)
    end
end)

--Remove all entities form list
hook.Add("TTTBeginRound", "RestartHalo", function()
    index = 0
    table.Empty( brEnt )
end)

--Remove all entities form list | Double check
hook.Add("TTTPrepareRound", "RestartHalo2", function()
    index = 0
    table.Empty( brEnt )
end)

net.Receive("ttt_barnacle_halo_push", function()
    local client = LocalPlayer()
    local ent = net.ReadEntity()
    local option = net.ReadBool()

    if option then --add barnacle to the list.
        brEnt[index] = ent
        index = index + 1
    else --remove barnacle form the list.
        if table.IsEmpty(brEnt) then return end
        for k, v in pairs(brEnt) do
            if ent == v then 
                brEnt[k] = false
            end
        end
    end
end)

