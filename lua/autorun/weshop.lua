npcstaticlist = {}

if SERVER then

--[[
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\CONVARS\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
]]

--
--
--
--
--
--
--

-- for Debugging (START) --
function wblDebug(a) 
    local Debug = wblmonDebug:GetInt()
    if Debug == 1 then
        print(tostring(a))
    end
end
-- for Debugging (END) --

--enable getting of money and money hud
wblmonhen = CreateConVar( "wblmoney_enable", 1, FCVAR_NONE, "1", 0, 1 ) 

local filePath = "weshop/MoneyEnabled.txt"
if file.Exists(filePath, "DATA") then
    local content = file.Read(filePath, "DATA")
    if content == "1" then
        RunConsoleCommand("wblmoney_enable", "1")
    elseif content == "0" then
        RunConsoleCommand("wblmoney_enable", "0")
    end
end


--functions that execute when changes on this convar happens
cvars.AddChangeCallback("wblmoney_enable", function(convar_name, old_value, new_value)
    wblDebug("ConVar " .. tostring(convar_name) .. " changed from " .. tostring(old_value) .. " to " .. tostring(new_value))
     	
     	if not file.IsDir("weshop", "DATA") then
        	file.CreateDir("weshop")
    	end
    	file.Write(filePath, new_value)   

		local monen
		    if new_value == "1" then
		        -- ConVar is enabled (assuming it's a checkbox or boolean value)
		        wblDebug("Dynamic Money is now enabled!")
		        -- Call your function to enable dynamic money
		        monen = 1
		        MoneyHuden()
		    else
		        -- ConVar is disabled
		        wblDebug("Dynamic Money is now disabled!")
		        -- Call your function to disable dynamic money
		        monen = 0
		    end
		net.Start("wblmoneyen")
   	 	net.WriteInt(monen, 16)
		net.Broadcast()	
		
end)

--for Debug
wblmonDebug = CreateConVar( "wblmoney_Debug", 0, FCVAR_NONE, "0", 0, 1 )


--Starting Money of New players or if money reset is executed
wblmonstart = CreateConVar( "wblmoney_money_start", 500, FCVAR_NONE, "500", 0, math.huge ) 



--Max Money of players 
wblmonmax = CreateConVar( "wblmoney_money_max", 16000, FCVAR_NONE, "16000", 0, math.huge ) 

cvars.AddChangeCallback("wblmoney_money_max", function(convar_name, old_value, new_value)

	local ply = player.GetAll() 
	for k, v in pairs(ply) do   
		local wblmoney = (v:GetPData("wblmoney",-1)) 
		local maxmonz = wblmonmax:GetInt()
		if tonumber(wblmoney) > tonumber(maxmonz) then
		wblmoney = maxmonz
		v:SetPData("wblmoney",wblmoney)
		net.Start("plyMonzupdateToC")
		net.WriteInt(wblmoney,32)
		net.WriteInt(0,32)
		net.Send(v)
		end
	end
	local monstart = tonumber(wblmonstart:GetInt())
	if tonumber(new_value) < tonumber(monstart) then
		RunConsoleCommand("wblmoney_money_start", new_value)
	end

end)

cvars.AddChangeCallback("wblmoney_money_start", function(convar_name, old_value, new_value)
	local monmax = tonumber(wblmonmax:GetInt())
	if tonumber(new_value) > tonumber(monmax) then
		RunConsoleCommand("wblmoney_money_max", new_value)
	end
end)

--Dynamic money options
wblmonhmul = CreateConVar( "wblmoney_dynamicmoney_multplier", 1, FCVAR_NONE, "1", 0, 2000 )
wblmonhoffset = CreateConVar( "wblmoney_dynamicmoney_offset", 0, FCVAR_NONE, "0", 0, math.huge )
wblmonhfb = CreateConVar( "wblmoney_dynamicmoney_fallback", 50, FCVAR_NONE, "50", 0, math.huge )
wblmonhudx = CreateConVar( "wblmoney_hudx", 0, FCVAR_NONE, "0", -10, 10 )

cvars.AddChangeCallback("wblmoney_hudx", function(convar_name, old_value, new_value)
    wblDebug("ConVar " .. tostring(convar_name) .. " changed from " .. tostring(old_value) .. " to " .. tostring(new_value))
        
		local hudx = new_value
		net.Start("wblmoneyhudx")
   	 	net.WriteInt(hudx, 16)
		--net.Broadcast
		
end)

wblmonhudy = CreateConVar( "wblmoney_hudy", 9, FCVAR_NONE, "9", -10, 10 )


wblmondynen = CreateConVar( "wblmoney_dynamicmoney_enable", 1, FCVAR_NONE, "1", 0, 1 ) 



--Persist Money in map change/restart. - neeed this to be at the top
wblmonpers = CreateConVar("wblmoney_money_persist", 0, FCVAR_NONE, "0", 0, 1)

local filePath = "weshop/MoneyPersist.txt"
if file.Exists(filePath, "DATA") then

    local content = file.Read(filePath, "DATA")

    if content == "1" then
        RunConsoleCommand("wblmoney_money_persist", "1")
    elseif content == "0" then
        RunConsoleCommand("wblmoney_money_persist", "0")
    end
end

cvars.AddChangeCallback("wblmoney_money_persist", function(convar_name, old_value, new_value)
    if not file.IsDir("weshop", "DATA") then
        file.CreateDir("weshop")
    end
    file.Write(filePath, new_value)
end)

--Money loss method
wblmonlosen = CreateConVar( "wblmoney_moneyloss_enabled", 1, FCVAR_NONE, "1", 0, 1 )



wblmonlosmet = CreateConVar( "wblmoney_moneyloss_method", 2, FCVAR_NONE, "2", 1, 2 )
wblmonlosfix = CreateConVar( "wblmoney_moneyloss_fixed_amount", 50, FCVAR_NONE, "50", 0, math.huge )
wblmonlospercent = CreateConVar( "wblmoney_moneyloss_percent_amount", 10, FCVAR_NONE, "10", 0, 100 )

--Money Divide among players
wblmonplycoop = CreateConVar( "wblmoney_money_coop", 0, FCVAR_NONE, "0", 0, 1 )

--Money Value of player
wblmonplyvalue = CreateConVar( "wblmoney_money_plyvalue", 300, FCVAR_NONE, "300", 0, math.huge )

--Money Value of Money Entity
wblmonentvalue = CreateConVar( "wblmoney_money_entvalue", 50, FCVAR_NONE, "50", 0, math.huge )





--Disable money gain on NPC who likes player
wblmonhallmon = CreateConVar( "wblmoney_Nomoneyonally", 0, FCVAR_NONE, "0", 0, 1 )

wblmonbuyanywhere = CreateConVar("wblmoney_buyanywhere", 0, FCVAR_ARCHIVE, "0", 0, 1)

cvars.AddChangeCallback("wblmoney_buyanywhere", function(convar_name, old_value, new_value)

    local monen = wblmonhen:GetInt()
    timer.Remove("LockShop")
    if tonumber(new_value) == 1 then
        net.Start("wblEnableShopbuy")
        net.Broadcast()
        for _, ply in ipairs(player.GetAll()) do
            ply.canbuy = true
        end
    else
        net.Start("wblDisableShopbuy")
        net.Broadcast()
        for _, ply in ipairs(player.GetAll()) do
            ply.canbuy = false
        end
    end
end)



wblmonbuyatstart = CreateConVar("wblmoney_buyanywhere_OnSpawn", 0, FCVAR_ARCHIVE, "0", 0, 1)

cvars.AddChangeCallback("wblmoney_buyanywhere_OnSpawn", function(convar_name, old_value, new_value)
    local monen = wblmonhen:GetInt()
    local monany = wblmonbuyanywhere:GetInt()
    timer.Remove("LockShop")
    if tonumber(new_value) == 1 then
        for _, ply in ipairs(player.GetAll()) do
            ply.canbuy = false
        end
        net.Start("wblDisableShopbuy")
        net.Broadcast()
    elseif (tonumber(new_value) == 0) and (tonumber(monany) == 1) then
        for _, ply in ipairs(player.GetAll()) do
            ply.canbuy = true
        end
        net.Start("wblEnableShopbuy")
        net.Broadcast()
    end
end)

wblmonbuyatstarttime = CreateConVar("wblmoney_buyanywhere_OnSpawntimelimit", 20, FCVAR_ARCHIVE, "20", 0, 100)

wblmonsingleplayercampaignmode = CreateConVar( "wblmoney_campaignmode_singleplayer", 0, FCVAR_NONE, "0", 0, 1 )

concommand.Add("wblmoney_Debug_Table", function(plyer, cmd, args, argStr)
    print("%%%%%%%%%% WBL WEAPON LIST %%%%%%%%%%")
    PrintTable(wblweaponlist)
    print("%%%%%%%%%% WBL WEAPON LIST %%%%%%%%%%")
    print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
    print("%%%%%%%%%% WBL AMMO LIST %%%%%%%%&&%%")
    PrintTable(wblammolist)
    print("%%%%%%%%%% WBL AMMO LIST %%%%%%%%&&%%")
end)

concommand.Add("wblmoney_resetallplayermoney", function(plyer, cmd, args, argStr)
    for _, ply in ipairs(player.GetAll()) do
        local moneystart = wblmonstart:GetInt()
        local maxmonz = wblmonstart:GetInt()
        local wblmoney = (ply:GetPData("wblmoney",-1))
        ply:SetPData("wblmoney",moneystart)
        net.Start("plyMonzResetToC")
        net.Send(ply)
        local wblmoney = (ply:GetPData("wblmoney",-1))

        wblDebug("Your current money now is: "..wblmoney)
        local monen = wblmonhen:GetInt()
        if monen == 1 then
            net.Start("plyMonzupdateToC")
            net.WriteInt(wblmoney,32)
            net.Send(ply)
        end

    end
end)


concommand.Add("wblmoney_hl1tomoney", function(plyer, cmd, args, argStr)
    RunConsoleCommand("hl1coop_weprepl_crowbar", "weshopmoney")
    RunConsoleCommand("hl1coop_weprepl_glock", "weshopmoney")
    RunConsoleCommand("hl1coop_weprepl_357", "weshopmoney")
    RunConsoleCommand("hl1coop_weprepl_mp5", "weshopmoney")
    RunConsoleCommand("hl1coop_weprepl_shotgun", "weshopmoney")
    RunConsoleCommand("hl1coop_weprepl_crossbow", "weshopmoney")
    RunConsoleCommand("hl1coop_weprepl_rpg", "weshopmoney")
    RunConsoleCommand("hl1coop_weprepl_gauss", "weshopmoney")
    RunConsoleCommand("hl1coop_weprepl_egon", "weshopmoney")
    RunConsoleCommand("hl1coop_weprepl_hornetgun", "weshopmoney")
    RunConsoleCommand("hl1coop_weprepl_handgrenade", "weshopmoney")
    RunConsoleCommand("hl1coop_weprepl_satchel", "weshopmoney")
    RunConsoleCommand("hl1coop_weprepl_tripmine", "weshopmoney")
    RunConsoleCommand("hl1coop_weprepl_snark", "weshopmoney")

    RunConsoleCommand("hl1coop_ammorepl_glock", "weshopmoney")
    RunConsoleCommand("hl1coop_ammorepl_357", "weshopmoney")
    RunConsoleCommand("hl1coop_ammorepl_mp5clip", "weshopmoney")
    RunConsoleCommand("hl1coop_ammorepl_mp5grenades", "weshopmoney")
    RunConsoleCommand("hl1coop_ammorepl_shotgun", "weshopmoney")
    RunConsoleCommand("hl1coop_ammorepl_crossbow", "weshopmoney")
    RunConsoleCommand("hl1coop_ammorepl_gauss", "weshopmoney")
    RunConsoleCommand("hl1coop_ammorepl_rpg", "weshopmoney")
end)

wblmonreplaceammoentities = CreateConVar( "wblmoney_campaignmode_replaceammoentities", 0, FCVAR_NONE, "0", 0, 1 )

wblmonNopickup = CreateConVar( "wblmoney_campaignmode_Disablepickup", 0, FCVAR_NONE, "0", 0, 1 )

wblmonNopickupslotid = CreateConVar( "wblmoney_campaignmode_Disablepickupsameslotid", 0, FCVAR_NONE, "0", 0, 1 )

wblmonreplaceammoentitiesantisoftlock = CreateConVar( "wblmoney_campaignmode_preventsoftlock", 1, FCVAR_NONE, "1", 0, 1 )


wblmonreplacewallchargers = CreateConVar( "wblmoney_campaignmode_replacewallchargers", 0, FCVAR_NONE, "0", 0, 1 )

wblmondelayedwstar = CreateConVar( "wblmoney_campaignmode_delayedwstar", 0, FCVAR_NONE, "0", 0, 1 )

--local Disablepickup = tonumber(wblmonNopickup:GetInt())
--[[
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\NETWORK\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
]]


local replaceableEntities = {
     -- Half-Life 2 Weapons
    ["weapon_smg1"] = false,
    ["weapon_stunstick"] = false,
    ["weapon_slam"] = false,
    ["weapon_ar2"] = false,
    ["weapon_pistol"] = false,
    ["weapon_357"] = false,
    ["weapon_crossbow"] = false,
    ["weapon_frag"] = false,
    ["weapon_crowbar"] = false,
    ["weapon_rpg"] = false,
    ["weapon_shotgun"] = false,
    ["weapon_physcannon"] = false,
    ["weapon_bugbait"] = false,

    -- Half-Life 2 Ammo
    ["item_ammo_pistol"] = true,
    ["item_ammo_pistol_large"] = true,
    ["item_ammo_smg1"] = true,
    ["item_ammo_smg1_large"] = true,
    ["item_ammo_ar2"] = true,
    ["item_ammo_357"] = true,
    ["item_ammo_357_large"] = true,
    ["item_ammo_crossbow"] = true,
    ["item_ammo_ar2_altfire"] = true,
    ["item_ammo_smg1_grenade"] = true,
    ["item_box_buckshot"] = true,

    -- Combine Ball ammo for AR2 alt-fire
    ["item_ammo_ar2_altfire"] = true,
    ["item_ammo_ar2_large"] = true,
    ["item_rpg_round"] = true,

    --Half-Life 1
    ["hl1_ammo_357"] = true,
    ["hl1_ammo_9mmbox"] = true,
    ["hl1_ammo_9mmclip"] = true,
    ["hl1_ammo_9mmar"] = true,
    ["hl1_ammo_argrenades"] = true,
    ["hl1_ammo_buckshot"] = true,
    ["hl1_item_healthkit"] = true,
    ["hl1_ammo_rpgclip"] = true,
    ["hl1_item_battery"] = true,
    ["hl1_ammo_gaussclip"] = true,
    ["hl1_ammo_crossbow"] = true,

    
    
}

local replaceableEntitiesSB = {
     -- Half-Life 2 Weapons
    ["weapon_smg1"] = false,
    ["weapon_stunstick"] = false,
    ["weapon_slam"] = false,
    ["weapon_ar2"] = false,
    ["weapon_pistol"] = false,
    ["weapon_357"] = false,
    ["weapon_crossbow"] = false,
    ["weapon_frag"] = false,
    ["weapon_crowbar"] = false,
    ["weapon_rpg"] = false,
    ["weapon_shotgun"] = false,
    ["weapon_physcannon"] = false,
    ["weapon_bugbait"] = false,

    -- Half-Life 2 Ammo
    ["item_ammo_pistol"] = true,
    ["item_ammo_pistol_large"] = true,
    ["item_ammo_smg1"] = true,
    ["item_ammo_smg1_large"] = true,
    ["item_ammo_ar2"] = true,
    ["item_ammo_357"] = true,
    ["item_ammo_357_large"] = true,
    ["item_ammo_crossbow"] = true,
    ["item_ammo_ar2_altfire"] = true,
    ["item_ammo_smg1_grenade"] = true,
    ["item_box_buckshot"] = true,

    -- Combine Ball ammo for AR2 alt-fire
    ["item_ammo_ar2_altfire"] = true,
    ["item_ammo_ar2_large"] = true,
    ["item_rpg_round"] = true,

    --Half-Life 1
    ["hl1_ammo_357"] = true,
    ["hl1_ammo_9mmbox"] = true,
    ["hl1_ammo_9mmclip"] = true,
    ["hl1_ammo_9mmar"] = true,
    ["hl1_ammo_argrenades"] = true,
    ["hl1_ammo_buckshot"] = true,
    ["hl1_item_healthkit"] = true,
    ["hl1_ammo_rpgclip"] = true,
    ["hl1_item_battery"] = true,
    ["hl1_ammo_gaussclip"] = true,
    ["hl1_ammo_crossbow"] = true,
    
}


local wblCoolD = 0
local wblCoolD2 = 0


-- Adding Signals (START) --


util.AddNetworkString("wblResetAllConVarsToDefault")
util.AddNetworkString("wblSaveConVarsToFileMonsettings")
util.AddNetworkString("wblLoadConVarsFromFileMonsettings")
util.AddNetworkString("wblRefreshMonsettingsToS")
util.AddNetworkString("wblRefreshMonsettingsToC")
util.AddNetworkString("wblDeleteMonsettings")

util.AddNetworkString("wblReloadNPCListPresetToS")
util.AddNetworkString("wblReloadNPCListPresetToC")
util.AddNetworkString("wblPresetSaveNPClistToS")
util.AddNetworkString("wblPresetDeleteNPClistToS")

util.AddNetworkString("wblUpdatePresetOnlistToS1")
util.AddNetworkString("wblUpdatePresetOnlistToS2")
util.AddNetworkString("wblUpdatePresetOnlistToC")

util.AddNetworkString("wblweaponpricereqToS")
util.AddNetworkString("wblweaponpricereqToC")


util.AddNetworkString("wblDebugenabledToC")
util.AddNetworkString("wblDebugenabledToS")
util.AddNetworkString("plyMonzinitToS")
util.AddNetworkString("plyMonzResetToS")
util.AddNetworkString("plyMonzResetToC")
util.AddNetworkString("plyMonzcantResetToC")
util.AddNetworkString("plyMonzupdateToC")
util.AddNetworkString("plyMonzupdateToCLose")
util.AddNetworkString("plyNPCtable")
util.AddNetworkString("plyNPCtableremove")
util.AddNetworkString("plyNPCtableedit")
util.AddNetworkString("wblmoneyen")
util.AddNetworkString("clientnpclistreq")
util.AddNetworkString("clientnpclistok")
util.AddNetworkString("npclistpresetgive")
--util.AddNetworkString("wblmoneyresetnotif")
util.AddNetworkString("wblmoneyhudx")
util.AddNetworkString("wblmoneyhudy")
-- Adding Signals (END) --
util.AddNetworkString("wblreqAmmotypequick")
util.AddNetworkString("wblsendAmmotypequick")

util.AddNetworkString("wblmonhudenreq")

util.AddNetworkString("wblEnableShopbuy")
util.AddNetworkString("wblDisableShopbuy")

net.Receive("wblmonhudenreq", function(len, ply)
    local monenn = net.ReadInt(16)
    net.Start("wblmoneyen")
    net.WriteInt(monenn, 16)
    net.Send(ply)
end)

net.Receive("wblDebugenabledToS", function() 
    local Debug = tonumber(wblmonDebug:GetInt())
    net.WriteInt(Debug, 16)
    net.Broadcast()
end)

--Receive list of Static Money NPC
net.Receive("plyNPCtable", function() 
	npcstaticlist = net.ReadTable()
	wblDebug("I got the message")

    for k, v in ipairs(npcstaticlist) do
        wblDebug("*********************************")
        wblDebug(v[1])
        wblDebug(v[2])
        wblDebug(v[3])
        wblDebug("*********************************")
    end

end)

local npclistpreset = {}
net.Receive("npclistpresetgive", function() 
	
end)

--update list of npc value on client on startup
net.Receive("clientnpclistreq", function(len, ply) 
    if npclistpreset == nil then return end
	net.Start("clientnpclistok")
    net.WriteString(npclistpreset)
    net.Send(ply)
end)

net.Receive("plyNPCtableedit", function() 
	local npclinenumbertoedit = net.ReadInt(32)
	local npcnewmoney = net.ReadInt(32)
	npcstaticlist[npclinenumbertoedit][3] = npcnewmoney
	wblDebug("Server received edit request")
	wblDebug("Editted Line: "..npclinenumbertoedit)
	wblDebug("New Table: ")
	for k, v in ipairs(npcstaticlist) do
        wblDebug("*********************************")
        wblDebug(v[1])
        wblDebug(v[2])
        wblDebug(v[3])
        wblDebug("*********************************")
    end
end)

net.Receive("plyNPCtableremove", function() 
	local npcnumbertoremove = net.ReadInt(32)
	table.remove(npcstaticlist, npcnumbertoremove)
	wblDebug("Server received removal request")
	wblDebug("Removed Line: "..npcnumbertoremove)
	wblDebug("New Table: ")
	for k, v in ipairs(npcstaticlist) do
        wblDebug("*********************************")
        wblDebug(v[1])
        wblDebug(v[2])
        wblDebug(v[3])
        wblDebug("*********************************")
    end
end)


net.Receive("plyMonzResetToS", function(len, ply)  
		local moneystart = wblmonstart:GetInt()
        local maxmonz = wblmonstart:GetInt()
        local wblmoney = (ply:GetPData("wblmoney",-1))
        if tonumber(wblmoney) >= tonumber(maxmonz) then
		    ply:SetPData("wblmoney",moneystart)
            net.Start("plyMonzResetToC")
            net.Send(ply)
            local wblmoney = (ply:GetPData("wblmoney",-1))

            wblDebug("Your current money now is: "..wblmoney)
            local monen = wblmonhen:GetInt()
            if monen == 1 then

                net.Start("plyMonzupdateToC")
                net.WriteInt(wblmoney,32)
                net.Send(ply)
            end
        else
            net.Start("plyMonzcantResetToC")
            net.Send(ply)
            return
        end
        
end)

--[[
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\FUNCTIONS\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
]]


local defaultConVars = {
    ["wblmoney_Debug"] = "1",
    ["wblmoney_campaignmode_Disablepickup"] = "0",
    ["wblmoney_campaignmode_Disablepickupsameslotid"] = "0",
    ["wblmoney_campaignmode_singleplayer"] = "0",
    ["wblmoney_campaignmode_preventsoftlock"] = "1",
    ["wblmoney_campaignmode_replaceammoentities"] = "0",
    ["wblmoney_campaignmode_replacewallchargers"] = "0",
    ["wblmoney_campaignmode_delayedwstar"] = "0",
    ["wblmoney_money_start"] = "500",
    ["wblmoney_money_max"] = "16000",
    ["wblmoney_dynamicmoney_multplier"] = "1",
    ["wblmoney_dynamicmoney_offset"] = "0",
    ["wblmoney_dynamicmoney_fallback"] = "50",
    ["wblmoney_dynamicmoney_enable"] = "1",
    ["wblmoney_moneyloss_enabled"] = "1",
    ["wblmoney_moneyloss_method"] = "2",
    ["wblmoney_moneyloss_fixed_amount"] = "50",
    ["wblmoney_moneyloss_percent_amount"] = "10",
    ["wblmoney_money_coop"] = "0",
    ["wblmoney_money_plyvalue"] = "300",
    ["wblmoney_money_entvalue"] = "50",
    ["wblmoney_Nomoneyonally"] = "0"
}

--Save Convar Values in a file
local convarList = {

    "wblmoney_Debug",
    "wblmoney_campaignmode_Disablepickup",
    "wblmoney_campaignmode_Disablepickupsameslotid",
    "wblmoney_campaignmode_singleplayer",
    "wblmoney_campaignmode_replaceammoentities",
    "wblmoney_campaignmode_preventsoftlock",
    "wblmoney_campaignmode_replacewallchargers",
    "wblmoney_campaignmode_delayedwstar",
    "wblmoney_money_start",            -- Starting money for new players or when money is reset.
    "wblmoney_money_max",              -- Maximum amount of money a player can have.
    "wblmoney_dynamicmoney_multplier", -- Multiplier for dynamic money.
    "wblmoney_dynamicmoney_offset",    -- Offset for dynamic money.
    "wblmoney_dynamicmoney_fallback",  -- Fallback amount for dynamic money.
    "wblmoney_dynamicmoney_enable",    -- Enables dynamic money.
    "wblmoney_moneyloss_enabled",      -- Enables money loss.
    "wblmoney_moneyloss_method",       -- Method of money loss (fixed or percentage).
    "wblmoney_moneyloss_fixed_amount", -- Fixed amount of money lost.
    "wblmoney_moneyloss_percent_amount",-- Percentage of money lost.
    "wblmoney_money_coop",             -- Enables money division among players.
    "wblmoney_money_plyvalue",         -- Money value of a player.
    "wblmoney_money_entvalue",         -- Money value of a money entity.
    "wblmoney_Nomoneyonally"           -- Disables money gain for friendly NPCs (who like the player).
}



---------------------TRANSFER FROM CLIENT START-------------------------------
--Function to load the convars and execute it
local convarpresetlist = {}

local function LoadConVarsFromFileMonsettings(fileName)
    local dirPath = "weshop/Monsettings"
    local filePath = dirPath .. "/".. fileName ..".txt"

    -- Check if the file exists
    if not file.Exists(filePath, "DATA") then
        notification.AddLegacy("Preset file not found!", NOTIFY_ERROR, 3)
        surface.PlaySound("buttons/button10.wav")
        return
    end

    -- Read the JSON data from the file
    local jsonData = file.Read(filePath, "DATA")

    -- Convert the JSON data back into a Lua table
    local convarValues = util.JSONToTable(jsonData)

    -- Iterate through the table and apply the ConVars
    for convarName, convarValue in pairs(convarValues) do
        -- Apply the saved value to the corresponding ConVar
        RunConsoleCommand(convarName, convarValue)
    end

    -- Notify the user
end

local function DeleteSetPreset(value)
    if #convarpresetlist == 0 then return end
    for i, v in ipairs(convarpresetlist) do
        if v == value then
            table.remove(convarpresetlist, i)
            local filePath = "weshop/monsettings/" .. value .. ".txt"
            if file.Exists(filePath, "DATA") then
                file.Delete(filePath)
                wblDebug("Preset deleted successfully.")
            else
                wblDebug("Preset not found.")
            end 
            return true -- Return true if the value was found and removed
        end
    end
    return false -- Return false if the value was not found
end

function ReloadSetPreset()
    local files, directories = file.Find("weshop/monsettings/*.txt", "DATA")
        wblDebug("Preset Reload function executed..")
    convarpresetlist = {}
    for _, fileName in ipairs(files) do
        local nameWithoutExtension = fileName:gsub("%.txt$", "")
        table.insert(convarpresetlist, nameWithoutExtension)
    end
    return convarpresetlist
end

local function SaveConVarsToFileMonsettings(fileName)
    local dirPath = "weshop/Monsettings"
    local filePath = dirPath .. "/".. fileName ..".txt"

    -- Check if the directory exists, create it if it doesn't
    if not file.IsDir(dirPath, "DATA") then
        file.CreateDir(dirPath)
    end

    -- Create a table to store the ConVar values
    local convarValues = {}

    -- Iterate through the list of ConVars and get their values
    for _, convarName in ipairs(convarList) do
        local convarValue = GetConVar(convarName):GetString()
        convarValues[convarName] = convarValue
    end

    -- Convert the table to JSON for easy storage
    local jsonData = util.TableToJSON(convarValues, true)

    -- Write the JSON data to the file
    file.Write(filePath, jsonData)

end



local function ResetAllConVarsToDefault()
    for convarName, defaultValue in pairs(defaultConVars) do
        RunConsoleCommand(convarName, defaultValue)
    end
end

function removeEntryByValue(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then
            table.remove(tbl, i)
            return true -- Return true if the value was found and removed
        end
    end
    return false -- Return false if the value was not found
end



net.Receive("wblResetAllConVarsToDefault", function(len, ply) 
    ResetAllConVarsToDefault()
end)

net.Receive("wblLoadConVarsFromFileMonsettings", function(len, ply) 
    local loadfile = net.ReadString()
    LoadConVarsFromFileMonsettings(loadfile)
end)

net.Receive("wblSaveConVarsToFileMonsettings", function(len, ply) 
    local savefile = net.ReadString()
    local inttype = net.ReadInt(16)
    SaveConVarsToFileMonsettings(savefile)
    local Presetlisttosend = ReloadSetPreset()
    net.Start("wblRefreshMonsettingsToC")
    net.WriteTable(Presetlisttosend)
    net.WriteInt(inttype,16)
    net.WriteString(savefile)
    net.Send(ply) 
end)

net.Receive("wblRefreshMonsettingsToS", function(len, ply) 
    local Presetlisttosend = ReloadSetPreset()
    net.Start("wblRefreshMonsettingsToC")
    net.WriteTable(Presetlisttosend)
    net.WriteInt(0,16)
    net.WriteString("")
    net.Send(ply) 
end)

net.Receive("wblDeleteMonsettings", function(len, ply) 
    local deletefile = net.ReadString()
    DeleteSetPreset(deletefile)
    local Presetlisttosend = ReloadSetPreset()
    net.Start("wblRefreshMonsettingsToC")
    net.WriteTable(Presetlisttosend)
    net.WriteInt(0,16)
    net.WriteString("")
    net.Send(ply) 
end)


local function WriteStringToFile(fileName, content)
    local dirPath = "weshop"
    local filePath = dirPath .. "/" .. fileName .. ".txt"

    -- Check if the directory exists; create it if it doesn't
    if not file.IsDir(dirPath, "DATA") then
        file.CreateDir(dirPath)
    end

    -- Write the string to the file
    file.Write(filePath, content)

    -- Optionally, print a confirmation message
    wblDebug("String written to " .. filePath)
end

local function ReadStringFromFile(fileName)
    local dirPath = "weshop"
    local filePath = dirPath .. "/" .. fileName .. ".txt"

    -- Check if the file exists
    if file.Exists(filePath, "DATA") then
        -- Read the content of the file
        local content = file.Read(filePath, "DATA")
        return content
    else
        -- File does not exist, return an error message or nil
        wblDebug("File not found: " .. filePath)
        return nil
    end
end

local npclistoftheprest = {}
local npclistpresetremember = ""

net.Receive("wblUpdatePresetOnlistToS1", function(len, ply) 
    wblDebug("wblUpdatePresetOnlistToS1 received")
    local value = net.ReadString()
    wblDebug("Value is: "..value)
    if tostring(value) == "" or value == nil then
        wblDebug("value is blank or nil")
        value = ReadStringFromFile("Remnpclistpreset")
        if value == nil or tostring(value) == "" then
            value = "Default"
        end
    else
        npclistpresetremember = tostring(value)
    end
    local dataTable1 = {}
    local dataTable2 = {}
    if value ~= "Default" then
        local dirPath1 = "weshop/npclistpreset"
        local filePath1 = dirPath1 .. "/" .. value .. ".txt"

        local jsonData1 = file.Read(filePath1, "DATA")
        dataTable1 = util.JSONToTable(jsonData1)

        local dirPath2 = "Weshop/npclistpresetvalue"
        local filePath2 = dirPath2 .. "/" .. value .. ".txt"
        local jsonData2 = file.Read(filePath2, "DATA")
            
        dataTable2 = util.JSONToTable(jsonData2)

    else
        dataTable1 = {}
        dataTable2 = {}
    end
    net.Start("wblUpdatePresetOnlistToC")
    net.WriteTable(dataTable1)
    net.WriteTable(dataTable2)
    net.Send(ply) 
end)

net.Receive("wblPresetDeleteNPClistToS", function(len, ply) 
    wblDebug("wblPresetDeleteNPClistToS received")
    local value = net.ReadString()
    local filePath = "weshop/npclistpreset/" .. value .. ".txt"
    if file.Exists(filePath, "DATA") then
        file.Delete(filePath)
        wblDebug("Preset deleted successfully.")
    else
        wblDebug("Preset not found.")
    end 

    local filePath = "weshop/npclistpresetvalue/" .. value .. ".txt"
    if file.Exists(filePath, "DATA") then
        file.Delete(filePath)
        wblDebug("Preset deleted successfully.")
    else
        wblDebug("Preset not found.")
    end
end)

net.Receive("wblPresetSaveNPClistToS", function(len, ply) 
    wblDebug("wblPresetSaveNPClistToS received")
    local presettabletosave = net.ReadTable()
    local presettabletosave3 = net.ReadTable()
    local name = net.ReadString()

    wblDebug("Preset Save function executed..")
    local dirPath = "Weshop/npclistpreset"
    local filePath = dirPath .. "/"..name..".txt"

    if not file.IsDir(dirPath, "DATA") then
        file.CreateDir(dirPath)
    end
    local jsonData = util.TableToJSON(presettabletosave, true) -- `true` adds formatting (optional)
    file.Write(filePath, jsonData)



    local dirPath = "Weshop/npclistpresetvalue"
    local filePath = dirPath .. "/"..name..".txt"
    if not file.IsDir(dirPath, "DATA") then
        file.CreateDir(dirPath)
    end
    local jsonData = util.TableToJSON(presettabletosave3, true) -- `true` adds formatting (optional)
    file.Write(filePath, jsonData)
end)


net.Receive("wblReloadNPCListPresetToS", function(len, ply)
    wblDebug("wblReloadNPCListPresetToS received") 
    local presetnamee = net.ReadString()
    local files, directories = file.Find("weshop/npclistpreset/*.txt", "DATA")
    wblDebug("Preset Reload function executed..")
    npclistoftheprest = {}
    for _, fileName in ipairs(files) do
        local nameWithoutExtension = fileName:gsub("%.txt$", "")
        table.insert(npclistoftheprest, nameWithoutExtension)
    end
    net.Start("wblReloadNPCListPresetToC")
    net.WriteTable(npclistoftheprest)
    net.WriteString(presetnamee)
    net.Send(ply) 
end)




---------------------TRANSFER FROM CLIENT END-------------------------------

local function SaveConVarsToFile(fileName)
    local dirPath = "weshop"
    local filePath = dirPath .. "/".. fileName ..".txt"

    -- Check if the directory exists, create it if it doesn't
    if not file.IsDir(dirPath, "DATA") then
        file.CreateDir(dirPath)
    end

    -- Create a table to store the ConVar values
    local convarValues = {}

    -- Iterate through the list of ConVars and get their values
    for _, convarName in ipairs(convarList) do
        local convarValue = GetConVar(convarName):GetString()
        convarValues[convarName] = convarValue
    end

    -- Convert the table to JSON for easy storage
    local jsonData = util.TableToJSON(convarValues, true)

    -- Write the JSON data to the file
    file.Write(filePath, jsonData)

end

--Function to load the convars and execute it
local function LoadConVarsFromFile(fileName)
    local dirPath = "weshop"
    local filePath = dirPath .. "/".. fileName ..".txt"

    -- Check if the file exists
    if not file.Exists(filePath, "DATA") then
        
        return
    end

    -- Read the JSON data from the file
    local jsonData = file.Read(filePath, "DATA")

    -- Convert the JSON data back into a Lua table
    local convarValues = util.JSONToTable(jsonData)

    -- Iterate through the table and apply the ConVars
    for convarName, convarValue in pairs(convarValues) do
        -- Apply the saved value to the corresponding ConVar
        RunConsoleCommand(convarName, convarValue)
    end

    -- Notify the user
end

local function SaveTableToFile(fileName, tableToSave)
    if tableToSave == nil then return end
    -- Define the directory and file path
    local dirPath = "weshop"
    local filePath = dirPath .. "/" .. fileName .. ".txt"

    -- Convert the table to JSON
    local jsonData = util.TableToJSON(tableToSave, true)  -- `true` for pretty-printing

    -- Check if the directory exists, create it if it doesn't
    if not file.IsDir(dirPath, "DATA") then
        file.CreateDir(dirPath)
    end

    -- Write the JSON data to the file
    file.Write(filePath, jsonData)

    wblDebug("Table saved successfully to " .. filePath)
end

local function LoadTableFromFile(fileName)
    -- Define the directory and file path
    local dirPath = "weshop"
    local filePath = dirPath .. "/" .. fileName .. ".txt"

    -- Check if the file exists
    if file.Exists(filePath, "DATA") then
        -- Read the JSON data from the file
        local jsonData = file.Read(filePath, "DATA")

        -- Convert the JSON data back to a Lua table
        local loadedTable = util.JSONToTable(jsonData)

        wblDebug("Table loaded successfully from " .. filePath)
        return loadedTable
    else
        wblDebug("File does not exist: " .. filePath)
        return nil
    end
end



function wblfnlmoney_modmatcompare(k,v,npcclass,npcmodel,npcmaterial)
		wblDebug("************** LOOP# "..k.." START **************")
			local npcclassserver = npcclass
			wblDebug("Grabbing NPC class from server side: "..tostring(npcclassserver))
			local npcclassclient = v[1]
			wblDebug("Grabbing NPC class from client side: "..tostring(npcclassclient))

		    local npcmodelserver = npcmodel
			wblDebug("Grabbing NPC model from server side: "..tostring(npcmodelserver))
			wblDebug("v[2]: "..tostring(v[2]))
			local npcmodmatclient = v[2]
			wblDebug("Grabbing NPC model from client side: "..tostring(npcmodmatclient))

			local npcmaterialserver = npcmaterial
			wblDebug("Grabbing NPC material from server side: "..tostring(npcmaterialserver))

		    wblDebug("************** LOOP# "..k.." END **************")

		    wblDebug("npcclassserver: "..tostring(npcclassserver))
		    wblDebug("npcclassclient: "..tostring(npcclassclient))
		    wblDebug("npcmodelserver: "..tostring(npcmodelserver))
		    wblDebug("npcmodmatclient: "..tostring(npcmodmatclient))
		    wblDebug("npcmaterialserver: "..tostring(npcmaterialserver))
		    wblDebug(npcclassserver == npcclassclient)
		    wblDebug(((npcmodmatclient == npcmaterialserver) or (npcmodmatclient == npcmodelserver)))
		    wblDebug(npcmodmatclient ~=nil)

		    if npcclassserver == npcclassclient and ((npcmodmatclient == npcmaterialserver) or (npcmodmatclient == npcmodelserver)) and (npcmodmatclient ~=nil) then
		    wblDebug("^^^^^^^^^^^^MODEL/MATERIAL MATCHED (NOT NIL)^^^^^^^^^^^^")
		    return false, v[3]
			    else if (npcclassserver == npcclassclient) and (npcmodmatclient == nil) then
			        	wblDebug("^^^^^^^^^^^^CLASS MATCHED (NIL MATERIAL/MODEL)^^^^^^^^^^^^")
			        	return false, v[3]
			    else
			        	wblDebug("^^^^^^^^^^^^ NO CLASSES/MODEL/MATERIAL MATCHED ^^^^^^^^^^^^")
			        	return true
			     end

		    end

end

--function to evaluate finalmoney through checking offsets, multpliers or if statically have money value on npc list(used by wblgivemoneydynamichealth function)
function wblfnlmoney(addvalue,npcc)
	wblDebug("&&&&&&&&&& wblfnlmoney FUNCTION INITIATED &&&&&&&&&")
		wblDebug(npcstaticlist)
        if npcstaticlist == nil then
            npcstaticlist = {}
        end
		--Gethring the data from the table list(client) and the npc spawned in the world(server) for comparison
		if not npcc:IsValid() then return 0 end
        local npcclass = tostring(npcc:GetClass())
		wblDebug("NPC Class from server: "..npcclass)
        if npcclass == "npc_bullseye" then return 50 end
		local npcmodel = tostring(npcc:GetModel())
		wblDebug("NPC Model from server: "..npcmodel)
		local npcmaterial = tostring(npcc:GetMaterial())
		wblDebug("NPC Material from server: "..npcmaterial)
		local donecompare = true
		local manny = 0

		--will start to iterate through the client's custom table, going through npcs that have model and material data.
		for k, v in ipairs(npcstaticlist) do
			if v[2] ~= nil and donecompare then
				wblDebug("v2 is not nil")
				donecompare, manny = wblfnlmoney_modmatcompare(k,v,npcclass,npcmodel,npcmaterial)
			end
	    end

	    --will start to iterate through the client's custom table, going through npcs that have model and material data as nil.
	    --"donecompare" will tell if we should keep iterating or keep going
	    if donecompare then
		    for k, v in ipairs(npcstaticlist) do
				if v[2] == nil and npcmaterial == "" and donecompare then
					wblDebug("v2 is nil")
					donecompare, manny = wblfnlmoney_modmatcompare(k,v,npcclass,npcmodel,npcmaterial)
				end
		    end
		else
			wblDebug("Executed comparing already, wont run loop again")
		end

		--Final interpretation, if money is on list itll give the custom money, if not itll be dynamic money/default money
		wblDebug("donecompare: "..tostring(donecompare))
		if not donecompare then
			wblDebug("Static Money Successful")
			wblDebug("Money Value override to be given now: "..tostring(manny))
			local fnlmoney = manny
			return fnlmoney
		else
			wblDebug("No Static Money, using Dyanmic Money")
			local dynmoneyen = wblmondynen:GetInt()
		    if dynmoneyen == 1 then
				local moneymult = wblmonhmul:GetFloat()
				wblDebug("Money Multiplier: "..moneymult)
				local moneyoffset = wblmonhoffset:GetFloat()
				local fnlmoney = (addvalue*moneymult) + moneyoffset
                wblDebug("fnlmoney: "..fnlmoney)
				return fnlmoney
			else
				wblDebug("////////////////////////////////")
				wblDebug("Dynamic Money disabled. Using Fallback Money")
				wblDebug("////////////////////////////////")
				fnlmoney = wblmonhfb:GetInt()
				return fnlmoney
		    end
		end


		wblDebug("&&&&&&&&&& wblfnlmoney FUNCTION ENDED &&&&&&&&&")
		
		
end

local chargerReplaceThink = true
local AmmoReplaceThink = true

local function replaceAmmo()
    local Softlocken = tonumber(wblmonreplaceammoentitiesantisoftlock:GetInt())
    if Softlocken == 1 then 
        for _, ent in pairs(ents.GetAll()) do
            if IsValid(ent) and replaceableEntities[ent:GetClass()] then
                local pos = ent:GetPos()
                local ang = ent:GetAngles()
                ent:Remove()

                local moneyBundle = ents.Create("weshopmoney")
                if IsValid(moneyBundle) then
                    moneyBundle:SetPos(pos)
                    moneyBundle:SetAngles(ang)
                    moneyBundle:Spawn()
                end
            end
        end
    else
        for _, ent in pairs(ents.GetAll()) do
            if IsValid(ent) and replaceableEntitiesSB[ent:GetClass()] then
                local pos = ent:GetPos()
                local ang = ent:GetAngles()
                ent:Remove()

                local moneyBundle = ents.Create("weshopmoney")
                if IsValid(moneyBundle) then
                    moneyBundle:SetPos(pos)
                    moneyBundle:SetAngles(ang)
                    moneyBundle:Spawn()
                end
            end
        end
    end
end

local function replaceExistingChargers()
    local ReplaceCharger = tonumber(wblmonreplacewallchargers:GetInt())
    wblDebug("Replace Charger has been")
    if ReplaceCharger == 1 then
        for _, ent in pairs(ents.GetAll()) do
            if IsValid(ent) and (ent:GetClass() == "item_healthcharger" or ent:GetClass() == "item_suitcharger") then
                local pos = ent:GetPos()
                local ang = ent:GetAngles()
                ent:Remove()
                
                local shopOnWall = ents.Create("weshoponwall")
                if IsValid(shopOnWall) then
                    shopOnWall:SetPos(pos)
                    shopOnWall:SetAngles(ang)
                    shopOnWall:Spawn()
                end
            end
        end
        for _, ent in pairs(ents.GetAll()) do
            if IsValid(ent) and (ent:GetClass() == "item_ammo_crate") then
                local pos = ent:GetPos()
                local ang = ent:GetAngles()
                ent:Remove()
                
                local shopOnWall = ents.Create("weshop")
                if IsValid(shopOnWall) then
                    shopOnWall:SetPos(pos)
                    shopOnWall:SetAngles(ang)
                    shopOnWall:Spawn()
                end
            end
        end
    end
end

--Check if killed npc is ally or not (used by wblgivemoneydynamichealth function)
function npcDispositionCheck(plykiller,npc)
		if IsValid(npc) and npc:IsNPC() then
		    local npcRel = npc:Disposition(plykiller)
		    if disposition ~= nil then
		        wblDebug("Disposition of NPC: " .. tostring(disposition))
		    else
		        wblDebug("Disposition method returned nil, setting NPC Disposition to Neutral")
		        local npcRel = 4
		    end
		    return npcRel
		else
		    wblDebug("Invalid NPC Disposition, setting NPC Disposition to Neutral")
		    local npcRel = 4
		    return npcRel
		end
end



--GIVE MONEY NORMALLY (START) --
function wblgivemoneydynamichealth(plykiller,addvalue,npc) 
	local mongen = wblmonhen:GetInt()
	if mongen == 1 then
		wblDebug("&&&&&&&&&& wblgivemoneydynamichealth FUNCTION INITIATED &&&&&&&&&")
		local npcRel = npcDispositionCheck(plykiller,npc)
		
		--function to get final money
		local mnygiven = wblfnlmoney(addvalue,npc)
		--Save line executions if its zero in the first place
		if mnygiven == 0 then return end
		local Nomoneyonally = wblmonhallmon:GetInt()
		--check if you should get money on allies
		--local dynmoneyen = wblmondynen:GetInt()
		--if dynmoneyen == 1 then

		
			if npcRel == 3 and Nomoneyonally == 1 then
				wblDebug("////////////////////////////////")
				wblDebug("NPC Relationship to killer: "..npcRel)
				wblDebug("No money on Ally option is ON")
				wblDebug("NPC that died is an ally")
				wblDebug("Ignoring...")
				wblDebug("////////////////////////////////")
			else
				wblDebug("////////////////////////////////")
				local plycoop = tonumber(wblmonplycoop:GetInt())
				if plycoop == 0 then
					--function to give money to single player
					local wblmoney = (plykiller:GetPData("wblmoney",-1))
					wblmoney = wblmoney + mnygiven
					wblmoney = math.ceil( wblmoney )
					local maxmonz = tonumber(wblmonmax:GetInt())
					if wblmoney < 0 then
						plykiller:SetPData( "wblmoney", 0 ) 
						wblmoney = 0
					elseif wblmoney > maxmonz then
						plykiller:SetPData( "wblmoney", maxmonz )
						wblmoney = maxmonz
					else
						plykiller:SetPData( "wblmoney", wblmoney ) 
					end
					wblDebug("Money given: "..mnygiven)
					wblDebug("Money of: "..tostring(plykiller)..": "..tostring(wblmoney))
					wblDebug("NPC Relationship to killer: "..npcRel)
					wblDebug("////////////////////////////////")
					wblDebug("mnygiven"..mnygiven)
					wblDebug("wblmoney"..wblmoney)
					wblDebug("Maxmonz"..maxmonz)
					if (mnygiven > 0) and (wblmoney <= maxmonz) then
						wblDebug("Executed 1")
						net.Start("plyMonzupdateToC")
						net.WriteInt(wblmoney, 32)
						net.WriteInt(mnygiven, 32)
						net.Send(plykiller)	--plykiller
					elseif mnygiven < 0 then
						wblDebug("Executed 2")
						mnygiven = (mnygiven)*(-1)
						net.Start("plyMonzupdateToCLose")
						net.WriteInt(wblmoney, 32)
						net.WriteInt(mnygiven, 32)
						net.Send(plykiller)	
					end
				else
					--function to give divided money to all players
					local humanCount = 0
					for _, ply in pairs(player.GetAll()) do
					    if not ply:IsBot() then
					        humanCount = humanCount + 1
					    end
					end
					for k, v in pairs(player.GetAll()) do

					    local wblmoney = (v:GetPData("wblmoney",-1))
					    local divmnygiven = math.ceil(mnygiven/humanCount)
						wblmoney = wblmoney + divmnygiven
						wblmoney = math.ceil( wblmoney )
						local maxmonz = wblmonmax:GetInt()
						if wblmoney < 0 then
							v:SetPData( "wblmoney", 0 ) 
							wblmoney = 0
						elseif wblmoney > maxmonz then
							v:SetPData( "wblmoney", maxmonz )
							wblmoney = maxmonz
						else
							v:SetPData( "wblmoney", wblmoney ) 
						end
						wblDebug("Money given: "..divmnygiven)
						wblDebug("Money of: "..tostring(v)..": "..tostring(wblmoney))
						wblDebug("NPC Relationship to killer: "..npcRel)
						wblDebug("////////////////////////////////")
						if (divmnygiven > 0) and (wblmoney <= maxmonz) then
							net.Start("plyMonzupdateToC")
							net.WriteInt(wblmoney, 32)
							net.WriteInt(divmnygiven, 32)
							net.Send(v)	--plykiller
						elseif divmnygiven < 0 then
							divmnygiven = (divmnygiven)*(-1)
							net.Start("plyMonzupdateToCLose")
							net.WriteInt(wblmoney, 32)
							net.WriteInt(divmnygiven, 32)
							net.Send(v)	
						end
					end
				end
			end
	
	wblDebug("&&&&&&&&&& wblgivemoneydynamichealth FUNCTION ENDED &&&&&&&&&")
	else
		return
		wblDebug("Money disbled. Ignoring function..")
	end



end

-- GIVE MONEY NORMALLY (END) --

--function to enable money hud to all players
function MoneyHuden()
	local ply = player.GetAll() -- Get all players put on a table
	for k, v in pairs(ply) do   -- Loop through the table which contains players, executes per player
		wblDebug(v:GetPData("wblmoney",-1))   --
		local wblmoney = (v:GetPData("wblmoney",-1)) --Get player money
		--if wblmoney == -1 then -- if no money yet, set it to initial money
		--	print("No money yet, initializing") --TEMPORARY COMMENTS TO RESET

		wblDebug("Your current money now is: "..wblmoney)
		--Send a go signal to Client that the hud should be updated
		net.Start("plyMonzupdateToC")
		net.WriteInt(wblmoney,32)
		net.WriteInt(0,32)
		net.Send(v)
	end
end


cvars.AddChangeCallback("wblmoney_campaignmode_singleplayer", function(convar_name, old_value, new_value)
    if tonumber(new_value) == 1 then
        local players = player.GetAll() -- Get a list of all players
        if #players == 1 then
            local plyy
            if #players > 0 then
                plyy = players[1]
                local wblmoney = tonumber(plyy:GetPData("wblmoney",-1))
                WriteStringToFile("SinglePlayerMoney", wblmoney)
                wblDebug("Wrote: "..wblmoney.." at SinglePlayerMoney")
            end
        end
    end
end)

local function HandleWBLBuy(c)
    wblDebug("HandleWBLBuy executed")
    c.isinshop = true
    wblDebug(c.canbuy)
    if c.canbuy == nil then
        local monen = wblmonhen:GetInt()
        local monanystart = wblmonbuyanywhere:GetInt()
        wblDebug("monen: "..monen)
        wblDebug("wblmonbuyanywhere: "..monanystart)
        if (tonumber(monanystart) == 1) then
            c.canbuy = true
        end
    end
    wblDebug(c.canbuy)
    if c.canbuy and (IsValid(c) and c:Health() > 0) then
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
    end
end

concommand.Add("wblbuy", function(ply, cmd, args, str)
    HandleWBLBuy(ply)
    wblDebug("wblbuy chat has been executed")
end)

local function RestrictPlayerAmmoToMax(ply, wblammolist)
    for _, ammo in ipairs(wblammolist) do
        if ammo.class and ply:GetAmmoCount(ammo.class) ~= nil then  -- Check if ammo class is valid and not nil
            local currentAmmo = ply:GetAmmoCount(ammo.class)
            if currentAmmo > ammo.maxquantity then
                ply:SetAmmo(ammo.maxquantity, ammo.class)
            end
        end
    end
end



--[[
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\HOOKS\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
]]

local restrictedItems = {
     -- Half-Life 2 Weapons
    ["weapon_smg1"] = true,
    ["weapon_stunstick"] = true,
    ["weapon_slam"] = false,
    ["weapon_ar2"] = true,
    ["weapon_pistol"] = true,
    ["weapon_357"] = true,
    ["weapon_crossbow"] = true,
    ["weapon_frag"] = false,
    ["weapon_crowbar"] = false,
    ["weapon_rpg"] = false,
    ["weapon_shotgun"] = true,
    ["weapon_physcannon"] = false,
    ["weapon_bugbait"] = false,

    -- Half-Life 2 Ammo
    ["item_ammo_pistol"] = true,
    ["item_ammo_pistol_large"] = true,
    ["item_ammo_smg1"] = true,
    ["item_ammo_smg1_large"] = true,
    ["item_ammo_ar2"] = true,
    ["item_ammo_357"] = true,
    ["item_ammo_357_large"] = true,
    ["item_ammo_crossbow"] = true,
    ["item_ammo_ar2_altfire"] = true,
    ["item_ammo_smg1_grenade"] = true,
    ["item_box_buckshot"] = true,

    -- Combine Ball ammo for AR2 alt-fire
    ["item_ammo_ar2_altfire"] = true,
    ["item_ammo_ar2_large"] = true, 
    ["item_rpg_round"] = true,

    -- Half-Life 1
    ["weapon_hl1_357"] = true,
    ["weapon_hl1_crossbow"] = true,
    ["weapon_hl1_crowbar"] = true,
    ["weapon_hl1_glock"] = true,
    ["weapon_hl1_egon"] = true,
    ["weapon_hl1_handgrenade"] = true,
    ["weapon_hl1_mp5"] = true,
    ["weapon_hl1_rpg"] = true,
    ["weapon_hl1_satchel"] = true,
    ["weapon_hl1_shotgun"] = true,
    ["weapon_hl1_snark"] = true,
    ["weapon_hl1_tripmine"] = true,
    ["weapon_hl1_gauss"] = true,
    ["weapon_hl1_hornetgun"] = true,


    
}

local restrictedItemsSB = {
     -- Half-Life 2 Weapons
    ["weapon_smg1"] = true,
    ["weapon_stunstick"] = true,
    ["weapon_slam"] = false,
    ["weapon_ar2"] = true,
    ["weapon_pistol"] = true,
    ["weapon_357"] = true,
    ["weapon_crossbow"] = true,
    ["weapon_frag"] = true,
    ["weapon_crowbar"] = true,
    ["weapon_rpg"] = true,
    ["weapon_shotgun"] = true,
    ["weapon_physcannon"] = true,
    ["weapon_bugbait"] = true,

    -- Half-Life 2 Ammo
    ["item_ammo_pistol"] = true,
    ["item_ammo_pistol_large"] = true,
    ["item_ammo_smg1"] = true,
    ["item_ammo_smg1_large"] = true,
    ["item_ammo_ar2"] = true,
    ["item_ammo_357"] = true,
    ["item_ammo_357_large"] = true,
    ["item_ammo_crossbow"] = true,
    ["item_ammo_ar2_altfire"] = true,
    ["item_ammo_smg1_grenade"] = true,
    ["item_box_buckshot"] = true,

    -- Combine Ball ammo for AR2 alt-fire
    ["item_ammo_ar2_altfire"] = true,
    ["item_ammo_ar2_large"] = true,
    ["item_rpg_round"] = true,
    
    -- Half-Life 1
    ["weapon_hl1_357"] = true,
    ["weapon_hl1_crossbow"] = true,
    ["weapon_hl1_crowbar"] = true,
    ["weapon_hl1_glock"] = true,
    ["weapon_hl1_egon"] = true,
    ["weapon_hl1_handgrenade"] = true,
    ["weapon_hl1_mp5"] = true,
    ["weapon_hl1_rpg"] = true,
    ["weapon_hl1_satchel"] = true,
    ["weapon_hl1_shotgun"] = true,
    ["weapon_hl1_snark"] = true,
    ["weapon_hl1_tripmine"] = true,
    ["weapon_hl1_gauss"] = true,
    ["weapon_hl1_hornetgun"] = true,

}


hook.Add("PlayerSwitchWeapon", "RestrictPlayerAmmoOnSwitch", function(ply, oldWeapon, newWeapon)
    wblDebug("Player Switched weapon")
    RestrictPlayerAmmoToMax(ply, wblammolist)
end)

-- Function to prevent pickup of restricted items
hook.Add("PlayerCanPickupWeapon", "PreventPickupOfRestrictedItems", function(ply, wep)
    -- Check if the weapon is in the restricted list
    if not ply.justspawn then
        local Disablepickup = tonumber(wblmonNopickup:GetInt())
        if Disablepickup == 1 then
            if ( ply:HasWeapon( wep:GetClass() ) ) then
                wblDebug("Same class detected, not allowing pickup")
                return false
            end
            wblDebug("Weapon class check passed, proceeding..")
            if not wblBuying then
                wblDebug("player not buying, proceeding..")
                if not ply.isinshop then
                    wblDebug("player not in shop, proceeding..")
                    local Softlocken = tonumber(wblmonreplaceammoentitiesantisoftlock:GetInt())
                        if Softlocken == 1 then
                            if restrictedItems[wep:GetClass()] then
                                -- Return false to prevent pickup
                                wblDebug("Weapon on list, not allowing")
                                return false
                            end
                        else
                            if restrictedItemsSB[wep:GetClass()] then
                                -- Return false to prevent pickup
                                wblDebug("Weapon on list, not allowing")
                                return false
                            end
                        end
                end
                local newWeaponClass = wep:GetClass()
                local currentWeapon = ply:GetActiveWeapon()
                timer.Simple(0, function()
                    if IsValid(wep) then
                        local Softlocken = tonumber(wblmonreplaceammoentitiesantisoftlock:GetInt())
                        if Softlocken == 1 then
                            if restrictedItems[wep:GetClass()] then
                                wep:Remove()
                                ply:SelectWeapon(currentWeapon)
                            end
                            net.Start("wblplydiedinstore")
                            net.Send(ply)
                            return false
                        else
                            if restrictedItemsSB[wep:GetClass()] then
                                wep:Remove()
                                ply:SelectWeapon(currentWeapon)
                            end
                            net.Start("wblplydiedinstore")
                            net.Send(ply)
                            return false
                        end
                    end
                    -- If the player had an active weapon before, give it back
                end)
            end
        end
    end

    local Disablepickupslotid = tonumber(wblmonNopickupslotid:GetInt())
    if Disablepickupslotid == 1 then
        wblDebug("Disablepickupslotid ran..")
        if ( ply:HasWeapon( wep:GetClass() ) ) then
            wblDebug("Same class detected, not allowing pickup")
            return false
        end
        local newWeaponClass = wep:GetClass()
        local foundWeapongnd = FindWeaponByClass(newWeaponClass)
        if foundWeapongnd == nil then
            wblDebug("Weapon on Ground is not on list, allowing pickup")
            return true
        else
            wblDebug("Weapon on Ground is in list, proceeding with further checks..")
        end
        local weapons = ply:GetWeapons() -- Get all weapons the player currently has
        for _, weapon in pairs(weapons) do
            local weapclass = weapon:GetClass()
            wblDebug("Player has: " .. weapclass) -- Print the class name of each weapon
            local foundWeaponply = FindWeaponByClass(weapclass)
            if foundWeaponply == nil then
            else
                if (foundWeapongnd.slotid == foundWeaponply.slotid) and (foundWeapongnd.class ~= foundWeaponply.class) then
                    wblDebug("Weapon "..foundWeapongnd.name.." has same slotid as "..foundWeaponply.name..", not allowing the pickup")
                    return false
                end
            end
        end
        wblDebug("Weapon has passed the check no matching slotid, allowing the pickup")
        return true
    end
end)

-- Optionally, you can also handle item pickups, such as health or ammo
hook.Add("PlayerCanPickupItem", "PreventPickupOfRestrictedItems", function(ply, item)
    -- Check if the item is in the restricted list
    local Disablepickup = tonumber(wblmonNopickup:GetInt())
    local Softlocken = tonumber(wblmonreplaceammoentitiesantisoftlock:GetInt())
    if Disablepickup == 1 then
        if Softlocken == 1 then
            if restrictedItems[item:GetClass()] then
                -- Return false to prevent pickup

                return false
            end
        else
            if restrictedItemsSB[item:GetClass()] then
                -- Return false to prevent pickup
                return false
            end
        end
    end
end)


local AmmoReplaceThink = true

hook.Add("Think", "ReplaceChargersThinkHook", function()
    local ReplaceCharger = tonumber(wblmonreplacewallchargers:GetInt())
    local ReplaceAmmo = tonumber(wblmonreplaceammoentities:GetInt())
    if ReplaceCharger == 1 then
        if chargerReplaceThink then
            replaceExistingChargers()
            
            -- Disable the think hook after the first run
            chargerReplaceThink = false
            
            
            timer.Simple(1, function() hook.Remove("Think", "ReplaceChargersThinkHook") end)
        end
    end

    if ReplaceAmmo == 1 then
        if AmmoReplaceThink then
            replaceAmmo()
            
            -- Disable the think hook after the first run
            AmmoReplaceThink = false
            timer.Simple(1, function() hook.Remove("Think", "ReplaceChargersThinkHook") end)
        end
    end
end)

hook.Add("Initialize", "SetConVarsOnStartup", function()
	LoadConVarsFromFile("LastSettings")
	npcstaticlist = LoadTableFromFile("npcvaluelist")
	npclistpreset = ReadStringFromFile("NPClistPreset")
end)

//// Credits to birdbrainswagtrain for fixing GetHoldtype 
///https://github.com/Facepunch/garrysmod-issues/issues/908
hook.Add("Initialize","holdtype_fix",function()
    local metaTable = FindMetaTable("Weapon")
    local baseTable = weapons.Get("weapon_base")

    local oldGetter = metaTable.GetHoldType
    local oldSetter = baseTable.SetWeaponHoldType

    metaTable.GetHoldType = function(self) return self.__holdtype_grry_plz_fix or oldGetter(self) end
    metaTable.SetWeaponHoldType = function(self,holdtype)
        self.__holdtype_grry_plz_fix=holdtype
        oldSetter(self,holdtype)
    end
end)


hook.Add("OnMapChange", "SaveConVarsOnMapChange", function()
	SaveConVarsToFile("LastSettings")
	SaveTableToFile("npcvaluelist", npcstaticlist)
	WriteStringToFile("NPClistPreset", npclistpreset)
end)

hook.Add("ShutDown", "SaveConVarsOnShutdown", function()
	SaveConVarsToFile("LastSettings")
	SaveTableToFile("npcvaluelist", npcstaticlist)
	WriteStringToFile("NPClistPreset", npclistpreset)
    WriteStringToFile("Remnpclistpreset", npclistpresetremember)
end)


hook.Add( "PlayerInitialSpawn", "Moneyinit", function( ply )
    --ply:RemovePData("wblmoney")
    CompressAndSendTable("wbladdweaponlistToC", wblweaponlist, ply)
    CompressAndSendTable("wbladdammolistToC", wblammolist, ply)
    local plysinglecp = tonumber(wblmonsingleplayercampaignmode:GetInt())
    local players = player.GetAll() -- Get a list of all players
    if plysinglecp == 1 and #players == 1 then
        local plyy
        if #players > 0 then
            local wblmoney = tonumber(ply:GetPData("wblmoney",-1))
            WriteStringToFile("SinglePlayerMoney", wblmoney)
        end
    end

	local monen = wblmonhen:GetInt()
		    if monen == 1 then
				local wblmoney = tonumber(ply:GetPData("wblmoney",-1)) --Get player money
				local moneystart = wblmonstart:GetInt()
				local moneypers = wblmonpers:GetInt()
				if wblmoney <= 0 or moneypers == 0 then
					ply:SetPData( "wblmoney", moneystart ) 
					wblmoney = tonumber(ply:GetPData("wblmoney",-1))
				end
				
				net.Start("plyMonzupdateToC")
				net.WriteInt(wblmoney,32)
				net.WriteInt(0,32)
				net.Send(ply)
				
		    end
    local monany = wblmonbuyanywhere:GetInt()
    local monanystart = wblmonbuyatstart:GetInt()
    
    if (tonumber(monany) == 1) and tonumber(monanystart) == 0 then
        wblDebug("wblEnableShopbuy Sent")
        net.Start("wblEnableShopbuy")
        net.Send(ply)
    else
        net.Start("wblDisableShopbuy")
        net.Send(ply)
    end
end )

hook.Add("PlayerSay", "WBLBuyChatCommand", function(ply, text, public)
    if text == "!wblbuy" then
        if ply.canbuy == nil then
            local monen = wblmonhen:GetInt()
            local monanystart = wblmonbuyanywhere:GetInt()
            wblDebug("monen: "..monen)
            wblDebug("wblmonbuyanywhere: "..monanystart)
            if (tonumber(monanystart) == 1) then
                ply.canbuy = true
            end
        end
        if ply.canbuy then
            HandleWBLBuy(ply)
        end
        return "" -- Return an empty string to prevent the message from being shown in chat
    end
end)

hook.Add("PlayerSpawn", "OnPlayerRespawn", function(ply)
    ply.isinshop = false
    ply.justspawn = true 
    local monanystart = wblmonbuyatstart:GetInt()
    local monen = wblmonhen:GetInt()
    local monanystarttime = wblmonbuyatstarttime:GetInt()
    if (tonumber(monanystart) == 1) then
        net.Start("wblEnableShopbuy")
        net.Send(ply)
        ply.canbuy = true
        timer.Remove("LockShop")
        timer.Create("LockShop", tonumber(monanystarttime), 1, function()
            net.Start("wblDisableShopbuy")
            net.Send(ply)
            ply.canbuy = false
        end)
    end
    local wstar = wblmondelayedwstar:GetInt()
    if tonumber(wstar) == 1 then
        timer.Simple(0.5, function()
            
            if IsValid(ply) then
                if not ply:IsSuitEquipped() then
                    ply:EquipSuit()
                end
                if ply:IsSuitEquipped() and ply:Health() > 1 then
                    ply:ConCommand("wstar")  -- Force the player to run the "wstar" command
                end
            end
            
        end)
    end
    timer.Simple(0.7, function()
    ply.justspawn = false 
    end)
end)


hook.Add("PlayerDeath", "HandlePlayerDeath", function(victim, inflictor, attacker)
    local plysinglecp = tonumber(wblmonsingleplayercampaignmode:GetInt())
    local players = player.GetAll() -- Get a list of all players
    if plysinglecp == 1 and #players == 1 then
        if #players > 0 then
            local wblmoneytoprocess = ReadStringFromFile("SinglePlayerMoney")
            local wblmoney = tonumber(wblmoneytoprocess)
            victim:SetPData( "wblmoney", wblmoney )
        end
        return
    end

	local lossen = tonumber(wblmonlosen:GetInt())
	local monen = tonumber(wblmonhen:GetInt())
	if monen == 0 then return end
    if (victim:IsPlayer() and victim:IsValid()) and lossen == 1 then
	    local wblmoney = tonumber(victim:GetPData("wblmoney",-1))
	    local lossmethod = tonumber(wblmonlosmet:GetInt())
	    if lossmethod == 1 then
	    	local lossfix = tonumber(wblmonlosfix:GetInt())
	    	mnygiven = lossfix
		elseif lossmethod == 2 then
			local lossperc = tonumber(wblmonlospercent:GetInt())
			mnygiven = (wblmoney)*(lossperc/100)
		end

		if mnygiven > wblmoney then
			wblmoney = 0
		else
			wblmoney = wblmoney - mnygiven
		end
		victim:SetPData( "wblmoney", wblmoney )
	    net.Start("plyMonzupdateToCLose")
		net.WriteInt(wblmoney, 32)
		net.WriteInt(mnygiven, 32)
		net.Send(victim)
	end	
	
	--for money gain on player kill
	if victim == attacker then return end
	local plycoop = tonumber(wblmonplycoop:GetInt())
	if (victim:IsPlayer() and victim:IsValid()) and (plycoop == 0) and (attacker:IsPlayer() and attacker:IsValid()) then
		local wblmoney = tonumber((attacker:GetPData("wblmoney",-1)))
		local plyvalue = tonumber(wblmonplyvalue:GetInt())
		wblmoney = wblmoney + plyvalue
		local maxmonz = wblmonmax:GetInt()
		if wblmoney < 0 then
			attacker:SetPData( "wblmoney", 0 ) 
			wblmoney = 0
		elseif wblmoney > maxmonz then
			attacker:SetPData( "wblmoney", maxmonz )
			wblmoney = maxmonz
		else
			attacker:SetPData( "wblmoney", wblmoney ) 
		end
		net.Start("plyMonzupdateToC")
		net.WriteInt(wblmoney,32)
		net.WriteInt(plyvalue,32)
		net.Send(attacker)
	end

end)



--Hook to Dynamically add Money on NPCS with health
hook.Add( "OnNPCKilled", "wblmoneyget", function( npc, ply, inflictor )
local ncls = npc:GetClass()
if npc:GetClass() == "npc_lambdaplayer" then
    npc.died = false
end
if npc.died ~= true or ncls == "npc_lambdaplayer" then
	npc.died = true
	wblDebug("<<NPC has died>>")


		
	if (npc.plykil ~= "No one") and npc:IsValid() then --

		local npcc = tostring(npc:GetClass())
		local npcmh = npc:GetMaxHealth()
		local npcch = npc:Health()
		wblDebug("NPC killed: "..tostring(npcc))
		wblDebug("Inflictor: "..tostring(inflictor))
		wblDebug("Player who Last damaged: "..tostring(npc.plykil))
		wblDebug("Who killed: "..tostring(ply))
		wblDebug("NPC Max Health: "..tostring(npcmh))
		wblDebug("NPC Current: "..tostring(npc.curhp))
		wblDebug("NPC is Valid: "..tostring(npc:IsValid()))
		if npcmh == nil or npc.curhp == nil then
			wblDebug("NPC Health is Invalid")
		else

		-- For some NPC that have higher current health than max
			if (npc:IsValid()) then
				if (npc.curhp > npcmh) then 
					wblDebug("****NPC with higher Current Health than Max Health Detected.****")
					wblgivemoneydynamichealth(npc.plykil,npc.pseudomaxhp,npc)

				elseif npcmh > 0 or npc.curhp > 0 then	--normal Routine
					wblDebug("****NPC Health is normal. Executing normal route****")
					wblDebug("NPC Max Health: "..tostring(npcmh))
					wblDebug("NPC Current: "..tostring(npc.curhp))
					wblgivemoneydynamichealth(npc.plykil,npc:GetMaxHealth(),npc)

				else --For fallback
					wblDebug("****No HP NPC Detected, crediting with fixed fallback money****")
					local mfb = wblmonhfb:GetInt()
					wblgivemoneydynamichealth(npc.plykil,mfb,npc)

				end
			end

		end
	else
		wblDebug("****No player did the last hit... Ignoring****")

	end


else
	wblDebug("****NPC has died already.. Ignoring****")
end -- end of IF NPC DIED

	
end)



--This is for No Health Enemies. Mark it for death to credit the player who did damage
hook.Add( "EntityTakeDamage", "PlayerLasthit", function( ent, dmginfo)
    
	local atker = dmginfo:GetAttacker()
	if (ent:IsNPC() or ent:IsNextBot()) and ent.died ~= true then
        wblDebug("entity: "..ent:GetClass())
		if ent.setpseudomaxhp then
			ent.setpseudomaxhp = false
				if ent:Health() > 9999999 then -- check if npc has weirdly amount of health
					local mfb = wblmonhfb:GetInt()
					ent.pseudomaxhp = mfb --fallback amount again
					wblDebug("****NPC with unusual Health detected. Setting Health var to fallback****")
				else
					ent.pseudomaxhp = ent:Health()
				end
				
				wblDebug("Pseudo Max HP set: "..tostring(ent.pseudomaxhp))
		end

		if atker:IsPlayer() then --check if its a player who damaged
			ent.plykil = atker
			ent.ownr = atker
			wblDebug("Damaged by: "..tostring(ent.plykil))
            wblDebug("Health of ent: "..ent:Health())
            if ent:GetClass() == "npc_lambdaplayer" then
                local lambdahealth = ent:Health()
                wblDebug("Lambda health : "..lambdahealth)
                local damage = dmginfo:GetDamage()
                wblDebug("Lambda damaged : "..damage)
                local healthAfterDamage = ent:Health() - dmginfo:GetDamage()
                local mfb = wblmonhfb:GetInt()
                if ent.lambdatrigger == true then
                    ent.lambdahealth = ent:Health()
                    ent.lambdatrigger = false
                    wblDebug("Lambda Player got hit, trigger is now: "..tostring(ent.lambdatrigger))
                end
                wblDebug("Lambda start health is now: "..tostring(ent.lambdahealth))
                if healthAfterDamage <= 0 then
                    ent.lambdatrigger = true
                    if ent.lambdahealth <= 0 then return end
                    wblgivemoneydynamichealth(ent.plykil,ent.lambdahealth,ent) 
                end
            end
		end
        local plycoop = tonumber(wblmonplycoop:GetInt())
        if plycoop == 1 then
            local players = player.GetAll() -- Get a list of all players
            local plyy
            if #players > 0 then
                plyy = players[1] -- Return the first player in the list
                ent.plykil = plyy
            end
        end
	elseif not ent:IsPlayer() then
		if atker:IsPlayer() then --check if its a player who damaged
			ent.ownr = atker
		end
	end
end )

--Get Health after the damage, mostly used on turret
hook.Add( "PostEntityTakeDamage", "PlayerLasthit", function( ent, dmginfo, tkdmg)
	local atker = dmginfo:GetAttacker()
    wblDebug("entity: "..ent:GetClass())
	if (ent:IsNPC() or ent:IsNextBot()) and ent.died ~= true then
		if ent:Health() > 9999999 then
			wblDebug("****NPC with unusual Health detected. Setting var to 40 current hp****")
			ent.curhp = 40
		else
			ent.curhp = ent:Health()

		end
		wblDebug("PostEntitydamage Triggered NPC Health: "..tostring(ent.curhp))

			
			if (ent.curhp <= 0 and ent.curhp ~= ent.pseudomaxhp) then -- This is to check if npc doesnt die but has 0 HP (can be damaged)
				
				timer.Simple( 0.1, function() 
				wblDebug("Is NPC still valid: "..tostring(ent:IsValid()))
				if ent:IsValid() then
				 	if ent.died ~= true then
				 		wblDebug("****Non-disappearing NPC with 0 HP detected.****")
				 		wblDebug("Who killed: "..tostring(atker))
						wblDebug("NPC Pseudo Max Health: "..tostring(ent.pseudomaxhp))
						wblDebug("NPC Current: "..tostring(ent.curhp))
							wblgivemoneydynamichealth(ent.plykil,ent.pseudomaxhp,ent)
							ent.died = true
						
					end
				else
					wblDebug("**NPC is Gone and invalid.. Ignoring**")
				end

				end )
			end

	end 
	
end )


--This is for NPC that doesnt register kill for some reason, A fallback
hook.Add( "EntityRemoved", "NPCGone", function( ent, ful )

if ent.plykil ~= "No one" and ent:GetClass() ~= "npc_lambdaplayer" then
	if (ent:IsNPC() or ent:IsNextBot()) and ent.died ~=true then
		local npcm = ent:GetMaxHealth()
		wblDebug("****NPC Didnt trigger OnNPCKilled:"..tostring(ent).."****")
		wblDebug("NPC Died:"..tostring(ent))
		wblDebug("Money value: "..tostring(ent.pseudomaxhp))
		wblDebug("Giving money to player: "..tostring(ent.plykil))
		wblgivemoneydynamichealth(ent.plykil,ent.pseudomaxhp,ent)
		ent.died = true
	end
end

end)




--Initializing for NPC attributes to be used.
hook.Add( "OnEntityCreated", "NPCAttinit", function( ent )
	if not ent:IsPlayer() then
		if ent:IsNPC() or ent:IsNextBot() then
			wblDebug("This NPC has been initialized"..tostring(ent:Health()))
			ent.pseudomaxhp = ent:Health()
			ent.setpseudomaxhp = true
			ent.curhp = ent:Health()
			ent.plykil = "No one"
			ent.died = false
            if ent:GetClass() == "npc_lambdaplayer" then
                ent.lambdatrigger = false
                timer.Simple(0.1, function()
                    ent.lambdahealth = ent:Health()
                    wblDebug("Lambda Player Health: "..tostring(ent.lambdahealth))
                end)
                wblDebug("Lambda Player : "..tostring(ent.lambdatrigger))
            end
			wblDebug("NPC Pseudo Max Health: "..tostring(ent.pseudomaxhp))
			wblDebug("NPC Current Health: "..tostring(ent.curhp))
			wblDebug("Last hitter: "..tostring(ent.plykil))
			ent:AddCallback("PhysicsCollide", function(ent, data)
				local otherEnt = data.HitEntity

	            -- Check if the colliding entity is a player or player's prop
	            if IsValid(otherEnt) then
	            	if otherEnt.ownr == nil then
	                	otherEnt.ownr = otherEnt:GetOwner()
	                end

	                if otherEnt:IsPlayer() then
	                    wblDebug(tostring(otherEnt:Nick()) .. " touched/pushed the NPC! Creditting "..tostring(otherEnt:Nick()))
	                    ent.plykil = otherEnt
	                    ent.ownr = otherEnt
	                elseif otherEnt:IsValid() and otherEnt:GetPhysicsObject():IsValid() and otherEnt.ownr:IsPlayer() then
	                    wblDebug(tostring(otherEnt.ownr:Nick()) .. " touched the NPC turret with a prop! Crediting ".. tostring(otherEnt.ownr:Nick()))
	                	ent.plykil = otherEnt.ownr
	                	ent.ownr = otherEnt.ownr
	                end
	            end
	        end)
		else

			ent:AddCallback("PhysicsCollide", function(ent, data)
				local otherEnt = data.HitEntity
				if wblCoolD2 <= CurTime() then
		            if IsValid(otherEnt) and not otherEnt:IsPlayer() then
		            	if otherEnt.ownr == nil then
		 				return
		 				elseif otherEnt.ownr ~= nil then
		 					ent.ownr = otherEnt.ownr
		 					wblDebug("Prop To Prop Owner of this entity is now: ".. tostring(otherEnt.ownr))
		 				end
		 			elseif IsValid(otherEnt) and otherEnt:IsPlayer() then
		 				ent.ownr = otherEnt
		 				wblDebug("Player to Prop, Owner of this entity is now: ".. tostring(otherEnt))
		            end
		        	wblCoolD2 = CurTime() + 0.2
		        end
	        end)
		end
	end

    local ReplaceAmmo = tonumber(wblmonreplaceammoentities:GetInt())
    local ReplaceCharger = tonumber(wblmonreplacewallchargers:GetInt())
    local Softlocken = tonumber(wblmonreplaceammoentitiesantisoftlock:GetInt())

    --Replace entity ADD AN OPTION TO IT
    if Softlocken == 1 then
        if (IsValid(ent) and replaceableEntities[ent:GetClass()]) and ReplaceAmmo == 1 then
            -- Delay to ensure the entity is fully initialized
            timer.Simple(0, function()
                -- Double-check if it's still valid and if a player is not holding it
                if IsValid(ent) and not ent:IsPlayerHolding() and not IsValid(ent:GetOwner()) then
                    -- Store position and angle of the entity to be replaced
                    local pos = ent:GetPos()
                    local ang = ent:GetAngles()

                    -- Remove the original weapon or ammo entity
                    ent:Remove()

                    -- Replace it with the money bundle "weshopmoney"
                    local moneyBundle = ents.Create("weshopmoney")
                    if IsValid(moneyBundle) then
                        moneyBundle:SetPos(pos)
                        moneyBundle:SetAngles(ang)
                        moneyBundle:Spawn()
                    end
                end
            end)
        end
    else
        if (IsValid(ent) and replaceableEntitiesSB[ent:GetClass()]) and ReplaceAmmo == 1 then
            -- Delay to ensure the entity is fully initialized
            timer.Simple(0, function()
                -- Double-check if it's still valid and if a player is not holding it
                if IsValid(ent) and not ent:IsPlayerHolding() and not IsValid(ent:GetOwner()) then
                    -- Store position and angle of the entity to be replaced
                    local pos = ent:GetPos()
                    local ang = ent:GetAngles()

                    -- Remove the original weapon or ammo entity
                    ent:Remove()

                    -- Replace it with the money bundle "weshopmoney"
                    local moneyBundle = ents.Create("weshopmoney")
                    if IsValid(moneyBundle) then
                        moneyBundle:SetPos(pos)
                        moneyBundle:SetAngles(ang)
                        moneyBundle:Spawn()
                    end
                end
            end)
        end
    end
    --Replace Wall Charger function
    if (IsValid(ent) and (ent:GetClass() == "item_healthcharger" or ent:GetClass() == "item_suitcharger")) and ReplaceCharger == 1 then
        -- Delay to ensure the entity is fully initialized before replacing
        timer.Simple(0, function()
            if IsValid(ent) then
                -- Store the position and orientation (angles) of the charger
                local pos = ent:GetPos()
                local ang = ent:GetAngles()

                -- Remove the original charger entity
                ent:Remove()

                -- Create and spawn the "weshoponwall" entity at the same position and orientation
                local shopOnWall = ents.Create("weshoponwall")
                if IsValid(shopOnWall) then
                    shopOnWall:SetPos(pos)
                    shopOnWall:SetAngles(ang)
                    shopOnWall:Spawn()
                end
            end
        end)
    end
    if (IsValid(ent) and (ent:GetClass() == "item_ammo_crate")) and ReplaceCharger == 1 then
        -- Delay to ensure the entity is fully initialized before replacing
        timer.Simple(0, function()
            if IsValid(ent) then
                -- Store the position and orientation (angles) of the charger
                local pos = ent:GetPos()
                local ang = ent:GetAngles()

                -- Remove the original charger entity
                ent:Remove()

                -- Create and spawn the "weshoponwall" entity at the same position and orientation
                local shopOnWall = ents.Create("weshop")
                if IsValid(shopOnWall) then
                    shopOnWall:SetPos(pos)
                    shopOnWall:SetAngles(ang)
                    shopOnWall:Spawn()
                end
            end
        end)
    end
end )

--This is for No Health Enemies. credit the player who picked up with gravgun
hook.Add( "GravGunOnPickedUp", "NPGravpickMFD", function( ply, ent )
	if not ent:IsPlayer() then
		if (ent:IsNPC() or ent:IsNextBot()) and ent.died == false  then
			ent.plykil = ply
			wblDebug(tostring(ent.plykil).."has picked up "..tostring(ent).." and is now creditted")
		end
		ent.ownr = ply
		wblDebug("Owner of this entity is now: ".. tostring(ply))
	end
end)

hook.Add( "GravGunPunt", "NPGravpickMFD", function( ply, ent )
	if not ent:IsPlayer() then
		if (ent:IsNPC() or ent:IsNextBot()) and ent.died == false then
			ent.plykil = ply
			wblDebug(tostring(ent.plykil).."has puntted "..tostring(ent).." and is now creditted")
			
		end
		ent.ownr = ply
		wblDebug("Owner of this entity is now: ".. tostring(ply))
	end
end)

--Credit player who used the npc
hook.Add( "PlayerUse", "NPCGrabuse", function( ply, ent )
	if wblCoolD <= CurTime() and not ent:IsPlayer() then
		if ((ent:IsNPC() or ent:IsNextBot()) and ent:GetPhysicsObject():IsValid()) and ent.died == false then
			ent.plykil = ply
			wblDebug(tostring(ent.plykil).."has used "..tostring(ent).." and is now creditted")
		end
		ent.ownr = ply
		wblCoolD = CurTime() + 1
		wblDebug("Owner of this entity is now: ".. tostring(ply))
	end
end )


local HoldTypecost = {
        ["melee"] = {min = 25, max = 150},
        ["grenade"] = {min = 50, max = 200},
        ["slam"] = {min = 100, max = 250},  
        ["pistol"] = {min = 150, max = 400},
        ["revolver"] = {min = 450, max = 750},
        ["smg"] = {min = 850, max = 1200},
        ["shotgun"] = {min = 1000, max = 1500},
        ["crossbow"] = {min = 2200, max = 2700},
        ["ar2"] = {min = 1700, max = 2200},
        ["rpg"] = {min = 2800, max = 3200},
        ["physgun"] = {min = 2800, max = 3200},
    }

local Ammocost = {
        ["grenade"] = {min = 50, max = 200},
        ["slam"] = {min = 100, max = 250},  
        ["pistol"] = {min = 150, max = 400},
        ["357"] = {min = 450, max = 750},
        ["smg1"] = {min = 850, max = 1200},
        ["buckshot"] = {min = 1000, max = 1500},
        ["xbowbolt"] = {min = 2200, max = 2700},
        ["ar2"] = {min = 1700, max = 2200},
        ["rpg_round"] = {min = 2800, max = 3200},
        ["ar2altfire"] = {min = 1200, max = 1500},
        ["smg1_grenade"] = {min = 900, max = 1200},
        ["striderminigun"] = {min = 2800, max = 3200},
        ["combinecannon"] = {min = 3400, max = 3700},
    }

local Ammoclipexceedcost = {
        ["grenade"] = {cost = 250,exceedcount = 3},
        ["slam"] = {cost = 250,exceedcount = 3},  
        ["pistol"] = {cost = 10,exceedcount = 18},
        ["357"] = {cost = 50, exceedcount = 7},
        ["smg1"] = {cost = 5,exceedcount = 30},
        ["buckshot"] = {cost = 75,exceedcount = 9},
        ["xbowbolt"] = {cost = 300,exceedcount = 1},
        ["ar2"] = {cost = 10,exceedcount = 30},
        ["rpg_round"] = {cost = 300,exceedcount = 3},
        ["ar2altfire"] = {cost = 500,exceedcount = 3},
        ["smg1_grenade"] = {cost = 250,exceedcount = 3},  
}

local Ammodamageexceedcost = {
        ["grenade"] = {cost = 1.5,exceeddamage = 130},
        ["slam"] = {cost = 1.5,exceeddamage = 220},  
        ["pistol"] = {cost = 50,exceeddamage = 6},
        ["357"] = {cost = 20, exceeddamage = 42},
        ["smg1"] = {cost = 100,exceeddamage = 5},
        ["buckshot"] = {cost = 100,exceeddamage = 9},
        ["xbowbolt"] = {cost = 10,exceeddamage = 105},
        ["ar2"] = {cost = 45,exceeddamage = 9},
        ["rpg_round"] = {cost = 10,exceeddamage = 105},
        ["striderminigun"] = {cost = 15,exceeddamage = 50},
        ["combinecannon"] = {cost = 15,exceeddamage = 100},
        ["rpg_round"] = {cost = 10,exceeddamage = 105},
        ["n.a."] = {cost = 1.5,exceeddamage = 50},
}


local meleeConvert = {"knife", "fists"}  -- Define meleeConvert as a table of strings

-- Check if the holdType is one of the melee types

-- Function to calculate excess costs based on damage and clip size
local function CalculateExcessCosts(weapon, damage, clipSize, primaryammo)
    -- Initialize total costs
    wblDebug("&&&&&&&&&&&&&&&&&&&&")
    wblDebug("CalculateExcessCosts function Executed")
    wblDebug("Damage: " .. damage)
    wblDebug("ClipSize: " .. clipSize)
    local totalCost = 0

    -- Check for damage processing
    if damage == "n.a." then
        wblDebug("Damage is n.a.")
    else
        if (tostring(damage) ~= "N.A." or tostring(damage) ~= "n.a.") and (tonumber(damage) > 0)  then
            wblDebug("Damage Is not N.A. Processing..")
            damage = tonumber(damage) -- Convert damage to a number
            
            -- Look up the exceed damage cost for the ammo type
            wblDebug("primaryAmmo: "..primaryammo)
            local exceedDamageInfo = Ammodamageexceedcost[primaryammo]
            if not exceedDamageInfo then
                exceedDamageInfo = Ammodamageexceedcost[xbowbolt]
            end
            if exceedDamageInfo then
                local exceedDamageLimit = exceedDamageInfo.exceeddamage
                local costPerExcessDamage = exceedDamageInfo.cost
                
                if damage > exceedDamageLimit then
                    local excessDamage = damage - exceedDamageLimit
                    local damageCost = excessDamage * costPerExcessDamage
                    wblDebug("Excess Damage: " .. excessDamage .. " Cost: " .. damageCost)
                    totalCost = totalCost + damageCost
                else
                    wblDebug("Damage does not exceed.. Skpping")
                end
            end
        end
    end
    

    -- Check for clip size processing
    if clipSize == "n.a." then
        wblDebug("Damage is n.a.")
    else
        if (tostring(clipSize) ~= "N.A." or tostring(clipSize) ~= "n.a.") and (tonumber(clipSize) > 0) then
            wblDebug("ClipSize Is not N.A. Processing..")
            clipSize = tonumber(clipSize) -- Convert clip size to a number
            wblDebug("primaryAmmo: "..primaryammo)
            -- Look up the exceed clip size cost for the ammo type
            local exceedClipInfo = Ammoclipexceedcost[primaryammo]
            
            if exceedClipInfo then
                local exceedClipLimit = exceedClipInfo.exceedcount
                local costPerExcessClip = exceedClipInfo.cost
                
                if clipSize > exceedClipLimit then
                    local excessClipSize = clipSize - exceedClipLimit
                    local clipCost = excessClipSize * costPerExcessClip
                    wblDebug("Excess Clip Size: " .. excessClipSize .. " Cost: " .. clipCost)
                    totalCost = totalCost + clipCost
                else
                    wblDebug("Clipsize does not exceed.. Skpping")
                end
            end
        end
    end

    -- Return the total cost calculated

    wblDebug("CalculateExcessCosts function Done")
    wblDebug("&&&&&&&&&&&&&&&&&&&&")
    return totalCost
end



-- Function to calculate costs based on ammo types and hold type
local function CalculateCosts(primaryAmmo, secondaryAmmo, holdType)
    wblDebug("&&&&&&&&&&&&&&&&&&&&")
    wblDebug("CalculateCosts function Executed")
    local function getRandomCost(costTable, ammoType)
        if costTable[ammoType] then
            local minCost = costTable[ammoType].min
            local maxCost = costTable[ammoType].max
            local randomCost = math.random(minCost, maxCost)
            return randomCost  -- Return the random cost without rounding
        end
        return nil
    end


    -- Initialize costs
    local finalPrimaryCost = 0
    local finalSecondaryCost = 0
    local finalHoldTypeCost = 0

    -- Calculate primary ammo cost
    if primaryAmmo and primaryAmmo ~= "n.a." then
        finalPrimaryCost = getRandomCost(Ammocost, primaryAmmo) or 0
        wblDebug("Final Primary Ammo Cost: " .. finalPrimaryCost)
    end

    -- Calculate secondary ammo cost
    if secondaryAmmo and secondaryAmmo ~= "n.a." then
        finalSecondaryCost = getRandomCost(Ammocost, secondaryAmmo) or 0
        wblDebug("Final Secondary Ammo Cost: " .. finalSecondaryCost)
    end

    -- Calculate hold type cost
    if holdType and holdType ~= "n.a." then
        finalHoldTypeCost = getRandomCost(HoldTypecost, holdType) or 0
        wblDebug("Final Holdtype Cost: " .. finalHoldTypeCost)
    end
    wblDebug("CalculateCosts function Done")
    wblDebug("&&&&&&&&&&&&&&&&&&&&")
    -- Handle the cost calculation based on the presence of values
    if primaryAmmo == "n.a." and secondaryAmmo == "n.a." and holdType == "n.a." then
        return finalHoldTypeCost * 2
    elseif holdType == "n.a." then
        return (finalPrimaryCost * 2) + finalSecondaryCost
    elseif primaryAmmo == "n.a." and secondaryAmmo == "n.a." then
        return finalHoldTypeCost * 2
    elseif secondaryAmmo == "n.a." then
        return finalPrimaryCost + finalHoldTypeCost
    elseif primaryAmmo == "n.a." then
        return (finalHoldTypeCost * 2) + finalSecondaryCost
    else
        return finalPrimaryCost + (finalSecondaryCost/2) + finalHoldTypeCost
    end

    
end


-- Function to round up to the nearest 50
local function roundUpTo50(value)
    return math.ceil(value / 50) * 50
end




local function GetWeaponInfoByClass(weaponClass)
    -- Spawn the weapon as a temporary entity
    local weapon = ents.Create(weaponClass)

    -- Check if the weapon entity is valid
    if IsValid(weapon) then
        -- Initialize the weapon entity
        weapon:Spawn()
        -- Get the hold type
        wblDebug("**************************************************")
        wblDebug("******1.1 Holdtype*******")
        local holdType = weapon.GetHoldType and weapon:GetHoldType() or "N.A."
        wblDebug("Original Holdtype: "..holdType)
        holdType = string.lower(holdType)
        for _, v in ipairs(meleeConvert) do
            if v == holdType then
                holdType = "melee"  -- Use assignment instead of comparison
                break  -- Exit the loop once a match is found
            end
        end
        wblDebug("After Melee Check Holdtype: "..holdType)
        local found = false
        for HType, _ in pairs(HoldTypecost) do
            if string.lower(holdType) == HType then
                found = true
                break
            end
        end
        if not found then
            wblDebug("Hold Type unidentified: "..holdType)
            wblDebug("Turning it into 'n.a.'...")
            holdType = "n.a."
        end
        wblDebug("After HoldType Table Check")
        wblDebug("**************************************************")
        wblDebug("******1.2 Primary Ammo*******")
        -- Get the primary ammo type
        local primaryAmmo = weapon.Primary and weapon.Primary.Ammo or "N.A."
        wblDebug("Original primaryAmmo: "..primaryAmmo)
        if primaryAmmo == "" or primaryAmmo == "none" then
            primaryAmmo = "N.A."
        end
        local primaryknown = primaryAmmo
        primaryAmmo = string.lower(primaryAmmo)
        local found = false
        for ammoType, _ in pairs(Ammocost) do
            if string.lower(primaryAmmo) == ammoType then
                found = true
                break
            end
        end
        if not found then
            wblDebug("primaryAmmo unidentified")
            wblDebug("Turning it into 'n.a.'...")
            primaryAmmo = "n.a."
        end
        wblDebug("After Ammo Table Check (primary): "..primaryAmmo)
        wblDebug("**************************************************")
        wblDebug("******1.3 Secondary Ammo*******")
        -- Get the secondary ammo type
        local secondaryAmmo = weapon.Secondary and weapon.Secondary.Ammo or "N.A."
        wblDebug("Original secondaryAmmo: "..secondaryAmmo)
        secondaryAmmo = string.lower(secondaryAmmo)
        local found = false
        for ammoType, _ in pairs(Ammocost) do
            if string.lower(secondaryAmmo) == ammoType then
                found = true
                break
            end
        end
        if not found then
            secondaryAmmo = "n.a."
            wblDebug("secondaryAmmo unidentified")
            wblDebug("Turning it into 'n.a.'...")
        end
        wblDebug("After Ammo Table Check (secondary): "..secondaryAmmo)
        wblDebug("**************************************************")
        wblDebug("******1.4 Post Process check*******")
        wblDebug("primaryknown: "..primaryknown)
        if (primaryAmmo == "n.a." and secondaryAmmo ~= "n.a.") and (primaryknown == "N.A.") then
            wblDebug("No Primary ammo but has secondary, placing secondary to primary")
            primaryAmmo = secondaryAmmo 
            secondaryAmmo = "n.a."
            wblDebug("New Primary ammo: "..primaryAmmo)
            wblDebug("New Secondary ammo: "..secondaryAmmo)
        end
        if (primaryAmmo == "n.a." and secondaryAmmo == "n.a.") and (holdType == "n.a.") then
            wblDebug("No Primary Ammo ID, No Secondary Ammo ID, and no holdType.. WTF is this weapon type?!")
            wblDebug("Will just assume assault rifle it is the most common")
            holdType = "ar2"
            wblDebug("New holdType: "..holdType)
        end
        wblDebug("Post Process done!")
        wblDebug("**************************************************")
        wblDebug("******1.5 Cost Calculation*******")
        local totalCostAmHT = CalculateCosts(primaryAmmo, secondaryAmmo, holdType)
        wblDebug("Total Cost of Ammo/Holdtype: " .. totalCostAmHT)
        wblDebug("**************************************************")
        wblDebug("**************************************************")
        wblDebug("**************************************************")
        wblDebug("******2.1 Weapon Damage Processing*******")
        local damage = weapon.Primary and weapon.Primary.Damage or "N.A."
        wblDebug("Original Damage: "..damage)
        damage = string.lower(damage)
        wblDebug("**************************************************")
        wblDebug("******2.2 Weapon ClipSize Processing*******")
        local clipSize = weapon.Primary and weapon.Primary.ClipSize or "N.A."
        wblDebug("Original ClipSize: "..clipSize)
        clipSize = string.lower(clipSize)
        wblDebug("**************************************************")
        wblDebug("******2.3 Excess Clipsize/Damage Processing*******")
        wblDebug("primaryAmmo: "..primaryAmmo)
        local totalCostDmgClip = CalculateExcessCosts(weapon, damage, clipSize, primaryAmmo)
        wblDebug("Total Excess Cost: " .. totalCostDmgClip)
        wblDebug("**************************************************")
        wblDebug("**************************************************")
        wblDebug("**************************************************")
        wblDebug("******3.1 Total Calculated Cost (Suggest Price)***")
        local totalCost = roundUpTo50(totalCostDmgClip + totalCostAmHT)
        wblDebug("@@@@ SUGGESTED PRICE: "..totalCost.." @@@@@@")
        weapon:Remove()
        
        return holdType, primaryAmmo, secondaryAmmo, totalCost, clipSize
    else
        -- Return "N.A." for all values if the weapon is invalid
        return "N.A.", "N.A.", "N.A."
    end
end


-- Create the console command to display the stats
concommand.Add("wblmoney_showsuggestedprice", function(ply, cmd, args)
    local weapon = ply:GetActiveWeapon()
    if IsValid(weapon) then
        local weaponClass = weapon:GetClass()  -- Get the class of the weapon
        wblDebug("Currently held weapon class: " .. weaponClass)
        local holdtype,primaryammo,secondaryammo,totalcost,clipsize = GetWeaponInfoByClass(weaponClass)
        wblDebug("**************************************************")
        wblDebug("holdtype: "..holdtype)
        wblDebug("primaryammo: "..primaryammo)
        wblDebug("secondaryammo: "..secondaryammo)
        wblDebug("**************************************************")
        ply:ChatPrint("Suggested price of "..weaponClass..": ω"..totalcost)
    else
        wblDebug("You are not holding a valid weapon.")
        ply:ChatPrint("You are not holding a valid weapon.")
        return nil
    end
    

end)


net.Receive("wblweaponpricereqToS", function(len, ply) 
    wblDebug("wblweaponpricereqToS Request received")
    local weaponclasss = net.ReadString()
    local holdtype,primaryammo,secondaryammo,totalcost,clipsize = GetWeaponInfoByClass(weaponclasss)
    wblDebug("**************************************************")
    wblDebug("holdtype: "..holdtype)
    wblDebug("primaryammo: "..primaryammo)
    wblDebug("secondaryammo: "..secondaryammo)
    wblDebug("**************************************************")
    net.Start("wblweaponpricereqToC")
    net.WriteInt(totalcost,32)
    net.WriteString(holdtype)
    net.WriteString(primaryammo)
    net.Send(ply)
    wblDebug("wblweaponpricereqToC Signal Sent")
end)

net.Receive("wblreqAmmotypequick", function(len, wblply)
    local weaponClass = net.ReadString()
    local weapon = ents.Create(weaponClass)
    local hol,prim,secon,totalcost,clipsize = GetWeaponInfoByClass(weaponClass)
    wblDebug("hol: "..hol)
    wblDebug("prim: "..prim)
    wblDebug("secon: "..secon)
    wblDebug("totalcost: "..totalcost)
    --Add HL2 Weapons hardcode them
    if IsValid(weapon) then
        weapon:Spawn()
        local holdType = weapon.GetHoldType and weapon:GetHoldType() or "N.A."
        local primaryAmmo = weapon.Primary and weapon.Primary.Ammo or "N.A."
        local secondaryAmmo = weapon.Secondary and weapon.Secondary.Ammo or "N.A."
        wblDebug("primaryAmmo sent: "..primaryAmmo)
        net.Start("wblsendAmmotypequick")
        net.WriteString(weaponClass)
        net.WriteString(holdType)
        net.WriteString(primaryAmmo)
        net.WriteString(secondaryAmmo)
        net.WriteInt(totalcost,32)
        if clipsize == "n.a." or clipsize == "N.A." then
            clipsize = 0
        end
        net.WriteInt(clipsize,32)

        net.Send(wblply)
        weapon:Remove()
    else
        wblDebug("Invalid weapon class or no weapon data available.")
    end
end)


end -- Its the "end" of IF SERVER





