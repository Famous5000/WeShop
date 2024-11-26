--Basic entity Creation Part
include("shared.lua")
--include("Weshop_cl.lua")

local Adjw = (ScrW()/1920)
local Adjh = (ScrH()/1080)

--placeholder sample




remweaponlistnum = 0
local keyBindings = {}

surface.CreateFont( "TheDefaultSettings", {
	font = "Trebuchet24", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 100,
	weight = 500*Adjw,
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

surface.CreateFont( "Definside", {
	font = "Trebuchet24", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 32*Adjw,
	weight = 100*Adjw,
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
	outline = false,
} )


--font for Buy buttons
surface.CreateFont("Buybutton", {
    font = "Trebuchet24",    -- Font name
    size = 25*Adjw,         -- Font size
    weight = 100*Adjw,      -- Font weight (boldness)
})
surface.CreateFont("ClickedBuybutton", {
    font = "Trebuchet24",    -- Font name
    size = 23*Adjw,         -- Font size
    weight = 500*Adjw,      -- Font weight (boldness)
    blursize = 0,
})

surface.CreateFont("Buybuttonammo", {
    font = "Trebuchet24",    -- Font name
    size = 23*Adjw,         -- Font size
    weight = 500*Adjw,      -- Font weight (boldness)
})

surface.CreateFont("Buybuttonammo2", {
    font = "Trebuchet24",    -- Font name
    size = 21*Adjw,         -- Font size
    weight = 500*Adjw,      -- Font weight (boldness)
})

surface.CreateFont("ClickedBuybuttonammo", {
    font = "Trebuchet24",    -- Font name
    size = 21*Adjw,         -- Font size
    weight = 500*Adjw,      -- Font weight (boldness)
    blursize = 0,
})

surface.CreateFont("ClickedBuybuttonammo2", {
    font = "Trebuchet24",    -- Font name
    size = 18*Adjw,         -- Font size
    weight = 500*Adjw,      -- Font weight (boldness)
    blursize = 0,
})

surface.CreateFont("SellButton", {
    font = "Trebuchet24",    -- Font name
    size = 26*Adjw,         -- Font size
    weight = 500*Adjw,      -- Font weight (boldness)
})

surface.CreateFont("SellButtonClicked", {
    font = "Trebuchet24",    -- Font name
    size = 24*Adjw,         -- Font size
    weight = 500*Adjw,      -- Font weight (boldness)
    blursize = 0,
})

surface.CreateFont("Omeg", {
    font = "Trebuchet24",    -- Font name
    size = 28*Adjw,         -- Font size
    weight = 500*Adjw,      -- Font weight (boldness)
    blursize = 0,
})

surface.CreateFont("Omeg2", {
    font = "Trebuchet24",    -- Font name
    size = 21*Adjw,         -- Font size
    weight = 500*Adjw,      -- Font weight (boldness)
    blursize = 0,
})

surface.CreateFont("Omeg3", {
    font = "Trebuchet24",    -- Font name
    size = 50*Adjw,         -- Font size
    weight = 500*Adjw,      -- Font weight (boldness)
    blursize = 0,
})

function ENT:Draw()

	self:DrawModel()

	local ang = self:GetAngles() -- To position the 3d2d drawing
	local flicker = math.random(50, 255) -- Flickering effect for the word

	-- Define the size and position of the triangular cone


	-- First side (original)
	local ang1 = self:GetAngles()
	ang1:RotateAroundAxis(self:GetAngles():Right(), 90)
	ang1:RotateAroundAxis(self:GetAngles():Forward(), 90)
	cam.Start3D2D(self:GetPos(), ang1, 0.1)

		-- Draw the text
		draw.SimpleText("ωelcome!", "TheDefaultSettings", 0, -500, Color(255, 255, 0, flicker), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
	cam.End3D2D()

	
	local ang2 = self:GetAngles()
	ang2:RotateAroundAxis(self:GetAngles():Right(), 270)
	ang2:RotateAroundAxis(self:GetAngles():Forward(), 90)
	cam.Start3D2D(self:GetPos(), ang2, 0.1)


		-- Draw the text
		draw.SimpleText("ωelcome!", "TheDefaultSettings", 0, -500, Color(255, 255, 0, flicker), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	cam.End3D2D()

	local ang3 = self:GetAngles()
	ang1:RotateAroundAxis(self:GetAngles():Right(), 180)
	ang1:RotateAroundAxis(self:GetAngles():Forward(), 0)
	cam.Start3D2D(self:GetPos(), ang1, 0.1)

		-- Draw the text
		draw.SimpleText("ωelcome!", "TheDefaultSettings", 0, -300, Color(255, 255, 0, flicker), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
	cam.End3D2D()

	local ang4 = self:GetAngles()
	ang2:RotateAroundAxis(self:GetAngles():Right(), 180)
	ang2:RotateAroundAxis(self:GetAngles():Forward(), 0)
	cam.Start3D2D(self:GetPos(), ang2, 0.1)

		-- Draw the text
		draw.SimpleText("ωelcome!", "TheDefaultSettings", 0, -300, Color(255, 255, 0, flicker), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
	cam.End3D2D()

end


local HP10price
local HP25price 
local AP10price
local AP25price
local ammo1price
local ammo2price
local weapsellvalue
wblweaponlist = {}
wblammolist = {}




net.Receive("wblupdatepricetoClient",function()
	HP10price = tonumber(net.ReadInt(32))
	HP25price = tonumber(net.ReadInt(32))
	AP10price = tonumber(net.ReadInt(32))
	AP25price = tonumber(net.ReadInt(32))
	weapsellvalue = tostring(net.ReadString())
	local ammo1 = tostring(net.ReadString())
	local ammo2 = tostring(net.ReadString())


	if ammo1 == "N.A." then
		ammo1price = "( N.A.)"
		ammo1pricefull = "( N.A.)"
	else
		ammo1price = "( ω"..ammo1.." )"
		ammo1pricefull = "( varies )"
	end

	if ammo2 == "N.A." then
		ammo2price = "( N.A.)"
		ammo2pricefull = "( N.A.)"
	else
		ammo2price = "( ω"..ammo2.." )"
		ammo2pricefull = "( varies )"
	end

end)

--Signal "WinPop" received from server when entity is used by player
net.Receive("wblWinPop",function()	

wblBuyMenu = vgui.Create("DFrame")
wblBuyMenu:SetSize(1280*Adjw, 720*Adjh)
wblBuyMenu:SetVisible(true)
wblBuyMenu:SetTitle("")
wblBuyMenu:SetDraggable(false)
wblBuyMenu:MakePopup()
wblBuyMenu:Center()    
wblBuyMenu.Paint = function(self, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 235)) 
    surface.SetDrawColor(255, 255, 0, 150) -- Yellow color with 150 alpha for transparency
    surface.DrawOutlinedRect(0, 0, w, h, 2) -- Draw the outline with a 2-pixel width
end

--wblweaponlist = net.ReadTable()
--PrintTable(wblweaponlist)
--wblammolist = net.ReadTable()
--PrintTable(wblammolist)



local remnumbut = #wblweaponlist

-- Call the function to update the image whenever the player switches weapons


	--for guide ill remove this
	local WeshoplineMidRight = vgui.Create("DLabel", wblBuyMenu)
	WeshoplineMidRight:SetText("")
	WeshoplineMidRight:SetPos( 850*Adjw, 150*Adjh ) 
	WeshoplineMidRight:SetSize(4*Adjw, 550*Adjh)
	WeshoplineMidRight.Paint = function(self, w, h)
    	draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 0, 100)) 
	end
	
	local Weshoptutorial = vgui.Create("DLabel", wblBuyMenu)
	Weshoptutorial:SetTall(30*Adjh)
	Weshoptutorial:SetText("Please Select a Tab ⤴")
	Weshoptutorial:SetPos( 40*Adjw, 150*Adjh ) 
	Weshoptutorial:SetSize(600*Adjw, 50*Adjh)
	Weshoptutorial:SetContentAlignment(4)
	Weshoptutorial:SetFont("Definside")
	Weshoptutorial:SetTextColor(Color(255, 255, 0, 150))
	Weshoptutorial:SetWrap(false)


	local Weshoptitle = vgui.Create("DLabel", wblBuyMenu)
	Weshoptitle:Dock(TOP)
	Weshoptitle:SetTall(30*Adjh)
	Weshoptitle:DockMargin(0, 10*Adjh, 0, 10*Adjh)
	Weshoptitle:SetText("ωelcome to the ωeapon shop!!")
	Weshoptitle:SetContentAlignment(5)
	Weshoptitle:SetFont("Definside")
	Weshoptitle:SetTextColor(Color(255, 255, 0, 150))
	Weshoptitle:SetWrap(false)

	local Weshopclosehint = vgui.Create("DLabel", wblBuyMenu)
	Weshopclosehint:SetSize(1100*Adjw, 25*Adjh) 
	Weshopclosehint:SetPos( 80*Adjw, 5*Adjh ) 
	Weshopclosehint:SetText(" (Press 'e' to close)    (Press 'c' to buy primary ammo)    (Press 'v' to buy secondary ammo)    (Press 1-9 to buy corresponding weapon)")
	Weshopclosehint:SetContentAlignment(5)
	Weshopclosehint:SetFont("Omeg2")
	Weshopclosehint:SetTextColor(Color(255, 255, 0, 150))
	Weshopclosehint:SetWrap(false)
		
		local function CreateIconframe(name, fileloc, xposition, yposition)
			local name = vgui.Create("DImage", wblBuyMenu)
			name:SetSize(100*Adjw, 100*Adjh) 
			name:SetPos( xposition*Adjw, yposition*Adjh ) 
			name:SetImage(fileloc) 
			name:SetImageColor(Color(255, 255, 255, 150))
		end

		--Medkit Icon
		CreateIconframe(WeshopMedkit, "materials/HP.png", 870, 170)
		
		--Armor Icon
		CreateIconframe(WeshopBattery, "materials/AP.png", 870, 307.5)

		--Primary Ammo Icon
		CreateIconframe(WeshopAmmo1, "materials/PA.png", 870, 445)

		--Secondary Ammo Icon
		CreateIconframe(WeshopAmmo2, "materials/SA.png", 870, 582.5)

		--Scroll Panel for Button Categories
		local CatscrollPanel = vgui.Create("DScrollPanel", wblBuyMenu)
		CatscrollPanel:Dock(TOP)
		CatscrollPanel:SetSize(1, 200)
		CatscrollPanel:SetPadding(100)
		

		local CatbuttonPanel = vgui.Create("DPanel", CatscrollPanel)
		CatbuttonPanel:Dock(TOP)
		CatbuttonPanel:SetTall(50*Adjh)
		CatbuttonPanel:SetWide(100*Adjw)  
		CatbuttonPanel.Paint = function(self, w, h)
		    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0)) -- Fully transparent background
		end
		
		--sample categories for the weapon lists
		
		--scrollpanel creation for weapon lists when a Button category is pressed
		local function CreateScrollPanel(frame, wblweaponlistaftcat)
		    if currentScrollPanel then
		        currentScrollPanel:Remove() -- Remove the previous scroll panel
		    end

		    -- Create new scroll panel
		    local scrollPanel = vgui.Create("DScrollPanel", frame)
		    scrollPanel:SetSize(450*Adjw, 420*Adjh) 
			scrollPanel:SetPos(32*Adjw, 170*Adjh) 
		    scrollPanel.Paint = function(self, w, h)
		        draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 100)) 
		    end

		    -- Customize the scroll bar
			local sbar = scrollPanel:GetVBar()

			-- Paint the background of the scrollbar with yellow outline
			function sbar:Paint(w, h)
			    surface.SetDrawColor(255, 255, 0, 70) -- Yellow color for the outline
			    surface.DrawOutlinedRect(0, 0, w, h, 2) -- Draws a 2px thick outline
			end

			-- Paint the up button with yellow outline
			function sbar.btnUp:Paint(w, h)
			    surface.SetDrawColor(255, 255, 0, 70) -- Yellow color for the outline
			    surface.DrawOutlinedRect(0, 0, w, h, 6) -- 2px outline for the up button
			end

			-- Paint the down button with yellow outline
			function sbar.btnDown:Paint(w, h)
			    surface.SetDrawColor(255, 255, 0, 70) -- Yellow color for the outline
			    surface.DrawOutlinedRect(0, 0, w, h, 6) -- 2px outline for the down button
			end

			-- Paint the grip with yellow outline
			function sbar.btnGrip:Paint(w, h)
			    surface.SetDrawColor(255, 255, 0, 70) -- Yellow color for the outline
			    surface.DrawOutlinedRect(0, 0, w, h, 7.5) -- 2px outline for the grip
			end

		
		    -- Add buttons to the scroll panel
		    for k, v in ipairs(wblweaponlistaftcat.weapons) do
			        local button = scrollPanel:Add("DButton")
			        button:SetText("")
			        button:SetSize(400*Adjw, 40*Adjh)
			        button:Dock(TOP)
			        button:DockMargin(10*Adjw, 10*Adjh, 10*Adjw, 0)
					button.isClicked = false
					button.isHovered = false 
					button.panelsCreated = false
					local BackModelPanel, BackTitlePanel, BackDescPanel
					local ModelPanel, TitlePanel, DescPanel
					local finalname = "("..k..") "..v.name -- change to truncate the dot dot
					local finalcost = "ω"..v.cost



					function button:Paint(w, h)
					    if self.isClicked then
					        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 0, 75)) 
					        draw.SimpleText(finalname, "ClickedBuybutton", 5, h / 2, Color(255, 255, 255, 220), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					        surface.SetDrawColor(255, 255, 0, 150)
					        surface.DrawOutlinedRect(0, 0, w, h, 2)
					    else
					        if self.isHovered then
					            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 0, 40)) -- Flash background when hovered
					        end
					        surface.SetDrawColor(255, 255, 0, 150)
					        surface.DrawOutlinedRect(0, 0, w, h, 2)
					        draw.SimpleText(finalname, "Buybutton", 5*Adjw, h / 2, Color(255, 255, 0, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					        --draw.SimpleText(finalcost, "Buybutton", 410*Adjw, h / 2, Color(255, 255, 0, 150), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
					    end
					end

					-- Add hover effect
					function button:OnCursorEntered()
					    self.isHovered = true
					    
					    -- Only create the panels if they haven't been created yet
					    if not self.panelsCreated then

					        BackModelPanel = vgui.Create("DPanel", wblBuyMenu)
					        BackModelPanel:SetSize(236 * Adjw, 200 * Adjh)
					        BackModelPanel:SetPos(552 * Adjw, 170 * Adjh)
					        BackModelPanel.Paint = function(self, w, h)
					            draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0, 90))
					        end


					        	local weaponClass = v.class
								local imagePath = "entities/" .. weaponClass .. ".png"
								local backupImagePath = "materials/vgui/hud/icon_placeholder.vtf"  -- Replace this with your backup image path

								-- Function to check if the material exists
								local function DoesMaterialExist(materialPath)
								    return Material(materialPath):IsError() == false
								end

								-- Check if the primary image exists; if not, use the backup image
								if DoesMaterialExist(imagePath) then
								    ModelPanel = vgui.Create("DImage", BackModelPanel)
								    ModelPanel:Dock(FILL)
								    ModelPanel:SetImage(imagePath)
								else
								    local threedmodelPanel = vgui.Create("DModelPanel", BackModelPanel)
								    threedmodelPanel:Dock(FILL)
								    
								    -- Check if it's a weapon or entity and get the model accordingly
								    local weaponTable = weapons.Get(weaponClass) -- Try getting weapon data from the class
								    local entityTable = scripted_ents.GetStored(weaponClass) -- Try getting entity data from the class

								    if weaponTable and weaponTable.WorldModel then
								        -- If it's a valid weapon, use its world model
								        threedmodelPanel:SetModel(weaponTable.WorldModel)
								    elseif entityTable and entityTable.t.Model then
								        -- If it's a valid entity, use its model
								        threedmodelPanel:SetModel(entityTable.t.Model)
								    else
								        -- Show error model if neither weapon nor entity is valid
								        threedmodelPanel:SetModel("models/error.mdl")
								    end

								    -- Set up the model panel controls
								    threedmodelPanel:SetCamPos(Vector(50, 25, 50)) -- Camera position
								    threedmodelPanel:SetLookAt(Vector(0, 0, 0)) -- Look at the center of the model
								    threedmodelPanel:SetFOV(40) -- Field of view
								    threedmodelPanel:SetAnimated(true) -- Enable animation for certain models
								end

						        --[[
						        local weaponClass = v.class
								local imagePath = "entities/" .. weaponClass .. ".png"
								local backupImagePath = "materials/vgui/hud/icon_placeholder.vtf"  -- Replace this with your backup image path

								-- Function to check if the material exists
								local function DoesMaterialExist(materialPath)
								    return Material(materialPath):IsError() == false
								end

								-- Check if the primary image exists; if not, use the backup image
								if DoesMaterialExist(imagePath) then
									ModelPanel = vgui.Create("DImage", BackModelPanel)
									ModelPanel:Dock(FILL)
								    ModelPanel:SetImage(imagePath)
								else
								    local threedmodelPanel = vgui.Create("DModelPanel", BackModelPanel)
								    threedmodelPanel:Dock(FILL)
								    -- Get the model for the given weapon class
								    local weaponTable = weapons.Get(weaponClass) -- Get weapon data from the class
								    if weaponTable and weaponTable.WorldModel then
								        threedmodelPanel:SetModel(weaponTable.WorldModel) -- Set the weapon's world model
								    else
								        threedmodelPanel:SetModel("models/error.mdl") -- Show error model if the weapon is invalid
								    end

								    -- Set up the model panel controls
								    threedmodelPanel:SetCamPos(Vector(50, 25, 50)) -- Camera position
								    threedmodelPanel:SetLookAt(Vector(0, 0, 0)) -- Look at the center of the model
								    threedmodelPanel:SetFOV(40) -- Field of view
								    threedmodelPanel:SetAnimated(true) -- Enable animation for certain models
															    
								end
								]]




					        BackTitlePanel = vgui.Create("DPanel", wblBuyMenu)
					        BackTitlePanel:SetSize(236 * Adjw, 59 * Adjh)
					        BackTitlePanel:SetPos(552 * Adjw, 380 * Adjh)
					        BackTitlePanel.Paint = function(self, w, h)
					            draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0, 90))
					        end

					        	local TitlePanel = vgui.Create("DLabel", BackTitlePanel)
					        	local finalnamecost = v.name
								TitlePanel:SetText(finalnamecost) 
								TitlePanel:Dock(TOP)
								TitlePanel:SetFont("Omeg")
								TitlePanel:SetSize(0, 30*Adjh)
								TitlePanel:SetContentAlignment(5)
								TitlePanel:SetTextColor(Color(255, 255, 0, 150))
								TitlePanel.Paint = function(self, w, h)
							    	draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0)) 
								end

								local TitlePanel2 = vgui.Create("DLabel", BackTitlePanel)
								TitlePanel2:SetText(finalcost) 
								TitlePanel2:Dock(TOP)
								TitlePanel2:DockMargin(0, 5, 0, 0)
								TitlePanel2:SetSize(0, 25*Adjh)
								TitlePanel2:SetFont("Omeg")
								TitlePanel2:SetContentAlignment(5)
								TitlePanel2:SetTextColor(Color(255, 255, 0, 150))
								TitlePanel2.Paint = function(self, w, h)
							    	draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0)) 
								end

					        BackDescPanel = vgui.Create("DPanel", wblBuyMenu)
					        BackDescPanel:SetSize(286 * Adjw, 230 * Adjh)
					        BackDescPanel:SetPos(527 * Adjw, 445 * Adjh)
					        BackDescPanel.Paint = function(self, w, h)
					            draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0, 70))
					        end
					        local finaldesc
					        if v.Arsenaltype ~= "ENT" then
					        	finaldesc = "Primary Ammo:  "..v.ammo1.."\nSecondary Ammo:  "..v.ammo2.."\nSlotID:  "..v.slotid.."\n\n"..v.desc
					    	else
					    		finaldesc = v.desc
					    	end
					    
					        	local DescPanel = vgui.Create("DLabel", BackDescPanel)
								DescPanel:SetText(finaldesc) --placeholder
								DescPanel:Dock(FILL)
								DescPanel:SetFont("Omeg2")
								DescPanel:SetContentAlignment(7)
								DescPanel:SetWrap(true) -- Enable text wrapping
								DescPanel:DockMargin(10*Adjw, 10*Adjh, 10*Adjw, 10*Adjh)
								DescPanel:SetTextColor(Color(255, 255, 0, 150))
								DescPanel.Paint = function(self, w, h)
							    	draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0)) 
								end
					        self.panelsCreated = true -- Mark the panels as created
					    end
					end



					function button:OnCursorExited()
					    self.isHovered = false

					    -- Remove the panels when the cursor exits the button
					    if self.panelsCreated then
					        BackModelPanel:Remove()
					        BackTitlePanel:Remove()
					        BackDescPanel:Remove()
					        BackModelPanel:Remove()
					        self.panelsCreated = false -- Reset the flag so panels can be created again when hovered
					    end
					end



					button.OnMousePressed = function()
					    button.isClicked = true
					    button:InvalidateLayout(true) -- Force the previous button to repaint
					end

					button.OnMouseReleased = function()
					    button.isClicked = false
					    button:InvalidateLayout(true) -- Force the previous button to repaint
					    net.Start("wblBuyweapon") 
					    net.WriteInt(v.cost, 32)
					    net.WriteString(v.class)
					    net.WriteString(v.Arsenaltype)
			    		net.SendToServer()
					end

					
					if k < 10 then
						local keyname = "KEY_" .. k
					    local keyCode = _G[keyname]
					    keyBindings[keyCode] = function()
					    	if not button:IsValid() then return end
					    	button.isClicked = false
						    button:InvalidateLayout(true) -- Force the previous button to repaint
						    net.Start("wblBuyweapon") 
						    net.WriteInt(v.cost, 32)
						    net.WriteString(v.class)
						    net.WriteString(v.Arsenaltype)
				    		net.SendToServer()
					    end
					elseif k == 10 then
					    local keyCode = KEY_0
					    keyBindings[keyCode] = function()
					    	if not button:IsValid() then return end
					    	button.isClicked = false
						    button:InvalidateLayout(true) -- Force the previous button to repaint
						    net.Start("wblBuyweapon") 
						    net.WriteInt(v.cost, 32)
						    net.WriteString(v.class)
						    net.WriteString(v.Arsenaltype)
				    		net.SendToServer()
					    end
					end





		    end
		    currentScrollPanel = scrollPanel
		end

		if remweaponlistnum ~= 0 then
        	CreateScrollPanel(wblBuyMenu, wblweaponlist[remweaponlistnum])
        	Weshoptutorial:SetVisible(false)

		end



		local numofcatbuttons = #wblweaponlist
		if numofcatbuttons == 0 then
        	Weshoptutorial:SetVisible(false)
        	local Weshoptutorial2 = vgui.Create("DLabel", wblBuyMenu)
			Weshoptutorial2:SetTall(30*Adjh)
			Weshoptutorial2:SetText("No Weapons to sell! Add weapons or load Presets in:\nSpawnmenu -> Options -> WeShop Admin -> Shop Options")
			Weshoptutorial2:SetPos( 80*Adjw, 200*Adjh ) 
			Weshoptutorial2:SetSize(700*Adjw, 80*Adjh)
			Weshoptutorial2:SetContentAlignment(4)
			Weshoptutorial2:SetFont("Definside")
			Weshoptutorial2:SetTextColor(Color(255, 255, 0, 150))
			Weshoptutorial2:SetWrap(false)
        end
		surface.CreateFont("CatButton", {
		    font = "Trebuchet24",    -- Font name
		    size = (32-numofcatbuttons)*Adjw,         -- Font size
		    weight = 500*Adjw,      -- Font weight (boldness)
		})
		surface.CreateFont("CatButtonpres", {
		    font = "DebugOverlay",    -- Font name
		    size = ((30-numofcatbuttons)*Adjw),         -- Font size
		    weight = 500*Adjw,      -- Font weight (boldness)
		    scanlines = 0,
			antialias = true,
			underline = false,
			italic = false,
			strikeout = false,
			symbol = false,
			rotary = false,
			shadow = false,
			additive = true,
			outline = false,
		})


		----Button adjusts automatically with number of buttons(Categories)---
		local buttonsize = (1205*Adjw)/numofcatbuttons
		local firstmarg = 1
		local currentClickedButton = nil
		local Exampletable = {}

		-- Function for when a label is too long for button
		function truncateString(inputStr)
		    local maxLength = math.floor(100/numofcatbuttons)
		    if #inputStr > maxLength then
		        return inputStr:sub(1, maxLength) .. ".."
		    else
		        return inputStr
		    end
		end

		-- Loop to make an example category for testing
		for i = 1, numofcatbuttons do
			local bname = (wblweaponlist[i].name)
			table.insert(Exampletable, bname)
		end
		
		--Loop that makes the buttons
		for i = 1, numofcatbuttons do

		    local Catbutton = vgui.Create("DButton", CatbuttonPanel)
			if firstmarg == 1 then
			    firstmarg = 0
			    Catbutton:DockMargin(30*Adjw, 5*Adjh, 0, 5*Adjh)
			else
			    Catbutton:DockMargin(10*Adjw, 5*Adjh, 0, 5*Adjh)
			end

			if numofcatbuttons == 1 then
			    Catbutton:SetSize(buttonsize, 50*Adjh)
			else
			    buttonsize = (((1220)*Adjw) / numofcatbuttons) - ((1 * 9.5)*Adjw)
			    Catbutton:SetSize(buttonsize, 50*Adjh)
			end
			Catbutton:SetText("")
			Catbutton:SetTextColor(Color(0, 0, 0))
			Catbutton:SetFont("CatButton")
			Catbutton:Dock(LEFT)
			Catbutton.isClicked = false
			Catbutton.isHovered = false -- Add hover tracking

			--Paint function for the button
			function Catbutton:Paint(w, h)
			    if self.isClicked then
			        draw.SimpleText(truncateString(Exampletable[i]), "CatButtonpres", w / 2, h / 2, Color(255, 255, 255, 220), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			        draw.RoundedBox(8, 0, 0, w, h, Color(255, 255, 0, 75))
			        surface.SetDrawColor(255, 255, 0, 150) -- Yellow color with 150 alpha for transparency
			        surface.DrawOutlinedRect(0, 0, w, h, 2) -- Draw the outline with a 2-pixel width 
			    else
			        if self.isHovered then
			            draw.RoundedBox(8, 0, 0, w, h, Color(255, 255, 0, 40)) -- Flash background when hovered
			        end
			        draw.SimpleText(truncateString(Exampletable[i]), "CatButton", w / 2, h / 2, Color(255, 255, 0, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			        surface.SetDrawColor(255, 255, 0, 150) -- Yellow color with 150 alpha for transparency
			        surface.DrawOutlinedRect(0, 0, w, h, 2) -- Draw the outline with a 2-pixel width 
			    end
			end

			-- Hover effect
			Catbutton.OnCursorEntered = function(self)
			    self.isHovered = true
			    self:InvalidateLayout(true) -- Repaint when hovered
			end

			Catbutton.OnCursorExited = function(self)
			    self.isHovered = false
			    self:InvalidateLayout(true) -- Repaint when hover ends
			end

			-- DoClick function for each button
			Catbutton.DoClick = function()
			    if currentClickedButton then
			        currentClickedButton.isClicked = false
			        currentClickedButton:InvalidateLayout(true) -- Force the previous button to repaint
			    end
			    Catbutton.isClicked = true
			    currentClickedButton = Catbutton
			    Catbutton:InvalidateLayout(true)
			    remweaponlistnum = i
			    CreateScrollPanel(wblBuyMenu, wblweaponlist[i])
				Weshoptutorial:SetVisible(false)
			end
		end


		
		--function to make a functional button
		local function CreateBuyButton(name, frame, fontdefault, fontclick, xposition, yposition, label, netsend)
			local name = vgui.Create("DButton", wblBuyMenu)
			name:SetSize(150*Adjw, 50*Adjh)
			name:SetText("")
			name:SetTextColor(Color(0, 0, 0))
			name:SetFont("Buybutton")
			name:SetPos( xposition*Adjw, yposition*Adjh )
			name.isClicked = false
			name.isHovered = false -- New variable to track hover state

			function name:Paint(w, h)
			    if name.isClicked then
			        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 0, 75)) 
			        draw.SimpleText(label, fontclick, w / 2, h / 2, Color(255, 255, 255, 220), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			        surface.SetDrawColor(255, 255, 0, 150) -- Yellow color with 150 alpha for transparency
			        surface.DrawOutlinedRect(0, 0, w, h, 2) -- Draw the outline with a 2-pixel width 
			    else
			        if name.isHovered then
			            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 0, 40)) -- Flash background when hovered
			        end
			        surface.SetDrawColor(255, 255, 0, 150) -- Yellow color with 150 alpha for transparency
			        surface.DrawOutlinedRect(0, 0, w, h, 2) -- Draw the outline with a 2-pixel width 
			        draw.SimpleText(label, fontdefault, w / 2, h / 2, Color(255, 255, 0, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			    end
			end

			-- Add hover effect
			name.OnCursorEntered = function(self)
			    name.isHovered = true
			    name:InvalidateLayout(true)
			end

			name.OnCursorExited = function(self)
			    name.isHovered = false
			    name:InvalidateLayout(true)
			end

			name.OnMousePressed = function()
			    name.isClicked = true
			    name:InvalidateLayout(true) -- Force the previous button to repaint
			end

			name.OnMouseReleased = function()
			    name.isClicked = false
			    name:InvalidateLayout(true) -- Force the previous button to repaint
			    net.Start(netsend) 
			    net.SendToServer()
			end

		end

		local function CreateBuyButtonPrimaryAmmo(name, frame, fontdefault, fontclick, xposition, yposition, label, netsend)
			local name = vgui.Create("DButton", wblBuyMenu)
			name:SetSize(150*Adjw, 50*Adjh)
			name:SetText("")
			name:SetTextColor(Color(0, 0, 0))
			name:SetFont("Buybutton")
			name:SetPos( xposition*Adjw, yposition*Adjh )
			name.isClicked = false
			name.isHovered = false -- New variable to track hover state

			function name:Paint(w, h)
			    if name.isClicked then
			        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 0, 75)) 
			        draw.SimpleText(label, fontclick, w / 2, h / 2, Color(255, 255, 255, 220), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			        surface.SetDrawColor(255, 255, 0, 150) -- Yellow color with 150 alpha for transparency
			        surface.DrawOutlinedRect(0, 0, w, h, 2) -- Draw the outline with a 2-pixel width 
			    else
			        if name.isHovered then
			            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 0, 40)) -- Flash background when hovered
			        end
			        surface.SetDrawColor(255, 255, 0, 150) -- Yellow color with 150 alpha for transparency
			        surface.DrawOutlinedRect(0, 0, w, h, 2) -- Draw the outline with a 2-pixel width 
			        draw.SimpleText(label, fontdefault, w / 2, h / 2, Color(255, 255, 0, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			    end
			end

			-- Add hover effect
			name.OnCursorEntered = function(self)
			    name.isHovered = true
			    name:InvalidateLayout(true)
			end

			name.OnCursorExited = function(self)
			    name.isHovered = false
			    name:InvalidateLayout(true)
			end

			name.OnMousePressed = function()
			    name.isClicked = true
			    name:InvalidateLayout(true) -- Force the previous button to repaint
			end

			name.OnMouseReleased = function()
			    name.isClicked = false
			    name:InvalidateLayout(true) -- Force the previous button to repaint
			    net.Start(netsend) 
			    net.SendToServer()
			end

		end

		--MADE NEW ONE FOR KEY PRESS ON PRIMARY AMMO
		local function CreateBuyButtonPrimaryAmmoKEY(name, frame, fontdefault, fontclick, xposition, yposition, label, netsend)
			local name = vgui.Create("DButton", wblBuyMenu)
			name:SetSize(150*Adjw, 50*Adjh)
			name:SetText("")
			name:SetTextColor(Color(0, 0, 0))
			name:SetFont("Buybutton")
			name:SetPos( xposition*Adjw, yposition*Adjh )
			name.isClicked = false
			name.isHovered = false -- New variable to track hover state

			function name:Paint(w, h)
			    if name.isClicked then
			        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 0, 75)) 
			        draw.SimpleText(label, fontclick, w / 2, h / 2, Color(255, 255, 255, 220), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			        surface.SetDrawColor(255, 255, 0, 150) -- Yellow color with 150 alpha for transparency
			        surface.DrawOutlinedRect(0, 0, w, h, 2) -- Draw the outline with a 2-pixel width 
			    else
			        if name.isHovered then
			            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 0, 40)) -- Flash background when hovered
			        end
			        surface.SetDrawColor(255, 255, 0, 150) -- Yellow color with 150 alpha for transparency
			        surface.DrawOutlinedRect(0, 0, w, h, 2) -- Draw the outline with a 2-pixel width 
			        draw.SimpleText(label, fontdefault, w / 2, h / 2, Color(255, 255, 0, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			    end
			end

			-- Add hover effect
			name.OnCursorEntered = function(self)
			    name.isHovered = true
			    name:InvalidateLayout(true)
			end

			name.OnCursorExited = function(self)
			    name.isHovered = false
			    name:InvalidateLayout(true)
			end

			name.OnMousePressed = function()
			    name.isClicked = true
			    name:InvalidateLayout(true) -- Force the previous button to repaint
			end

			name.OnMouseReleased = function()
			    name.isClicked = false
			    name:InvalidateLayout(true) -- Force the previous button to repaint
			    net.Start(netsend) 
			    net.SendToServer()
			end
			local keyCode = KEY_C
		    keyBindings[keyCode] = function()
		    	net.Start(netsend) 
			    net.SendToServer()
		    end

		end

		--MADE NEW FUNCTION FOR SECONDARY BUY KEY
		local function CreateBuyButtonSECONDKEY(name, frame, fontdefault, fontclick, xposition, yposition, label, netsend)
			local name = vgui.Create("DButton", wblBuyMenu)
			name:SetSize(150*Adjw, 50*Adjh)
			name:SetText("")
			name:SetTextColor(Color(0, 0, 0))
			name:SetFont("Buybutton")
			name:SetPos( xposition*Adjw, yposition*Adjh )
			name.isClicked = false
			name.isHovered = false -- New variable to track hover state

			function name:Paint(w, h)
			    if name.isClicked then
			        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 0, 75)) 
			        draw.SimpleText(label, fontclick, w / 2, h / 2, Color(255, 255, 255, 220), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			        surface.SetDrawColor(255, 255, 0, 150) -- Yellow color with 150 alpha for transparency
			        surface.DrawOutlinedRect(0, 0, w, h, 2) -- Draw the outline with a 2-pixel width 
			    else
			        if name.isHovered then
			            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 0, 40)) -- Flash background when hovered
			        end
			        surface.SetDrawColor(255, 255, 0, 150) -- Yellow color with 150 alpha for transparency
			        surface.DrawOutlinedRect(0, 0, w, h, 2) -- Draw the outline with a 2-pixel width 
			        draw.SimpleText(label, fontdefault, w / 2, h / 2, Color(255, 255, 0, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			    end
			end

			-- Add hover effect
			name.OnCursorEntered = function(self)
			    name.isHovered = true
			    name:InvalidateLayout(true)
			end

			name.OnCursorExited = function(self)
			    name.isHovered = false
			    name:InvalidateLayout(true)
			end

			name.OnMousePressed = function()
			    name.isClicked = true
			    name:InvalidateLayout(true) -- Force the previous button to repaint
			end

			name.OnMouseReleased = function()
			    name.isClicked = false
			    name:InvalidateLayout(true) -- Force the previous button to repaint
			    net.Start(netsend) 
			    net.SendToServer()
			end
		    local keyCode = KEY_V
		    keyBindings[keyCode] = function()
		    	net.Start(netsend) 
			    net.SendToServer()
		    end

		end

		--function to make money price tag label
		local function CreatePriceDlabel(name, frame, xposition, yposition, label)
			local name = vgui.Create("DLabel", wblBuyMenu)
			name:SetText(label) --placeholder
			name:SetPos( xposition*Adjw, yposition*Adjh )
			name:SetFont("Omeg")
			name:SetContentAlignment(5)
			name:SetTextColor(Color(255, 255, 0, 150))
			name:SetSize(100*Adjw, 50*Adjh)
			name.Paint = function(self, w, h)
		    	draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0)) 
			end
		end

		--Buy 10HP button
		CreateBuyButton(WeshopMedkitBuy1button, wblBuyMenu, "Buybutton", "ClickedBuybutton", 1000, 165, "Buy 10 Health", "wblplybought10hp")

		--Price Label for 10HP button
		CreatePriceDlabel(WeshopMedkitLabel1, wblBuyMenu, 1170, 165, "( ω"..HP10price.." )")
		
		--Buy 25HP button
		CreateBuyButton(WeshopMedkitBuy2button, wblBuyMenu, "Buybutton", "ClickedBuybutton", 1000, 220, "Buy 25 Health", "wblplybought25hp")

		--Price Label for 25HP button
		CreatePriceDlabel(WeshopMedkitLabel2, wblBuyMenu, 1170, 220, "( ω"..HP25price.." )")
		    
		--Buy 10AP button
		CreateBuyButton(WeshopBattery1button, wblBuyMenu, "Buybutton", "ClickedBuybutton", 1000, 302.5, "Buy 10 Armor", "wblplybought10ap")
		
		--Price Label for 10AP button
		CreatePriceDlabel(WeshopBattery1Label, wblBuyMenu, 1170, 302.5, "( ω"..AP10price.." )")

		--Buy 25AP button
		CreateBuyButton(WeshopBattery2button, wblBuyMenu, "Buybutton", "ClickedBuybutton", 1000, 357.5, "Buy 25 Armor", "wblplybought25ap")
		
		--Price Label for 25AP button
		CreatePriceDlabel(WeshopBattery2Label, wblBuyMenu, 1170, 357.5, "( ω"..AP25price.." )")

		--Buy 1 Primary ammo button
		CreateBuyButtonPrimaryAmmoKEY(WeshopPrimammo1button, wblBuyMenu, "Buybuttonammo", "ClickedBuybuttonammo", 1000, 440, "Buy Ammo", "wblplybought1primeammo")
		
		--Price Label for 1 Primary ammo button
		CreatePriceDlabel(WeshopPrimammo1Label, wblBuyMenu, 1170, 440, ammo1price)

		--Buy all Primary ammo button
		CreateBuyButtonPrimaryAmmo(WeshopPrimammo2button, wblBuyMenu, "Buybuttonammo", "ClickedBuybuttonammo", 1000, 495, "Buy Full Ammo", "wblplyboughtfullprimeammo")
		
		--Price Label for all Primary ammo button
		CreatePriceDlabel(WeshopPrimammo2Label, wblBuyMenu, 1170, 495, ammo1pricefull)

		--Buy 1 Primary ammo button
		CreateBuyButtonSECONDKEY(WeshopSecammo1button, wblBuyMenu, "Buybuttonammo2", "ClickedBuybuttonammo2", 1000, 577.5, "Buy Alt Ammo", "wblplybought1secammo")
		
		--Price Label for 1 Primary ammo button
		CreatePriceDlabel(WeshopSecammo1Label, wblBuyMenu, 1170, 577.5, ammo2price)

		--Buy all Primary ammo button
		CreateBuyButton(WeshopSecammo2button, wblBuyMenu, "Buybuttonammo2", "ClickedBuybuttonammo2", 1000, 632.5, "Buy Full Alt Ammo", "wblplyboughtfullsecammo")
		
		--Price Label for all Primary ammo button
		CreatePriceDlabel(WeshopSecammo2Label, wblBuyMenu, 1170, 632.5, ammo2pricefull)

		wblBuyMenu.OnKeyCodePressed = function(self, keyCode)
			if keyCode == KEY_E or keyCode == KEY_B then
		        self:Close()
		        return -- Return early if menu is closed
		    end
		    if keyBindings[keyCode] then
		        keyBindings[keyCode]() -- Call the function associated with the pressed key
		    end
		end

		local function CreateSellButton(name, frame, fontdefault, fontclick, xposition, yposition, label, netsend)
			local name = vgui.Create("DButton", wblBuyMenu)
			name:SetSize(450*Adjw, 50*Adjh)
			name:SetText("")
			name:SetTextColor(Color(0, 0, 0))
			name:SetFont("Buybutton")
			name:SetPos( xposition*Adjw, yposition*Adjh )
			name.isClicked = false
			name.isHovered = false -- New variable to track hover state
			local finalsellvalue
			if weapsellvalue ~= "N.A." then
				finalsellvalue = "( ω"..weapsellvalue.." )"
			else
				finalsellvalue = "( "..weapsellvalue.." )"
			end

			function name:Paint(w, h)
			    if name.isClicked then
			        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 0, 75)) 
			        draw.SimpleText(label, fontclick, 10*Adjw, h / 2, Color(255, 255, 255, 220), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			        -- place holder label
			        draw.SimpleText(finalsellvalue, fontclick, 440*Adjw, h / 2, Color(255, 255, 255, 220), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			        surface.SetDrawColor(255, 255, 0, 150) -- Yellow color with 150 alpha for transparency
			        surface.DrawOutlinedRect(0, 0, w, h, 2) -- Draw the outline with a 2-pixel width 
			    else
			        if name.isHovered then
			            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 0, 40)) -- Flash background when hovered
			        end
			        surface.SetDrawColor(255, 255, 0, 150) -- Yellow color with 150 alpha for transparency
			        surface.DrawOutlinedRect(0, 0, w, h, 2) -- Draw the outline with a 2-pixel width 
			        draw.SimpleText(label, fontdefault, 10*Adjw, h / 2, Color(255, 255, 0, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			        -- place holder label
			        draw.SimpleText(finalsellvalue, fontdefault, 440*Adjw, h / 2, Color(0, 255, 0, 150), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			    end
			end

			-- Add hover effect
			name.OnCursorEntered = function(self)
			    name.isHovered = true
			    name:InvalidateLayout(true)
			end

			name.OnCursorExited = function(self)
			    name.isHovered = false
			    name:InvalidateLayout(true)
			end

			name.OnMousePressed = function()
			    name.isClicked = true
			    name:InvalidateLayout(true) -- Force the previous button to repaint
			end

			name.OnMouseReleased = function()
			    name.isClicked = false
			    name:InvalidateLayout(true) -- Force the previous button to repaint
			    net.Start(netsend) 
			    net.SendToServer()
			end

		end


		CreateSellButton(WeshopSellbutton, wblBuyMenu, "SellButton", "SellButtonClicked", 32, 610, "Sell Currently Held Weapon", "wblSellweapon")
		
	--button for buy test
	--[[
		local wblbuycheap = vgui.Create("DButton",wblBuyMenu)
			wblbuycheap:SetPos(25,35)
			wblbuycheap:SetSize(100,50)
			wblbuycheap:SetText("Buy Weapon")
			wblbuycheap.DoClick = function()

				net.Start("wblBuySmall") 
				net.SendToServer() 
			end

		--3d model of weapon
		local modelPanel = vgui.Create("DModelPanel", wblBuyMenu)
	    modelPanel:SetSize(200,200)
	    modelPanel:SetPos(200,200)
	    -- Get the model for the given weapon class
	    local weaponTable = weapons.Get("weapon_rtbr_flaregun") -- Get weapon data from the class
	    if weaponTable and weaponTable.WorldModel then
	        modelPanel:SetModel(weaponTable.WorldModel) -- Set the weapon's world model
	    else
	        modelPanel:SetModel("models/error.mdl") -- Show error model if the weapon is invalid
	    end

	    -- Set up the model panel controls
	    modelPanel:SetCamPos(Vector(50, 25, 50)) -- Camera position
	    modelPanel:SetLookAt(Vector(0, 0, 0)) -- Look at the center of the model
	    modelPanel:SetFOV(10) -- Field of view
	    modelPanel:SetAnimated(true) -- Enable animation for certain models
	]]


		
end)

--Stop the player from moving when touching the store until done
net.Receive("wblFreeze", function()
	surface.PlaySound("items/ammocrate_open.wav")
	local origx = MoneyTextposx
	local origy = MoneyTextposy
	--local orighuden = wblhuden
	--wblhuden = 1
	MoneyTextposx = 0.50
	MoneyTextposy = 0.95
	function wblBuyMenu:OnRemove()
		MoneyTextposx = origx
		MoneyTextposy = origy
		--wblhuden = orighuden
		surface.PlaySound("items/ammocrate_close.wav")
		net.Start("wblUnfreeze")
		net.SendToServer()
	end
end)

--Not enough money notification
net.Receive("wblplynomoney", function()
    notification.AddLegacy("Not enough Money!", NOTIFY_ERROR, 3)
	surface.PlaySound("common/warning.wav")
end)

--Has already the weapon notification
net.Receive("wblplyhasweapon", function()
    notification.AddLegacy("You already have the weapon!", NOTIFY_ERROR, 3)
	surface.PlaySound("buttons/button1.wav")
end)

--Has already the weapon in same slotid
net.Receive("wblplyhasweaponinsameid", function()
	local slotid = net.ReadString()
	local weaponthatyouhave = net.ReadString()
    notification.AddLegacy("Your "..weaponthatyouhave.." uses "..slotid.." slot, sell it first!", NOTIFY_ERROR, 3)
	surface.PlaySound("buttons/button1.wav")
end)

net.Receive("wblplyboughtweapon", function()
	surface.PlaySound("weapons/ar2/ar2_reload_rotate.wav")
	local s = net.ReadUInt(8)
	if IsValid(wblBuyMenu) and wblBuyMenu ~= nil then
		if s == 2 then
			return
		--elseif s == 2 then
		--	notification.AddLegacy("Weapon isn't sellable", NOTIFY_ERROR, 3)
		end
		wblBuyMenu:Close()
	end
	
end)

net.Receive("wblplyboughthpsound", function()
	surface.PlaySound("items/smallmedkit1.wav")
end)

net.Receive("wblplyboughtpasound", function()
	surface.PlaySound("weapons/smg1/switch_burst.wav") 
	--surface.PlaySound("weapons/smg1/switch_single.wav") 
end)

net.Receive("wblplyboughtapsound", function()
	surface.PlaySound("items/battery_pickup.wav")
end)

net.Receive("wblplyhasmaxhp", function()
	surface.PlaySound("items/medshotno1.wav")
end)

net.Receive("wblplyhasmaxap", function()
	surface.PlaySound("items/suitchargeno1.wav")
end)

net.Receive("wblplydontknowweaponsound", function()
	notification.AddLegacy("Cannot Identify Weapon, Add the weapon to the shop list!", NOTIFY_ERROR, 3)
	surface.PlaySound("buttons/combine_button_locked.wav")
end)

net.Receive("wblNoWeaponsound", function()
	notification.AddLegacy("No weapon equipped!", NOTIFY_ERROR, 3)
	surface.PlaySound("buttons/combine_button_locked.wav")
end)

net.Receive("wblonlyweaponsound", function()
	local s = net.ReadInt(16)
	if s == 1 then
		notification.AddLegacy("Can't sell your only weapon!", NOTIFY_ERROR, 3)
	elseif s == 2 then
		notification.AddLegacy("Weapon isn't sellable", NOTIFY_ERROR, 3)
	elseif s == 3 then
		notification.AddLegacy("Weapon not listed in store, can't sell!", NOTIFY_ERROR, 3)
	elseif s == 4 then
		notification.AddLegacy("Softlock prevention enabled, can't sell weapon!", NOTIFY_ERROR, 3)
	elseif s == 5 then
		notification.AddLegacy("It is already top of the list!", NOTIFY_ERROR, 3)
	elseif s == 6 then
		notification.AddLegacy("It is already bottom of the list!", NOTIFY_ERROR, 3)
	end
	surface.PlaySound("buttons/combine_button_locked.wav")
end)

net.Receive("wblplyhasmaxprimeammo", function()
	notification.AddLegacy("You have max Primary Ammo!", NOTIFY_GENERIC, 3)
	surface.PlaySound("weapons/shotgun/shotgun_empty.wav")
	--surface.PlaySound("weapons/ar2/ar2_reload_push.wav")
	--surface.PlaySound("weapons/shotgun/shotgun_reload1.wav")

end)

net.Receive("wblplyhasmaxsecammo", function()
	notification.AddLegacy("You have max Secondary Ammo!", NOTIFY_GENERIC, 3)
	surface.PlaySound("weapons/shotgun/shotgun_empty.wav")
end)

net.Receive("wblplynoammotypesound", function()
	local ammotype = net.ReadInt(16)
	if ammotype == 1 then
		notification.AddLegacy("Weapon doesn't need primary ammo!", NOTIFY_ERROR, 5)
	else
		notification.AddLegacy("Weapon doesn't need secondary ammo!", NOTIFY_ERROR, 5)
	end
	surface.PlaySound("buttons/button1.wav")
end)

net.Receive("wblplynoammotypesoundC", function()
	local ammotype = net.ReadInt(16)
	if ammotype == 1 then
		notification.AddLegacy("Consumable/Throwable weapons don't need primary ammo!", NOTIFY_ERROR, 5)
	else
		notification.AddLegacy("Consumable/Throwable weapons don't need secondary ammo!", NOTIFY_ERROR, 5)
	end
	surface.PlaySound("buttons/button1.wav")
end)

net.Receive("wblplydiedinstore", function()
	if IsValid(wblBuyMenu) and wblBuyMenu ~= nil then
		wblBuyMenu:Close()
	end
end)

net.Receive("wblSellweaponsound", function()
	surface.PlaySound("weapons/ar2/ar2_reload_push.wav")
end)


net.Receive("wblbutton1soundother", function()
	local int = net.ReadInt(16)
	if int == 1 then
		notification.AddLegacy("Weapon's ammo unavailable, Add it's ammo type to the shop list! ", NOTIFY_ERROR, 3)
	elseif int == 2 then
		notification.AddLegacy("", NOTIFY_ERROR, 3)
	end
	surface.PlaySound("buttons/button1.wav")
end)
