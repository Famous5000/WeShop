-- WeShop -- buy-tamper auto-ban heads-up for server operators.
--
-- The weapon-buy net message is now server-verified, and clients that spoof
-- the price are auto-banned a few seconds later (see weshop_buy_antitamper in
-- lua/entities/weshop/init.lua). Auto-banning is aggressive enough that the
-- people running this addon deserve to know it's happening and where the
-- off-switch is -- so this prints a banner to the server console on load and
-- pings each superadmin ONCE (ever, per server) the first time they join.
--
-- Important framing: disabling the ban does NOT reopen the exploit. The server
-- still verifies the price and refuses the spoof either way; the convar only
-- controls whether a tamperer also gets banned.

if not SERVER then return end

-- Master switch for the NOTICE (not the protection). Set 0 to silence the
-- console banner and the superadmin join-pings entirely.
CreateConVar("weshop_antitamper_notice", "1", FCVAR_ARCHIVE,
    "WeShop: show the anti-tamper heads-up to console on load & to superadmins on first join (1) or stay silent (0).")

local TAG = "[WeShop] "

-- Full detail (console). Edit these lines to taste.
local NOTICE = {
    "Buy-tamper protection is active on this server.",
    "Clients that spoof the weapon-buy net message (price tampering) are",
    "automatically banned a few seconds later -- via ULX/ULib if installed,",
    "otherwise an engine ban.",
    "",
    "Disable the AUTO-BAN:        weshop_buy_antitamper 0",
    "  (price spoofs stay BLOCKED either way -- this only stops the ban.)",
    "Silence this message:        weshop_antitamper_notice 0",
}

local function noticeOn()
    local cv = GetConVar("weshop_antitamper_notice")
    return not cv or cv:GetBool()
end

local function printConsole(target)
    -- target == nil -> server console (MsgN); else a player's console.
    local emit = target and function(s) target:PrintMessage(HUD_PRINTCONSOLE, s) end or MsgN
    emit("")
    emit(string.rep("-", 64))
    for _, line in ipairs(NOTICE) do emit(line == "" and "" or (TAG .. line)) end
    emit(string.rep("-", 64))
    emit("")
end

-- Banner to the server console on addon load.
hook.Add("Initialize", "WeShop_AntiTamperNotice_Console", function()
    if not noticeOn() then return end
    printConsole(nil)
end)

-- Per-superadmin, once-ever (persisted via PData) ping the first time they
-- join after this notice exists. Short line in chat, full detail in console.
hook.Add("PlayerInitialSpawn", "WeShop_AntiTamperNotice_Admin", function(ply)
    timer.Simple(6, function() -- let the client settle so chat/console land
        if not IsValid(ply) or ply:IsBot() then return end
        if not ply:IsSuperAdmin() then return end
        if not noticeOn() then return end
        if ply:GetPData("weshop_antitamper_seen", "0") == "1" then return end
        ply:SetPData("weshop_antitamper_seen", "1")

        ply:ChatPrint(TAG .. "Buy-tamper auto-ban is active. See your console (~) for details and how to disable it.")
        printConsole(ply)
    end)
end)
