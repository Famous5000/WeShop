--These files can "access" this init.lua file
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

--This gets the lines from "shared.lua" file in the same folder
include("shared.lua")

--[[
These initializes or creates "channels" or Signals to 
communicate with client or the cl_init.lua because some
functions in the wiki can only be accessed by server (blue in wiki) 
and some by client (orange in wiki) so they need to communicate to each 
other to help each other's strengths and weaknesses
]]--
util.AddNetworkString("wbladdweaponlistToS")
util.AddNetworkString("wbladdweaponlistToC")
util.AddNetworkString("wbladdammolistToS")
util.AddNetworkString("wbladdammolistToC")
--util.AddNetworkString("wblUpdateWepAmmolistToS")
--util.AddNetworkString("wblUpdateWepAmmolistToC")

util.AddNetworkString("wblWinPop")
util.AddNetworkString("wblFreeze")
util.AddNetworkString("wblUnfreeze")
util.AddNetworkString("wblplydiedinstore")
util.AddNetworkString("wblBuyweapon")
util.AddNetworkString("wblplyhasweapon")
util.AddNetworkString("wblplyhasweaponinsameid")
util.AddNetworkString("wblplynomoney")
util.AddNetworkString("wblplyboughtweapon")
util.AddNetworkString("wblplybought10hp")
util.AddNetworkString("wblplybought25hp")
util.AddNetworkString("wblplyboughthpsound")
util.AddNetworkString("wblplyhasmaxhp")
util.AddNetworkString("wblplybought10ap")
util.AddNetworkString("wblplybought25ap")
util.AddNetworkString("wblplyboughtapsound")
util.AddNetworkString("wblplyhasmaxap")
util.AddNetworkString("wblplybought1primeammo")
util.AddNetworkString("wblplyboughtfullprimeammo")
util.AddNetworkString("wblplyhasmaxprimeammo")
util.AddNetworkString("wblplyboughtpasound")
util.AddNetworkString("wblplybought1secammo")
util.AddNetworkString("wblplyboughtfullsecammo")
util.AddNetworkString("wblplyhasmaxsecammo")
util.AddNetworkString("wblplyboughtsasound")
util.AddNetworkString("wblplynoammotypesound")
util.AddNetworkString("wblplynoammotypesoundC")
util.AddNetworkString("wblplydontknowweaponsound")

util.AddNetworkString("wblreqcurrentlyheld")
util.AddNetworkString("wblsendcurrentlyheld")
util.AddNetworkString("wblreqFormAmmotype")
util.AddNetworkString("wblsendFormAmmotype")


util.AddNetworkString("wblreqAmmotype")
util.AddNetworkString("wblsendAmmotype")
util.AddNetworkString("wblreqAmmotype1")
util.AddNetworkString("wblsendAmmotype1")


util.AddNetworkString("wblreqdeleteweaponToS")
util.AddNetworkString("wblreqChangenameweaponToS")
util.AddNetworkString("wblreqChangearsweaponToS")
util.AddNetworkString("wblreqChangecostweaponToS")
util.AddNetworkString("wblreqChangeslotweaponToS")
util.AddNetworkString("wblreqChangecatweaponToS")
util.AddNetworkString("wblreqChangesellvalweaponToS")
util.AddNetworkString("wblreqChangesellableweaponToS")
util.AddNetworkString("wblreqChangeDescweaponToS")

util.AddNetworkString("wblreqChangenameammoToS")
util.AddNetworkString("wblreqChangepriceammoToS")
util.AddNetworkString("wblreqChangeqtyammoToS")
util.AddNetworkString("wblreqChangemaxqtyammoToS")
util.AddNetworkString("wblreqdeleteammoToS")
util.AddNetworkString("wblreqMoveupweapon")
util.AddNetworkString("wblreqMovedownweapon")


util.AddNetworkString("wblResettodefaultpriceAPHP")
util.AddNetworkString("wbl10hpprice")
util.AddNetworkString("wbl25hpprice")
util.AddNetworkString("wbl10apprice")
util.AddNetworkString("wbl25apprice")
util.AddNetworkString("wblonlyweaponsound")
util.AddNetworkString("wblupdatepriceClientRequest")
util.AddNetworkString("wblupdatepricetoClient")

util.AddNetworkString("wblSellweapon")
util.AddNetworkString("wblSellweaponsound")
util.AddNetworkString("wblNoWeaponsound")
util.AddNetworkString("wblonlyweaponsound")
util.AddNetworkString("wblbutton1soundother")


util.AddNetworkString("wblweaponlist")
util.AddNetworkString("wblammolist")

util.AddNetworkString("wblreqlowestcostarrange")


util.AddNetworkString("wblReqWeaponAmmoPresetListToS")
util.AddNetworkString("wblReqWeaponAmmoPresetListToC")
util.AddNetworkString("wblSaveWeaponlistPresetToS")
util.AddNetworkString("wblLoadWeaponlistPresetToS")
util.AddNetworkString("wblDeleteWeaponlistPresetToS")
util.AddNetworkString("wblSaveSelectedWeaponlistPresetToS")
util.AddNetworkString("wblLoadSelectedWeaponlistPresetToS")
util.AddNetworkString("wblLoadSelectedWeaponlistPresetToC")
once = 1
local remammo1
local remammo2
local remweapon
wblBuying = false
-- for Debugging (START) --

-- for Debugging (END) --

function changeMoney(player,amount)
	if amount == 0 then -- called via sync_user, which really shouldn't happen in this context but it does so anyways so AAAAAAAAAAAAAAAAAAAAA
		local old = player:GetPData("wblmoneyOld",player:GetPData("wblmoney",-1))
		local cur = player:GetPData("wblmoney",-1)
		if old == -1 then
			print("Someone's old *and* current money was corrupted. Ignoring!")
		elseif old == cur then
			print("Old data was corrupted, or nothing changed. Re-syncing old data just in case.")
			player:SetPData("wblmoneyOld",old)
		else -- the intentional bit.
			if old < cur then
				net.Start("plyMonzupdateToC")
				net.WriteInt(new, 32)
				net.WriteInt(new-old, 32)
				net.Send(player)
			else
				net.Start("plyMonzupdateToCLose")
				net.WriteInt(new, 32)
				net.WriteInt(old-new, 32)
				net.Send(player)
			end
		end
	else -- not called via sync_user, time to handle money.
		local old = player:GetPData("wblmoneyOld",player:GetPData("wblmoney",-1))
		local cur = player:GetPData("wblmoney",-1)
		cur = cur + amount
		cur = math.ceil( cur )
		local maxmonz = tonumber(wblmonmax:GetInt())
		if cur < 0 then
			player:SetPData( "wblmoney", 0 ) 
			cur = 0
		elseif cur > maxmonz then
			player:SetPData( "wblmoney", maxmonz )
			cur = maxmonz
		else
			player:SetPData( "wblmoney", cur ) 
		end
		player:SetPData("wblmoneyOld",cur)
		local diff = cur - old
		if (diff > 0) and (cur <= maxmonz) then
			wblDebug("Executed 1")
			net.Start("plyMonzupdateToC")
			net.WriteInt(cur, 32)
			net.WriteInt(diff, 32)
			net.Send(player)
		elseif diff < 0 then
			wblDebug("Executed 2")
			amount = (amount)*(-1)
			net.Start("plyMonzupdateToCLose")
			net.WriteInt(cur, 32)
			net.WriteInt(diff, 32)
			net.Send(player)
		end
	end
end

--[[
local wblweaponlist = {
    {
        name = "Tier 1",
        weapons = {
            {name = "Flaregun", Arsenaltype = "W", class = "weapon_rtbr_flaregun", cost = 300, sellvalue  = 150, sellable  = true, slotid = "N.A.", ammo1 = "Flare shots", ammo2 = "N.A.", desc = "The flaregun launches heavy\narcing projectiles that explode on\nimpact, igniting the ground and\ncreating a persistent fire hazard."}, 
            {name = "Assault Rifle Mk1", Arsenaltype = "W", class = "weapon_rtbr_akm", cost = 400, sellvalue  = 200, sellable  = true, slotid = "AR", ammo1 = "AKM Rounds", ammo2 = "N.A.", desc = "This conventional assault rifle\nfires high-velocity rounds with\nreliable accuracy, offering a balanced\nmix of firepower and versatility for\neffective combat in various\nsituations"}, 
            {name = "Grenade Mk1", Arsenaltype = "C", class = "weapon_rtbr_frag", cost = 500, sellvalue  = 250, sellable  = true, slotid = "Grenade", ammo1 = "Grenade", ammo2 = "N.A.", desc = "KABOOM!"},
            {name = "Grenade Mk2", Arsenaltype = "C", class = "weapon_rtbr_frag", cost = 5000, sellvalue  = 250, sellable  = true, slotid = "Grenade", ammo1 = "Grenade", ammo2 = "N.A.", desc = "KABOOM!"},
            {name = "Grenade Mk3", Arsenaltype = "C", class = "weapon_rtbr_frag", cost = 100, sellvalue  = 250, sellable  = true, slotid = "Grenade", ammo1 = "Grenade", ammo2 = "N.A.", desc = "KABOOM!"},
            {name = "Grenade Mk4", Arsenaltype = "C", class = "weapon_rtbr_frag", cost = 500, sellvalue  = 250, sellable  = true, slotid = "Grenade", ammo1 = "Grenade", ammo2 = "N.A.", desc = "KABOOM!"},
            {name = "Grenade Mk5", Arsenaltype = "C", class = "weapon_rtbr_frag", cost = 645, sellvalue  = 250, sellable  = true, slotid = "Grenade", ammo1 = "Grenade", ammo2 = "N.A.", desc = "KABOOM!"},
            {name = "Grenade Mk6", Arsenaltype = "C", class = "weapon_rtbr_frag", cost = 500, sellvalue  = 250, sellable  = true, slotid = "Grenade", ammo1 = "Grenade", ammo2 = "N.A.", desc = "KABOOM!"},
            {name = "Grenade Mk7", Arsenaltype = "C", class = "weapon_rtbr_frag", cost = 2222, sellvalue  = 250, sellable  = true, slotid = "Grenade", ammo1 = "Grenade", ammo2 = "N.A.", desc = "KABOOM!"},
            {name = "Assault Rifle Mk2", Arsenaltype = "W", class = "weapon_rtbr_oicw", cost = 800, sellvalue  = 400, sellable  = true, slotid = "AR", ammo1 = "OICW Rounds", ammo2 = "SMG Grenade", desc = "Better Ak47s.. For everyone!"}, 
        }
    },
    {
        name = "Tier 2",
        weapons = {
            {name = "Rocket Launcher", Arsenaltype = "W", class = "ez2cwep_rpg", cost = 1000, sellvalue  = 300, sellable  = true, slotid = "Projectile Explosives", ammo1 = "Rockets", ammo2 = "N.A.", desc = "ROCKET NYOOM"}, 
            {name = "Assault Rifle Mk2", Arsenaltype = "W", class = "weapon_rtbr_oicw", cost = 800, sellvalue  = 400, sellable  = true, slotid = "AR", ammo1 = "OICW Rounds", ammo2 = "SMG Grenade", desc = "Better Ak47s.. For everyone!"}, 
            {name = "Grenade Mk2", Arsenaltype = "C", class = "weapon_frag", cost = 10, sellvalue  = 500, sellable  = true, slotid = "Grenade", ammo1 = "Grenade", ammo2 = "N.A.", desc = "MORE KABOOM!"}
        }
    },
}

local wblammolist = {
            {name = "Pistol Rounds", class = "Pistol", price = 10, quantity = 15, maxquantity = 150}, 
            {name = "OICW Rounds", class = "rtbr_oicw", price = 40, quantity = 30, maxquantity = 90},
            {name = "Flare shots", class = "rtbr_flare", price = 200, quantity = 1, maxquantity = 12},
            {name = "Rockets", class = "RPG_Round", price = 250, quantity = 1, maxquantity = 3},
            {name = "SMG Grenade", class = "SMG1_Grenade", price = 250, quantity = 1, maxquantity = 3},
            {name = "AKM Rounds", class = "rtbr_akm", price = 35, quantity = 30, maxquantity = 90}
}
]]

wblweaponlisthl2tiered = {
  {
    name = "Tier 1",
    weapons = {
      {
        ammo1 = "N.A.",
        sellable = true,
        class = "weapon_crowbar",
        desc = "A versatile melee weapon, favored for its simplicity and effectiveness that you would feel like taking on an entire alien army.",
        ammo2 = "N.A.",
        slotid = "Melee",
        sellvalue = 0,
        name = "Crowbar",
        Arsenaltype = "W",
        cost = 0
      },
      {
        ammo1 = "N.A.",
        sellable = true,
        class = "weapon_rtbr_frag",
        sellvalue = 75,
        ammo2 = "N.A.",
        slotid = "Explosives",
        desc = "This frag grenade features a timed fuse mechanism, allowing the user to prime it and set a delayed  explosion for precise detonation after throwing.",
        Arsenaltype = "C",
        name = "Frag Grenade",
        cost = 150
      },
      {
        ammo1 = "Pistol Rounds",
        sellable = true,
        class = "weapon_pistol",
        sellvalue = 200,
        ammo2 = "N.A.",
        slotid = "Pistol",
        desc = "A reliable semi-automatic fire pisto with moderate damage and accuracy, making it a versatile sidearm for medium-range encounters.",
        Arsenaltype = "W",
        name = "Pistol",
        cost = 400
      },
      {
        ammo1 = "Revolver Rounds",
        sellable = true,
        class = "weapon_357",
        desc = "A high-powered, precision weapon capable of delivering devastating damage with a single shot, making it ideal for taking down tougher enemies at long range.",
        ammo2 = "N.A.",
        slotid = "Revolver",
        sellvalue = 450,
        name = "Revolver",
        Arsenaltype = "W",
        cost = 900
      },
      {
        ammo1 = "SMG Rounds",
        sellable = true,
        class = "weapon_smg1",
        sellvalue = 550,
        ammo2 = "SMG Grenade",
        slotid = "SMG",
        desc = "This standard-issue SMG features a built-in grenade launcher, offering a balanced blend of rapid-fire precision and explosive versatility for diverse combat situations.",
        Arsenaltype = "W",
        name = "SMG",
        cost = 1100
      },
      {
        ammo1 = "Flare Shots",
        sellable = true,
        class = "weapon_rtbr_flaregun",
        sellvalue = 600,
        ammo2 = "N.A.",
        slotid = "Explosives",
        desc = "The flaregun launches heavy arcing projectiles that explode on impact, igniting the ground and creating a persistent fire hazard.",
        Arsenaltype = "W",
        name = "Flare Gun",
        cost = 1200
      },
      {
        ammo1 = "Bolts",
        sellable = true,
        class = "weapon_crossbow",
        desc = "The crossbow fires red-hot, steel rebar with pinpoint accuracy, allowing for powerful, long-range shots that can impale enemies to surfaces.",
        ammo2 = "N.A.",
        slotid = "Crossbow",
        sellvalue = 650,
        name = "Crossbow",
        Arsenaltype = "W",
        cost = 1300
      },
      {
        ammo1 = "Shotgun Rounds",
        sellable = true,
        class = "weapon_shotgun",
        desc = "The shotgun delivers devastating close-range firepower with a wide spread, making it highly effective at close quarters.",
        ammo2 = "N.A.",
        slotid = "Shotgun",
        sellvalue = 700,
        name = "Shotgun",
        Arsenaltype = "W",
        cost = 1400
      },
      {
        ammo1 = "AKM Rounds",
        sellable = true,
        class = "weapon_rtbr_akm",
        sellvalue = 750,
        ammo2 = "N.A.",
        slotid = "Assault Rifle",
        desc = "This conventional assault rifle fires high-velocity rounds with reliable accuracy, offering a balanced mix of firepower and versatility for effective combat in various situations.",
        Arsenaltype = "W",
        name = "AKM",
        cost = 1500
      }
    }
  },
  {
    name = "Tier 2",
    weapons = {
      {
        ammo1 = "N.A.",
        sellable = true,
        class = "weapon_frag",
        sellvalue = 80,
        ammo2 = "N.A.",
        slotid = "Explosives",
        desc = "This high-explosive grenade starts its timer when thrown, making it less versatile for timing but delivering significantly greater damage.",
        Arsenaltype = "C",
        name = "HE Grenade",
        cost = 160
      },
      {
        ammo1 = "N.A.",
        sellable = true,
        class = "weapon_rtbr_crowbar",
        desc = "The enhanced version improves alloy construction and have a reinforced design, allowing it to deliver increased damage with every strike through enhanced impact resistance.",
        ammo2 = "N.A.",
        slotid = "Melee",
        sellvalue = 250,
        name = "Enhanced Crowbar",
        Arsenaltype = "W",
        cost = 500
      },
      {
        ammo1 = "Pistol Rounds",
        sellable = true,
        class = "weapon_rtbr_pistol",
        sellvalue = 425,
        ammo2 = "N.A.",
        slotid = "Pistol",
        desc = "Utilizing reinforced ammunition, the burst pistol delivers more powerful shots with each trigger pull but features a slower primary fire rate; its alternate fire also includes a double-shot burst mode.",
        Arsenaltype = "W",
        name = "Burst Pistol",
        cost = 850
      },
      {
        ammo1 = "Bolts",
        sellable = true,
        class = "ez2cwep_crossbow",
        sellvalue = 900,
        ammo2 = "N.A.",
        slotid = "Crossbow",
        desc = "This crossbow features a reinforced auto-tensioning system, reducing reload time while maintaining the devastating power of its red-hot, steel rebar projectiles.",
        Arsenaltype = "W",
        name = "Rapidshot Crossbow",
        cost = 1800
      },
      {
        ammo1 = "Revolver Rounds",
        sellable = true,
        class = "weapon_rtbr_357",
        desc = "The Mk2 Revolver delivers enhanced damage with each shot, featuring a refined firing mechanism for increased stopping power and effectiveness in combat.",
        ammo2 = "N.A.",
        slotid = "Revolver",
        sellvalue = 950,
        name = "Revolver Mk2",
        Arsenaltype = "W",
        cost = 1900
      },
      {
        ammo1 = "SMG Rounds",
        sellable = true,
        class = "weapon_rtbr_smg1",
        sellvalue = 1050,
        ammo2 = "N.A.",
        slotid = "SMG",
        desc = "By sacrificing its grenade launcher, this SMG uses a high-pressure firing system that amplifies bullet armor penetration, delivering significantly stronger damage per shot.",
        Arsenaltype = "W",
        name = "Breaker SMG",
        cost = 2100
      },
      {
        ammo1 = "OICW Rounds",
        sellable = true,
        class = "weapon_rtbr_oicw",
        sellvalue = 1250,
        ammo2 = "SMG Grenade",
        slotid = "Assault Rifle",
        desc = "This enhanced assault rifle combines powerful shots with adaptable functionality, featuring a dual-shot grenade launcher that can fire two grenades before reloading.",
        Arsenaltype = "W",
        name = "XM29 OICW",
        cost = 2500
      },
      {
        ammo1 = "Shotgun Rounds",
        sellable = true,
        class = "ez2cwep_shotgun",
        desc = "Riot shotgun incorporates a reinforced double-barrel mechanism with upgraded blast chambers, providing a more potent secondary fire with amplified damage and precision spread.",
        ammo2 = "N.A.",
        slotid = "Shotgun",
        sellvalue = 1300,
        name = "Riot Shotgun",
        Arsenaltype = "W",
        cost = 2600
      },
      {
        ammo1 = "Rockets",
        sellable = true,
        class = "ez2cwep_rpg",
        desc = "This rocket launcher fires fast-moving, unguided rockets that rely on explosive force rather than propulsion, delivering immediate impact without tracking capabilities.",
        ammo2 = "N.A.",
        slotid = "Launcher",
        sellvalue = 1350,
        name = "Rocket Launcher",
        Arsenaltype = "W",
        cost = 2700
      },
      {
        ammo1 = "Pulse Rounds",
        sellable = true,
        class = "weapon_ar2",
        desc = "A energy-based assault rifle equipped with a secondary fire that launches devastating dark energy orbs, capable of disintegrating enemies on impact.",
        ammo2 = "Energy Charges",
        slotid = "Assault Rifle",
        sellvalue = 1400,
        name = "Pulse Rifle",
        Arsenaltype = "W",
        cost = 2800
      }
    }
  },
  {
    name = "Tier 3",
    weapons = {
      {
        ammo1 = "N.A.",
        sellable = true,
        class = "weapon_slam",
        desc = "The Selectable Lightweight Attack Munition is adual-purpose explosive that can set deadly tripwires or detonate remotely, making it ideal for controlling the battlefield and ambushing foes.",
        ammo2 = "N.A.",
        slotid = "Explosives",
        sellvalue = 125,
        name = "S.L.A.M.",
        Arsenaltype = "C",
        cost = 250
      },
      {
        ammo1 = "N.A.",
        sellable = true,
        class = "weapon_rtbr_stunstick",
        sellvalue = 500,
        ammo2 = "N.A.",
        slotid = "Melee",
        desc = "This stunstick delivers more damage with a slower firing rate and can be charged up to unleash a powerful electrical surge for heavy damage.",
        Arsenaltype = "W",
        name = "Stun Baton",
        cost = 1000
      },
      {
        ammo1 = "Pistol Rounds",
        sellable = true,
        class = "ez2cwep_pistol",
        sellvalue = 950,
        ammo2 = "N.A.",
        slotid = "Pistol",
        desc = "The Mk2 pistol features an upgraded frame that overcharges rounds, delivering devastating firepower with each shot, capable dealing massive damage to any target.",
        Arsenaltype = "W",
        name = "Pistol Mk2",
        cost = 1900
      },
      {
        ammo1 = "Pistol Rounds",
        sellable = true,
        class = "weapon_rtbr_alyxgun",
        sellvalue = 1750,
        ammo2 = "N.A.",
        slotid = "Pistol",
        desc = "The Alyx gun, with its advanced rapid-fire system, consumes ammunition rapidly but delivers high DPS.",
        Arsenaltype = "W",
        name = "Alyx's Gun",
        cost = 3500
      },
      {
        ammo1 = "Revolver Rounds",
        sellable = true,
        class = "ez2cwep_magnum",
        desc = " Delivering unmatched damage with high-caliber rounds, the Mk3 revolver makes every shot devastatingly powerful.",
        ammo2 = "N.A.",
        slotid = "Revolver",
        sellvalue = 2000,
        name = "Revolver Mk3",
        Arsenaltype = "W",
        cost = 4000
      },
      {
        ammo1 = "SMG Rounds",
        sellable = true,
        class = "ez2cwep_smg",
        sellvalue = 2250,
        ammo2 = "SMG Grenade",
        slotid = "SMG",
        desc = "SMG Mk2 boasts upgraded ballistic chambers for intensified bullet impact and an optimized grenade launcher with accelerated rechambering.",
        Arsenaltype = "W",
        name = "SMG Mk2",
        cost = 4500
      },
      {
        ammo1 = "Bolts",
        sellable = true,
        class = "weapon_rtbr_steambow",
        sellvalue = 2500,
        ammo2 = "N.A.",
        slotid = "Crossbow",
        desc = "The Steambow allows it to fire two bolts in rapid succession before reloading, secondary mode launches an unstable charged bolt that pulsates waves of energy that deals continuous damage.",
        Arsenaltype = "W",
        name = "Steambow",
        cost = 5000
      },
      {
        ammo1 = "Shotgun Rounds",
        sellable = true,
        class = "weapon_rtbr_shotgun",
        sellvalue = 2600,
        ammo2 = "N.A.",
        slotid = "Shotgun",
        desc = "Delivers greater damage with a full-auto secondary fire mode, the assault variation replaces the double-barrel function for rapid, sustained firepower.",
        Arsenaltype = "W",
        name = "Assault Shotgun",
        cost = 5100
      },
      {
        ammo1 = "Rockets",
        sellable = true,
        class = "weapon_rpg",
        sellvalue = 2600,
        ammo2 = "N.A.",
        slotid = "Launcher",
        desc = "The RPG fires slower, guided rockets with propulsion capabilities, allowing for more accurate strikes over longer distances.",
        Arsenaltype = "W",
        name = "RPG",
        cost = 5200
      },
      {
        ammo1 = "Pulse Rounds",
        sellable = true,
        class = "ez2cwep_ar2",
        sellvalue = 2750,
        ammo2 = "Energy Charges",
        slotid = "Assault Rifle",
        desc = "Now outfitted with upgraded pulse modulators, the Mk2 boosts the damage output of its primary fire and dark energy orbs.",
        Arsenaltype = "W",
        name = "Pulse Rifle Mk2",
        cost = 5500
      }
    }
  },
  {
    name = "Tier 4",
    weapons = {
      {
        ammo1 = "N.A.",
        sellable = true,
        class = "weapon_zbase_xengrenade_improved",
        desc = "The Xen grenade generates a black hole upon detonation that sucks in objects and enemies (and you), then disperses them by spawning random entities in their place.",
        ammo2 = "N.A.",
        slotid = "Explosives",
        sellvalue = 400,
        name = "Xen Grenade",
        Arsenaltype = "C",
        cost = 800
      },
      {
        ammo1 = "Revolver Rounds",
        sellable = true,
        class = "weapon_rtbr_annabelle",
        desc = "The Anabelle features slightly lower damage compared to the Mk3 revolver but compensates with its full-auto capability and lever-action design, offering rapid fire and sustained firepower.",
        ammo2 = "N.A.",
        slotid = "Revoler",
        sellvalue = 3000,
        name = "Annabelle",
        Arsenaltype = "W",
        cost = 6000
      },
      {
        ammo1 = "Recharging Pulse",
        sellable = true,
        class = "ez2cwep_pulse_pistol",
        desc = "The pulse pistol boasts unlimited ammo and a charge-up feature, delivering immensely powerful energy blasts with each shot, making it a formidable weapon for any combat situation.",
        ammo2 = "N.A.",
        slotid = "Pistol",
        sellvalue = 3500,
        name = "Pulse Pistol",
        Arsenaltype = "W",
        cost = 7000
      },
      {
        ammo1 = "Pistol Rounds",
        sellable = true,
        class = "ez2cwep_mp5",
        desc = "This SMG trades its grenade launcher for a burst-fire mode, utilizing pistol ammo to deliver incredible damage per second with relentless precision",
        ammo2 = "N.A.",
        slotid = "SMG",
        sellvalue = 4000,
        name = "Blitz SMG",
        Arsenaltype = "W",
        cost = 8000
      },
      {
        ammo1 = "Uranium Rounds",
        sellable = true,
        class = "weapon_rtbr_gauss",
        desc = " Fires a high-powered, charged energy beam with precision, capable of penetrating multiple targets and delivering devastating damage when fully charged.",
        ammo2 = "N.A.",
        slotid = "Experimental",
        sellvalue = 4500,
        name = "Tau Cannon",
        Arsenaltype = "W",
        cost = 9000
      },
      {
        ammo1 = "Pulse Rounds",
        sellable = true,
        class = "ez2cwep_ar2_proto",
        desc = "Provides an enhanced primary fire with advanced power modulation, while its secondary mode uses an experimental tri-phasic energy emitter to discharge three high-velocity dark energy orbs.",
        ammo2 = "Energy Charges",
        slotid = "Assault Rifle",
        sellvalue = 5000,
        name = "Prototype Pulse Rifle",
        Arsenaltype = "W",
        cost = 10000
      }
    }
  }
}


wblammolisthl2tiered = { 
    {
        maxquantity = 150.0,
        price = 8.0,
        quantity = 15.0,
        class = "Pistol",
        name = "Pistol Rounds"
    },
    {
        maxquantity = 18.0,
        price = 80.0,
        quantity = 6.0,
        class = "357",
        name = "Revolver Rounds"
    },
    {
        maxquantity = 225.0,
        price = 15.0,
        quantity = 25.0,
        class = "SMG1",
        name = "SMG Rounds"
    },
    {
        maxquantity = 5.0,
        price = 200.0,
        quantity = 1.0,
        class = "SMG1_Grenade",
        name = "SMG Grenade"
    },
    {
        maxquantity = 12.0,
        price = 100.0,
        quantity = 1.0,
        class = "rtbr_flare",
        name = "Flare Shots"
    },
    {
        maxquantity = 10.0,
        price = 30.0,
        quantity = 1.0,
        class = "XBowBolt",
        name = "Bolts"
    },
    {
        maxquantity = 30.0,
        price = 60.0,
        quantity = 6.0,
        class = "Buckshot",
        name = "Shotgun Rounds"
    },
    {
        maxquantity = 210.0,
        price = 35.0,
        quantity = 30.0,
        class = "rtbr_akm",
        name = "AKM Rounds"
    },
    {
        maxquantity = 90.0,
        price = 40.0,
        quantity = 30.0,
        class = "rtbr_oicw",
        name = "OICW Rounds"
    },
    {
        maxquantity = 3.0,
        price = 150.0,
        quantity = 1.0,
        class = "RPG_Round",
        name = "Rockets"
    },
    {
        maxquantity = 60.0,
        price = 60.0,
        quantity = 30.0,
        class = "AR2",
        name = "Pulse Rounds"
    },
    {
        maxquantity = 3.0,
        price = 300.0,
        quantity = 1.0,
        class = "AR2AltFire",
        name = "Energy Charges"
    },
    {
        maxquantity = 0.0,
        price = 0.0,
        quantity = 0.0,
        class = "AirboatGun",
        name = "Recharging Pulse"
    },
    {
        maxquantity = 100.0,
        price = 100.0,
        quantity = 20.0,
        class = "Uranium",
        name = "Uranium Rounds"
    }
}



HP10price = nil
HP25price = nil
AP10price = nil
AP25price = nil
defaultsellvalue = nil

wblmonsmallhealthprice = CreateConVar( "wblmoney_money_smallhealthprice", 100, FCVAR_ARCHIVE, "100", 0, math.huge )
cvars.AddChangeCallback("wblmoney_money_smallhealthprice", function(convar_name, old_value, new_value)
    HP10price = tonumber(new_value)
end)

wblmonlargehealthprice = CreateConVar( "wblmoney_money_largehealthprice", 200, FCVAR_ARCHIVE, "200", 0, math.huge )
cvars.AddChangeCallback("wblmoney_money_largehealthprice", function(convar_name, old_value, new_value)
    HP25price = tonumber(new_value)
end)

wblmonsmallarmorprice = CreateConVar( "wblmoney_money_smallarmorprice", 50, FCVAR_ARCHIVE, "50", 0, math.huge )
cvars.AddChangeCallback("wblmoney_money_smallarmorprice", function(convar_name, old_value, new_value)
    AP10price = tonumber(new_value)
end)

wblmonlargearmorprice = CreateConVar( "wblmoney_money_largearmorprice", 100, FCVAR_ARCHIVE, "100", 0, math.huge )
cvars.AddChangeCallback("wblmoney_money_largearmorprice", function(convar_name, old_value, new_value)
    AP25price = tonumber(new_value)
end)

wblmonsellvaluedefault = CreateConVar( "wblmoney_money_defaultsellvalue", 200, FCVAR_ARCHIVE, "200", 0, math.huge )
cvars.AddChangeCallback("wblmoney_money_defaultsellvalue", function(convar_name, old_value, new_value)
    defaultsellvalue = tonumber(new_value)
end)

wblmonsellonlylisted = CreateConVar( "wblmoney_money_sellonlylisted", 0, FCVAR_ARCHIVE, "0", 0, 1 )

wblmonignoreslotid = CreateConVar( "wblmoney_money_ignoreslotidinshop", 0, FCVAR_ARCHIVE, "0", 0, 1 )
cvars.AddChangeCallback("wblmoney_money_ignoreslotidinshop", function(convar_name, old_value, new_value)
    wblDebug("wblmoney_money_ignoreslotidinshop changed")
    wblDebug("new_value changed: "..tonumber(new_value))
    if tonumber(new_value) == 1 then
        RunConsoleCommand("wblmoney_campaignmode_Disablepickupsameslotid", 0)
    end
end)

HP10price = tonumber(wblmonsmallhealthprice:GetInt())
HP25price = tonumber(wblmonlargehealthprice:GetInt())
AP10price = tonumber(wblmonsmallarmorprice:GetInt())
AP25price = tonumber(wblmonlargearmorprice:GetInt())
defaultsellvalue = tonumber(wblmonsellvaluedefault:GetInt())
weapsellvalue = defaultsellvalue
weapsellvaluetosend = tostring(defaultsellvalue)
ammo1pricedefault = 25
ammo1price = ammo1pricedefault
ammo2pricedefault = 200
ammo2price = ammo2pricedefault


--FUNCTIONS TO MAKE YOUR OWN TABLE STAART--
--FUNCTIONS TO MAKE YOUR OWN TABLE STAART--
--FUNCTIONS TO MAKE YOUR OWN TABLE STAART--
--FUNCTIONS TO MAKE YOUR OWN TABLE STAART--

--local wblweaponlist = {}
--local wblammolist = {}

local function AddAmmo(ammoName, ammoClass, price, quantity, maxQuantity)
    table.insert(wblammolist, {
        name = ammoName,
        class = ammoClass,
        price = price,
        quantity = quantity,
        maxquantity = maxQuantity
    })
end

local function AddWeapon(tierName, weaponName, arsenalType, class, cost, sellValue, sellable, slotId, ammo1, ammo2, desc)
    -- Find or create the tier
    local tierExists = false
    for _, tier in ipairs(wblweaponlist) do
        if tier.name == tierName then
            -- Add weapon to the existing tier
            table.insert(tier.weapons, {
                name = weaponName,
                Arsenaltype = arsenalType,
                class = class,
                cost = cost,
                sellvalue = sellValue,
                sellable = sellable,
                slotid = slotId,
                ammo1 = ammo1,
                ammo2 = ammo2,
                desc = desc
            })
            tierExists = true
            break
        end
    end

    -- If the tier doesn't exist, create it and add the weapon
    if not tierExists then
        table.insert(wblweaponlist, {
            name = tierName,
            weapons = {
                {
                    name = weaponName,
                    Arsenaltype = arsenalType,
                    class = class,
                    cost = cost,
                    sellvalue = sellValue,
                    sellable = sellable,
                    slotid = slotId,
                    ammo1 = ammo1,
                    ammo2 = ammo2,
                    desc = desc
                }
            }
        })
    end
end

local function SpawnWeapononme(ply, weaponClass)
    -- Create the weapon entity
    local weapon = ents.Create(weaponClass)
    
    -- Check if the weapon entity was created successfully
    if IsValid(weapon) then
        -- Get the player's position and forward direction
        local playerPos = ply:GetPos()
        local playerForward = ply:GetForward()  -- Get the player's forward vector
        
        -- Set the weapon's position to be in front of the player, at a distance of 15 units (adjust as needed)
        local spawnDistance = 45  -- Distance in units to spawn the weapon in front of the player
        weapon:SetPos(playerPos + playerForward * spawnDistance + Vector(0, 0, 45))  -- Adjust Z offset for visibility

        -- Spawn the weapon entity
        weapon:Spawn()

        -- Optionally, you can make the weapon ownership transfer to the player
        -- weapon:SetOwner(ply)

        wblDebug("Weapon spawned in front of the player.")
    else
        wblDebug("Failed to create the weapon entity.")
    end
end

local function GiveWeaponToPlayer(ply, weaponClass)
    -- Attempt to give the weapon using the VJ base method
    if ply:Give(weaponClass) then
        wblDebug("Weapon given successfully.")

        -- Set a timer to check the player's inventory after 0.1 seconds
        timer.Simple(0.1, function()
            -- Check if the player has the weapon in their inventory
            if ply:HasWeapon(weaponClass) then
                wblDebug("Player has the weapon in inventory.")
            else
                wblDebug("Player does not have the weapon. Spawning it instead.")
                -- If the player does not have the weapon, spawn it
                SpawnWeapononme(ply, weaponClass)
            end
        end)
    else
        wblDebug("Failed to give the weapon directly. Spawning it instead.")
        -- If giving the weapon fails, try spawning the weapon entity directly
        SpawnWeapononme(ply, weaponClass)
    end
end

local WeaponAmmoPresetList = {}

local function SaveStringToFile(fileNamee, str)
    local folderPath = "weshop"
    
    -- Ensure the file name ends with ".txt"
    local fullFileName = fileNamee .. ".txt"
    
    -- Create the folder if it doesn't exist
    if not file.Exists(folderPath, "DATA") then
        file.CreateDir(folderPath)
    end
    
    -- Save the string to the file inside the weshop folder
    if fullFileName and str then
        file.Write(folderPath .. "/" .. fullFileName, str)
        wblDebug("String saved to file: " .. folderPath .. "/" .. fullFileName)
    else
        wblDebug("Invalid file name or string.")
    end
end


local function LoadStringFromFile(fileNamee)
    local folderPath = "weshop"
    
    -- Ensure the file name ends with ".txt"
    local fullFileName = fileNamee .. ".txt"
    
    -- Create the full path with the folder and file name
    local fullPath = folderPath .. "/" .. fullFileName
    
    -- Check if the file exists
    if file.Exists(fullPath, "DATA") then
        local loadedString = file.Read(fullPath, "DATA")
        return loadedString
    else
        return "Default" -- Return "Default" if the file does not exist
    end
end


local function SaveTableToFile(filefolder, tableToSave, PresetName)
    -- Define the directory and file path with PresetName
    local dirPath = "weshop/" .. filefolder
    local filePath = dirPath .. "/" .. PresetName .. ".txt"

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

local function LoadTableFromFile(filefolder, PresetName)
    -- Define the directory and file path with PresetName
    local dirPath = "weshop/" .. filefolder
    local filePath = dirPath .. "/" .. PresetName .. ".txt"

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

local function DeleteFile(filefolder, PresetName)
    -- Define the directory and file path with PresetName
    local dirPath = "weshop/" .. filefolder
    local filePath = dirPath .. "/" .. PresetName .. ".txt"

    -- Check if the file exists before attempting to delete it
    if file.Exists(filePath, "DATA") then
        file.Delete(filePath)  -- Delete the file
        wblDebug("File deleted successfully: " .. filePath)
    else
        wblDebug("File does not exist: " .. filePath)
    end
end

function IsWeaponAvailable(weaponClass)
    local weaponList = weapons.GetList()
    for _, weapon in ipairs(weaponList) do
        if weapon.ClassName == weaponClass then
            return true
        end
    end
    return false
end

local function GetPresetListFromFolder(folder)
    local dirPath = "weshop/" .. folder
    local files, _ = file.Find(dirPath .. "/*.txt", "DATA")  -- Find all .txt files in the folder
    local PresetList
    if (IsWeaponAvailable("weapon_xengrenade") and IsWeaponAvailable("weapon_rtbr_alyxgun")) and (IsWeaponAvailable("ez2cwep_ar2_proto")) then
        PresetList = {"Default", "Half-Life 2 Tiered"}
    else
        PresetList = {"Default"}
    end
    -- Extract the filenames without the .txt extension and store them in PresetList
    for _, fileName in ipairs(files) do
        local presetName = string.StripExtension(fileName)  -- Remove the .txt extension
        table.insert(PresetList, presetName)
    end

    return PresetList  -- Return the table containing all preset names
end


local function SaveWeaponAmmotable(PresetName)
    SaveTableToFile("Weaponlist", wblweaponlist, PresetName)
    SaveTableToFile("Ammolist", wblammolist, PresetName)
end

local function LoadWeaponAmmotable(PresetName)
    wblweaponlist = LoadTableFromFile("Weaponlist", PresetName)
    wblammolist = LoadTableFromFile("Ammolist", PresetName)
end

local function UpdateWeaponAmmolist()
    WeaponAmmoPresetList = GetPresetListFromFolder("Weaponlist")
    wblDebug("UpdateWeaponAmmolist function activated")
    --PrintTable(WeaponAmmoPresetList)
end

local function DeleteWeaponAmmotable(PresetName)
    DeleteFile("Weaponlist", PresetName)
    DeleteFile("Ammolist", PresetName)
    UpdateWeaponAmmolist()
end

function wblsortWeaponsByCost(wblweaponlist)
    for _, tier in ipairs(wblweaponlist) do
        table.sort(tier.weapons, function(a, b)
            return a.cost < b.cost
        end)
    end
end

UpdateWeaponAmmolist()

--[[

-- AddWeapon(tierName, weaponName, arsenalType, class, cost, sellValue, sellable, slotId, ammo1, ammo2, desc)
AddWeapon("Tier 1", "Flaregun", "W", "weapon_rtbr_flaregun", 300, 150, true, "N.A.", "Flare shots", "N.A.", "The flaregun launches heavy\narcing projectiles that explode on\nimpact, igniting the ground and\ncreating a persistent fire hazard.\nMy name is comrade general this is\nto make the description super long")
AddWeapon("Tier 1", "SMG", "W", "weapon_smg1", 300, 150, true, "SMG", "SMG Rounds", "SMG Grenade", "The SMUG DANCE")
AddWeapon("Tier 2", "Assault Rifle Mk1", "W", "weapon_rtbr_akm", 400, 200, true, "AR", "AKM Rounds", "N.A.", "This conventional assault rifle\nfires high-velocity rounds with\nreliable accuracy, offering a balanced\nmix of firepower and versatility for\neffective combat in various\nsituations.")
AddWeapon("Tier 3", "Rocket Launcher", "W", "ez2cwep_rpg", 600, 300, true, "Projectile Explosives", "Rockets", "N.A.", "ROCKET NYOOM")
AddWeapon("Tier 4", "OICW", "W", "weapon_rtbr_oicw", 600, 300, true, "AR", "OICW Rounds", "SMG Grenade", "ROCKET NYOOM")
AddWeapon("Tier 4", "Pulse", "W", "weapon_rtbr_oicw", 600, 300, true, "AR", "OICW Rounds", "SMG Grenade", "ROCKET NYOOM")

--AddAmmo(ammoName, ammoClass, price, quantity, maxQuantity)
AddAmmo("Flare shots", "rtbr_flare", 200, 1, 12)
AddAmmo("Pistol Rounds", "Pistol", 10, 15, 150)
AddAmmo("OICW Rounds", "rtbr_oicw", 10, 15, 150)
AddAmmo("SMG Grenade", "SMG1_Grenade", 250, 1, 3)
AddAmmo("AKM Rounds", "rtbr_akm", 25, 30, 90)
AddAmmo("SMG Rounds", "SMG1", 15, 25, 225)

PrintTable(wblweaponlist)
]]


--FUNCTIONS TO MAKE YOUR OWN TABLE STOP--
--FUNCTIONS TO MAKE YOUR OWN TABLE STOP--
--FUNCTIONS TO MAKE YOUR OWN TABLE STOP--
--FUNCTIONS TO MAKE YOUR OWN TABLE STOP--


function updatepricesinstore(ply)
    wblDebug("Updated the Prices in store (HP/AP/Default sell value)")
	net.Start("wblupdatepricetoClient")
	net.WriteInt(HP10price,32)
	net.WriteInt(HP25price,32)
	net.WriteInt(AP10price,32)
	net.WriteInt(AP25price,32)
	net.WriteString(tostring(weapsellvaluetosend))
	net.WriteString(tostring(ammo1price))
	net.WriteString(tostring(ammo2price))
	net.Send(ply)
end




function FindAmmoByName(ammoName)
    for _, ammo in ipairs(wblammolist) do
        if ammo.name == ammoName then
            wblDebug("ammoName: "..ammoName)
            return ammo -- Return the ammo entry if the name matches
        end
    end
    return nil -- Return nil if no match is found
end

local function FindAmmoByClass(ammoClass)
    for _, ammo in ipairs(wblammolist) do
        if ammo.class == ammoClass then
            return ammo -- Return the ammo entry if the class matches
        end
    end
    return nil -- Return nil if no match is found
end

local function FindWeaponByName(weaponName)
    for _, tier in ipairs(wblweaponlist) do
        for _, weapon in ipairs(tier.weapons) do
            if weapon.name == weaponName then
                return weapon -- Return the weapon if name matches
            end
        end
    end
    return nil -- Return nil if the weapon is not found
end

function FindWeaponByClass(weaponClass)
    for _, tier in ipairs(wblweaponlist) do
        for _, weapon in ipairs(tier.weapons) do
            if weapon.class == weaponClass then
                return weapon -- Return the weapon if class matches
            end
        end
    end
    return nil -- Return nil if the weapon is not found
end

local function FindWeaponBySlotId(slotId)
    for _, tier in ipairs(wblweaponlist) do
        for _, weapon in ipairs(tier.weapons) do
            if weapon.slotid == slotId then
                return weapon -- Return the weapon if slotid matches
            end
        end
    end
    return nil -- Return nil if the weapon is not found
end

local function FindWeaponByAmmo1(ammo1)
    for _, tier in ipairs(wblweaponlist) do
        for _, weapon in ipairs(tier.weapons) do
            if weapon.ammo1 == ammo1 then
                return weapon -- Return the weapon if ammo1 matches
            end
        end
    end
    return nil -- Return nil if no matching weapon is found
end

local function FindWeaponByAmmo2(ammo2)
    for _, tier in ipairs(wblweaponlist) do
        for _, weapon in ipairs(tier.weapons) do
            if weapon.ammo2 == ammo2 then
                return weapon -- Return the weapon if ammo2 matches
            end
        end
    end
    return nil -- Return nil if no matching weapon is found
end


local function RemoveWeaponByClass(weaponClass)
    -- Iterate through the tiers
    for tierIndex, tier in ipairs(wblweaponlist) do
        -- Iterate through the weapons in each tier
        for weaponIndex, weapon in ipairs(tier.weapons) do
            if weapon.class == weaponClass then
                -- Remove the weapon from the tier's weapon list
                table.remove(tier.weapons, weaponIndex)
                
                -- If the tier has no weapons left, remove the tier
                if #tier.weapons == 0 then
                    table.remove(wblweaponlist, tierIndex)
                end

                return true -- Successfully removed the weapon
            end
        end
    end

    return false -- Weapon not found
end

function RemoveAmmoByClass(ammoClass)
    for i, ammo in ipairs(wblammolist) do
        if ammo.class == ammoClass then
            table.remove(wblammolist, i)
            wblDebug("Ammo entry '" .. ammo.name .. "' has been deleted.")
            return
        end
    end
    wblDebug("Ammo entry with class '" .. ammoClass .. "' not found.")
end


local function ReplaceWeaponNameByClass(classname, newName)
    -- Loop through all tiers
    for _, tier in ipairs(wblweaponlist) do
        -- Loop through all weapons in the current tier
        for _, weapon in ipairs(tier.weapons) do
            -- Check if the weapon class matches the provided classname
            if weapon.class == classname then
                -- Replace the weapon's name
                weapon.name = newName
                return true  -- Return true once the weapon is found and updated
            end
        end
    end
    return false  -- Return false if the weapon class is not found
end


local function ReplaceWeaponCostByClass(classname, newCost)
    -- Loop through all tiers
    for _, tier in ipairs(wblweaponlist) do
        -- Loop through all weapons in the current tier
        for _, weapon in ipairs(tier.weapons) do
            -- Check if the weapon class matches the provided classname
            if weapon.class == classname then
                -- Replace the weapon's cost
                weapon.cost = newCost
                wblDebug("Weapon cost updated to: " .. newCost .. " for class: " .. classname)
                return true  -- Return true once the weapon is found and updated
            end
        end
    end
    wblDebug("Weapon with class " .. classname .. " not found.")
    return false  -- Return false if the weapon class is not found
end

local function ReplaceWeaponSlotIDByClass(classname, newSlotID)
    -- Loop through all tiers
    for _, tier in ipairs(wblweaponlist) do
        -- Loop through all weapons in the current tier
        for _, weapon in ipairs(tier.weapons) do
            -- Check if the weapon class matches the provided classname
            if weapon.class == classname then
                -- Replace the weapon's SlotID
                weapon.slotid = newSlotID
                wblDebug("Weapon SlotID updated to: " .. newSlotID .. " for class: " .. classname)
                return true  -- Return true once the weapon is found and updated
            end
        end
    end
    wblDebug("Weapon with class " .. classname .. " not found.")
    return false  -- Return false if the weapon class is not found
end

local function ReplaceWeaponDescByClass(classname, newDesc)
    -- Loop through all tiers
    for _, tier in ipairs(wblweaponlist) do
        -- Loop through all weapons in the current tier
        for _, weapon in ipairs(tier.weapons) do
            -- Check if the weapon class matches the provided classname
            if weapon.class == classname then
                -- Replace the weapon's description
                weapon.desc = newDesc
                wblDebug("Weapon description updated for class: " .. classname)
                return true  -- Return true once the weapon is found and updated
            end
        end
    end
    wblDebug("Weapon with class " .. classname .. " not found.")
    return false  -- Return false if the weapon class is not found
end

local function ReplaceArsenalTypeByClass(classname, NewArsenaltype)
    -- Loop through all tiers
    for _, tier in ipairs(wblweaponlist) do
        -- Loop through all weapons in the current tier
        for _, weapon in ipairs(tier.weapons) do
            -- Check if the weapon class matches the provided classname
            if weapon.class == classname then
                -- Replace the weapon's Arsenaltype (category)
                weapon.Arsenaltype = NewArsenaltype
                wblDebug("Weapon Arsenal updated to: " .. NewArsenaltype .. " for class: " .. classname)
                return true  -- Return true once the weapon is found and updated
            end
        end
    end
    wblDebug("Weapon with class " .. classname .. " not found.")
    return false  -- Return false if the weapon class is not found
end

function UpdateAmmoName(ammoclass, newname)
    for _, ammo in ipairs(wblammolist) do
        if ammo.class == ammoclass then
            ammo.name = newname
            return true -- Indicate that the name was updated
        end
    end
    return false -- Indicate that no matching class was found
end

function UpdateAmmoPrice(ammoclass, newprice)
    for _, ammo in ipairs(wblammolist) do
        if ammo.class == ammoclass then
            ammo.price = newprice
            return true -- Indicate that the price was updated
        end
    end
    return false -- Indicate that no matching class was found
end

function UpdateAmmoQuantity(ammoclass, newquantity)
    for k, ammo in ipairs(wblammolist) do
        if ammo.class == ammoclass then
            ammo.quantity = newquantity
            return true -- Indicate that the quantity was updated
        end
    end
    return false -- Indicate that no matching class was found
end

function UpdateAmmoMaxQuantity(ammoclass, newmaxquantity)
    for _, ammo in ipairs(wblammolist) do
        if ammo.class == ammoclass then
            ammo.maxquantity = newmaxquantity
            return true -- Indicate that the max quantity was updated
        end
    end
    return false -- Indicate that no matching class was found
end

local function ReplaceAmmo1(oldAmmoName, newAmmoName)
    for _, tier in ipairs(wblweaponlist) do
        for _, weapon in ipairs(tier.weapons) do
            if weapon.ammo1 == oldAmmoName then
                weapon.ammo1 = newAmmoName -- Replace ammo1 with new ammo name
            end
        end
    end
end

local function ReplaceAmmo2(oldAmmoName, newAmmoName)
    for _, tier in ipairs(wblweaponlist) do
        for _, weapon in ipairs(tier.weapons) do
            if weapon.ammo2 == oldAmmoName then
                weapon.ammo2 = newAmmoName -- Replace ammo2 with new ammo name
            end
        end
    end
end

-- Function to move a weapon to a different tier
local function MoveWeaponToTier(classname, newTierName)
    local weaponToMove = nil
    local oldTierIndex = nil
    local weaponIndex = nil

    -- Step 1: Find and remove the weapon from its current tier
    for tierIndex, tier in ipairs(wblweaponlist) do
        for index, weapon in ipairs(tier.weapons) do
            if weapon.class == classname then
                -- Store the weapon to move
                weaponToMove = weapon
                oldTierIndex = tierIndex
                weaponIndex = index
                break
            end
        end
        if weaponToMove then break end
    end

    if not weaponToMove then
        wblDebug("Weapon with class " .. classname .. " not found.")
        return false
    end

    -- Remove the weapon from its current tier
    table.remove(wblweaponlist[oldTierIndex].weapons, weaponIndex)

    -- Step 2: Move the weapon to the new tier (create the tier if it doesn't exist)
    local newTierFound = false
    for _, tier in ipairs(wblweaponlist) do
        if tier.name == newTierName then
            -- Add the weapon to the new tier
            table.insert(tier.weapons, weaponToMove)
            newTierFound = true
            break
        end
    end

    if not newTierFound then
        -- If the new tier does not exist, create a new one
        table.insert(wblweaponlist, {
            name = newTierName,
            weapons = {weaponToMove}
        })
        wblDebug("New tier created: " .. newTierName)
    else
        wblDebug("Weapon moved to existing tier: " .. newTierName)
    end

    -- Step 3: Remove the old tier if it's empty
    if #wblweaponlist[oldTierIndex].weapons == 0 then
        table.remove(wblweaponlist, oldTierIndex)
    end

    return true
end

local function ChangeSellValueByClass(classname, newSellValue)
    -- Loop through all tiers
    for _, tier in ipairs(wblweaponlist) do
        -- Loop through all weapons in the current tier
        for _, weapon in ipairs(tier.weapons) do
            -- Check if the weapon class matches the provided classname
            if weapon.class == classname then
                -- Replace the weapon's cost
                weapon.sellvalue = newSellValue
                wblDebug("Weapon cost updated to: " .. newSellValue .. " for class: " .. classname)
                return true  -- Return true once the weapon is found and updated
            end
        end
    end
    wblDebug("Weapon with class " .. classname .. " not found.")
    return false  -- Return false if the weapon class is not found
end



function ChangeSellableByClass(classname, isSellable)
    local weaponFound = false

    -- Iterate through all tiers
    for _, tier in ipairs(wblweaponlist) do
        -- Iterate through the weapons in each tier
        for _, weapon in ipairs(tier.weapons) do
            if weapon.class == classname then
                -- Update the sellable status for the found weapon
                weapon.sellable = isSellable
                weaponFound = true
                wblDebug("Sellable status updated for weapon: " .. weapon.name .. " to " .. tostring(isSellable))
                break
            end
        end
        if weaponFound then break end
    end

    -- If the weapon class was not found
    if not weaponFound then
        wblDebug("Weapon with class " .. classname .. " not found.")
    end
end

function wblMoveWeaponUp(tierName, weaponName, ply)
    for _, tier in ipairs(wblweaponlist) do
        if tier.name == tierName then
            for i = 2, #tier.weapons do -- Start from the second weapon to allow swapping with the one before it
                if tier.weapons[i].name == weaponName then
                    -- Swap with the previous weapon
                    tier.weapons[i], tier.weapons[i - 1] = tier.weapons[i - 1], tier.weapons[i]
                    wblDebug(weaponName .. " moved up!")
                    return
                end
            end
            wblDebug(weaponName .. " is already at the top or doesn't exist!")
            net.Start("wblonlyweaponsound")
            net.WriteInt(5,16)
            net.Send(ply)
            return
        end
    end
    wblDebug("Tier " .. tierName .. " not found!")
end

function wblMoveWeaponDown(tierName, weaponName, ply)
    for _, tier in ipairs(wblweaponlist) do
        if tier.name == tierName then
            for i = 1, #tier.weapons - 1 do -- Stop at second-to-last weapon to allow swapping with the one after it
                if tier.weapons[i].name == weaponName then
                    -- Swap with the next weapon
                    tier.weapons[i], tier.weapons[i + 1] = tier.weapons[i + 1], tier.weapons[i]
                    wblDebug(weaponName .. " moved down!")
                    return
                end
            end
            wblDebug(weaponName .. " is already at the bottom or doesn't exist!")
            net.Start("wblonlyweaponsound")
            net.WriteInt(6,16)
            net.Send(ply)
            return
        end
    end
    wblDebug("Tier " .. tierName .. " not found!")
end


local function GetPlayerWeapon(player, weapon_class)
    -- Iterate through the player's weapons
    for _, wep in ipairs(player:GetWeapons()) do
        if wep:GetClass() == weapon_class then
            return wep -- Return the weapon if class matches
        end
    end
    return nil -- Return nil if the weapon is not found
end

--Set the reserve ammo
local function SetReserveAmmo(plyer, ammoType, amount)
    local ammoID = game.GetAmmoID(ammoType) -- Get ammo type ID
    if ammoID then
        plyer:SetAmmo(amount, ammoID) -- Set the ammo amount
    else
        wblDebug("Invalid ammo type: " .. ammoType)
    end
end

--Add Reserve ammo
local function AddReserveAmmo(plyer, ammoType, amountToAdd)
    local ammoID = game.GetAmmoID(ammoType) -- Get ammo type ID
    if ammoID then
        local currentAmmo = plyer:GetAmmoCount(ammoID) -- Get current reserve ammo
        plyer:SetAmmo(currentAmmo + amountToAdd, ammoID) -- Set new reserve ammo amount
    else
        wblDebug("Invalid ammo type: " .. ammoType)
    end
end

local function Moneydeduct(ply, cost, seen)
	local monen = wblmonhen:GetInt()
	local wblmoney = ply:GetPData("wblmoney",-1)
	price = tonumber(cost)
    wblmoney = tonumber(wblmoney)
    local monen = wblmonhen:GetInt()
    if monen == 1 then
    	if price > wblmoney then
    		net.Start("wblplynomoney")
			net.Send(ply)
			net.Start("plyMonzupdateToCLose")
			net.WriteInt(wblmoney, 32)
			net.Send(ply)	
    		--notification.AddLegacy("Not enough Money!", NOTIFY_ERROR, 3)
			--surface.PlaySound("buttons/button10.wav")
    		return false
    	else
    		changeMoney(ply,-cost)
		return true
    	end
    else
    	return true
    end  
end



local function Moneyadd(ply, add, seen)
	local monen = wblmonhen:GetInt()
	local wblmoney = ply:GetPData("wblmoney",-1)
	price = tonumber(add)
    wblmoney = tonumber(wblmoney)
    local monen = wblmonhen:GetInt()
    if monen == 1 then
    		changeMoney(ply,price)
    else
    	return true
    end  
end


--give player weapon function
local function GivePlayerWeapon(ply, weaponClass, weaponprice, arsenal)
    -- Check if the player is valid and not a bot
    if not IsValid(ply) or not ply:IsPlayer() then return end
    wblBuying = true

    -- Check if the player already has the weapon
    if ply:HasWeapon(weaponClass) and arsenal == "W" then
    	net.Start("wblplyhasweapon")
		net.Send(ply)
        ply:SelectWeapon(weaponClass)
        net.Start("wblplydiedinstore")
        net.Send(ply)
        --notification.AddLegacy("You already have the weapon!", NOTIFY_ERROR, 3)
		--surface.PlaySound("buttons/button10.wav")
    else

    	--Check if player has the weapon in that certain slot already
    	local foundWeaponbeingbought = FindWeaponByClass(weaponClass)
    	if foundWeaponbeingbought.slotid ~= "N.A." then
		    local weaponss = ply:GetWeapons() -- Get all weapons the player currently holds
		    for _, weapon in ipairs(weaponss) do
		        local weaponclassfound =  weapon:GetClass() -- Print weapon class
		        local foundWeapon = FindWeaponByClass(weaponclassfound)
				if foundWeapon ~= nil then
                    
                    local ignore = wblmonignoreslotid:GetInt()
					if ((foundWeapon.slotid == foundWeaponbeingbought.slotid) and (foundWeapon.name ~= foundWeaponbeingbought.name)) and (tonumber(ignore) ~= 1) then
						net.Start("wblplyhasweaponinsameid")
						net.WriteString(foundWeaponbeingbought.slotid)
						net.WriteString(foundWeapon.name)
						net.Send(ply)
						ply:SelectWeapon(foundWeapon.class)
						net.Start("wblplydiedinstore")
						net.Send(ply)
                        wblBuying = false
						return
					end

				end
			end
		end

    	local wblmoney = ply:GetPData("wblmoney",-1)
    	weaponprice = tonumber(weaponprice)
    	wblmoney = tonumber(wblmoney)
    	local monen = wblmonhen:GetInt()
		if monen == 1 then
	    	if weaponprice > wblmoney then

	    		net.Start("wblplynomoney")
				net.Send(ply)
				net.Start("plyMonzupdateToCLose")
				net.WriteInt(wblmoney, 32)
				net.Send(ply)	
	    		--notification.AddLegacy("Not enough Money!", NOTIFY_ERROR, 3)
				--surface.PlaySound("buttons/button10.wav")
                wblBuying = false
	    		return
	    	else
		    		-- Give the player the weapon
		    	
			
		    		changeMoney(ply,-weaponprice)
                    local ammohasbeengiven = true
		    		if arsenal == "C" then
                        wblDebug("Weapon is ArsenalAAAAAAAAAAAAAAAAA")
		    			if ply:HasWeapon(weaponClass) then
		    				local weap = GetPlayerWeapon(ply, weaponClass)
		    				local ammotype = game.GetAmmoName(weap:GetPrimaryAmmoType())
                            if ammotype == nil then
                                ammotype = game.GetAmmoName(weap:GetSecondaryAmmoType())
                            end
                            local currentAmmo = ply:GetAmmoCount(ammotype)
		    				AddReserveAmmo(ply, ammotype, 1)
                            timer.Simple(0.1, function()
                                local newAmmo = ply:GetAmmoCount(ammotype)
                                if newAmmo > currentAmmo then
                                    wblDebug("Ammo successfully added: "..newAmmo - currentAmmo)
                                else
                                    wblDebug("Ammo not added. Possible mod restriction or max ammo reached.")
                                    ammohasbeengiven = false
                                    wblDebug("Ammo has not been given")
                                    Moneyadd(ply, weaponprice, true)
                                end
                            end)

		    			else
                            GiveWeaponToPlayer(ply, weaponClass)
                            timer.Simple(0.2, function()
                                local weap = GetPlayerWeapon(ply, weaponClass)
                                wblDebug(weap)
                                local ammotype = game.GetAmmoName(weap:GetPrimaryAmmoType())
                                if ammotype == nil then
                                    ammotype = game.GetAmmoName(weap:GetSecondaryAmmoType())
                                end
                                wblDebug("ammotype: "..ammotype)
                                SetReserveAmmo(ply, ammotype, 1)
                            end)
		    				--ply:Give(weaponClass)
		    			end
		    		elseif arsenal == "W" then
                        GiveWeaponToPlayer(ply, weaponClass)
		    			--ply:Give(weaponClass)
                    elseif arsenal == "ENT" then
                        SpawnWeapononme(ply, weaponClass)
                        net.Start("wblplyboughtweapon")
                        net.WriteUInt(2,8)
                        net.Send(ply)
                        return
		    		else
		    			wblDebug("NO ARSENAL TYPE DETECTED")
                        wblBuying = false
		    			return
		    		end
				    ply:SelectWeapon(weaponClass)
                    --timer.Simple(0.2, function()
                    --    wblDebug("Ammo given: "..tostring(ammohasbeengiven))
                    --    if not ammohasbeengiven then
                    --        wblDebug("Ammo has not been given")
                    --        Moneyadd(ply, weaponprice, true)
                    --    end
                    --end)
                net.Start("wblplyboughtweapon")
                net.WriteUInt(1,8)
                net.Send(ply)
	    	end
	    else
            if arsenal == "C" then
                wblDebug("Weapon is ArsenalAAAAAAAAAAAAAAAAA")
                if ply:HasWeapon(weaponClass) then
                    local weap = GetPlayerWeapon(ply, weaponClass)
                    local ammotype = game.GetAmmoName(weap:GetPrimaryAmmoType())
                    if ammotype == nil then
                        ammotype = game.GetAmmoName(weap:GetSecondaryAmmoType())
                    end
                    local currentAmmo = ply:GetAmmoCount(ammotype)
                    AddReserveAmmo(ply, ammotype, 1)
                    timer.Simple(0.1, function()
                        local newAmmo = ply:GetAmmoCount(ammotype)
                        if newAmmo > currentAmmo then
                            wblDebug("Ammo successfully added: "..newAmmo - currentAmmo)
                        else
                            wblDebug("Ammo not added. Possible mod restriction or max ammo reached.")
                            ammohasbeengiven = false
                            wblDebug("Ammo has not been given")
                        end
                    end)

                else
                    GiveWeaponToPlayer(ply, weaponClass)
                    timer.Simple(0.2, function()
                        local weap = GetPlayerWeapon(ply, weaponClass)
                        wblDebug(weap)
                        local ammotype = game.GetAmmoName(weap:GetPrimaryAmmoType())
                        if ammotype == nil then
                            ammotype = game.GetAmmoName(weap:GetSecondaryAmmoType())
                        end
                        wblDebug("ammotype: "..ammotype)
                        SetReserveAmmo(ply, ammotype, 1)
                    end)
                    --ply:Give(weaponClass)
                end
            elseif arsenal == "W" then
                GiveWeaponToPlayer(ply, weaponClass)
                --ply:Give(weaponClass)
            elseif arsenal == "ENT" then
                SpawnWeapononme(ply, weaponClass)
                net.Start("wblplyboughtweapon")
                net.WriteUInt(2,8)
                net.Send(ply)
                return
            else
                wblDebug("NO ARSENAL TYPE DETECTED")
                wblBuying = false
                return
            end
	    	net.Start("wblplyboughtweapon")
            net.WriteUInt(1,8)
			net.Send(ply)
	    	--ply:Give(weaponClass)
	    	ply:SelectWeapon(weaponClass)
	    end
        wblBuying = false
    end
    
end

local function HasOnlyOneWeapon(ply)
    local weapons = #ply:GetWeapons()
    return weapons
end

local function SellWeapon(ply)
    -- Get the currently held weapon
    
    if HasOnlyOneWeapon(ply) == 1 then
    	net.Start("wblonlyweaponsound")
    	net.WriteInt(1,16)
	    net.Send(ply)
    	return
    end
    local sellamount 
    local currentWeapon = ply:GetActiveWeapon()
    if not (IsValid(currentWeapon) and currentWeapon:GetClass() ~= "none") then 
    	net.Start("wblNoWeaponsound")
	    net.Send(ply)
     	return 
 	end
	local weaponclass = currentWeapon:GetClass()

    local Softlocken = tonumber(wblmonreplaceammoentitiesantisoftlock:GetInt())
    if Softlocken == 1 and (weaponclass == "weapon_rpg" or weaponclass == "weapon_bugbait" or weaponclass == "weapon_physcannon" or weaponclass == "weapon_frag") then
        net.Start("wblonlyweaponsound")
        net.WriteInt(4,16)
        net.Send(ply)
        return
    end
	local foundWeapon = FindWeaponByClass(weaponclass)
	if foundWeapon == nil then
		sellamount = weapsellvalue
        wblDebug("foundWeapon is nil sellamount is: "..tostring(sellamount))
	else
		sellamount = foundWeapon.sellvalue
		if not foundWeapon.sellable then
	    	net.Start("wblonlyweaponsound")
	    	net.WriteInt(2,16)
		    net.Send(ply)
	    	return
    	end
	end
	if IsValid(currentWeapon) and currentWeapon:GetClass() ~= "weapon_worldmodel" then
		if foundWeapon ~= nil then
			if foundWeapon.Arsenaltype == "C" then
				local ammocount = ply:GetAmmoCount(currentWeapon:GetPrimaryAmmoType())
				local ammotype = game.GetAmmoName(currentWeapon:GetPrimaryAmmoType())
                wblDebug("Ammo type: ")
                wblDebug(ammotype)
                if ammotype == nil then
                    ammotype = game.GetAmmoName(currentWeapon:GetSecondaryAmmoType())
                    ammocount = ply:GetAmmoCount(currentWeapon:GetSecondaryAmmoType())
                end
                wblDebug("Ammo type: ")
                wblDebug(ammotype)
				if ammocount > 1 then
					AddReserveAmmo(ply, ammotype, -1)
					Moneyadd(ply, sellamount, true)
				elseif ammocount == 0 then
					ply:StripWeapon(currentWeapon:GetClass())
					net.Start("wblplydiedinstore")
					net.Send(ply)
				else
					AddReserveAmmo(ply, ammotype, -1)
					ply:StripWeapon(currentWeapon:GetClass())
					Moneyadd(ply, sellamount, true)
					net.Start("wblplydiedinstore")
					net.Send(ply)
				end
			else
				Moneyadd(ply, sellamount, true)
				net.Start("wblplydiedinstore")
				net.Send(ply)
                ply:StripWeapon(currentWeapon:GetClass())
			end
		else
            local sellonlylisted = tonumber(wblmonsellonlylisted:GetInt())
            if sellonlylisted == 1 then
                net.Start("wblonlyweaponsound")
                net.WriteInt(3,16)
                net.Send(ply)
                return
            else
                --local sellamount = weapsellvalue
    			Moneyadd(ply, weapsellvalue, true)
    			net.Start("wblplydiedinstore")
    			net.Send(ply)
                ply:StripWeapon(currentWeapon:GetClass())
            end
		end
		net.Start("wblSellweaponsound")
	    net.Send(ply)
	else
        ply:ChatPrint("You don't have a weapon to sell!")
	end
end

--Give HP to player
local function GiveHP(ply, HPamount, HPprice)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    	local wblmoney = ply:GetPData("wblmoney",-1)
    	HPprice = tonumber(HPprice)
    	wblmoney = tonumber(wblmoney)
    	local monen = wblmonhen:GetInt()
		if monen == 1 then
	    	if HPprice > wblmoney then

	    		net.Start("wblplynomoney")
				net.Send(ply)
				net.Start("plyMonzupdateToCLose")
				net.WriteInt(wblmoney, 32)
				net.Send(ply)	
	    		--notification.AddLegacy("Not enough Money!", NOTIFY_ERROR, 3)
				--surface.PlaySound("buttons/button10.wav")
	    		return
	    	else
		    		-- Give the player the weapon
		    	net.Start("wblplyboughthpsound")
			net.Send(ply)
			
		    	changeMoney(ply,-HPprice)	
			return HPamount
	    	end
	    else
	    	net.Start("wblplyboughthpsound")
			net.Send(ply)
	    	return HPamount
	    end
end



--Give Armor to player
local function GiveAP(ply, APamount, APprice)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    	local wblmoney = ply:GetPData("wblmoney",-1)
    	APprice = tonumber(APprice)
    	wblmoney = tonumber(wblmoney)
    	local monen = wblmonhen:GetInt()
		if monen == 1 then
	    	if APprice > wblmoney then

	    		net.Start("wblplynomoney")
				net.Send(ply)
				net.Start("plyMonzupdateToCLose")
				net.WriteInt(wblmoney, 32)
				net.Send(ply)	
	    		--notification.AddLegacy("Not enough Money!", NOTIFY_ERROR, 3)
				--surface.PlaySound("buttons/button10.wav")
	    		return
	    	else
		    		-- Give the player the weapon
		    	net.Start("wblplyboughtapsound")
				net.Send(ply)
			
		    		changeMoney(ply,-APprice)
					return APamount
	    	end
	    else
	    	net.Start("wblplyboughtapsound")
			net.Send(ply)
	    	return APamount
	    end
end

function CompressAndSendTable(netString, dataTable, ply)
    -- Convert the table to a JSON string
    local jsonData = util.TableToJSON(dataTable)

    -- Compress the JSON string
    local compressedData = util.Compress(jsonData)

    -- Make sure compression worked
    if not compressedData then
        wblDebug("Failed to compress data for " .. netString)
        return
    end

    -- Send the compressed data
    net.Start(netString)
    net.WriteUInt(#compressedData, 32) -- Write the length of the compressed data
    net.WriteData(compressedData, #compressedData) -- Write the compressed data
    net.Broadcast() -- Broadcast to all players
    wblDebug("Compression and sending of data successful")
end


--for Buying Weapons
net.Receive("wblBuyweapon", function(len, ply)
	local price = net.ReadInt(32)
	local weaponclass = net.ReadString()
	local arsenaltype = net.ReadString()
	wblDebug("Arsenaltype received from server: "..arsenaltype)
	GivePlayerWeapon(ply, weaponclass, price, arsenaltype)
end)

--for Buying 1 Primary Ammo
net.Receive("wblplybought1primeammo", function(len, ply)
	local price = net.ReadInt(32)
	local weapon = ply:GetActiveWeapon()
	if not (IsValid(weapon) and weapon:GetClass() ~= "none") then 
    	net.Start("wblNoWeaponsound")
	    net.Send(ply)
     	return 
 	end
	local weaponclass = weapon:GetClass()
	local foundWeapon = FindWeaponByClass(weaponclass)
    wblDebug("foundWeapon Name: "..foundWeapon.name)
    wblDebug("foundWeapon Name: "..foundWeapon.ammo1)
    wblDebug("foundWeapon Name: "..foundWeapon.ammo2)
    -- Check if weapon is listed in the shop
	if foundWeapon == nil then
		net.Start("wblplydontknowweaponsound")
		net.Send(ply)
		return

    -- Check if it is equpment or weapon has N.A. Primary ammo
    elseif foundWeapon.Arsenaltype == "C" then
        net.Start("wblplynoammotypesoundC")
        net.WriteInt(1,16)
        net.Send(ply)
        return
	elseif foundWeapon.ammo1 == "N.A." then

		net.Start("wblplynoammotypesound")
		net.WriteInt(1,16)
		net.Send(ply)
		return
	end

	local ammo = FindAmmoByName(foundWeapon.ammo1)

    -- Check if ammo of weapon is listed
	if ammo == nil then
        wblDebug("ammo is nil!")
		net.Start("wblbutton1soundother")
        net.WriteInt(1,16)
        net.Send(ply)
        return
	end

	local currentammo = ply:GetAmmoCount(ammo.class)
	if currentammo < ammo.maxquantity then
		local ammodiff = ammo.maxquantity - currentammo
		if Moneydeduct(ply, ammo.price, true) then
			local plyammo = ply:GetAmmoCount(ammo.class)
			if ammodiff >= ammo.quantity then
				AddReserveAmmo(ply, ammo.class, ammo.quantity)
			else
				SetReserveAmmo(ply, ammo.class, ammo.maxquantity)
			end
			if remammo1 ~= ply:GetAmmoCount(ammo.class) then
				net.Start("wblplyboughtpasound")
				net.Send(ply)
				remammo1 = ply:GetAmmoCount(ammo.class)
				remweapon = ply:GetActiveWeapon()
			elseif (remammo1 == plyammo) and (remweapon == ply:GetActiveWeapon()) then
				net.Start("wblplyhasmaxprimeammo")
				net.Send(ply)
				Moneyadd(ply, ammo.price, true)
				wblDebug("Weapon has its own reserve ammo set, it is overriding my settings!, will follow SWEPs rule!")
			end
		end
	else
		net.Start("wblplyhasmaxprimeammo")
		net.Send(ply)
	end
end)

--for Buying All Primary Ammo
net.Receive("wblplyboughtfullprimeammo", function(len, ply)
	local price = net.ReadInt(32)
	local weapon = ply:GetActiveWeapon()
	if not (IsValid(weapon) and weapon:GetClass() ~= "none") then 
    	net.Start("wblNoWeaponsound")
	    net.Send(ply)
     	return 
 	end
	local weaponclass = weapon:GetClass()
	local foundWeapon = FindWeaponByClass(weaponclass)
	if foundWeapon == nil then
		net.Start("wblplydontknowweaponsound")
		net.Send(ply)
		return
    elseif foundWeapon.Arsenaltype == "C" then
        net.Start("wblplynoammotypesoundC")
        net.WriteInt(1,16)
        net.Send(ply)
        return
	elseif foundWeapon.ammo1 == "N.A." then
		net.Start("wblplynoammotypesound")
		net.WriteInt(1,16)
		net.Send(ply)
		return
	end
	local ammo = FindAmmoByName(foundWeapon.ammo1)
    if ammo == nil then
        net.Start("wblbutton1soundother")
        net.WriteInt(1,16)
        net.Send(ply)
        return
    end
	local currentammo = ply:GetAmmoCount(ammo.class)
	if currentammo < ammo.maxquantity then
		local ammodiff = ammo.maxquantity - currentammo
		local buymult = math.ceil(ammodiff/ammo.quantity)
		local wblmoney = ply:GetPData("wblmoney",-1)
		if tonumber(wblmoney) >= ammo.price then
			for i = 1, buymult do
				local wblmoney = ply:GetPData("wblmoney",-1)
				ammodiff = ammo.maxquantity - currentammo
				if tonumber(wblmoney) >= ammo.price then
						if Moneydeduct(ply, ammo.price, true) then
							local plyammo = ply:GetAmmoCount(ammo.class)
							if ammodiff >= ammo.quantity then
								AddReserveAmmo(ply, ammo.class, ammo.quantity)
							else
								SetReserveAmmo(ply, ammo.class, ammo.maxquantity)
							end
							if remammo1 ~= ply:GetAmmoCount(ammo.class) then
								net.Start("wblplyboughtpasound")
								net.Send(ply)
								remammo1 = ply:GetAmmoCount(ammo.class)
								remweapon = ply:GetActiveWeapon()
							elseif (remammo1 == plyammo) and (remweapon == ply:GetActiveWeapon()) then
								net.Start("wblplyhasmaxprimeammo")
								net.Send(ply)
								Moneyadd(ply, ammo.price, true)
								wblDebug("Weapon has its own reserve ammo set, it is overriding my settings!, will follow SWEPs rule!")
								break
							end
						end
				else
	
					break
				end
			end
		else
			net.Start("wblplynomoney")
			net.Send(ply)
			net.Start("plyMonzupdateToCLose")
			net.WriteInt(wblmoney, 32)
			net.Send(ply)
		end
	else
		net.Start("wblplyhasmaxprimeammo")
		net.Send(ply)
	end
end)

--for Buying 1 Secondary Ammo
net.Receive("wblplybought1secammo", function(len, ply)
	local price = net.ReadInt(32)
	local weapon = ply:GetActiveWeapon()
	if not (IsValid(weapon) and weapon:GetClass() ~= "none") then 
    	net.Start("wblNoWeaponsound")
	    net.Send(ply)
     	return 
 	end
	local weaponclass = weapon:GetClass()
	local foundWeapon = FindWeaponByClass(weaponclass)
	if foundWeapon == nil then
		net.Start("wblplydontknowweaponsound")
		net.Send(ply)
		return
    elseif foundWeapon.Arsenaltype == "C" then
        net.Start("wblplynoammotypesoundC")
        net.WriteInt(2,16)
        net.Send(ply)
        return
	elseif foundWeapon.ammo2 == "N.A." then
		net.Start("wblplynoammotypesound")
		net.WriteInt(2,16)
		net.Send(ply)
		return
	end

	local ammo = FindAmmoByName(foundWeapon.ammo2)
    if ammo == nil then
        net.Start("wblbutton1soundother")
        net.WriteInt(1,16)
        net.Send(ply)
        return
    end
	local currentammo = ply:GetAmmoCount(ammo.class)
	if currentammo < ammo.maxquantity then
		local ammodiff = ammo.maxquantity - currentammo
		if Moneydeduct(ply, ammo.price, true) then
			local plyammo = ply:GetAmmoCount(ammo.class)
			if ammodiff >= ammo.quantity then
				AddReserveAmmo(ply, ammo.class, ammo.quantity)
			else
				SetReserveAmmo(ply, ammo.class, ammo.maxquantity)
			end
			if remammo2 ~= ply:GetAmmoCount(ammo.class) then
				net.Start("wblplyboughtpasound")
				net.Send(ply)
				remammo2 = ply:GetAmmoCount(ammo.class)
				remweapon = ply:GetActiveWeapon()
			elseif (remammo2 == plyammo) and (remweapon == ply:GetActiveWeapon()) then
				net.Start("wblplyhasmaxsecammo")
				net.Send(ply)
				Moneyadd(ply, ammo.price, true)
				wblDebug("Weapon has its own reserve ammo set, it is overriding my settings!, will follow SWEPs rule!")
			end
		end
	else
		net.Start("wblplyhasmaxsecammo")
		net.Send(ply)
	end
end)



--for Buying All Secondary Ammo
net.Receive("wblplyboughtfullsecammo", function(len, ply)
	local price = net.ReadInt(32)
	local weapon = ply:GetActiveWeapon()
	if not (IsValid(weapon) and weapon:GetClass() ~= "none") then 
    	net.Start("wblNoWeaponsound")
	    net.Send(ply)
     	return 
 	end
	local weaponclass = weapon:GetClass()
	local foundWeapon = FindWeaponByClass(weaponclass)
	if foundWeapon == nil then
		net.Start("wblplydontknowweaponsound")
		net.Send(ply)
		return
    elseif foundWeapon.Arsenaltype == "C" then
        net.Start("wblplynoammotypesoundC")
        net.WriteInt(2,16)
        net.Send(ply)
        return
	elseif foundWeapon.ammo2 == "N.A." then
		net.Start("wblplynoammotypesound")
		net.WriteInt(2,16)
		net.Send(ply)
		return
	end
	local ammo = FindAmmoByName(foundWeapon.ammo2)
    if ammo == nil then
        net.Start("wblbutton1soundother")
        net.WriteInt(1,16)
        net.Send(ply)
        return
    end
	local currentammo = ply:GetAmmoCount(ammo.class)
	if currentammo < ammo.maxquantity then
		local ammodiff = ammo.maxquantity - currentammo
		local buymult = math.ceil(ammodiff/ammo.quantity)
		local wblmoney = ply:GetPData("wblmoney",-1)
		if tonumber(wblmoney) >= ammo.price then
			for i = 1, buymult do
				local wblmoney = ply:GetPData("wblmoney",-1)
				ammodiff = ammo.maxquantity - currentammo
				if tonumber(wblmoney) >= ammo.price then
						if Moneydeduct(ply, ammo.price, true) then
							local plyammo = ply:GetAmmoCount(ammo.class)
							if ammodiff >= ammo.quantity then
								AddReserveAmmo(ply, ammo.class, ammo.quantity)
							else
								SetReserveAmmo(ply, ammo.class, ammo.maxquantity)
							end
							if remammo2 ~= ply:GetAmmoCount(ammo.class) then
								net.Start("wblplyboughtpasound")
								net.Send(ply)
								remammo2 = ply:GetAmmoCount(ammo.class)
								remweapon = ply:GetActiveWeapon()
							elseif (remammo2 == plyammo) and (remweapon == ply:GetActiveWeapon()) then
								net.Start("wblplyhasmaxsecammo")
								net.Send(ply)
								Moneyadd(ply, ammo.price, true)
								wblDebug("Weapon has its own reserve ammo set, it is overriding my settings!, will follow SWEPs rule!")
								break
							end
						end
				else
	
					break
				end
			end
		else
			net.Start("wblplynomoney")
			net.Send(ply)
			net.Start("plyMonzupdateToCLose")
			net.WriteInt(wblmoney, 32)
			net.Send(ply)
		end
	else
		net.Start("wblplyhasmaxsecammo")
		net.Send(ply)
	end
end)

--placeholder price


--Buying 10HP
net.Receive("wblplybought10hp", function(len, wblply)
	local maxhealth = wblply:GetMaxHealth()
	local currenthealth = wblply:Health()
	local healthdiff = maxhealth - currenthealth
	if currenthealth < maxhealth then
		if healthdiff >= 10 then
			local HPheal = GiveHP(wblply, 10, HP10price)
			if HPheal ~= nil then
				wblply:SetHealth(currenthealth + HPheal)
			end
		elseif healthdiff < 10 then
			local Sethp = GiveHP(wblply, maxhealth, HP10price)
			if Sethp ~= nil then
				wblply:SetHealth(Sethp)
			end
		end
	else
		net.Start("wblplyhasmaxhp")
		net.Send(wblply)
	end
end)

--Buying 25HP
net.Receive("wblplybought25hp", function(len, wblply)
	local maxhealth = wblply:GetMaxHealth()
	local currenthealth = wblply:Health()
	local healthdiff = maxhealth - currenthealth
	if currenthealth < maxhealth then
		if healthdiff >= 25 then
			local HPheal = GiveHP(wblply, 25, HP25price)
			if HPheal ~= nil then
				wblply:SetHealth(currenthealth + HPheal)
			end
		elseif healthdiff < 25 then
			local Sethp = GiveHP(wblply, maxhealth, HP25price)
			if Sethp ~= nil then
				wblply:SetHealth(Sethp)
			end
		end
	else
		net.Start("wblplyhasmaxhp")
		net.Send(wblply)
	end
end)

--Buying 10AP
net.Receive("wblplybought10ap", function(len, wblply)

	local activeWeapon = wblply:GetActiveWeapon()
    
    if IsValid(activeWeapon) then
        wblDebug(activeWeapon:GetPrimaryAmmoType()) -- Returns the primary ammo type
        -- You can also check GetSecondaryAmmoType() for the secondary ammo type if needed
    end

	local maxarmor = wblply:GetMaxArmor()
	local currentarmor = wblply:Armor()
	local armordiff = maxarmor - currentarmor
	if currentarmor < maxarmor then
		if armordiff >= 10 then
			local APcharge = GiveAP(wblply, 10, AP10price)
			if APcharge ~= nil then
				wblply:SetArmor(currentarmor + APcharge)
			end
		elseif armordiff < 10 then
			local Setarm = GiveAP(wblply, maxarmor, AP10price)
			if Setarm ~= nil then
				wblply:SetArmor(Setarm)
			end
		end
	else
		net.Start("wblplyhasmaxap")
		net.Send(wblply)
	end
end)

--Buying 25AP
net.Receive("wblplybought25ap", function(len, wblply)
	local maxarmor = wblply:GetMaxArmor()
	local currentarmor = wblply:Armor()
	local armordiff = maxarmor - currentarmor
	if currentarmor < maxarmor then
		if armordiff >= 25 then
			local APcharge = GiveAP(wblply, 25, AP25price)
			if APcharge ~= nil then
				wblply:SetArmor(currentarmor + APcharge)
			end
		elseif armordiff < 25 then
			local Setarm = GiveAP(wblply, maxarmor, AP25price)
			if Setarm ~= nil then
				wblply:SetArmor(Setarm)
			end
		end
	else
		net.Start("wblplyhasmaxap")
		net.Send(wblply)
	end
end)

net.Receive("wblSellweapon", function(len, wblply)
	SellWeapon(wblply)
end)

function ENT:Initialize()
    -- Set the model for the entity
    self:SetModel("models/items/item_item_crate.mdl")
    
    -- Initialize physics and solid properties
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)  -- Allow movement initially
    self:SetSolid(SOLID_VPHYSICS)        -- Ensures the entity has solid properties
    self:SetUseType(SIMPLE_USE)          -- Single-use interaction
    self:SetColor(Color(170, 255, 170, 255))
    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

    -- Get the physics object
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()                       -- Wake the physics object to allow movement
    end

    -- Timer to stop movement after a few seconds
    timer.Simple(4, function()
        if IsValid(self) then
            self:SetMoveType(MOVETYPE_NONE) -- Make it static after 5 seconds
            if phys:IsValid() then
                phys:EnableMotion(false)   -- Stop any further motion
                phys:Sleep()                -- Put the physics object to sleep
            end
            self:EnableCustomCollisions(false)  -- Optional: Disable custom collisions
        end
    end)
end

--Execution of functions when a player uses it
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
    wblDebug("weapsellvalue: "..weapsellvalue)
    wblDebug("HP10price: "..HP10price)
    wblDebug("HP25price: "..HP25price)
    wblDebug("AP10price: "..AP10price)
    wblDebug("AP25price: "..AP25price)
    wblDebug("defaultsellvalue: "..defaultsellvalue)
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
	c:Freeze(true)
	net.Start("wblFreeze")
	net.Send(c)
    --
    --PrintTable(wblweaponlist)
    --PrintTable(wblammolist)
    --
end

--receive signal "Unfreeze"
net.Receive("wblUnfreeze", function(len, ply)
    ply.isinshop = false
	ply:Freeze(false)
end)

net.Receive("wblreqcurrentlyheld", function(len, wblply)
    local weapon = wblply:GetActiveWeapon()
    if IsValid(weapon) then
        local weaponClass = weapon:GetClass() -- Get the class of the weapon
        local foundweapon = FindWeaponByClass(weaponClass)
        -- Duplicate weapon check
        if foundweapon == nil then
        -- Intentional blank
        elseif foundweapon.class == weaponClass then
            net.Start("wblsendcurrentlyheld")
            net.WriteInt(3,16)
            net.WriteString("")
            net.Send(wblply)
            return
        end
        -- If Passed check it wll continue..
        net.Start("wblsendcurrentlyheld")
        net.WriteInt(1,16)
        net.WriteString(weaponClass)
        net.Send(wblply)
    else
        net.Start("wblsendcurrentlyheld")
        net.WriteInt(2,16)
        net.WriteString("")
        net.Send(wblply)
    end
end)

--util.AddNetworkString("wblreqFormAmmotype")
--util.AddNetworkString("wblsendFormAmmotype")

--FindAmmoByClass(ammoClass)

net.Receive("wblreqFormAmmotype", function(len, wblply)
    local weapon = wblply:GetActiveWeapon()
    if IsValid(weapon) then
        local primaryAmmoType = weapon:GetPrimaryAmmoType() 
        local secondaryAmmoType = weapon:GetSecondaryAmmoType() 
        local primaryAmmoName = game.GetAmmoName(primaryAmmoType)
        local secondaryAmmoName = game.GetAmmoName(secondaryAmmoType)
        local Primeammotosend = tostring(primaryAmmoName or "N.A.")
        local Secondammotosend = tostring(secondaryAmmoName or "N.A.")
        local PrimeAmmolistname
        local SecondAmmolistname
        local ammo1
        local ammo2 

        if Primeammotosend ~= "N.A." then
            ammo1 = FindAmmoByClass(Primeammotosend)
            if ammo1 == nil then
                wblDebug("ammo1 is nil")
                PrimeAmmolistname = "N.A."
            else
                PrimeAmmolistname = ammo1.name
                wblDebug(PrimeAmmolistname)
            end   
        else
            PrimeAmmolistname = "N.A."
        end

        if Secondammotosend ~= "N.A." then
            ammo2 = FindAmmoByClass(Secondammotosend)
            if ammo2 == nil then
                wblDebug("ammo2 is nil")
                SecondAmmolistname = "N.A."
            else
                SecondAmmolistname = ammo2.name
                wblDebug(SecondAmmolistname)
            end   
        else
            SecondAmmolistname = "N.A."
        end

        net.Start("wblsendFormAmmotype")
        net.WriteString(Primeammotosend)
        net.WriteString(Secondammotosend)
        net.WriteString(PrimeAmmolistname)
        net.WriteString(SecondAmmolistname)
        net.Send(wblply)
    end
end)

--util.AddNetworkString("wblreqAmmotype")
--util.AddNetworkString("wblsendAmmotype")
net.Receive("wblreqAmmotype", function(len, wblply)
    local s = net.ReadInt(16)
    local weapon = wblply:GetActiveWeapon()
    if IsValid(weapon) then
        local primaryAmmoType = weapon:GetPrimaryAmmoType() 
        local secondaryAmmoType = weapon:GetSecondaryAmmoType()
        local primaryAmmoName = game.GetAmmoName(primaryAmmoType)
        local secondaryAmmoName = game.GetAmmoName(secondaryAmmoType)
        local Primeammotosend = tostring(primaryAmmoName or "N.A.")
        local Secondammotosend = tostring(secondaryAmmoName or "N.A.")
        if s == 1 then
            net.Start("wblsendAmmotype")
            net.WriteString(Primeammotosend)
            net.Send(wblply)
        elseif s == 2 then
            net.Start("wblsendAmmotype")
            net.WriteString(Secondammotosend)
            net.Send(wblply)
        end
    end
end)



net.Receive("wblreqAmmotype1", function(len, wblply)
    local weapon = wblply:GetActiveWeapon()
    if IsValid(weapon) then
        local primaryAmmoType = weapon:GetPrimaryAmmoType() 
        local secondaryAmmoType = weapon:GetSecondaryAmmoType()
        local primaryAmmoName = game.GetAmmoName(primaryAmmoType)
        local secondaryAmmoName = game.GetAmmoName(secondaryAmmoType)
        local Primeammotosend = tostring(primaryAmmoName or "N.A.")
        local Secondammotosend = tostring(secondaryAmmoName or "N.A.")
            net.Start("wblsendAmmotype1")
            net.WriteString(Primeammotosend)
            net.WriteString(Secondammotosend)
            net.Send(wblply)
    end
end)


net.Receive("wbladdammolistToS", function(len, wblply)
    local ammoName = net.ReadString()
    local ammoClass = net.ReadString()
    local price = net.ReadInt(32)
    local quantity = net.ReadInt(32)
    local maxQuantity = net.ReadInt(32)
    AddAmmo(ammoName, ammoClass, price, quantity, maxQuantity)
    CompressAndSendTable("wbladdammolistToC", wblammolist, wblply)
end)


net.Receive("wbladdweaponlistToS", function(len, wblply)
    wblDebug("Add weapon received")
    local tierName = net.ReadString()
    local weaponName = net.ReadString()
    local arsenalType = net.ReadString()
    local class = net.ReadString()
    local cost = net.ReadInt(32)
    local sellValue = net.ReadInt(32)
    local sellable = net.ReadBool()
    local slotId = net.ReadString()
    local ammo1 = net.ReadString()
    local ammo2 = net.ReadString()
    local desc = net.ReadString()
    AddWeapon(tierName, weaponName, arsenalType, class, cost, sellValue, sellable, slotId, ammo1, ammo2, desc)
    CompressAndSendTable("wbladdweaponlistToC", wblweaponlist, wblply)
    wblDebug("List Written")
    wblDebug("New weapon list: ")
    --PrintTable(wblweaponlist)
end)



net.Receive("wblreqdeleteammoToS", function(len, wblply)
    wblDebug("Remove ammo received")
    local ammoClass = net.ReadString()
    wblDebug("Removing: "..ammoClass)
    --PrintTable(wblammolist)
    RemoveAmmoByClass(ammoClass)
    CompressAndSendTable("wbladdammolistToC", wblammolist, wblply)
end)


net.Receive("wblreqdeleteweaponToS", function(len, wblply)
    wblDebug("Remove weapon received")
    local wepclass = net.ReadString()
    RemoveWeaponByClass(wepclass)
    CompressAndSendTable("wbladdweaponlistToC", wblweaponlist, wblply)
end)

--util.AddNetworkString("wblreqlowestcostarrangeToS")
--util.AddNetworkString("wblsendlowestcostarrangeToC")






net.Receive("wblreqlowestcostarrange", function(len, wblply)
    wblsortWeaponsByCost(wblweaponlist)
    CompressAndSendTable("wbladdweaponlistToC", wblweaponlist, wblply)
end)


net.Receive("wblreqChangenameweaponToS", function(len, wblply)
    wblDebug("Change weapon name received")
    local wepclass = net.ReadString()
    local newname = net.ReadString()
    ReplaceWeaponNameByClass(wepclass, newname)
    CompressAndSendTable("wbladdweaponlistToC", wblweaponlist, wblply)
end)

net.Receive("wblreqChangearsweaponToS", function(len, wblply)
    wblDebug("Change Arsenal received")
    local wepclass = net.ReadString()
    local newname = net.ReadString()
    local newnameprocessed
    if newname == "Consumable/Throwable" then
        newnameprocessed = "C"
    else
        newnameprocessed = "W"
    end
    ReplaceArsenalTypeByClass(wepclass, newnameprocessed)
    CompressAndSendTable("wbladdweaponlistToC", wblweaponlist, wblply)
end)

net.Receive("wblreqChangecostweaponToS", function(len, wblply)
    wblDebug("Change Cost received")
    local wepclass = net.ReadString()
    local newcost = net.ReadInt(32)
    ReplaceWeaponCostByClass(wepclass, newcost)
    CompressAndSendTable("wbladdweaponlistToC", wblweaponlist, wblply)
end)

net.Receive("wblreqChangeslotweaponToS", function(len, wblply)
    wblDebug("Change slot received")
    local wepclass = net.ReadString()
    local newslot = net.ReadString()
    ReplaceWeaponSlotIDByClass(wepclass, newslot)
    CompressAndSendTable("wbladdweaponlistToC", wblweaponlist, wblply)
end)

net.Receive("wblreqChangecatweaponToS", function(len, wblply)
    wblDebug("Change Category received")
    local wepclass = net.ReadString()
    local newcat = net.ReadString()
    MoveWeaponToTier(wepclass, newcat)
    CompressAndSendTable("wbladdweaponlistToC", wblweaponlist, wblply)
end)

net.Receive("wblreqChangesellvalweaponToS", function(len, wblply)
    wblDebug("Change Sell Value received")
    local wepclass = net.ReadString()
    local newsellvalue = net.ReadInt(32)
    ChangeSellValueByClass(wepclass, newsellvalue)
    CompressAndSendTable("wbladdweaponlistToC", wblweaponlist, wblply)
end)

net.Receive("wblreqChangesellableweaponToS", function(len, wblply)
    wblDebug("Change Sellable received")
    local wepclass = net.ReadString()
    local newsellable = net.ReadBool()
    ChangeSellableByClass(wepclass, newsellable)
    CompressAndSendTable("wbladdweaponlistToC", wblweaponlist, wblply)
end)

net.Receive("wblreqChangeDescweaponToS", function(len, wblply)
    wblDebug("Change Category received")
    local wepclass = net.ReadString()
    local newdesc = net.ReadString()
    ReplaceWeaponDescByClass(wepclass, newdesc)
    CompressAndSendTable("wbladdweaponlistToC", wblweaponlist, wblply)
end)

--[[
util.AddNetworkString("wblreqMoveupweapon")
util.AddNetworkString("wblreqMovedownweapon")
wblMoveWeaponUp(tierName, weaponName)
wblMoveWeaponDown(tierName, weaponName)
]]

net.Receive("wblreqMoveupweapon", function(len, wblply)
    wblDebug("Move up req received")
    local Tier = net.ReadString()
    local weaponname = net.ReadString()
    wblMoveWeaponUp(Tier, weaponname, wblply)
    CompressAndSendTable("wbladdweaponlistToC", wblweaponlist, wblply)
end)

net.Receive("wblreqMovedownweapon", function(len, wblply)
    wblDebug("Move down req received")
    local Tier = net.ReadString()
    local weaponname = net.ReadString()
    wblMoveWeaponDown(Tier, weaponname, wblply)
    CompressAndSendTable("wbladdweaponlistToC", wblweaponlist, wblply)
end)

net.Receive("wblReqWeaponAmmoPresetListToS", function(len, wblply)
    wblDebug("Weapon Ammo Preset List Request received")
    UpdateWeaponAmmolist()
    net.Start("wblReqWeaponAmmoPresetListToC")
    net.WriteTable(WeaponAmmoPresetList)
    net.Send(wblply)
end)

net.Receive("wblSaveWeaponlistPresetToS", function(len, wblply)
    wblDebug("Save WeaponAmmo Preset received")
    local presetname = net.ReadString()
    SaveWeaponAmmotable(presetname)
    UpdateWeaponAmmolist()
end)


net.Receive("wblLoadWeaponlistPresetToS", function(len, wblply)
    wblDebug("Load WeaponAmmo Preset received")
    
    local presetname = net.ReadString()
    if presetname == "Default" then
        wblweaponlist = {}
        wblammolist = {}
    elseif presetname == "Half-Life 2 Tiered" then
        wblweaponlist = wblweaponlisthl2tiered
        wblammolist = wblammolisthl2tiered
    else
        LoadWeaponAmmotable(presetname)
    end
    CompressAndSendTable("wbladdweaponlistToC", wblweaponlist, wblply)
    CompressAndSendTable("wbladdammolistToC", wblammolist, wblply)
end)

net.Receive("wblDeleteWeaponlistPresetToS", function(len, wblply)
    wblDebug("Delete WeaponAmmo Preset received")
    local presetname = net.ReadString()
    DeleteWeaponAmmotable(presetname)
    net.Start("wblReqWeaponAmmoPresetListToC")
    net.WriteTable(WeaponAmmoPresetList)
    net.Send(wblply)
end)

net.Receive("wblSaveSelectedWeaponlistPresetToS", function(len, wblply)
    wblDebug("Selected WeaponAmmo Preset Save received")
    local selectedpreset = net.ReadString()
    SaveStringToFile("RemSelectedAmoWepPreset", selectedpreset)
end)

net.Receive("wblLoadSelectedWeaponlistPresetToS", function(len, wblply)
    wblDebug("Selected WeaponAmmo Preset Load received")
    net.Start("wblLoadSelectedWeaponlistPresetToC")
    net.WriteString(LoadStringFromFile("RemSelectedAmoWepPreset"))
    net.Send(wblply)
end)

--net.Receive("wblUpdateWepAmmolistToS", function(len, wblply)
--    wblDebug("Update WeaponAmmo List received UNUSED")
--    return
--    net.Start("wblUpdateWepAmmolistToC")
--    net.WriteTable(wblweaponlist)
--    net.WriteTable(wblammolist)
--    net.Send(wblply)
--end)

net.Receive("wblResettodefaultpriceAPHP", function(len, wblply)
    RunConsoleCommand("wblmoney_money_smallhealthprice", "100")
    RunConsoleCommand("wblmoney_money_largehealthprice", "200")
    RunConsoleCommand("wblmoney_money_smallarmorprice", "50")
    RunConsoleCommand("wblmoney_money_largearmorprice", "100")
    RunConsoleCommand("wblmoney_money_defaultsellvalue", "200")
    RunConsoleCommand("wblmoney_buyanywhere", "0") 
    RunConsoleCommand("wblmoney_money_sellonlylisted", "0") 
    RunConsoleCommand("wblmoney_money_ignoreslotidinshop", "0") 
end)

net.Receive("wblreqChangenameammoToS", function(len, wblply)
    wblDebug("Change ammo name received")
    local ammoClass = net.ReadString()
    local NewammoName = net.ReadString()
    local foundammo = FindAmmoByClass(ammoClass)
    ReplaceAmmo1(foundammo.name, NewammoName)
    ReplaceAmmo2(foundammo.name, NewammoName)
    UpdateAmmoName(ammoClass, NewammoName)
    CompressAndSendTable("wbladdammolistToC", wblammolist, wblply)
end)

net.Receive("wblreqChangepriceammoToS", function(len, wblply)
    wblDebug("Change ammo price received")
    local ammoClass = net.ReadString()
    local NewammoPrice = net.ReadInt(32)
    UpdateAmmoPrice(ammoClass, NewammoPrice)
    CompressAndSendTable("wbladdammolistToC", wblammolist, wblply)
    CompressAndSendTable("wbladdweaponlistToC", wblweaponlist, wblply)
end)

net.Receive("wblreqChangeqtyammoToS", function(len, wblply)
    wblDebug("Change ammo qty received")
    local ammoClass = net.ReadString()
    local Newqty = net.ReadInt(32)
    UpdateAmmoQuantity(ammoClass, Newqty)
    CompressAndSendTable("wbladdammolistToC", wblammolist, wblply)
end)

net.Receive("wblreqChangemaxqtyammoToS", function(len, wblply)
    wblDebug("Change ammo max qty received")
    local ammoClass = net.ReadString()
    local Newqty = net.ReadInt(32)
    UpdateAmmoMaxQuantity(ammoClass, Newqty)
    CompressAndSendTable("wbladdammolistToC", wblammolist, wblply)
end)


hook.Add("PlayerDeath", "PlayerDeathExample", function(victim, inflictor, attacker)
    net.Start("wblplydiedinstore")
	net.Send(victim)
end)




hook.Add("ShutDown", "SaveWeaponAndAmmoLists", function()
    SaveTableToFile("RememberWeaponlist", wblweaponlist, "wblweaponlist")
    SaveTableToFile("RememberAmmolist", wblammolist, "wblammolist")
end)

-- Hook for loading tables on server initialization
hook.Add("Initialize", "LoadWeaponAndAmmoLists", function()
    wblweaponlist = {}
    wblammolist = {}
    wblweaponlist = LoadTableFromFile("RememberWeaponlist", "wblweaponlist") or {}
    wblammolist = LoadTableFromFile("RememberAmmolist", "wblammolist") or {}
end)
