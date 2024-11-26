AddCSLuaFile("cl_init.lua") --server knows about cl_init, but we need to send init.lua (server) file  to client by doing this
AddCSLuaFile("shared.lua") --server also sends to shared.lua file
include("shared.lua") --gets all the codes of the shared lua (as if copy pasted shared.lua's codes to here)


function ENT:Initialize()
    self:SetModel("models/props_combine/suit_charger001.mdl") --obvious
    --self:SetModel("models/items/item_item_crate.mdl")
    
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)  
    self:SetSolid(SOLID_VPHYSICS)    
    self:SetUseType(SIMPLE_USE)     
    self:SetColor(Color(170, 255, 170, 255))
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:EnableMotion(false)    
        phys:Sleep()                
    end
    self:EnableCustomCollisions(false)
end



function ENT:Use(a, c)  --c is the player, dunno who is a
    c.isinshop = true
    local currentWeapon = c:GetActiveWeapon()
    if IsValid(currentWeapon) then
        local weaponclass = currentWeapon:GetClass()
        local foundWeapon = FindWeaponByClass(weaponclass)
        if foundWeapon == nil then
            weapsellvalue = defaultsellvalue
            local sellonlylisted = tonumber(wblmonsellonlylisted:GetInt())
            if sellonlylisted == 1 then
                weapsellvaluetosend = "N.A."
            else
                weapsellvaluetosend = tostring(defaultsellvalue)
            end
            ammo1price = "N.A."
            ammo2price = "N.A."
        else
            if foundWeapon.sellable then
                weapsellvalue = foundWeapon.sellvalue
                weapsellvaluetosend = tostring(foundWeapon.sellvalue)
            else
                weapsellvaluetosend = "N.A."
            end
            local ammo1 = FindAmmoByName(foundWeapon.ammo1)
            if ammo1 == nil then
                ammo1price = "N.A."
            else
                ammo1price = ammo1.price
            end
            
            local ammo2 = FindAmmoByName(foundWeapon.ammo2)
            if ammo2 == nil then
                ammo2price = "N.A."
            else
                ammo2price = ammo2.price
            end
        end
    else
        weapsellvalue = defaultsellvalue
        weapsellvaluetosend = tostring(defaultsellvalue)
        ammo1price = "N.A."
        ammo2price = "N.A."
    end
    if once == 1 then
        CompressAndSendTable("wbladdweaponlistToC", wblweaponlist, c)
        CompressAndSendTable("wbladdammolistToC", wblammolist, c)
        wblDebug("UPDATED WEAPON LIST TO CLIENT")
        once = 0
    end
    updatepricesinstore(c)
    net.Start("wblWinPop") --Starts the "WinPop" signal/channel for client
    remammo = -1
    net.Send(c) --Sends a go signal to "c" which is the player who used it
    c:SetVelocity(Vector(0, 0, 0))
    c:Freeze(true)
    net.Start("wblFreeze")
    net.Send(c)
    --
    --PrintTable(wblweaponlist)
    --PrintTable(wblammolist)
    --
end