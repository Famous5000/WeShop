AddCSLuaFile("cl_init.lua") --server knows about cl_init, but we need to send init.lua (server) file  to client by doing this
AddCSLuaFile("shared.lua") --server also sends to shared.lua file
include("shared.lua") --gets all the codes of the shared lua (as if copy pasted shared.lua's codes to here)



function ENT:Initialize()
    self:SetModel("models/items/battery.mdl")
    self:SetColor(Color(0, 255, 0))

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local angles = self:GetAngles()
    angles:RotateAroundAxis(angles:Right(), 90) -- Rotate around the Z-axis by 90 degrees
    self:SetAngles(angles)

    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:Wake()
    end

end


 --Function triggered when touched by another entity
function ENT:StartTouch(ent)
    -- Check if the touching entity is a player
    if ent:IsPlayer() then
        self:HandleInteraction(ent)
    end
end

-- Function triggered when the entity is "used" (interacted with via the use key)
function ENT:Use(activator, caller)
    -- Check if the activator is a player
    if activator:IsPlayer() then
        self:HandleInteraction(activator)
    end
end

-- Function that handles the interaction (either touch or use)
function ENT:HandleInteraction(ply)
	self:EmitSound("npc/turret_floor/click1.wav")
    local plycoop = tonumber(wblmonplycoop:GetInt())
    if plycoop == 0 then
    	local wblmoney = tonumber((ply:GetPData("wblmoney",-1)))
		local entvalue = tonumber(wblmonentvalue:GetInt())
		wblmoney = wblmoney + entvalue
		local maxmonz = wblmonmax:GetInt()
		if wblmoney < 0 then
			ply:SetPData( "wblmoney", 0 ) 
			wblmoney = 0
		elseif wblmoney > maxmonz then
			ply:SetPData( "wblmoney", maxmonz )
			wblmoney = maxmonz
		else
			ply:SetPData( "wblmoney", wblmoney ) 
		end
		net.Start("plyMonzupdateToC")
		net.WriteInt(wblmoney,32)
		net.WriteInt(entvalue,32)
		net.Send(ply)
    else
        local humanCount = 0
        for _, plyy in pairs(player.GetAll()) do
            if not plyy:IsBot() then
                humanCount = humanCount + 1
            end
        end

        for _, plyyer in pairs(player.GetAll()) do
            if not plyyer:IsBot() then
                --print("humanCount: "..humanCount)
                local wblmoney = tonumber((plyyer:GetPData("wblmoney",-1)))
                local entvalue = tonumber(wblmonentvalue:GetInt())
                wblmoney = wblmoney + (entvalue/humanCount)
                local maxmonz = wblmonmax:GetInt()
                if wblmoney < 0 then
                    plyyer:SetPData( "wblmoney", 0 ) 
                    wblmoney = 0
                elseif wblmoney > maxmonz then
                    plyyer:SetPData( "wblmoney", maxmonz )
                    wblmoney = maxmonz
                else
                    plyyer:SetPData( "wblmoney", wblmoney ) 
                end
                net.Start("plyMonzupdateToC")
                net.WriteInt(wblmoney,32)
                net.WriteInt(entvalue/humanCount,32)
                net.Send(plyyer)
            end
        end


    end
    
    self:Remove()
end