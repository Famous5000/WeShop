
if CLIENT then
	
wblfontoffset = 40
Adjw = (ScrW()/1920)
Adjh = (ScrH()/1080)


surface.CreateFont( "pont_1", {
	font = "Arial", 
	extended = false,
	size = wblfontoffset + 25,
	weight = 330,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
} )

surface.CreateFont( "pont_2", {
	font = "Arial", 
	extended = false,
	size = wblfontoffset + 13,
	weight = 380,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
} )

surface.CreateFont( "pont_3", {
	font = "Arial", 
	extended = false,
	size = wblfontoffset + 6,
	weight = 410,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
} )

surface.CreateFont( "pont_4", {
	font = "Arial", 
	extended = false,
	size = wblfontoffset + 3,
	weight = 455,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
} )

surface.CreateFont( "pont_5", {
	font = "Arial", 
	extended = false,
	size = wblfontoffset + 1,
	weight = 485,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
} )

surface.CreateFont( "pont_6", {
	font = "Arial", 
	extended = false,
	size = wblfontoffset,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = true,
} )

surface.CreateFont( "pont_monget", {
	font = "Arial", 
	extended = false,
	size = wblfontoffset,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = true,
} )
------------------------------------------
MoneyTextposx = cookie.GetNumber("MoneyTextposx", 0.5) -- Default to 100 if no cookie is found
MoneyTextposy = cookie.GetNumber("MoneyTextposy", 0.95) -- Default to 100 if no cookie is found
wblhuden = cookie.GetNumber("wblcheckboxenhud", 1)


-- Declare Accumonz globally
Accumonz = 0






function MoneyGetLabel(a)
    -- Reset Accumonz after 1 second
    --if wblhuden == 0 then return end
    timer.Create("AccumonzReset", 1, 1, function() 
        Accumonz = 0
    end)

    -- Update Accumonz with the amount a
    Accumonz = Accumonz + a
    local PosTaily = (ScrH() * MoneyTextposy)    
    local PosHeady = (ScrH() * MoneyTextposy) - 50
    local AlphaTail = 255
    local AlphaHead = 0
    local TxtR = 0
    local TxtG = 0
    local b = 0
    if a > 0 then
    	b = "+ ω" .. tostring(Accumonz)
    	TxtG = 255
    	TxtR = 0
	elseif a < 0 then
	    b = "- ω" .. tostring((-1)*Accumonz)
	    TxtG = 0
	    TxtR = 255
	else
		return
	end
	

    local function UpdateHUD()
        PosTaily = Lerp(6 * FrameTime(), PosTaily, PosHeady)
        AlphaTail = Lerp(0.8 * FrameTime(), AlphaTail, AlphaHead)
        draw.SimpleText(b, "pont_monget", ScrW() * MoneyTextposx, PosTaily, Color(TxtR, TxtG, 0, AlphaTail), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    hook.Add("HUDPaint", "Monget", UpdateHUD)
end


--function for updating player money on hud
	--Why did I have to animate and make this nests, still looks cool though
	--to do:
	--Change Box size and text size depending on resolution (ScrW ScrH)
	--OPTIMIZE IS POSSIBLE
function updatewblmoney(a) 
	--if wblhuden == 0 then return end
	local b = "ω"..tostring(a)
	local TTT = 0.02

	timer.Remove("tpont_1")
	timer.Remove("tpont_2")
	timer.Remove("tpont_3")
	timer.Remove("tpont_4")
	timer.Remove("tpont_5")
	hook.Remove("HUDPaint", "pont_1")
	hook.Remove("HUDPaint", "pont_2")
	hook.Remove("HUDPaint", "pont_3")
	hook.Remove("HUDPaint", "pont_4")
	hook.Remove("HUDPaint", "pont_5")
	hook.Remove("HUDPaint", "pont_6")
	hook.Remove("HUDPaint", "RectBack1")
	local txtR = 0
	local txtG = 255
	local txtB = 0
	local BoxR = 0
	local BoxG = 125
	local BoxB = 0

	



	hook.Add( "HUDPaint", "pont_1", function()

		draw.SimpleText( b, "pont_1", ScrW() * MoneyTextposx, ScrH() * MoneyTextposy, Color(txtR, txtG, txtB), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end)
			
	timer.Create("tpont_1",TTT, 1, function() 
		hook.Remove("HUDPaint", "pont_1")
		hook.Add( "HUDPaint", "pont_2", function()
		draw.RoundedBox(16, (ScrW() * MoneyTextposx)-73, (ScrH() * MoneyTextposy)-30, 150, 50, Color(BoxR, BoxG, BoxB,175))
		draw.SimpleText( b, "pont_2", ScrW() * MoneyTextposx, ScrH() * MoneyTextposy, Color(txtR, txtG, txtB), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end)
		timer.Create("tpont_2",TTT, 1, function() 
			hook.Remove("HUDPaint", "pont_2")
			hook.Add( "HUDPaint", "pont_3", function()
			draw.RoundedBox(16, (ScrW() * MoneyTextposx)-73, (ScrH() * MoneyTextposy)-30, 150, 50, Color(BoxR, BoxG, BoxB,175))
			draw.SimpleText( b, "pont_3", ScrW() * MoneyTextposx, ScrH() * MoneyTextposy, Color(txtR, txtG, txtB), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end)
			timer.Create("tpont_3",TTT, 1, function() 
				hook.Remove("HUDPaint", "pont_3")
				hook.Add( "HUDPaint", "pont_4", function()
				draw.RoundedBox(16, (ScrW() * MoneyTextposx)-73, (ScrH() * MoneyTextposy)-30, 150, 50, Color(BoxR, BoxG, BoxB,175))
				draw.SimpleText( b, "pont_4", ScrW() * MoneyTextposx, ScrH() * MoneyTextposy, Color(txtR, txtG, txtB), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end)
				timer.Create("tpont_4",TTT, 1, function() 
					hook.Remove("HUDPaint", "pont_4")
					hook.Add( "HUDPaint", "pont_5", function()
					draw.RoundedBox(16, (ScrW() * MoneyTextposx)-73, (ScrH() * MoneyTextposy)-30, 150, 50, Color(BoxR, BoxG, BoxB,175))
					draw.SimpleText( b, "pont_5", ScrW() * MoneyTextposx, ScrH() * MoneyTextposy, Color(txtR, txtG, txtB), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end)
					timer.Create("tpont_5",TTT, 1, function() 
						hook.Remove("HUDPaint", "pont_5")
						local ColorTail = 0
						local ColorHead = 255
						local ColorTail2 = 120
						local ColorHead2 = 0
						hook.Add( "HUDPaint", "pont_6", function()
						draw.RoundedBox(16, (ScrW() * MoneyTextposx)-73, (ScrH() * MoneyTextposy)-30, 150, 50, Color(BoxR, ColorTail2, BoxB,175))
						draw.SimpleText( b, "pont_6", ScrW() * MoneyTextposx, ScrH() * MoneyTextposy, Color(ColorTail, txtG, ColorTail), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						ColorTail = Lerp(4*FrameTime(), ColorTail, ColorHead)
						ColorTail2 = Lerp(5*FrameTime(), ColorTail2, ColorHead2)
						end)
					end)
				end)
			end)	
		end)
	end)
end


function updatewblmoneylose(a) 
	--if wblhuden == 0 then return end
	local b = "ω"..tostring(a)
	local TTT = 0.02

	timer.Remove("tpont_1")
	timer.Remove("tpont_2")
	timer.Remove("tpont_3")
	timer.Remove("tpont_4")
	timer.Remove("tpont_5")
	hook.Remove("HUDPaint", "pont_1")
	hook.Remove("HUDPaint", "pont_2")
	hook.Remove("HUDPaint", "pont_3")
	hook.Remove("HUDPaint", "pont_4")
	hook.Remove("HUDPaint", "pont_5")
	hook.Remove("HUDPaint", "pont_6")
	hook.Remove("HUDPaint", "RectBack1")
	local txtR = 255
	local txtG = 0
	local txtB = 0
	local BoxR = 125
	local BoxG = 0
	local BoxB = 0
	hook.Add( "HUDPaint", "pont_1", function()

		draw.SimpleText( b, "pont_1", ScrW() * MoneyTextposx, ScrH() * MoneyTextposy, Color(txtR, txtG, txtB), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end)
			
	timer.Create("tpont_1",TTT, 1, function() 
		hook.Remove("HUDPaint", "pont_1")
		hook.Add( "HUDPaint", "pont_2", function()
		draw.RoundedBox(16, (ScrW() * MoneyTextposx)-73, (ScrH() * MoneyTextposy)-30, 150, 50, Color(BoxR, BoxG, BoxB,175))
		draw.SimpleText( b, "pont_2", ScrW() * MoneyTextposx, ScrH() * MoneyTextposy, Color(txtR, txtG, txtB), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end)
		timer.Create("tpont_2",TTT, 1, function() 
			hook.Remove("HUDPaint", "pont_2")
			hook.Add( "HUDPaint", "pont_3", function()
			draw.RoundedBox(16, (ScrW() * MoneyTextposx)-73, (ScrH() * MoneyTextposy)-30, 150, 50, Color(BoxR, BoxG, BoxB,175))
			draw.SimpleText( b, "pont_3", ScrW() * MoneyTextposx, ScrH() * MoneyTextposy, Color(txtR, txtG, txtB), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end)
			timer.Create("tpont_3",TTT, 1, function() 
				hook.Remove("HUDPaint", "pont_3")
				hook.Add( "HUDPaint", "pont_4", function()
				draw.RoundedBox(16, (ScrW() * MoneyTextposx)-73, (ScrH() * MoneyTextposy)-30, 150, 50, Color(BoxR, BoxG, BoxB,175))
				draw.SimpleText( b, "pont_4", ScrW() * MoneyTextposx, ScrH() * MoneyTextposy, Color(txtR, txtG, txtB), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end)
				timer.Create("tpont_4",TTT, 1, function() 
					hook.Remove("HUDPaint", "pont_4")
					hook.Add( "HUDPaint", "pont_5", function()
					draw.RoundedBox(16, (ScrW() * MoneyTextposx)-73, (ScrH() * MoneyTextposy)-30, 150, 50, Color(BoxR, BoxG, BoxB,175))
					draw.SimpleText( b, "pont_5", ScrW() * MoneyTextposx, ScrH() * MoneyTextposy, Color(txtR, txtG, txtB), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end)
					timer.Create("tpont_5",TTT, 1, function() 
						hook.Remove("HUDPaint", "pont_5")
						local ColorTail = 0
						local ColorHead = 255
						local ColorTail2 = 120
						local ColorHead2 = 0
						hook.Add( "HUDPaint", "pont_6", function()
						draw.RoundedBox(16, (ScrW() * MoneyTextposx)-73, (ScrH() * MoneyTextposy)-30, 150, 50, Color(ColorTail2, BoxG, BoxB,175))
						draw.SimpleText( b, "pont_6", ScrW() * MoneyTextposx, ScrH() * MoneyTextposy, Color(txtR, ColorTail, ColorTail), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						ColorTail = Lerp(4*FrameTime(), ColorTail, ColorHead)
						ColorTail2 = Lerp(5*FrameTime(), ColorTail2, ColorHead2)
						end)
					end)
				end)
			end)	
		end)
	end)
end


------------------------------------------
--[[
--Make Main panel for the makeshift startup/when joining
local frame = vgui.Create("DFrame")
frame:SetSize(100, 100)
frame:SetVisible(true)	
frame:Center()
frame:MakePopup()


	local b = vgui.Create("DButton",frame)

	b.DoClick = function()
	--makeshft "on startup" signal by pressing button
		net.Start("plyMonzResetToS") 
		net.SendToServer() 
		for _, npc in ipairs(list.Get("NPC")) do
		    print(npc.Name or "Unnamed NPC", npc.Class)
		end
	end
]]
-------------------------------------------

--signal receved by server to update the hud of player money
net.Receive("plyMonzupdateToC",function(Len)
	local mon = net.ReadInt(32)
	local mongot = net.ReadInt(32)
	updatewblmoney(mon)
	MoneyGetLabel(mongot)
end)

--signal receved by server to signal to lose cash
net.Receive("plyMonzupdateToCLose",function(Len)
	local mon = net.ReadInt(32)
	local monlose = net.ReadInt(32)
	if mon < 0 then
		mon = 0
	end
	updatewblmoneylose(mon)
	MoneyGetLabel(monlose*(-1))
end)

--signal to enable hud or disable money hud
net.Receive("wblmoneyen",function(Len)
	local monen = net.ReadInt(16)
	if monen == 0 then
		timer.Remove("tpont_1")
		timer.Remove("tpont_2")
		timer.Remove("tpont_3")
		timer.Remove("tpont_4")
		timer.Remove("tpont_5")
		hook.Remove("HUDPaint", "pont_1")
		hook.Remove("HUDPaint", "pont_2")
		hook.Remove("HUDPaint", "pont_3")
		hook.Remove("HUDPaint", "pont_4")
		hook.Remove("HUDPaint", "pont_5")
		hook.Remove("HUDPaint", "pont_6")
		hook.Remove("HUDPaint", "RectBack1")
		hook.Remove("HUDPaint", "Monget")
	end
end)


net.Receive("plyMonzcantResetToC", function()
	notification.AddLegacy("Cant reset money if your money is lower than starting money!", NOTIFY_ERROR, 6)
	surface.PlaySound("buttons/button10.wav")
end)

net.Receive("plyMonzResetToC", function()
	surface.PlaySound("weapons/physcannon/physcannon_drop.wav")
	notification.AddLegacy("Your money has reset!", NOTIFY_GENERIC, 3)
end)
								
--net.Receive("wblmoneyresetnotif", function()
--	surface.PlaySound("weapons/ar2/ar2_reload_rotate.wav")
--	surface.PlaySound("weapons/smg1/switch_burst.wav") 
	--surface.PlaySound("weapons/smg1/switch_single.wav") 
--end)

net.Receive("wblEnableShopbuy", function()
    local myIcon = Material("materials/Cart.png") -- Replace with the actual path to your PNG file

    hook.Add("HUDPaint", "DrawMyIcon", function()
        -- Define the position for the icon
        local iconX = (MoneyTextposx * ScrW()) + 90
        local iconY = (MoneyTextposy * ScrH()) - 19
        local iconSize = 32

        -- Set the background color (e.g., semi-transparent black)
        local bgColor = Color(0, 100, 0, 200) -- Change the last value for transparency (0-255)

        -- Draw the rounded rectangle background
        draw.RoundedBox(8, iconX - 5, iconY - 5, iconSize + 10, iconSize + 10, bgColor) -- Adjust padding as needed

        -- Set the color for the icon
        surface.SetDrawColor(0, 255, 0, 255) -- Full white, no tint

        -- Set the material (your PNG icon)
        surface.SetMaterial(myIcon)

        -- Draw the icon
        surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
    end)
end)

-- Receive message to disable drawing the icon
net.Receive("wblDisableShopbuy", function()
    hook.Remove("HUDPaint", "DrawMyIcon")
end)




end