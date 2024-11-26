
--
-- The server only runs this file so it can send it to the client
--

if ( SERVER ) then AddCSLuaFile( "Weshop_Menu.lua" ) return end

wbldeben = 0

net.Start("wblDebugenabledToS")
net.SendToServer()

net.Receive("wblDebugenabledToC",function(Len)
    wbldeben = net.ReadInt(16)
end)



-- for Debugging (START) --
function wblDebug(a) 
    if wbldeben == 1 then
        print(tostring(a))
    end
end

function wblDebugtable(a) 
    if wbldeben == 1 then
        PrintTable(a)
    end
end
-- for Debugging (END) --
Adjw = (ScrW()/1920)
Adjh = (ScrH()/1080)
npcdataonlist = {}
npclisttodeliver = {}
npclisttodelivermoney = {}
local presettabletosave = {}
local presettabletosave3 = {}
local weapclasstoadd
wblweaponlist = {}
wblammolist = {}
WeaponAmmoPresetList = {}



--preset saving for npclist
--[[
function PresetSaveNPClist(name)
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

end
]]



--Reset to Default
--[[
local function ResetAllConVarsToDefault()
    for convarName, defaultValue in pairs(defaultConVars) do
        RunConsoleCommand(convarName, defaultValue)
    end
end

-- Function to save the values of the ConVars to a file
local function SaveConVarsToFile(fileName)
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

--Function to load the convars and execute it
local function LoadConVarsFromFile(fileName)
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
]]

local function FindAmmoByName(ammoName)
    for _, ammo in ipairs(wblammolist) do
        if ammo.name == ammoName then
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

local function FindWeaponByClass(weaponClass)
    for _, tier in ipairs(wblweaponlist) do
        for _, weapon in ipairs(tier.weapons) do
            if weapon.class == weaponClass then
                return weapon -- Return the weapon if class matches
            end
        end
    end
    return nil -- Return nil if the weapon is not found
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

local function FindWeaponByAmmo1(ammoType)
    for _, tier in ipairs(wblweaponlist) do
        for _, weapon in ipairs(tier.weapons) do
            if weapon.ammo1 == ammoType then
                return weapon -- Return the weapon if ammo1 matches
            end
        end
    end
    return nil -- Return nil if no weapon is found
end

local function FindWeaponByAmmo2(ammoType)
    for _, tier in ipairs(wblweaponlist) do
        for _, weapon in ipairs(tier.weapons) do
            if weapon.ammo2 == ammoType then
                return weapon -- Return the weapon if ammo2 matches
            end
        end
    end
    return nil -- Return nil if no weapon is found
end


local function GetWeaponNameByClass(weaponClass)
    -- Hardcoded names for Half-Life 2 weapons
    local hl2WeaponNames = {
        ["weapon_smg1"] = "SMG",
        ["weapon_ar2"] = "Pulse Rifle",
        ["weapon_pistol"] = "Pistol",
        ["weapon_357"] = "357 Magnum",
        ["weapon_crossbow"] = "Crossbow",
        ["weapon_frag"] = "Grenade",
        ["weapon_crowbar"] = "Crowbar",
        ["weapon_rpg"] = "RPG",
        ["weapon_physcannon"] = "Gravity Gun",
        ["weapon_shotgun"] = "Shotgun",
        ["weapon_stunstick"] = "Stunstick",
        ["weapon_slam"] = "S.L.A.M",
        ["weapon_bugbait"] = "Bugbait"
    }

    -- Check if the weapon class matches a hardcoded HL2 weapon
    if hl2WeaponNames[weaponClass] then
        return hl2WeaponNames[weaponClass]
    end

    -- Retrieve the weapon table using the class name for other weapons
    local weaponData = weapons.GetStored(weaponClass)
    
    -- If weaponData exists and has a PrintName field, try to resolve the name
    if weaponData and weaponData.PrintName then
        local printName = weaponData.PrintName
        
        -- Check if it starts with "#" indicating it's a localization key
        if string.sub(printName, 1, 1) == "#" then
            -- Use language.GetPhrase to resolve it to the display name
            return language.GetPhrase(string.sub(printName, 2)) -- Remove the "#" and resolve
        else
            return printName -- Return as is if it's not a localization key
        end
    else
        return weaponClass -- Fallback if no name is found
    end
end

local function GetWeaponPrimaryClipSize(weaponClass)
    -- Hardcoded clip sizes for Half-Life 2 weapons
    local hl2WeaponClipSizes = {
        ["weapon_smg1"] = 45,
        ["weapon_ar2"] = 30,
        ["weapon_pistol"] = 18,
        ["weapon_357"] = 6,
        ["weapon_crossbow"] = 1,
        ["weapon_frag"] = "N.A.",  
        ["weapon_crowbar"] = 2,  
        ["weapon_rpg"] = 1,
        ["weapon_physcannon"] = 2,  
        ["weapon_shotgun"] = 6,
        ["weapon_bugbait"] = 2  
    }

    -- Check if the weapon class matches a hardcoded HL2 weapon
    if hl2WeaponClipSizes[weaponClass] then
        return hl2WeaponClipSizes[weaponClass]
    end

    -- Retrieve the weapon table using the class name for other weapons
    local weaponData = weapons.GetStored(weaponClass)
    
    -- Check if the weapon data exists and has a Primary table with ClipSize
    if weaponData and weaponData.Primary and weaponData.Primary.ClipSize then
        return weaponData.Primary.ClipSize
    else
        return "Unknown Clip Size" -- Fallback if no data is found
    end
end


local function GetWeaponSpawnCategory(weaponClass)
    -- Hardcoded spawn categories for Half-Life 2 weapons
    local hl2WeaponCategories = {
        ["weapon_physgun"] = "Garry's Mod",
        ["gmod_tool"] = "Garry's Mod",
        ["gmod_camera"] = "Garry's Mod",
        ["weapon_flechettegun"] = "Garry's Mod",
        ["manhack_welder"] = "Garry's Mod",
        ["weapon_fists"] = "Garry's Mod",
        ["weapon_medkit"] = "Garry's Mod",
        ["weapon_smg1"] = "Half-Life 2",
        ["weapon_ar2"] = "Half-Life 2",
        ["weapon_pistol"] = "Half-Life 2",
        ["weapon_357"] = "Half-Life 2",
        ["weapon_crossbow"] = "Half-Life 2",
        ["weapon_frag"] = "Half-Life 2",
        ["weapon_crowbar"] = "Half-Life 2",
        ["weapon_rpg"] = "Half-Life 2",
        ["weapon_physcannon"] = "Half-Life 2",
        ["weapon_shotgun"] = "Half-Life 2",
        ["weapon_stunstick"] = "Half-Life 2",
        ["weapon_slam"] = "Half-Life 2",
        ["weapon_bugbait"] = "Half-Life 2"
    }

    -- Check if the weapon class matches a hardcoded HL2 weapon
    if hl2WeaponCategories[weaponClass] then
        return hl2WeaponCategories[weaponClass]
    end

    -- Retrieve the weapon table using the class name for other weapons
    local weaponData = weapons.GetStored(weaponClass)
    
    -- Check if the weapon data exists and has a Category field
    if weaponData and weaponData.Category then
        return weaponData.Category
    else
        return "Unknown Category" -- Fallback if no data is found
    end
end

local function ReceiveAndDecompressTable()
    -- Read the length of the compressed data
    local dataLength = net.ReadUInt(32)

    -- Read the compressed data
    local compressedData = net.ReadData(dataLength)

    -- Decompress the data
    local jsonData = util.Decompress(compressedData)

    -- Make sure decompression worked
    if not jsonData then
        print("Failed to decompress data")
        return nil
    end

    -- Convert the JSON string back into a Lua table
    return util.JSONToTable(jsonData)
end

net.Receive("wbladdammolistToC",function(Len)
    wblammolist = ReceiveAndDecompressTable()
end)
net.Receive("wbladdweaponlistToC",function(Len)
    wblweaponlist = ReceiveAndDecompressTable()
end)

hook.Add( "AddToolMenuCategories", "Weshop_option", function()
	spawnmenu.AddToolCategory( "Options", "WeShopAdm", "#WeShop Admin" )
	spawnmenu.AddToolCategory( "Options", "WeShopCli", "#WeShop Client" )
end )

hook.Add( "PopulateToolMenu", "WeshopCustomMenuSettings", function()


--[[
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\SERVER\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
]]		spawnmenu.AddToolMenuOption( "Options", "WeShopAdm", "Shopz", "#Shop Option", "", "", function( panel )
				if !LocalPlayer():IsSuperAdmin() and !LocalPlayer():IsAdmin() then
				        panel:Help("Admin only access..")
				        return
				end

				local For0 = vgui.Create("DForm")
				For0:Dock(TOP)
				For0:SetSize(1,100)
				For0:SetName("Weapon and Ammo Shop List")

					local WepPresetLabel = vgui.Create("DLabel")        
					WepPresetLabel:Dock(TOP)
					WepPresetLabel:SetText("Weapon/Ammo List Preset: ")
					WepPresetLabel:SetTextColor(Color(0, 0, 0))

					local WepPresetCombo = vgui.Create("DComboBox")
					WepPresetCombo:Dock(TOP)
					WepPresetCombo:SetValue("Default")
					WepPresetCombo:DockMargin( 0, 0, 0, 5 )

                    function RefreshWepAmmoPreset()
                        WepPresetCombo:Clear()
                        for _, preset in ipairs(WeaponAmmoPresetList) do
                            WepPresetCombo:AddChoice(preset)
                            net.Start("wblLoadSelectedWeaponlistPresetToS")
                            net.SendToServer()
                        end
                    end

                    net.Receive("wblLoadSelectedWeaponlistPresetToC",function(Len)
                        SelectedValue = net.ReadString()
                        WepPresetCombo:SetValue(SelectedValue)
                        net.Start("wblLoadWeaponlistPresetToS")
                        net.WriteString(tostring(SelectedValue))
                        net.SendToServer()
                    end)

                    net.Start("wblReqWeaponAmmoPresetListToS")
                    net.SendToServer()
                    net.Receive("wblReqWeaponAmmoPresetListToC",function(Len)
                        WeaponAmmoPresetList = net.ReadTable()
                        wblDebug("AmmoWeapon Preset List Received")
                        --PrintTable(WeaponAmmoPresetList)
                        RefreshWepAmmoPreset()
                    end)

                    WepPresetCombo.OnSelect = function(panel, index, value)
                        net.Start("wblSaveSelectedWeaponlistPresetToS")
                        net.WriteString(tostring(value))
                        net.SendToServer()
                        net.Start("wblLoadWeaponlistPresetToS")
                        net.WriteString(tostring(value))
                        net.SendToServer()
                    end
                    

                    
					local textEntries = {}


						local WepAddPreset = vgui.Create( "DButton") // Create the button and parent it to the frame
						WepAddPreset:Dock( TOP )
						WepAddPreset:SetText( "Save/Overwrite List to a Preset" )					// Set the text on the button
						WepAddPreset:SetSize( 250, 20 )
							WepAddPreset.DoClick = function()
									local WepPresetframe = vgui.Create("DFrame")
									WepPresetframe:SetSize(250, 100)            
									WepPresetframe:SetTitle("New Preset") 
									WepPresetframe:Center()                      
									WepPresetframe:MakePopup()                   

									local WepPresetLabel = vgui.Create("DLabel", WepPresetframe)        
									WepPresetLabel:Dock(TOP)
									WepPresetLabel:SetText("Preset Name: ")    
									
									local WepPresetTextEntry = vgui.Create("DTextEntry", WepPresetframe)       
									WepPresetTextEntry:Dock(TOP)
									WepPresetTextEntry:SetSize(200, 30)  -- Width and height of the text field
									WepPresetTextEntry:SetText("")
									WepPresetTextEntry:RequestFocus()
									local WepPresetname
									WepPresetTextEntry.OnEnter = function(self)
										--Add New Preset
									    WepPresetname = self:GetValue()  -- Get the input text and store it in a variable
									    if WepPresetname == "Default" or WepPresetname == "default" or WepPresetname == "Half-Life 2 Tiered" or WepPresetname == "Counter-Strike 1.6" then
									    	notification.AddLegacy("Preset cannot be saved as this name!", NOTIFY_ERROR, 3)
											surface.PlaySound("buttons/button10.wav")
									    	WepPresetframe:Close()
									    	return
									    end
                                        --for i, presetName in ipairs(WeaponAmmoPresetList) do
                                        --    if presetName == WepPresetname then
                                        --        notification.AddLegacy("Preset cannot be saved as this name!", NOTIFY_ERROR, 3)
                                        --        surface.PlaySound("buttons/button10.wav")
                                        --        WepPresetframe:Close()
                                        --        return
                                        --    end
                                        --end

										    if WepPresetname == "" then
										    	WepPresetframe:Close()
										    	return
										    end
                                            net.Start("wblSaveSelectedWeaponlistPresetToS")
                                            net.WriteString(tostring(WepPresetname))
                                            net.SendToServer()
										    WepPresetframe:Close()  -- Close the frame when "Enter" is pressed
										    wblDebug("New Preset name is ".. tostring(WepPresetname))
                                            net.Start("wblSaveWeaponlistPresetToS")
                                            net.WriteString(tostring(WepPresetname))
                                            net.SendToServer()
                                            net.Start("wblReqWeaponAmmoPresetListToS")
                                            net.SendToServer()
									end
							end

					local WepDeletePreset = vgui.Create( "DButton") // Create the button and parent it to the frame
						WepDeletePreset:Dock( TOP )
						WepDeletePreset:SetText( "Delete Weapon/Ammo list Preset" )					// Set the text on the button
						WepDeletePreset:SetSize( 250, 20 )
							--Delete a Preset
							WepDeletePreset.DoClick = function()
                                wblDebug("WepPresetCombo:GetValue(): "..WepPresetCombo:GetValue())
                                if WepPresetCombo:GetValue() == "Default"  or WepPresetCombo:GetValue() == "Half-Life 2 Tiered" or WepPresetCombo:GetValue() == "Counter-Strike 1.6" then
                                    notification.AddLegacy("Can't Delete this Preset!", NOTIFY_ERROR, 6)
                                    surface.PlaySound("buttons/button10.wav")
                                    return
                                end
                                local delConfirmframe = vgui.Create("DFrame")
                                delConfirmframe:SetSize(250, 150)            
                                delConfirmframe:SetTitle("ARE YOU SURE??")
                                delConfirmframe:Center()                      
                                delConfirmframe:MakePopup()  

                                local delConfirmLabel = vgui.Create("DLabel", delConfirmframe)        
                                delConfirmLabel:Dock(TOP)
                                delConfirmLabel:SetText("Are you sure you want to Delete this preset?")    

                                local delConfirmButton = vgui.Create("DButton", delConfirmframe)
                                delConfirmButton:SetText("Delete!")            
                                delConfirmButton:DockMargin( 0, 0, 0, 5 )
                                delConfirmButton:Dock(FILL)         
                                delConfirmButton.DoClick = function()
                                    net.Start("wblSaveSelectedWeaponlistPresetToS")
                                    net.WriteString("Default")
                                    net.SendToServer()
                                    net.Start("wblDeleteWeaponlistPresetToS")
                                    net.WriteString(tostring(WepPresetCombo:GetValue()))
                                    net.SendToServer()
                                    net.Start("wblLoadWeaponlistPresetToS")
                                    net.WriteString("Default")
                                    net.SendToServer()                  
                                    delConfirmframe:Close()
                                end
							end
					local WeplistLabel = vgui.Create("DLabel")        
					WeplistLabel:Dock(TOP)
					WeplistLabel:SetText("Weapon Shop List: ")
					WeplistLabel:SetTextColor(Color(0, 0, 0))

					local WepList = vgui.Create( "DListView") 
					WepList:Dock( FILL )
					WepList:SetSize(100,((200/1080)*ScrH()))
					WepList:SetMultiSelect( false )
					WepList:AddColumn( "Name" )
					WepList:AddColumn( "Class" )
					WepList:AddColumn( "Cost" )
					WepList:AddColumn( "slotID" )
                    WepList:AddColumn( "Ars Type" )
					WepList:AddColumn( "Category" )


					local WepNoteLabel = vgui.Create("DLabel")        
					WepNoteLabel:Dock(TOP)
					WepNoteLabel:SetText("SOME USEFUL INFO: ")
					WepNoteLabel:SetTextColor(Color(0, 0, 0))
					

					local AmmolistLabel = vgui.Create("DLabel")        
					AmmolistLabel:Dock(TOP)
					AmmolistLabel:SetText("Ammo List: ")
					AmmolistLabel:SetTextColor(Color(0, 0, 0))

					local AmmoList = vgui.Create( "DListView")
					AmmoList:Dock( FILL )
					AmmoList:SetSize(100,((200/1080)*ScrH()))
					AmmoList:SetMultiSelect( false )
					AmmoList:AddColumn( "Name" )
					AmmoList:AddColumn( "Class" )
					AmmoList:AddColumn( "Price" )
					AmmoList:AddColumn( "Amount per buy" )
					AmmoList:AddColumn( "Max Ammo Cap" )

                    

                    net.Receive("wbladdammolistToC",function(Len)
                        wblammolist = ReceiveAndDecompressTable()
                        if wblammolist then
                            RefreshAmmolist()
                        end
                        wblDebug("wblammolist ammo received client")
                    end)

					local AddWeaponAmmo = vgui.Create( "DButton", Forrm ) // Create the button and parent it to the frame
					AddWeaponAmmo:Dock( FILL )
					AddWeaponAmmo:SetText( "Manual Add Current Weapon" )					// Set the text on the button
					AddWeaponAmmo:SetSize( 250, 20 )

                    local AddQuick = vgui.Create( "DButton", Forrm ) // Create the button and parent it to the frame
                    AddQuick:Dock( FILL )
                    AddQuick:SetText( "Quick Add Current Weapon " )                   // Set the text on the button
                    AddQuick:SetSize( 250, 20 )

					AddWeaponAmmo.DoClick = function()				// A custom function run when clicked ( note the . instead of : )

						AddWeaponAmmoFrame = vgui.Create("DFrame")
						AddWeaponAmmoFrame:SetSize(355, 475) 	
						AddWeaponAmmoFrame:Center()
						AddWeaponAmmoFrame:SetTitle("Manual Add Current Weapon")
						AddWeaponAmmoFrame:SetVisible(true)
						AddWeaponAmmoFrame:MakePopup()
						AddWeaponAmmo:SetEnabled(false)
                        AddQuick:SetEnabled(false)
						function AddWeaponAmmoFrame:OnClose()
						    AddWeaponAmmo:SetEnabled(true)
                            AddQuick:SetEnabled(true)
						end

						local WeaponStatLeft = vgui.Create("DPanel", AddWeaponAmmoFrame) -- Parent the panel to the frame
						WeaponStatLeft:Dock(LEFT)                 -- Fill the frame with the panel
						WeaponStatLeft:SetSize(150, 20)
						WeaponStatLeft:SetBackgroundColor(Color(100, 100, 100, 0))
						WeaponStatLeft:DockMargin( 5, 5, 5, 5 )

							local WeaponNameLabel = vgui.Create("DLabel", WeaponStatLeft)        
							WeaponNameLabel:Dock(TOP)
							WeaponNameLabel:SetText("Weapon Name: ") 
							WeaponNameLabel:SetSize(220, 20)


							local WeaponNameTextEntry = vgui.Create("DTextEntry", WeaponStatLeft)       
							WeaponNameTextEntry:Dock(TOP)
							WeaponNameTextEntry:SetSize(200, 20)  
							WeaponNameTextEntry:DockMargin( 0, 0, 0, 5 )

							local WeaponClassLabel = vgui.Create("DLabel", WeaponStatLeft)        
							WeaponClassLabel:Dock(TOP)
							WeaponClassLabel:SetText("Weapon Class: ") 
							WeaponClassLabel:SetSize(200, 20)

							local WeaponClassTextEntry = vgui.Create("DTextEntry", WeaponStatLeft)       
							WeaponClassTextEntry:Dock(TOP)
							WeaponClassTextEntry:SetSize(200, 20)  
							WeaponClassTextEntry:DockMargin( 0, 0, 0, 5 )
							WeaponClassTextEntry:SetEnabled(false)
							
							

							local WeaponArsenalLabel = vgui.Create("DLabel", WeaponStatLeft)        
							WeaponArsenalLabel:Dock(TOP)
							WeaponArsenalLabel:SetSize(200, 20)
							WeaponArsenalLabel:SetText("Arsenal Type: ") 
							
							local WepArsenalCombo = vgui.Create("DComboBox", WeaponStatLeft)
							WepArsenalCombo:Dock(TOP) 	
							WepArsenalCombo:AddChoice("Consumable/Throwable")
							WepArsenalCombo:AddChoice("Weapon")
							WepArsenalCombo:SetSize(200, 20)
							WepArsenalCombo:DockMargin( 0, 0, 0, 5 )


							local WeaponslotIDLabel = vgui.Create("DLabel", WeaponStatLeft)        
							WeaponslotIDLabel:Dock(TOP)
							WeaponslotIDLabel:SetSize(200, 20)
							WeaponslotIDLabel:SetText("SlotID: ")  
							
							local WeaponSlotIDTextEntry = vgui.Create("DTextEntry", WeaponStatLeft)       
							WeaponSlotIDTextEntry:Dock(TOP)
							WeaponSlotIDTextEntry:SetSize(200, 20)  -- Width and height of the text field
							WeaponSlotIDTextEntry:DockMargin( 0, 0, 0, 5 )


							local WeaponShopCatLabel = vgui.Create("DLabel", WeaponStatLeft)        
							WeaponShopCatLabel:Dock(TOP)
							WeaponShopCatLabel:SetSize(200, 20)
							WeaponShopCatLabel:SetText("Shop category: ")  
							
							local WeaponShopCatTextEntry = vgui.Create("DTextEntry", WeaponStatLeft)       
							WeaponShopCatTextEntry:Dock(TOP)
							WeaponShopCatTextEntry:SetSize(200, 20)  -- Width and height of the text field
							WeaponShopCatTextEntry:DockMargin( 0, 0, 0, 5 )
							net.Start("wblreqcurrentlyheld")
							net.SendToServer()

							net.Receive("wblsendcurrentlyheld",function()
								local s = net.ReadInt(16)
								local weapclass = net.ReadString()
								if s == 1 then
									weapclasstoadd = tostring(weapclass)
								elseif s == 2 then
									notification.AddLegacy("Can't Identify weapon class!", NOTIFY_ERROR, 3)
									surface.PlaySound("buttons/combine_button_locked.wav")
									weapclasstoadd = "N.A."
								elseif s == 3 then
									notification.AddLegacy("Weapon Already in the list!", NOTIFY_ERROR, 3)
									surface.PlaySound("buttons/combine_button_locked.wav")
									weapclasstoadd = "N.A."
								end

								if weapclasstoadd == "N.A." then
									WeaponClassTextEntry:SetText("N.A.")
									WeaponNameTextEntry:SetText("")
									AddWeaponAmmoFrame:Close()
								else
									WeaponClassTextEntry:SetText(tostring(weapclasstoadd))
									local spawnMenuName = GetWeaponNameByClass(weapclass)
                                    if weapclasstoadd == "weapon_physgun" then
                                        WeaponNameTextEntry:SetText("Physics Gun")
    								else
                                        WeaponNameTextEntry:SetText(spawnMenuName)
                                    end
									local primaryClipSize = GetWeaponPrimaryClipSize(weapclass)
                                    wblDebug(primaryClipSize)
                                    if primaryClipSize == "N.A." or primaryClipSize == "Unknown Clip Size" then
                                        WepArsenalCombo:SetValue("")
                                    elseif weapclasstoadd == "weapon_physgun" then
                                        WepArsenalCombo:SetValue("Weapon")
									elseif primaryClipSize > 0 then
										WepArsenalCombo:SetValue("Weapon")
									else
										WepArsenalCombo:SetValue("")
									end
									local WepCat = GetWeaponSpawnCategory(weapclass)
									WeaponShopCatTextEntry:SetText(WepCat)


                                    local imagePath = "entities/" .. weapclass .. ".png"
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
                                        local weaponTable = weapons.Get(weapclass) -- Get weapon data from the class
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
								end
							end)



                            net.Start("wblreqAmmotype1")
                            net.SendToServer()

                            


							local WeaponCostLabel = vgui.Create("DLabel", WeaponStatLeft)        
							WeaponCostLabel:Dock(TOP)
							WeaponCostLabel:SetSize(200, 20)
							WeaponCostLabel:SetText("Cost: ") 

							local WeaponCostWang = vgui.Create("DNumberWang", WeaponStatLeft) 
							WeaponCostWang:Dock( TOP )
							WeaponCostWang:SetSize(200,20)
							WeaponCostWang:DockMargin( 0, 0, 0, 5 )
							WeaponCostWang:SetMin(-99999) 
							WeaponCostWang:SetMax(math.huge)
							
							


							local WeaponSellvalueLabel = vgui.Create("DLabel", WeaponStatLeft)        
							WeaponSellvalueLabel:Dock(TOP)
							WeaponSellvalueLabel:SetSize(200, 20)
							WeaponSellvalueLabel:SetText("Sell Value:         Sellable?: ") 
							WeaponSellvalueLabel:DockMargin( 0, 0, 0, 25 )

							local WeaponSellvalueWang = vgui.Create("DNumberWang", AddWeaponAmmoFrame) 
							WeaponSellvalueWang:SetSize(70,20)
							WeaponSellvalueWang:SetPos(10,325)
							WeaponSellvalueWang:SetMin(-99999) 
							WeaponSellvalueWang:SetMax(math.huge)
							

                            net.Receive("wblweaponpricereqToC",function()
                                local price = net.ReadInt(32)
                                local holdtype = net.ReadString()
                                local primammo = net.ReadString()
                                if price ~= nil then
                                local sellprice = price/2
                                    WeaponCostWang:SetValue(tonumber(price))
                                    WeaponSellvalueWang:SetValue(tonumber(sellprice))
                                else
                                    WeaponCostWang:SetValue(400)
                                    WeaponSellvalueWang:SetValue(200)
                                end
                                wblDebug("holdtype: "..holdtype)
                                wblDebug("primammo: "..primammo)
                                if primammo == "n.a." then
                                    if holdtype == "melee" then
                                        WeaponSlotIDTextEntry:SetText("Melee")
                                    elseif holdtype == "grenade" then
                                        WeaponSlotIDTextEntry:SetText("Throwable")
                                    elseif holdtype == "slam" then
                                        WeaponSlotIDTextEntry:SetText("Equipment")
                                    elseif holdtype == "pistol" then
                                        WeaponSlotIDTextEntry:SetText("Sidearm")
                                    elseif holdtype == "revolver" then
                                        WeaponSlotIDTextEntry:SetText("Precision Sidearm")
                                    elseif holdtype == "smg" then
                                        WeaponSlotIDTextEntry:SetText("Submachine Gun")
                                    elseif holdtype == "shotgun" then
                                        WeaponSlotIDTextEntry:SetText("Shotgun")
                                    elseif holdtype == "crossbow" then
                                        WeaponSlotIDTextEntry:SetText("Precision")
                                    elseif holdtype == "ar2" then
                                        WeaponSlotIDTextEntry:SetText("Rifle")
                                    elseif holdtype == "rpg" then
                                        WeaponSlotIDTextEntry:SetText("Launcher")
                                    elseif holdtype == "physgun" then
                                        WeaponSlotIDTextEntry:SetText("Experimental")
                                    else
                                        WeaponSlotIDTextEntry:SetText("N.A.")
                                    end
                                elseif primammo == "grenade" then
                                    WeaponSlotIDTextEntry:SetText("Throwable")
                                elseif primammo == "slam" then
                                    WeaponSlotIDTextEntry:SetText("Equipment")
                                elseif primammo == "pistol" then
                                    WeaponSlotIDTextEntry:SetText("Sidearm")
                                elseif primammo == "357" then
                                    WeaponSlotIDTextEntry:SetText("Precision Sidearm")
                                elseif primammo == "smg1" then
                                    WeaponSlotIDTextEntry:SetText("Submachine Gun")
                                elseif primammo == "buckshot" then
                                    WeaponSlotIDTextEntry:SetText("Shotgun")
                                elseif primammo == "xbowbolt" then
                                    WeaponSlotIDTextEntry:SetText("Precision")
                                elseif primammo == "ar2" then
                                    WeaponSlotIDTextEntry:SetText("Assault Rifle")
                                elseif primammo == "rpg_round" then
                                    WeaponSlotIDTextEntry:SetText("Rocket")
                                elseif primammo == "ar2altfire" then
                                    WeaponSlotIDTextEntry:SetText("Experimental")
                                elseif primammo == "smg1_grenade" then
                                    WeaponSlotIDTextEntry:SetText("Launcher")
                                else
                                    WeaponSlotIDTextEntry:SetText("N.A.")
                                end
                            end)


                            timer.Simple(0.1, function()
                                if WeaponClassTextEntry:IsValid() then
                                    net.Start("wblweaponpricereqToS")
                                    wblDebug(WeaponClassTextEntry:GetValue())
                                    net.WriteString(WeaponClassTextEntry:GetValue())
                                    net.SendToServer()
                                end
							end)
 
							
							local WeaponSellableCombo = vgui.Create("DComboBox", AddWeaponAmmoFrame)
							WeaponSellableCombo:AddChoice("No")
							WeaponSellableCombo:AddChoice("Yes")
							WeaponSellableCombo:SetValue("Yes")
							WeaponSellableCombo:SetSize(70, 20)
							WeaponSellableCombo:SetPos(90,325)
							

							local Weaponammo1Label = vgui.Create("DLabel", WeaponStatLeft)        
							Weaponammo1Label:Dock(TOP)
							Weaponammo1Label:SetSize(200, 20)
							Weaponammo1Label:SetText("Primary Ammo name: ")  
							
							local Weaponammo1TextEntry = vgui.Create("DTextEntry", WeaponStatLeft)       
							Weaponammo1TextEntry:Dock(TOP)
							Weaponammo1TextEntry:SetSize(200, 20)  
							Weaponammo1TextEntry:SetText("N.A.")
							Weaponammo1TextEntry:DockMargin( 0, 0, 0, 5 )
							Weaponammo1TextEntry:SetEnabled(false)

							local Weaponammo2Label = vgui.Create("DLabel", WeaponStatLeft)        
							Weaponammo2Label:Dock(TOP)
							Weaponammo2Label:SetSize(200, 20)
							Weaponammo2Label:SetText("Secondary Ammo name: ")  
							
							local Weaponammo2TextEntry = vgui.Create("DTextEntry", WeaponStatLeft)       
							Weaponammo2TextEntry:Dock(TOP)
							Weaponammo2TextEntry:SetSize(200, 20)  
							Weaponammo2TextEntry:SetText("N.A.")
							Weaponammo2TextEntry:DockMargin( 0, 0, 0, 5 )
							Weaponammo2TextEntry:SetEnabled(false)

							

						--My name is comrade general this is
						local WeaponStatRight = vgui.Create("DPanel", AddWeaponAmmoFrame) -- Parent the panel to the frame
						WeaponStatRight:Dock(RIGHT)                 -- Fill the frame with the panel
						WeaponStatRight:SetSize(175, 20)
						WeaponStatRight:SetBackgroundColor(Color(100, 100, 100, 0))
						WeaponStatRight:DockMargin( 5, 5, 5, 5 )

                            local WeaponModelLabel1 = vgui.Create("DLabel", WeaponStatRight)
                            WeaponModelLabel1:Dock(TOP)
                            WeaponModelLabel1:SetText("Weapon Image Preview: ")
                            WeaponModelLabel1:SetSize(220, 20)
						
                            BackModelPanel = vgui.Create("DPanel", WeaponStatRight)
                            BackModelPanel:Dock(TOP)
                            BackModelPanel:DockMargin(0, 0, 0, 10)
                            BackModelPanel:SetSize(220 , 168)
                            BackModelPanel.Paint = function(self, w, h)
                                draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0, 90))
                            end

							local WeaponDescLabel1 = vgui.Create("DLabel", WeaponStatRight)
							WeaponDescLabel1:Dock(TOP)
							WeaponDescLabel1:SetText("Weapon Description (Optional): ")
						    WeaponDescLabel1:SetSize(220, 15)

                            local WeaponDescLabelhelp = vgui.Create("DLabel", WeaponStatRight)
                            WeaponDescLabelhelp:Dock(TOP)
                            WeaponDescLabelhelp:SetWrap(true)
                            WeaponDescLabelhelp:SetText("*Up to six lines will be displayed")
                            WeaponDescLabelhelp:SetSize(220, 15)

						    local WeaponDescText1 = vgui.Create("DTextEntry", WeaponStatRight)
						    WeaponDescText1:Dock(TOP)
						    WeaponDescText1:SetSize(200, 87)
						    WeaponDescText1:SetText("")
                            WeaponDescText1:SetMultiline(true) 

							local AddAmmoPrimaryLabel = vgui.Create("DLabel", WeaponStatRight)        
							AddAmmoPrimaryLabel:Dock(TOP)
							AddAmmoPrimaryLabel:SetSize(200, 20)
							AddAmmoPrimaryLabel:SetText("") 

							local AddAmmoPrimaryButton = vgui.Create( "DButton", WeaponStatRight ) 
							AddAmmoPrimaryButton:Dock( TOP )
							AddAmmoPrimaryButton:SetText( "Add Primary Ammo" )					
							AddAmmoPrimaryButton:SetSize(200, 20)  
							AddAmmoPrimaryButton:DockMargin(0, 0, 0, 5)
							


							local AddAmmoSecondaryLabel = vgui.Create("DLabel", WeaponStatRight)        
							AddAmmoSecondaryLabel:Dock(TOP)
							AddAmmoSecondaryLabel:SetSize(200, 20)
							AddAmmoSecondaryLabel:SetText("") 

							local AddAmmoSecondaryButton = vgui.Create( "DButton", WeaponStatRight ) 
							AddAmmoSecondaryButton:Dock( TOP )
							AddAmmoSecondaryButton:SetText( "Add Secondary Ammo" )					
							AddAmmoSecondaryButton:SetSize(200, 20) 

                            -- Autofill Default for Weapons that use Grenades or Slam
                            local B1en
                            local B2en
                            net.Receive("wblsendAmmotype1",function()
                                local ammoclass1 = net.ReadString()
                                local ammoclass2 = net.ReadString()
                                if (ammoclass1 == "Grenade" or ammoclass1 == "slam") and ammoclass2 == "N.A." then
                                    WepArsenalCombo:SetValue("Consumable/Throwable")
                                    WeaponCostWang:SetValue(150)
                                    WeaponSellvalueWang:SetValue(75)
                                    if AddAmmoPrimaryButton:IsEnabled() then
                                        B1en = 1
                                        AddAmmoPrimaryButton:SetEnabled(false)
                                    end
                                    if AddAmmoPrimaryButton:IsEnabled() then
                                        B2en = 1
                                        AddAmmoSecondaryButton:SetEnabled(false)
                                    end
                                end
                            end)

                            -- Disable or Enable add ammo buttons if Throwable or Weapon respectively 
                            WepArsenalCombo.OnSelect = function(panel, index, value)
                                if value == "Consumable/Throwable" then 
                                    if AddAmmoPrimaryButton:IsEnabled() then
                                        B1en = 1
                                        AddAmmoPrimaryButton:SetEnabled(false)
                                    end
                                    if AddAmmoSecondaryButton:IsEnabled() then
                                        B2en = 1
                                        AddAmmoSecondaryButton:SetEnabled(false)
                                    end
                                elseif value == "Weapon" then
                                    if B1en == 1 then
                                        AddAmmoPrimaryButton:SetEnabled(true)
                                        B1en = 0
                                    end
                                    if B2en == 1 then
                                        AddAmmoSecondaryButton:SetEnabled(true)
                                        B2en = 0
                                    end
                                end

                            end

							net.Start("wblreqFormAmmotype")
							net.SendToServer() 

							net.Receive("wblsendFormAmmotype",function()
								local Primeammo = net.ReadString()
								local Secondammo = net.ReadString()
								local Primeammolistname = net.ReadString()
								local Secondammolistname = net.ReadString()
								if Primeammo == "N.A." then
									AddAmmoPrimaryButton:SetEnabled(false)
								end
								if Secondammo == "N.A." then
									AddAmmoSecondaryButton:SetEnabled(false)
								end
								if Primeammolistname ~= "N.A." then
									Weaponammo1TextEntry:SetText(Primeammolistname)
									AddAmmoPrimaryButton:SetEnabled(false)
								end
								if Secondammolistname ~= "N.A." then
									Weaponammo2TextEntry:SetText(Secondammolistname)
									AddAmmoSecondaryButton:SetEnabled(false)
								end

							end)

							local AcceptNewButton = vgui.Create( "DButton", AddWeaponAmmoFrame ) 
							AcceptNewButton:SetText( "Add Weapon to Shop" )			
							AcceptNewButton:SetPos(10, 440)  		
							AcceptNewButton:SetSize(335, 25)  
							

							local function ClickAmmobutton(Ammotypform, ammotyp, ammotypbutton)
								local AddAmmoFrame = vgui.Create("DFrame")
								AddAmmoFrame:SetSize(200, 310) 	
								AddAmmoFrame:Center()
								AddAmmoFrame:SetTitle("Add Primary Ammo")
								AddAmmoFrame:SetVisible(true)
								AddWeaponAmmoFrame:SetVisible(false)
								AddAmmoFrame:MakePopup()

								function AddAmmoFrame:OnClose()
								    AddWeaponAmmoFrame:SetVisible(true)
								end
								

								local AmmoNameLabel = vgui.Create("DLabel", AddAmmoFrame)        
								AmmoNameLabel:Dock(TOP)
								AmmoNameLabel:SetText("Ammo Name: ") 
								AmmoNameLabel:SetSize(220, 20)
								 
								local AmmoNameTextEntry = vgui.Create("DTextEntry", AddAmmoFrame)       
								AmmoNameTextEntry:Dock(TOP)
								AmmoNameTextEntry:SetSize(200, 20)  
								AmmoNameTextEntry:DockMargin( 0, 0, 0, 5 )

								local AmmoClassLabel = vgui.Create("DLabel", AddAmmoFrame)        
								AmmoClassLabel:Dock(TOP)
								AmmoClassLabel:SetText("Ammo Class: ") 
								AmmoClassLabel:SetSize(200, 20)

								local AmmoClassTextEntry = vgui.Create("DTextEntry", AddAmmoFrame)       
								AmmoClassTextEntry:Dock(TOP)
								AmmoClassTextEntry:SetSize(200, 20)  
								AmmoClassTextEntry:DockMargin( 0, 0, 0, 5 )
								AmmoClassTextEntry:SetEnabled(false)
								net.Start("wblreqAmmotype")
								net.WriteInt(ammotyp,16)
								net.SendToServer()

								

								local AmmoPriceLabel = vgui.Create("DLabel", AddAmmoFrame)        
								AmmoPriceLabel:Dock(TOP)
								AmmoPriceLabel:SetSize(200, 20)
								AmmoPriceLabel:SetText("Price: ") 

								local AmmoPriceWang = vgui.Create("DNumberWang", AddAmmoFrame) 
								AmmoPriceWang:Dock( TOP )
								AmmoPriceWang:SetSize(200,20)
								AmmoPriceWang:DockMargin( 0, 0, 0, 5 )
								AmmoPriceWang:SetMin(-99999) 
								AmmoPriceWang:SetMax(math.huge)
								if ammotyp == 1 then
									AmmoPriceWang:SetValue(10)
								else
									AmmoPriceWang:SetValue(200)
								end
								

								local AmmoQtyLabel = vgui.Create("DLabel", AddAmmoFrame)        
								AmmoQtyLabel:Dock(TOP)
								AmmoQtyLabel:SetSize(200, 20)
								AmmoQtyLabel:SetText("Quantity given: ") 

								local AmmoQtyWang = vgui.Create("DNumberWang", AddAmmoFrame) 
								AmmoQtyWang:Dock( TOP )
								AmmoQtyWang:SetSize(200,20)
								AmmoQtyWang:DockMargin( 0, 0, 0, 5 )
								AmmoQtyWang:SetMin(-99999) 
								AmmoQtyWang:SetMax(math.huge)
								if ammotyp == 1 then
									AmmoQtyWang:SetValue(15)
								else
									AmmoQtyWang:SetValue(1)
								end
								

								local AmmoQtyMaxLabel = vgui.Create("DLabel", AddAmmoFrame)        
								AmmoQtyMaxLabel:Dock(TOP)
								AmmoQtyMaxLabel:SetSize(200, 40)
								AmmoQtyMaxLabel:SetText("Max Ammo Cap: \nThe store will cap ammo at this amount.") 

								local AmmoQtyMaxWang = vgui.Create("DNumberWang", AddAmmoFrame) 
								AmmoQtyMaxWang:Dock( TOP )
								AmmoQtyMaxWang:SetSize(200,20)
								AmmoQtyMaxWang:DockMargin( 0, 0, 0, 5 )
								AmmoQtyMaxWang:SetMin(-99999) 
								AmmoQtyMaxWang:SetMax(math.huge)
								if ammotyp == 1 then
									AmmoQtyMaxWang:SetValue(180)
								else
									AmmoQtyMaxWang:SetValue(3)
								end

                                -- Autofill for HL2 ammo easier setup
                                net.Receive("wblsendAmmotype",function()
                                    local ammoclass = net.ReadString()
                                    AmmoClassTextEntry:SetText(tostring(ammoclass))
                                    if ammoclass ~= "RPG_Round" then
                                        AmmoNameTextEntry:SetText(tostring(ammoclass).." Rounds")
                                    elseif ammoclass == "RPG_Round" then
                                        AmmoNameTextEntry:SetText("RPG Rockets")
                                    end

                                    if ammoclass == "Grenade" or ammoclass == "slam" then
                                        AmmoQtyWang:SetValue(1)
                                        AmmoQtyMaxWang:SetValue(3)
                                        AmmoPriceWang:SetValue(75)
                                        AmmoNameTextEntry:SetText("Grenade")
                                    elseif ammoclass == "RPG_Round" then
                                        AmmoPriceWang:SetValue(150)
                                        AmmoQtyWang:SetValue(1)
                                        AmmoQtyMaxWang:SetValue(3)
                                    elseif ammoclass == "AR2" then
                                        AmmoPriceWang:SetValue(60)
                                        AmmoQtyWang:SetValue(30)
                                        AmmoQtyMaxWang:SetValue(60)
                                        AmmoNameTextEntry:SetText("Pulse Rounds")
                                    elseif ammoclass == "AR2AltFire" then
                                        AmmoPriceWang:SetValue(300)
                                        AmmoQtyWang:SetValue(1)
                                        AmmoQtyMaxWang:SetValue(3)
                                        AmmoNameTextEntry:SetText("Energy Charges")
                                    elseif ammoclass == "XBowBolt" then
                                        AmmoPriceWang:SetValue(30)
                                        AmmoQtyWang:SetValue(1)
                                        AmmoQtyMaxWang:SetValue(10)
                                        AmmoNameTextEntry:SetText("Bolts")
                                    elseif ammoclass == "SMG1" then
                                        AmmoPriceWang:SetValue(15)
                                        AmmoQtyWang:SetValue(25)
                                        AmmoQtyMaxWang:SetValue(225)
                                        AmmoNameTextEntry:SetText("SMG Rounds")
                                    elseif ammoclass == "SMG1_Grenade" then
                                        AmmoPriceWang:SetValue(200)
                                        AmmoQtyWang:SetValue(1)
                                        AmmoQtyMaxWang:SetValue(3)
                                        AmmoNameTextEntry:SetText("SMG Grenade")
                                    elseif ammoclass == "Pistol" then
                                        AmmoPriceWang:SetValue(8)
                                        AmmoQtyWang:SetValue(15)
                                        AmmoQtyMaxWang:SetValue(150)
                                        AmmoNameTextEntry:SetText("Pistol Rounds")
                                    elseif ammoclass == "357" then
                                        AmmoPriceWang:SetValue(80)
                                        AmmoQtyWang:SetValue(6)
                                        AmmoQtyMaxWang:SetValue(18)
                                        AmmoNameTextEntry:SetText("Revolver Rounds")
                                    elseif ammoclass == "Buckshot" then
                                        AmmoPriceWang:SetValue(60)
                                        AmmoQtyWang:SetValue(6)
                                        AmmoQtyMaxWang:SetValue(30)
                                        AmmoNameTextEntry:SetText("Shotgun Rounds")
                                    end
                                end)
								

								

								local AmmoAcceptButton = vgui.Create( "DButton", AddAmmoFrame ) 
								AmmoAcceptButton:SetText( "Add Ammo" )			
								AmmoAcceptButton:Dock( TOP )
								AmmoAcceptButton:SetSize(335, 25)  
								AmmoAcceptButton.DoClick = function()
									local Ammoname = AmmoNameTextEntry:GetValue()
									local AmmoClass = AmmoClassTextEntry:GetValue()
									--Insert Check if duplicate ammo here 
									local ammoclassonlistcheck = FindAmmoByClass(AmmoClass)
									local ammonameonlistcheck = FindAmmoByName(Ammoname)
									if ammonameonlistcheck == nil then
									   ammonameonlistcheck = ""
									end
									if ammoclassonlistcheck == nil then
									   ammoclassonlistcheck = ""
									end
									if AmmoClass == tostring(ammoclassonlistcheck.class) then
										AddAmmoFrame:Close()
										ammotypbutton:SetEnabled(false)
										AddWeaponAmmoFrame:SetVisible(true)
										notification.AddLegacy("Duplicate Ammo Class!", NOTIFY_ERROR, 3)
										surface.PlaySound("buttons/button10.wav")
									end
									if Ammoname == nil or Ammoname == "" then
										notification.AddLegacy("Ammo name cannot be empty!", NOTIFY_ERROR, 3)
										surface.PlaySound("buttons/button10.wav")
									elseif Ammoname == tostring(ammonameonlistcheck.name) then
										notification.AddLegacy("Ammo name already Taken!", NOTIFY_ERROR, 3)
										surface.PlaySound("buttons/button10.wav")
									else
										AddAmmoFrame:Close()
										Ammotypform:SetText(Ammoname)
										ammotypbutton:SetEnabled(false)
										net.Start("wbladdammolistToS")
										net.WriteString(AmmoNameTextEntry:GetValue())
										net.WriteString(AmmoClassTextEntry:GetValue())
										net.WriteInt(AmmoPriceWang:GetValue(),32)
										net.WriteInt(AmmoQtyWang:GetValue(),32)
										net.WriteInt(AmmoQtyMaxWang:GetValue(),32)
										net.SendToServer()
										AddWeaponAmmoFrame:SetVisible(true)
									end

								end

							end

							-- Add functionality to Add primary ammo button
							AddAmmoPrimaryButton.DoClick = function()
								ClickAmmobutton(Weaponammo1TextEntry,1,AddAmmoPrimaryButton)
							end

							AddAmmoSecondaryButton.DoClick = function()
								ClickAmmobutton(Weaponammo2TextEntry,2,AddAmmoSecondaryButton)
							end


							-- Add functionality to Accept New weapon button
							AcceptNewButton.DoClick = function()
                                --Check Name duplicate
                                local foundweapon = FindWeaponByName(WeaponNameTextEntry:GetValue())
                                if foundweapon == nil then
                                   foundweapon = ""
                                end

                                if WeaponNameTextEntry:GetValue() == foundweapon.name then
                                    notification.AddLegacy("Weapon Name Already Taken!", NOTIFY_ERROR, 3)
                                    surface.PlaySound("buttons/button10.wav")
                                    return
                                end

                                if AddAmmoPrimaryButton:IsEnabled() then
                                    notification.AddLegacy("Please Add New Primary Ammo!", NOTIFY_ERROR, 3)
                                    surface.PlaySound("buttons/button10.wav")
                                    return
                                end
                                if AddAmmoSecondaryButton:IsEnabled() then
                                    notification.AddLegacy("Please Add New Secondary Ammo!", NOTIFY_ERROR, 3)
                                    surface.PlaySound("buttons/button10.wav")
                                    return
                                end
                                

								-- Sellable processing
								local sellableprocessed
								if WeaponSellableCombo:GetValue() == "Yes" then
									sellableprocessed = true
								elseif WeaponSellableCombo:GetValue() == "No" then
									sellableprocessed = false
								else
									sellableprocessed = true
								end

								-- Nil Check
								if WeaponNameTextEntry:GetValue() == nil or WeaponNameTextEntry:GetValue() == "" then
									notification.AddLegacy("Weapon Name Cannot be Empty!", NOTIFY_ERROR, 3)
									surface.PlaySound("buttons/button10.wav")
									return
								end
								local Arsenaltoprocess = WepArsenalCombo:GetValue()
								local Arsenalprocessed
								if Arsenaltoprocess == "Consumable/Throwable" then
									Arsenalprocessed = "C"
								elseif Arsenaltoprocess == "Weapon" then
									Arsenalprocessed = "W"
								else
									notification.AddLegacy("Arsenal Type Cannot be Empty!", NOTIFY_ERROR, 3)
									surface.PlaySound("buttons/button10.wav")
									return
								end

								
								if WeaponShopCatTextEntry:GetValue() == nil or WeaponShopCatTextEntry:GetValue() == "" then
									notification.AddLegacy("Shop Category Cannot be Empty!", NOTIFY_ERROR, 3)
									surface.PlaySound("buttons/button10.wav")
									return
								end

								
								-- Description Lines Processing
								local desc1 = WeaponDescText1:GetValue()
								local tierName = WeaponShopCatTextEntry:GetValue()
							    local weaponName = WeaponNameTextEntry:GetValue()
							    local arsenalType = Arsenalprocessed
							    local class = WeaponClassTextEntry:GetValue()
							    local cost = WeaponCostWang:GetValue()
							    local sellValue = WeaponSellvalueWang:GetValue()
							    local sellable = sellableprocessed
							    local slotId = WeaponSlotIDTextEntry:GetValue()
							    local ammo1 = Weaponammo1TextEntry:GetValue()
							    local ammo2 = Weaponammo2TextEntry:GetValue()
							    local finalDesc = desc1
							    net.Start("wbladdweaponlistToS")
								net.WriteString(tostring(tierName))
								net.WriteString(tostring(weaponName))
								net.WriteString(tostring(arsenalType))
								net.WriteString(tostring(class))
								net.WriteInt(tonumber(cost),32)
								net.WriteInt(tonumber(sellValue),32)
								net.WriteBool(tobool(sellable))
								net.WriteString(tostring(slotId))
								net.WriteString(tostring(ammo1))
								net.WriteString(tostring(ammo2))
								net.WriteString(tostring(finalDesc))
								net.SendToServer()
								AddWeaponAmmoFrame:Close()
								wblDebug("Sent Add weapon to server")
							end

					end

                    local SortLowest = vgui.Create( "DButton", Forrm ) // Create the button and parent it to the frame
                    SortLowest:Dock( FILL )
                    SortLowest:SetText( "Sort Ascending by Cost per Category" )                   // Set the text on the button
                    SortLowest:SetSize( 250, 20 )
                    SortLowest.DoClick = function()
                        net.Start("wblreqlowestcostarrange")
                        net.SendToServer()
                    end

                    local ammoData = {
                        ["grenade"] = { Price = 75, Qty = 1, MaxQty = 3, AmmoName = "Grenade Rounds", Realname = "Grenade"},
                        ["slam"] = { Price = 100, Qty = 1, MaxQty = 3, AmmoName = "Slam Rounds", Realname = "Slam" },
                        ["rpg_round"] = { Price = 150, Qty = 1, MaxQty = 3, AmmoName = "RPG Round", Realname = "RPG_Round" },
                        ["ar2"] = { Price = 60, Qty = 30, MaxQty = 60, AmmoName = "Pulse Rounds", Realname = "AR2" },
                        ["ar2altfire"] = { Price = 150, Qty = 1, MaxQty = 3, AmmoName = "Energy Charges", Realname = "AR2AltFire" },
                        ["xbowbolt"] = { Price = 30, Qty = 1, MaxQty = 10, AmmoName = "Bolts", Realname = "XBowBolt" },
                        ["smg1"] = { Price = 15, Qty = 25, MaxQty = 225, AmmoName = "SMG Rounds", Realname = "SMG1" },
                        ["smg1_grenade"] = { Price = 200, Qty = 1, MaxQty = 3, AmmoName = "SMG Grenade", Realname = "SMG1_Grenade" },
                        ["pistol"] = { Price = 8, Qty = 15, MaxQty = 150, AmmoName = "Pistol Rounds", Realname = "Pistol" },
                        ["357"] = { Price = 80, Qty = 6, MaxQty = 18, AmmoName = "Revolver Rounds", Realname = "357" },
                        ["buckshot"] = { Price = 60, Qty = 6, MaxQty = 30, AmmoName = "Shotgun Rounds", Realname = "Buckshot" },
                        ["combinecannon"] = { Price = 150, Qty = 1, MaxQty = 8, AmmoName = "Cannon Charges", Realname = "CombineCannon" },
                        ["striderminigun"] = { Price = 150, Qty = 5, MaxQty = 20, AmmoName = "Strider Ammo", Realname = "StriderMinigun" },
                    }



                    local function Backupammotype(holdtype,ammotype)
                        wblDebug("Backupammo Started")
                        wblDebug("holdtype: "..holdtype)
                        wblDebug("ammotype: "..ammotype)
                        local priceammo,qtyammo,maxqtyammo
                        if holdtype == "grenade" then
                            priceammo = ammoData["grenade"].Price
                            qtyammo = ammoData["grenade"].Qty
                            maxqtyammo = ammoData["grenade"].MaxQty
                        elseif holdtype == "slam" then
                            priceammo = ammoData["slam"].Price
                            qtyammo = ammoData["slam"].Qty
                            maxqtyammo = ammoData["slam"].MaxQty
                        elseif holdtype == "pistol" then
                            priceammo = ammoData["pistol"].Price
                            qtyammo = ammoData["pistol"].Qty
                            maxqtyammo = ammoData["pistol"].MaxQty
                        elseif holdtype == "revolver" then
                            priceammo = ammoData["357"].Price
                            qtyammo = ammoData["357"].Qty
                            maxqtyammo = ammoData["357"].MaxQty
                        elseif holdtype == "smg" then
                            priceammo = ammoData["smg1"].Price
                            qtyammo = ammoData["smg1"].Qty
                            maxqtyammo = ammoData["smg1"].MaxQty
                        elseif holdtype == "shotgun" then
                            priceammo = ammoData["buckshot"].Price
                            qtyammo = ammoData["buckshot"].Qty
                            maxqtyammo = ammoData["buckshot"].MaxQty
                        elseif holdtype == "crossbow" then
                            priceammo = ammoData["xbowbolt"].Price
                            qtyammo = ammoData["xbowbolt"].Qty
                            maxqtyammo = ammoData["xbowbolt"].MaxQty
                        elseif holdtype == "ar2" then
                            priceammo = ammoData["ar2"].Price
                            qtyammo = ammoData["ar2"].Qty
                            maxqtyammo = ammoData["ar2"].MaxQty
                        elseif holdtype == "rpg" then
                            priceammo = ammoData["rpg_round"].Price
                            qtyammo = ammoData["rpg_round"].Qty
                            maxqtyammo = ammoData["rpg_round"].MaxQty
                        elseif holdtype == "physgun" then
                            priceammo = ammoData["combinecannon"].Price
                            qtyammo = ammoData["combinecannon"].Qty
                            maxqtyammo = ammoData["combinecannon"].MaxQty
                        else
                            if tonumber(ammotype) == 2 then
                                priceammo = 100
                                qtyammo = 1
                                maxqtyammo = 5
                            else
                                priceammo = 10
                                qtyammo = 15
                                maxqtyammo = 150
                            end
                        end
                        return priceammo,qtyammo,maxqtyammo
                    end

                    local hl2WeaponAmmotypes = {
                        ["weapon_smg1"] = {primaryammo = "smg1", secondaryammo = "smg1_grenade"},
                        ["weapon_ar2"] = {primaryammo = "ar2", secondaryammo = "ar2altfire"},
                        ["weapon_pistol"] = {primaryammo = "pistol", secondaryammo = "N.A."},
                        ["weapon_357"] = {primaryammo = "357", secondaryammo = "N.A."},
                        ["weapon_crossbow"] = {primaryammo = "xbowbolt", secondaryammo = "N.A."},
                        ["weapon_frag"] = {primaryammo = "N.A.", secondaryammo = "N.A."},
                        ["weapon_crowbar"] = {primaryammo = "N.A.", secondaryammo = "N.A."},
                        ["weapon_rpg"] = {primaryammo = "rpg_round", secondaryammo = "N.A."},
                        ["weapon_physcannon"] = {primaryammo = "N.A.", secondaryammo = "N.A."},
                        ["weapon_shotgun"] = {primaryammo = "buckshot", secondaryammo = "N.A."},
                        ["weapon_bugbait"] = {primaryammo = "N.A.", secondaryammo = "N.A."}
                    }

                    local throwableConsumables = {
                        "grenade",     
                        "c4",
                        "molotov",
                        "throwing knife",
                        "shuriken",
                        "bottle",
                        "chuckable",
                        "claymore",
                        "remote bomb",
                        "smoke bomb",
                        "flashbang",
                        "satchel charge",
                        "breaching charge",
                        "smoke canister",
                        "dynamite",
                        "flares",
                        "firebomb",
                        "potion",
                        "health kit",
                        "stimpak",
                        "drink",
                        "food",
                        "medkit",
                        "mine",
                        "bandage",
                        "first aid kit",
                        "antidote"
                    }

                    local weapss = {
                        "launcher",
                        "cannon",
                        "layer",
                        "gun"
                    }

                    
                    
                    local function hl2SendAmmoData(nameammo, classrealnameammo, priceammo, qtyammo, maxqtyammo)
                        local foundAmmo = FindAmmoByClass(classrealnameammo)
                        if foundAmmo then
                            wblDebug("Ammo already in list")
                        else 
                            net.Start("wbladdammolistToS")
                            net.WriteString(nameammo)
                            net.WriteString(classrealnameammo)
                            net.WriteInt(priceammo, 32)
                            net.WriteInt(qtyammo, 32)
                            net.WriteInt(maxqtyammo, 32)
                            net.SendToServer()
                        end
                    end

                    local function GetAmmoRealname(ammoType)
                        if ammoData[ammoType] then
                            return ammoData[ammoType].Realname
                        else
                            return "N.A."
                        end
                    end

                    -- Loop through HL2 weapon types and retrieve Realname
                    local function GetWeaponAmmoRealnames(weaponClass)
                        if hl2WeaponAmmotypes[weaponClass] then
                            local primaryAmmoType = hl2WeaponAmmotypes[weaponClass].primaryammo
                            local secondaryAmmoType = hl2WeaponAmmotypes[weaponClass].secondaryammo
                            
                            local primaryRealname = GetAmmoRealname(primaryAmmoType)
                            local secondaryRealname = GetAmmoRealname(secondaryAmmoType)
                            
                            return primaryRealname, secondaryRealname
                        else
                            return "N.A.", "N.A."
                        end
                    end

                    net.Receive("wblsendAmmotypequick",function()
                        wblDebug("wblsendAmmotypequick Received")
                        local weaponclasss = net.ReadString()
                        wblDebug("weaponclasss received: "..weaponclasss)
                        local foundweapondup = FindWeaponByClass(weaponclasss)
                        if foundweapondup == nil then
                        else
                            wblDebug(weaponclasss.." is already in the list!")
                            return
                        end
                        
                        local HoldType = net.ReadString()
                        wblDebug("HoldType received: "..HoldType)
                        local primaryAmmoType = net.ReadString()
                        wblDebug("primaryAmmoType received: "..primaryAmmoType)
                        local secondaryAmmoType = net.ReadString()
                        wblDebug("secondaryAmmoType received: "..secondaryAmmoType)
                        local Weaponcost = net.ReadInt(32)
                        wblDebug("Weaponcost received: "..Weaponcost)
                        local clipsize = net.ReadInt(32)
                        wblDebug("clipsize received: "..clipsize)
                        local sellvalue = Weaponcost/2
                        local spawnMenuName = GetWeaponNameByClass(weaponclasss)
                        local slotsname

                        if weaponclasss == "weapon_physgun" then
                            spawnMenuName = "Physics Gun"
                        end
                        if HoldType == "" or HoldType == "none" then
                            HoldType = "N.A."
                        end
                        if primaryAmmoType == "" or primaryAmmoType == "none" then
                            primaryAmmoType = "N.A."
                        end
                        if secondaryAmmoType == "" or secondaryAmmoType == "none" then
                            secondaryAmmoType = "N.A."
                        end
                        local WepCat = GetWeaponSpawnCategory(weaponclasss)
                        local Arsenal = "W"
                        if HoldType == "grenade" or HoldType == "slam" then
                            Arsenal = "C"
                        elseif (HoldType == "N.A." and primaryAmmoType == "N.A.") and (secondaryAmmoType == "grenade" or secondaryAmmoType == "slam") then
                            Arsenal = "C"
                        elseif (HoldType == "N.A." and secondaryAmmoType == "N.A.") and (primaryAmmoType == "grenade" or secondaryAmmoType == "slam") then
                            Arsenal = "C"
                        end

                        if (string.lower(primaryAmmoType) == "grenade") and (tostring(HoldType) ~= "ar2" or tostring(HoldType) ~= "shotgun" or tostring(HoldType) ~= "pistol" or tostring(HoldType) ~= "crossbow" or tostring(HoldType) ~= "smg") then
                            slotsname = "Throwable"
                        elseif string.lower(primaryAmmoType) == "slam" then
                            slotsname = "Equipment"
                        elseif string.lower(primaryAmmoType) == "pistol" then
                            slotsname = "Sidearm"
                        elseif string.lower(primaryAmmoType) == "357" then
                            slotsname = "Precision"
                        elseif string.lower(primaryAmmoType) == "smg1" then
                            slotsname = "Submachine Gun"
                        elseif string.lower(primaryAmmoType) == "buckshot" then
                            slotsname = "Shotgun"
                        elseif string.lower(primaryAmmoType) == "xbowbolt" then
                            slotsname = "Precision"
                        elseif string.lower(primaryAmmoType) == "ar2" then
                            slotsname = "Assault Rifle"
                        elseif string.lower(primaryAmmoType) == "rpg_round" then
                            slotsname = "Rocket"
                        elseif string.lower(primaryAmmoType) == "ar2altfire" then
                            slotsname = "Experimental"
                        elseif string.lower(primaryAmmoType) == "smg1_grenade" then
                            slotsname = "Launcher"
                        elseif string.lower(primaryAmmoType) == "combinecannon" then
                            slotsname = "Experimental"
                        elseif string.lower(primaryAmmoType) == "striderminigun" then
                            slotsname = "Experimental"
                        else
                            if HoldType == "melee" or HoldType == "knife" or HoldType == "melee2" or HoldType == "fist" or HoldType == "fists" then
                                slotsname = "Melee"
                            elseif HoldType == "grenade" then
                                slotsname = "Throwable"
                            elseif HoldType == "slam" then
                                slotsname = "Equipment"
                            elseif HoldType == "pistol" then
                                slotsname = "Sidearm"
                            elseif HoldType == "revolver" then
                                slotsname = "Precision"
                            elseif HoldType == "smg" then
                                slotsname = "Submachine Gun"
                            elseif HoldType == "shotgun" then
                                slotsname = "Shotgun"
                            elseif HoldType == "crossbow" then
                                slotsname = "Precision"
                            elseif HoldType == "ar2" then
                                slotsname = "Rifle"
                            elseif HoldType == "rpg" then
                                slotsname = "Launcher"
                            elseif HoldType == "physgun" then
                                slotsname = "Experimental"
                            else
                                slotsname = "N.A."
                            end
                        end

                        local stringword = string.lower(spawnMenuName)
                        
                        for _, word in ipairs(throwableConsumables) do
                            local startPos, endPos = string.find(stringword, word)
                            if startPos then
                                wblDebug("Found the word '" .. word .. "' at position:", startPos, "to", endPos)
                                Arsenal = "C"
                            end
                        end
                        
                        for _, word in ipairs(weapss) do
                            local startPos, endPos = string.find(stringword, word)
                            if startPos then
                                wblDebug("Found the word '" .. word .. "' at position:", startPos, "to", endPos)
                                Arsenal = "W"
                            end
                        end

                        
                        primaryAmmoTypeclass = primaryAmmoType
                        primaryAmmoType = string.lower(primaryAmmoType)
                        local ammoInfo1 = ammoData[primaryAmmoType]
                        local nameammo, priceammo, classammo, qtyammo, maxqtyammo
                        local classammo1 = "N.A."
                        local classammo2 = "N.A."

                        if primaryAmmoType ~= "n.a." and Arsenal == "W" then
                            if ammoInfo1 then
                                nameammo = ammoInfo1.AmmoName or primaryAmmoTypeclass .. " Rounds"
                                classammo = ammoInfo1.Realname
                                priceammo = ammoInfo1.Price
                                qtyammo = ammoInfo1.Qty
                                maxqtyammo = ammoInfo1.MaxQty
                            else
                                nameammo = primaryAmmoTypeclass .. " Rounds"
                                classammo = primaryAmmoTypeclass 
                                if HoldType == "grenade" or HoldType == "slam" then
                                    priceammo = 75
                                    qtyammo = 1
                                    maxqtyammo = 3
                                else
                                    priceammo,qtyammo,maxqtyammo = Backupammotype(HoldType,1)
                                end
                            end
                            wblDebug("nameammo: "..nameammo)
                            wblDebug("priceammo: "..priceammo)
                            wblDebug("classammo: "..classammo)
                            wblDebug("qtyammo: "..qtyammo)
                            wblDebug("maxqtyammo: "..maxqtyammo)
                            local foundAmmo = FindAmmoByClass(classammo)
                            if foundAmmo then
                                wblDebug("Ammo already in list")
                            else
                                net.Start("wbladdammolistToS")
                                net.WriteString(nameammo)
                                net.WriteString(classammo)
                                net.WriteInt(priceammo,32)
                                net.WriteInt(qtyammo,32)
                                net.WriteInt(maxqtyammo,32)
                                net.SendToServer()
                                
                            end
                            classammo1 = classammo
                        end

                        
                        secondaryAmmoTypeclass = secondaryAmmoType
                        secondaryAmmoType = string.lower(secondaryAmmoType)
                        local ammoInfo2 = ammoData[secondaryAmmoType]

                        if secondaryAmmoType ~= "n.a." and Arsenal == "W" then
                            if ammoInfo2 then
                                nameammo = ammoInfo2.AmmoName or secondaryAmmoTypeclass .. " Rounds"
                                classammo = ammoInfo2.Realname
                                priceammo = ammoInfo2.Price
                                qtyammo = ammoInfo2.Qty
                                maxqtyammo = ammoInfo2.MaxQty
                            else
                                nameammo = secondaryAmmoTypeclass .. " Rounds"
                                classammo = secondaryAmmoTypeclass 
                                if HoldType == "grenade" or HoldType == "slam" then
                                    priceammo = 75
                                    qtyammo = 1
                                    maxqtyammo = 3
                                else
                                    priceammo = 100
                                    qtyammo = 1
                                    maxqtyammo = 3
                                end
                            end
                            wblDebug("nameammo: "..nameammo)
                            wblDebug("priceammo: "..priceammo)
                            wblDebug("classammo: "..classammo)
                            wblDebug("qtyammo: "..qtyammo)
                            wblDebug("maxqtyammo: "..maxqtyammo)
                            local foundAmmo = FindAmmoByClass(classammo)
                            if foundAmmo then
                                wblDebug("Ammo already in list")
                            else 
                                net.Start("wbladdammolistToS")
                                net.WriteString(nameammo)
                                net.WriteString(classammo)
                                net.WriteInt(priceammo,32)
                                net.WriteInt(qtyammo,32)
                                net.WriteInt(maxqtyammo,32)
                                net.SendToServer()
                            end
                            classammo2 = classammo
                        end
                        local ifhl2 = false

                        if hl2WeaponAmmotypes[weaponclasss] then
                            local weaponInfo = hl2WeaponAmmotypes[weaponclasss]
                            local primaryammo = weaponInfo.primaryammo
                            local secondaryammo = weaponInfo.secondaryammo
                            
                            -- Handle primary ammo
                            if ammoData[primaryammo] then
                                local ammoInfo = ammoData[primaryammo]
                                hl2SendAmmoData(ammoInfo.AmmoName, ammoInfo.Realname, ammoInfo.Price, ammoInfo.Qty, ammoInfo.MaxQty)
                            end

                            -- Handle secondary ammo (if applicable)
                            if ammoData[secondaryammo] and secondaryammo ~= "N.A." then
                                local ammoInfo = ammoData[secondaryammo]
                                hl2SendAmmoData(ammoInfo.AmmoName, ammoInfo.Realname, ammoInfo.Price, ammoInfo.Qty, ammoInfo.MaxQty)
                            end
                            ifhl2 = true
                        end

                        if ifhl2 == true then
                            classammo1, classammo2 = GetWeaponAmmoRealnames(weaponclasss)
                            wblDebug("Primary Ammo Realname:", classammo1)  -- Output: SMG1
                            wblDebug("Secondary Ammo Realname:", classammo2)  -- Output: SMG1_Grenade
                        end

                        local finalDesc = "A Weapon from "..WepCat.."."
                        timer.Simple(0.1, function()
                            local foundAmmo1 = FindAmmoByClass(classammo1)
                            local foundAmmo2 = FindAmmoByClass(classammo2)
                            local ammoname1 = "N.A."
                            local ammoname2 = "N.A."
                            if foundAmmo1 ~= nil then
                                ammoname1 = foundAmmo1.name
                            else
                                ammoname1 = "N.A."
                            end
                            if foundAmmo2 ~= nil then
                                ammoname2 = foundAmmo2.name
                            else
                                ammoname2 = "N.A."
                            end
                            wblDebug("Spawn Menu Name: "..spawnMenuName)
                            wblDebug("Weapon Class: "..weaponclasss)
                            wblDebug("Weapon Category: "..WepCat)
                            wblDebug("Weapon Arsenal Type: "..Arsenal)
                            wblDebug("Weapon SlotID: "..slotsname)
                            wblDebug("Weapon Weaponcost: "..tonumber(Weaponcost))
                            wblDebug("Weapon sellvalue: "..tonumber(sellvalue))
                            wblDebug("Weapon primaryAmmoType: "..ammoname1)
                            wblDebug("Weapon secondaryAmmoType: "..ammoname2)
                            wblDebug("Weapon Desc: "..finalDesc)
                            net.Start("wbladdweaponlistToS")
                            net.WriteString(tostring(WepCat))
                            net.WriteString(tostring(spawnMenuName))
                            net.WriteString(tostring(Arsenal))
                            net.WriteString(tostring(weaponclasss))
                            net.WriteInt(tonumber(Weaponcost),32)
                            net.WriteInt(tonumber(sellvalue),32)
                            net.WriteBool(true)
                            net.WriteString(tostring(slotsname))
                            net.WriteString(tostring(ammoname1))
                            net.WriteString(tostring(ammoname2))
                            net.WriteString(tostring(finalDesc))
                            net.SendToServer()
                            wblDebug("Sent Add weapon to server")
                        end)
                        

                    
                    end)

                    function wblquickaddweaponclass(weaponclasss)
                        net.Start("wblreqAmmotypequick")
                        net.WriteString(weaponclasss)
                        net.SendToServer()
                    end

                    --[[
                    local function sendNetworkMessage(ply, dataList)
                        for i = 1, #dataList do
                            -- Use timer.Simple to space out each network message
                            timer.Simple(i * 0.1, function()
                                net.Start("MyNetworkMessage")
                                net.WriteString(dataList[i])
                                net.Send(ply)
                            end)
                        end
                    end

                    -- Example usage
                    local player = ...  -- Some player
                    local dataToSend = { "Data1", "Data2", "Data3", "Data4" }

                    sendNetworkMessage(player, dataToSend)
                    ]]


                    
                    AddQuick.DoClick = function()
                        net.Receive("wblsendcurrentlyheld",function()
                            local s = net.ReadInt(16)
                            local weapclass = net.ReadString()
                            wblDebug("weapclass: "..weapclass)
                            wblDebug("s: "..s)
                            if s == 1 then
                                weaponclasss = tostring(weapclass)
                            elseif s == 2 then
                                notification.AddLegacy("Can't Identify weapon class!", NOTIFY_ERROR, 3)
                                surface.PlaySound("buttons/combine_button_locked.wav")
                                return
                            elseif s == 3 then
                                notification.AddLegacy("Weapon Already in the list!", NOTIFY_ERROR, 3)
                                surface.PlaySound("buttons/combine_button_locked.wav")
                                return
                            end
                            wblquickaddweaponclass(weaponclasss)
                        end)
                            net.Start("wblreqcurrentlyheld")
                            net.SendToServer()
                    end

                    local AddQuickCategory = vgui.Create( "DButton", Forrm ) // Create the button and parent it to the frame
                    AddQuickCategory:Dock( FILL )
                    AddQuickCategory:SetText( "Quick Add Weapons in Spawn Category" )                   // Set the text on the button
                    AddQuickCategory:SetSize( 250, 20 )


                    local AddEntity = vgui.Create( "DButton", Forrm ) // Create the button and parent it to the frame
                    AddEntity:Dock( FILL )
                    AddEntity:SetText( "Add Entity" )                   // Set the text on the button
                    AddEntity:SetSize( 250, 20 )
                    AddEntity.DoClick = function()
                        local AddEntityFrame = vgui.Create("DFrame")
                        AddEntityFrame:SetSize(355, 225)    
                        AddEntityFrame:Center()
                        AddEntityFrame:SetTitle("Add Entity")
                        AddEntityFrame:SetVisible(true)
                        AddEntityFrame:MakePopup()
                        AddQuickCategory:SetEnabled(false)
                        AddQuick:SetEnabled(false)
                        AddWeaponAmmo:SetEnabled(false)
                        AddEntity:SetEnabled(false)
                        if AddWeaponAmmoFrame == nil then
                        else
                            if AddWeaponAmmoFrame:IsValid() then
                                AddWeaponAmmoFrame:Close()
                                AddWeaponAmmo:SetEnabled(false)
                                timer.Simple(0.05, function ()
                                    AddQuick:SetEnabled(false)
                                end)
                            end
                        end
                            
                        function AddEntityFrame:OnClose()
                            AddQuickCategory:SetEnabled(true)
                            AddQuick:SetEnabled(true)
                            AddWeaponAmmo:SetEnabled(true)
                            AddEntity:SetEnabled(true)
                        end

                        local EntityStatLeft = vgui.Create("DPanel", AddEntityFrame) -- Parent the panel to the frame
                        EntityStatLeft:Dock(LEFT)                 -- Fill the frame with the panel
                        EntityStatLeft:SetSize(150, 20)
                        EntityStatLeft:SetBackgroundColor(Color(100, 100, 100, 0))
                        EntityStatLeft:DockMargin( 5, 5, 5, 5 )

                        local EntityStatRight = vgui.Create("DPanel", AddEntityFrame) -- Parent the panel to the frame
                        EntityStatRight:Dock(RIGHT)                 -- Fill the frame with the panel
                        EntityStatRight:SetSize(175, 20)
                        EntityStatRight:SetBackgroundColor(Color(100, 100, 100, 0))
                        EntityStatRight:DockMargin( 5, 5, 5, 5 )

                        local EntityNameLabel = vgui.Create("DLabel", EntityStatLeft)        
                        EntityNameLabel:Dock(TOP)
                        EntityNameLabel:SetText("Entity Name: ") 
                        EntityNameLabel:SetSize(220, 20)

                        local EntityNameTextEntry = vgui.Create("DTextEntry", EntityStatLeft)       
                        EntityNameTextEntry:Dock(TOP)
                        EntityNameTextEntry:SetSize(200, 20)  
                        EntityNameTextEntry:DockMargin( 0, 0, 0, 5 )

                        local EntityClassLabel = vgui.Create("DLabel", EntityStatLeft)        
                        EntityClassLabel:Dock(TOP)
                        EntityClassLabel:SetText("Entity Class: ") 
                        EntityClassLabel:SetSize(200, 20)

                        local EntityClassTextEntry = vgui.Create("DTextEntry", EntityStatLeft)       
                        EntityClassTextEntry:Dock(TOP)
                        EntityClassTextEntry:SetSize(200, 20)  
                        EntityClassTextEntry:DockMargin( 0, 0, 0, 5 )
                        EntityClassTextEntry:SetEnabled(true)

                        local EntityCostLabel = vgui.Create("DLabel", EntityStatLeft)        
                        EntityCostLabel:Dock(TOP)
                        EntityCostLabel:SetSize(200, 20)
                        EntityCostLabel:SetText("Cost: ") 

                        local EntityCostWang = vgui.Create("DNumberWang", EntityStatLeft) 
                        EntityCostWang:Dock( TOP )
                        EntityCostWang:SetSize(200,20)
                        EntityCostWang:DockMargin( 0, 0, 0, 5 )
                        EntityCostWang:SetMin(-99999) 
                        EntityCostWang:SetMax(math.huge)
                        EntityCostWang:SetValue(400)

                        local EntityShopCatLabel = vgui.Create("DLabel", EntityStatLeft)        
                        EntityShopCatLabel:Dock(TOP)
                        EntityShopCatLabel:SetSize(200, 20)
                        EntityShopCatLabel:SetText("Shop category: ")  
                        
                        local EntityShopCatTextEntry = vgui.Create("DTextEntry", EntityStatLeft)       
                        EntityShopCatTextEntry:Dock(TOP)
                        EntityShopCatTextEntry:SetSize(200, 20)  -- Width and height of the text field
                        EntityShopCatTextEntry:DockMargin( 0, 0, 0, 5 )

                        local EntityDescLabel1 = vgui.Create("DLabel", EntityStatRight)
                        EntityDescLabel1:Dock(TOP)
                        EntityDescLabel1:SetText("Entity Description (Optional): ")
                        EntityDescLabel1:SetSize(220, 15)

                        local EntityDescLabelhelp = vgui.Create("DLabel", EntityStatRight)
                        EntityDescLabelhelp:Dock(TOP)
                        EntityDescLabelhelp:SetWrap(true)
                        EntityDescLabelhelp:SetText("*Up to six lines will be displayed")
                        EntityDescLabelhelp:SetSize(220, 15)

                        local EntityDescText1 = vgui.Create("DTextEntry", EntityStatRight)
                        EntityDescText1:Dock(TOP)
                        EntityDescText1:SetSize(200, 87)
                        EntityDescText1:SetText("")
                        EntityDescText1:SetMultiline(true)
                        EntityDescText1:DockMargin( 0, 0, 0, 8 )

                        local AcceptNewEntity = vgui.Create( "DButton", EntityStatRight ) 
                        AcceptNewEntity:Dock( TOP )
                        AcceptNewEntity:SetText( "Add Entity" )                  
                        AcceptNewEntity:SetSize(200, 50)
                        AcceptNewEntity.DoClick = function()
                            local foundweapon = FindWeaponByName(EntityNameTextEntry:GetValue())
                            if foundweapon == nil then
                               foundweapon = ""
                            end
                            if EntityNameTextEntry:GetValue() == foundweapon.name then
                                notification.AddLegacy("Name Already Taken!", NOTIFY_ERROR, 3)
                                surface.PlaySound("buttons/button10.wav")
                                return
                            end
                            if EntityClassTextEntry:GetValue() == nil or EntityClassTextEntry:GetValue() == "" then
                                notification.AddLegacy("Entity Class Cannot be Empty!", NOTIFY_ERROR, 3)
                                surface.PlaySound("buttons/button10.wav")
                                return
                            end
                            if EntityNameTextEntry:GetValue() == nil or EntityNameTextEntry:GetValue() == "" then
                                notification.AddLegacy("Entity Name Cannot be Empty!", NOTIFY_ERROR, 3)
                                surface.PlaySound("buttons/button10.wav")
                                return
                            end
                            if EntityShopCatTextEntry:GetValue() == nil or EntityShopCatTextEntry:GetValue() == "" then
                                notification.AddLegacy("Shop Category Cannot be Empty!", NOTIFY_ERROR, 3)
                                surface.PlaySound("buttons/button10.wav")
                                return
                            end
                            local desc1 = EntityDescText1:GetValue()
                            local tierName = EntityShopCatTextEntry:GetValue()
                            local weaponName = EntityNameTextEntry:GetValue()
                            local arsenalType = "ENT"
                            local class = EntityClassTextEntry:GetValue()
                            local cost = EntityCostWang:GetValue()
                            local sellValue = 0
                            local sellable = 0
                            local slotId = "N.A."
                            local ammo1 = "N.A."
                            local ammo2 = "N.A."
                            local finalDesc = desc1
                            net.Start("wbladdweaponlistToS")
                            net.WriteString(tostring(tierName))
                            net.WriteString(tostring(weaponName))
                            net.WriteString(tostring(arsenalType))
                            net.WriteString(tostring(class))
                            net.WriteInt(tonumber(cost),32)
                            net.WriteInt(tonumber(sellValue),32)
                            net.WriteBool(tobool(sellable))
                            net.WriteString(tostring(slotId))
                            net.WriteString(tostring(ammo1))
                            net.WriteString(tostring(ammo2))
                            net.WriteString(tostring(finalDesc))
                            net.SendToServer()
                            AddEntityFrame:Close()
                            wblDebug("Sent Add entity to server")
                        end
                    end
                    AddQuickCategory.DoClick = function()
                        local AddQuickCategoryFrame = vgui.Create("DFrame")
                        AddQuickCategoryFrame:SetSize(275, 410)    
                        AddQuickCategoryFrame:Center()
                        AddQuickCategoryFrame:SetTitle("Add Weapons/Ammo")
                        AddQuickCategoryFrame:SetVisible(true)
                        AddQuickCategoryFrame:MakePopup()
                        AddQuickCategory:SetEnabled(false)
                        AddQuick:SetEnabled(false)
                        AddWeaponAmmo:SetEnabled(false)
                        AddEntity:SetEnabled(false)
                        if AddWeaponAmmoFrame ~= nil then
                            if AddWeaponAmmoFrame:IsValid() then
                                AddWeaponAmmoFrame:Close()
                                AddWeaponAmmo:SetEnabled(false)
                                timer.Simple(0.05, function ()
                                    AddQuick:SetEnabled(false)
                                end)
                            end
                        end
                        
                        function AddQuickCategoryFrame:OnClose()
                            AddQuickCategory:SetEnabled(true)
                            AddQuick:SetEnabled(true)
                            AddWeaponAmmo:SetEnabled(true)
                            AddEntity:SetEnabled(true)
                        end

                        --local WeaponCatLabel = vgui.Create("DLabel", AddQuickCategoryFrame)        
                        --WeaponCatLabel:Dock(TOP)
                        --WeaponCatLabel:SetText("Override Category Name: ") 
                        --WeaponCatLabel:SetSize(220, 20)


                        --local WeaponCatTextEntry = vgui.Create("DTextEntry", AddQuickCategoryFrame)       
                        --WeaponCatTextEntry:Dock(TOP)
                        --WeaponCatTextEntry:SetSize(200, 20)  
                        --WeaponCatTextEntry:DockMargin( 0, 0, 0, 5 )

                        local AddWeaponList = vgui.Create("DListView", AddQuickCategoryFrame) -- Create the list for weapon categories
                        AddWeaponList:Dock(TOP)
                        AddWeaponList:DockMargin(0, 0, 0, 5)
                        AddWeaponList:SetSize(200, 345)
                        AddWeaponList:AddColumn("Weapon Categories")

                        local weaponList = list.Get("Weapon") -- Retrieve the list of weapons in GMod
                        local addedCategories = {}

                        -- Loop through all weapons to get categories
                        for _, weaponData in pairs(weaponList) do
                            local category = weaponData.Category or "Uncategorized"
                            if not addedCategories[category] then
                                AddWeaponList:AddLine(category) -- Add the category to the list
                                addedCategories[category] = true -- Ensure each category is added only once
                            end
                        end


                        function AddWeaponList:DoDoubleClick(lineID, line)  -- Correctly use ':' for method definition
                            -- Debugging output to check the parameters
                            AddQuickCategoryFrame:ShowCloseButton(false)
                            wblDebug("Line ID: "..tostring(lineID))
                            local Selectedline = AddWeaponList:GetSelectedLine()
                            wblDebug("Line: "..Selectedline)
                            local CatSelectedLine = AddWeaponList:GetLines()[Selectedline]
                            local selectedCategory = CatSelectedLine:GetValue(1)
                            wblDebug("Line: "..selectedCategory)
                        
                            local weaponClassesInCategory = {} -- Table to store weapon classes

                            --[[
                            -- Retrieve all weapon classes for the selected category
                            for _, weaponData in pairs(weaponList) do
                                if weaponData.Category == selectedCategory then
                                    table.insert(weaponClassesInCategory, weaponData.ClassName)
                                end
                            end
                            ]]
                            for _, weaponData in pairs(weaponList) do
                                if weaponData.Category == selectedCategory and weaponData.Spawnable then
                                    table.insert(weaponClassesInCategory, weaponData.ClassName)
                                end
                            end
                            AddWeaponList:Remove()
                            local ProcessCatLabel = vgui.Create("DLabel", AddQuickCategoryFrame)        
                            ProcessCatLabel:Dock(TOP)
                            ProcessCatLabel:SetText("Processing please wait...") 
                            ProcessCatLabel:SetSize(220, 40)
                            -- Loop through the weapon classes and execute the function with a delay
                            local delay = 0
                            local totalWeapons = #weaponClassesInCategory -- Total number of weapons in the category
                            local progressThresholds = {0.25, 0.50, 0.75, 1.00} -- Progress points for notifications
                            local nextThresholdIndex = 1 -- Track the next threshold to trigger
                            local processedWeapons = 0 -- Counter for processed weapons
                            notification.AddLegacy("Processing Weapons Please wait!", NOTIFY_GENERIC, 3)
                            surface.PlaySound("npc/scanner/combat_scan2.wav")
                            for i, weaponclass in ipairs(weaponClassesInCategory) do
                                timer.Simple(delay, function()
                                    wblDebug("weaponclass to process: "..weaponclass)
                                    wblquickaddweaponclass(tostring(weaponclass)) -- Call your function with the weapon class
                                    wblDebug("Added weapon class: " .. weaponclass)

                                    -- Update the number of processed weapons
                                    processedWeapons = processedWeapons + 1
                                    local progress = processedWeapons / totalWeapons

                                    -- Trigger notifications at 25%, 50%, 75%, and 100%
                                    if nextThresholdIndex <= #progressThresholds and progress >= progressThresholds[nextThresholdIndex] then
                                        local percentage = progressThresholds[nextThresholdIndex] * 100
                                        notification.AddLegacy("Processing " .. percentage .. "% complete", NOTIFY_GENERIC, 3) -- Show a notification
                                        surface.PlaySound("npc/scanner/combat_scan5.wav")
                                        nextThresholdIndex = nextThresholdIndex + 1 -- Move to the next threshold
                                    end
                                end)

                                delay = delay + 0.2 -- Increment delay for each weapon class
                            end

                            -- Close the frame after all the weapon classes have been processed
                            timer.Simple(delay, function()
                                if AddQuickCategoryFrame and AddQuickCategoryFrame:IsValid() then
                                    AddQuickCategoryFrame:Close()
                                    wblDebug("Frame closed after processing all weapon classes.")
                                    notification.AddLegacy("All weapons processed!", NOTIFY_GENERIC, 5) -- Final notification when done
                                    surface.PlaySound("npc/scanner/combat_scan1.wav")
                                end
                            end)

                            
                        end
                        



                    end

					function RefreshAmmolist()
						wblDebug("Ammo list Refresh Executed")
						if AmmoList:IsValid() then
    						AmmoList:Clear()
    						--PrintTable(wblammolist)
    						for k, v in ipairs(wblammolist) do
    						    AmmoList:AddLine(v.name, v.class, "ω"..v.price, v.quantity, v.maxquantity)
    						end
                        end
					end

					function RefreshWeaponlist()
						remweaponlistnum = 0
                        if WepList:IsValid() then
    						WepList:Clear()
    						--PrintTable(wblweaponlist)
    						for _, tier in ipairs(wblweaponlist) do
    						    for _, weapon in ipairs(tier.weapons) do
    						        -- Add each weapon to the DListView
    						        WepList:AddLine(
    						            weapon.name,               
    						            weapon.class,              
    						            "ω"..weapon.cost,
                                        weapon.slotid,               
    						            weapon.Arsenaltype,            
    						            tier.name                  
    						        )
    						    end
    						end
                        end
					end

					WepList.OnRowRightClick = function(_, lineID, line)
						local weaponClass = line:GetColumnText(2)
                        local weapontier = line:GetColumnText(6)
                        local IfEnt = line:GetColumnText(5)
						local foundweapon = FindWeaponByClass(weaponClass)
					    local menuu = DermaMenu()

					   
					    menuu:AddOption("Remove", function()
					    	wblDebug("Remove Request sent")
					    	wblDebug(weaponClass)
					       	net.Start("wblreqdeleteweaponToS")
					       	net.WriteString(weaponClass)
						   	net.SendToServer()
					    end)

                        menuu:AddOption("Move up", function()
                            wblDebug("Move up Request sent")
                            wblDebug("Tier: "..weapontier)
                            wblDebug("Weapon name: "..foundweapon.name)
                            net.Start("wblreqMoveupweapon")
                            net.WriteString(weapontier)
                            net.WriteString(foundweapon.name)
                            net.SendToServer()
                        end)

                        menuu:AddOption("Move down", function()
                            wblDebug("Move down Request sent")
                            wblDebug("Tier: "..weapontier)
                            wblDebug("Weapon name: "..foundweapon.name)
                            net.Start("wblreqMovedownweapon")
                            net.WriteString(weapontier)
                            net.WriteString(foundweapon.name)
                            net.SendToServer()
                        end)
					    
					    local subMenu, editOption = menuu:AddSubMenu("Edit")
					    
					    
					    subMenu:AddOption("Change Name", function()
                            local Editframe = vgui.Create("DFrame")
                            wblDebug("Line ID: "..tostring(lineID))
                            wblDebug("Line: "..tostring(line))
                            Editframe:SetSize(250, 120)            
                            Editframe:SetTitle("Change Weapon Name") 
                            Editframe:Center()                      
                            Editframe:MakePopup()      

                            local weaponClass = (line:GetColumnText(2))
                            local foundweapon = FindWeaponByClass(weaponClass)

                            local EditLabelold = vgui.Create("DLabel", Editframe)        
                            EditLabelold:Dock(TOP)
                            EditLabelold:SetText("Old Name: "..foundweapon.name)             

                            local EditLabel = vgui.Create("DLabel", Editframe)        
                            EditLabel:Dock(TOP)
                            EditLabel:SetText("New Name: ")    

                            
                            local NewNameTextEntry = vgui.Create("DTextEntry", Editframe)       
                            NewNameTextEntry:Dock(TOP)
                            NewNameTextEntry:DockMargin( 0, 0, 0, 5 )
                            NewNameTextEntry:SetSize(250, 30)
                            NewNameTextEntry:SetText(foundweapon.name)
                            NewNameTextEntry:RequestFocus()
                            NewNameTextEntry.OnEnter = function(self)
                                if NewNameTextEntry:GetValue() ~= "" then
                                    local foundweaponname = FindWeaponByName(NewNameTextEntry:GetValue())
                                    if foundweaponname == nil then
                                       foundweaponname = ""
                                    end
                                    if NewNameTextEntry:GetValue() == foundweaponname.name then
                                        notification.AddLegacy("Weapon Name Already Taken!", NOTIFY_ERROR, 3)
                                        surface.PlaySound("buttons/button10.wav")
                                        return
                                    end
                                    Editframe:Close()
                                    net.Start("wblreqChangenameweaponToS")
                                    net.WriteString(weaponClass)
                                    net.WriteString(NewNameTextEntry:GetValue())
                                    net.SendToServer()

                                end
                            end
					    end)

                        if IfEnt ~= "ENT" then
                            subMenu:AddOption("Change Arsenal Type", function()
                                local Editframe = vgui.Create("DFrame")
                                wblDebug("Line ID: "..tostring(lineID))
                                wblDebug("Line: "..tostring(line))
                                Editframe:SetSize(250, 120)            
                                Editframe:SetTitle("Change Arsenal Type") 
                                Editframe:Center()                      
                                Editframe:MakePopup()      

                                local weaponClass = (line:GetColumnText(2))
                                local foundweapon = FindWeaponByClass(weaponClass)
                                local finalold
                                local finalnew
                                if foundweapon.Arsenaltype == "C" then
                                    finalold = "Consumable/Throwable"
                                    finalnew = "Weapon"
                                elseif foundweapon.Arsenaltype == "W" then
                                    finalold = "Weapon"
                                    finalnew = "Consumable/Throwable"
                                end

                                local EditLabelold = vgui.Create("DLabel", Editframe)        
                                EditLabelold:Dock(TOP)
                                EditLabelold:SetText("Old Arsenal Type: "..finalold)             

                                local EditLabel = vgui.Create("DLabel", Editframe)        
                                EditLabel:Dock(TOP)
                                EditLabel:SetText("New Arsenal Type: "..finalnew)    

                                local AcceptNewArsenalType = vgui.Create( "DButton", Editframe ) 
                                AcceptNewArsenalType:Dock( TOP )
                                AcceptNewArsenalType:SetText( "Switch to "..finalnew.."?" )                  
                                AcceptNewArsenalType:SetSize(250, 30)
                                AcceptNewArsenalType:DockMargin(0, 0, 0, 5)
                                    AcceptNewArsenalType.DoClick = function()
                                        Editframe:Close()
                                        net.Start("wblreqChangearsweaponToS")
                                        net.WriteString(weaponClass)
                                        net.WriteString(finalnew)
                                        net.SendToServer()
                                    end
                            end)
                        end
					    
					    subMenu:AddOption("Change Cost", function()
					       local Editframe = vgui.Create("DFrame")
                            wblDebug("Line ID: "..tostring(lineID))
                            wblDebug("Line: "..tostring(line))
                            Editframe:SetSize(250, 120)            
                            Editframe:SetTitle("Change Weapon Cost") 
                            Editframe:Center()                      
                            Editframe:MakePopup()      

                            local weaponClass = (line:GetColumnText(2))
                            local foundweapon = FindWeaponByClass(weaponClass)

                            local EditLabelold = vgui.Create("DLabel", Editframe)        
                            EditLabelold:Dock(TOP)
                            EditLabelold:SetText("Old cost: ω"..foundweapon.cost)             

                            local EditLabel = vgui.Create("DLabel", Editframe)        
                            EditLabel:Dock(TOP)
                            EditLabel:SetText("New Cost: ")    

                            
                            local NewNameTextEntry = vgui.Create("DNumberWang", Editframe) 
                            NewNameTextEntry:Dock( TOP )
                            NewNameTextEntry:DockMargin( 0, 0, 0, 5 )
                            NewNameTextEntry:SetMin(-99999) 
                            NewNameTextEntry:SetMax(math.huge)   
                            NewNameTextEntry:SetValue(foundweapon.cost)  
                            NewNameTextEntry:SetSize(250, 30)
                            NewNameTextEntry:RequestFocus()
                            NewNameTextEntry.OnEnter = function(self)
                                if NewNameTextEntry:GetValue() ~= "" then
                                    Editframe:Close()
                                    net.Start("wblreqChangecostweaponToS")
                                    net.WriteString(weaponClass)
                                    net.WriteInt(tonumber(NewNameTextEntry:GetValue()),32)
                                    net.SendToServer()

                                end
                            end
					    end)
					    
                        if IfEnt ~= "ENT" then
    					    subMenu:AddOption("Change SlotID", function()
    					        local Editframe = vgui.Create("DFrame")
                                wblDebug("Line ID: "..tostring(lineID))
                                wblDebug("Line: "..tostring(line))
                                Editframe:SetSize(250, 120)            
                                Editframe:SetTitle("Change SlotID") 
                                Editframe:Center()                      
                                Editframe:MakePopup()      

                                local weaponClass = (line:GetColumnText(2))
                                local foundweapon = FindWeaponByClass(weaponClass)

                                local EditLabelold = vgui.Create("DLabel", Editframe)        
                                EditLabelold:Dock(TOP)
                                EditLabelold:SetText("Old slotID: "..foundweapon.slotid)             

                                local EditLabel = vgui.Create("DLabel", Editframe)        
                                EditLabel:Dock(TOP)
                                EditLabel:SetText("New slotID: ")    

                                
                                local NewNameTextEntry = vgui.Create("DTextEntry", Editframe)       
                                NewNameTextEntry:Dock(TOP)
                                NewNameTextEntry:DockMargin( 0, 0, 0, 5 )
                                NewNameTextEntry:SetSize(250, 30)
                                NewNameTextEntry:SetText(foundweapon.slotid)
                                NewNameTextEntry:RequestFocus()
                                NewNameTextEntry.OnEnter = function(self)
                                    if NewNameTextEntry:GetValue() ~= "" then
                                        Editframe:Close()
                                        net.Start("wblreqChangeslotweaponToS")
                                        net.WriteString(weaponClass)
                                        net.WriteString(NewNameTextEntry:GetValue())
                                        net.SendToServer()

                                    end
                                end
    					    end)
                        end

					    subMenu:AddOption("Change Shop category", function()
					        local Editframe = vgui.Create("DFrame")
                            wblDebug("Line ID: "..tostring(lineID))
                            wblDebug("Line: "..tostring(line))
                            Editframe:SetSize(250, 120)            
                            Editframe:SetTitle("Change Shop category") 
                            Editframe:Center()                      
                            Editframe:MakePopup()      

                            local weaponClass = (line:GetColumnText(2))
                            local foundweapon = FindWeaponByClass(weaponClass)

                            local EditLabelold = vgui.Create("DLabel", Editframe)        
                            EditLabelold:Dock(TOP)
                            EditLabelold:SetText("Old Category: "..line:GetColumnText(6))             

                            local EditLabel = vgui.Create("DLabel", Editframe)        
                            EditLabel:Dock(TOP)
                            EditLabel:SetText("New Category: ")    

                            
                            local NewNameTextEntry = vgui.Create("DTextEntry", Editframe)       
                            NewNameTextEntry:Dock(TOP)
                            NewNameTextEntry:DockMargin( 0, 0, 0, 5 )
                            NewNameTextEntry:SetSize(250, 30)
                            NewNameTextEntry:SetText(line:GetColumnText(6))
                            NewNameTextEntry:RequestFocus()
                            NewNameTextEntry.OnEnter = function(self)
                                if NewNameTextEntry:GetValue() ~= "" then
                                    Editframe:Close()
                                    net.Start("wblreqChangecatweaponToS")
                                    net.WriteString(weaponClass)
                                    net.WriteString(NewNameTextEntry:GetValue())
                                    net.SendToServer()

                                end
                            end
					    end)

                        if IfEnt ~= "ENT" then
    					    subMenu:AddOption("Change Sell value", function()
    					        local Editframe = vgui.Create("DFrame")
                                wblDebug("Line ID: "..tostring(lineID))
                                wblDebug("Line: "..tostring(line))
                                Editframe:SetSize(250, 120)            
                                Editframe:SetTitle("Change Sell value") 
                                Editframe:Center()                      
                                Editframe:MakePopup()      

                                local weaponClass = (line:GetColumnText(2))
                                local foundweapon = FindWeaponByClass(weaponClass)

                                local EditLabelold = vgui.Create("DLabel", Editframe)        
                                EditLabelold:Dock(TOP)
                                EditLabelold:SetText("Old Sell Value: ω"..foundweapon.sellvalue)             

                                local EditLabel = vgui.Create("DLabel", Editframe)        
                                EditLabel:Dock(TOP)
                                EditLabel:SetText("New Sell Value: ")    

                                
                                local NewNameTextEntry = vgui.Create("DNumberWang", Editframe) 
                                NewNameTextEntry:Dock( TOP )
                                NewNameTextEntry:DockMargin( 0, 0, 0, 5 )
                                NewNameTextEntry:SetMin(-99999) 
                                NewNameTextEntry:SetMax(math.huge)   
                                NewNameTextEntry:SetValue(foundweapon.sellvalue)  
                                NewNameTextEntry:SetSize(250, 30)
                                NewNameTextEntry:RequestFocus()
                                NewNameTextEntry.OnEnter = function(self)
                                    if NewNameTextEntry:GetValue() ~= "" then
                                        Editframe:Close()
                                        net.Start("wblreqChangesellvalweaponToS")
                                        net.WriteString(weaponClass)
                                        net.WriteInt(tonumber(NewNameTextEntry:GetValue()),32)
                                        net.SendToServer()

                                    end
                                end
    					    end)
                        end
                        
                        if IfEnt ~= "ENT" then
    					    subMenu:AddOption("Change if Sellable", function()
    					        local Editframe = vgui.Create("DFrame")
                                wblDebug("Line ID: "..tostring(lineID))
                                wblDebug("Line: "..tostring(line))
                                Editframe:SetSize(250, 90)            
                                Editframe:SetTitle("Change if Sellable") 
                                Editframe:Center()                      
                                Editframe:MakePopup()      

                                local weaponClass = (line:GetColumnText(2))
                                local foundweapon = FindWeaponByClass(weaponClass)
                                local finalold
                                local finalnew
                                if foundweapon.sellable == true then
                                    finalold = "sellable"
                                    finalnew = "not sellable"
                                elseif foundweapon.sellable == false then
                                    finalold = "not sellable"
                                    finalnew = "sellable"
                                end

                                local EditLabelold = vgui.Create("DLabel", Editframe)        
                                EditLabelold:Dock(TOP)
                                EditLabelold:SetText("Weapon is "..finalold)               

                                local AcceptNewArsenalType = vgui.Create( "DButton", Editframe ) 
                                AcceptNewArsenalType:Dock( TOP )
                                AcceptNewArsenalType:SetText( "Make it "..finalnew.."?" )                  
                                AcceptNewArsenalType:SetSize(250, 30)
                                AcceptNewArsenalType:DockMargin(0, 0, 0, 5)
                                    AcceptNewArsenalType.DoClick = function()
                                        Editframe:Close()
                                        net.Start("wblreqChangesellableweaponToS")
                                        net.WriteString(weaponClass)
                                        net.WriteBool(not(foundweapon.sellable))
                                        net.SendToServer()
                                    end
    					    end)
                        end
                        

                        subMenu:AddOption("Change Description", function()

                            local weaponClass = (line:GetColumnText(2))
                            local foundweapon = FindWeaponByClass(weaponClass)
                            local Editframe = vgui.Create("DFrame")
                            wblDebug("Line ID: "..tostring(lineID))
                            wblDebug("Line: "..tostring(line))
                            Editframe:SetSize(200, 295)            
                            Editframe:SetTitle("Change Desc") 
                            Editframe:Center()                      
                            Editframe:MakePopup()      

                            local EditDesc = vgui.Create("DPanel", Editframe) -- Parent the panel to the frame
                            EditDesc:Dock(RIGHT)                 -- Fill the frame with the panel
                            EditDesc:SetSize(175, 20)
                            EditDesc:SetBackgroundColor(Color(100, 100, 100, 0))
                            EditDesc:DockMargin( 5, 5, 5, 5 )

                            local EditLabelold = vgui.Create("DLabel", EditDesc)        
                            EditLabelold:Dock(TOP)

                            EditLabelold:SetText("Old Description: ")

                            local EditLabelold2 = vgui.Create("DLabel", EditDesc)        
                            EditLabelold2:Dock(TOP)
                            EditLabelold2:SetSize(175, 87)
                            EditLabelold2:SetWrap(true)
                            EditLabelold2:SetText(foundweapon.desc)

                            local EditLabel = vgui.Create("DLabel", EditDesc)        
                            EditLabel:Dock(TOP)
                            EditLabel:SetText("New Description: ")

                            local DescText1 = vgui.Create("DTextEntry", EditDesc)
                            DescText1:Dock(TOP)
                            DescText1:SetSize(200, 87)
                            DescText1:SetText(foundweapon.desc)
                            DescText1:SetMultiline(true) 
                            DescText1:DockMargin( 0, 0, 0, 5 )

                            local AcceptNewButton = vgui.Create( "DButton", EditDesc ) 
                            AcceptNewButton:SetText( "Change Description" )      
                            AcceptNewButton:Dock(TOP)            
                            AcceptNewButton:SetSize(335, 25)
                            AcceptNewButton.DoClick = function(self)
                                if DescText1:GetValue() ~= "" then
                                    Editframe:Close()
                                    net.Start("wblreqChangeDescweaponToS")
                                    net.WriteString(weaponClass)
                                    net.WriteString(DescText1:GetValue())
                                    net.SendToServer()

                                end
                            end
                            
                        end)


					    menuu:Open()
					end

                    --Ammolist Rightclick functions
                    AmmoList.OnRowRightClick = function(_, lineID, line)
                        local AmmoClass = line:GetColumnText(2)
                        local foundAmmo = FindAmmoByClass(AmmoClass)
                        local foundWeapon1 = FindWeaponByAmmo1(foundAmmo.name)
                        if foundWeapon1 == nil then
                        end
                        local foundWeapon2 = FindWeaponByAmmo2(foundAmmo.name)
                        if foundWeapon2 == nil then
                        end
                        wblDebug("foundAmmo: "..foundAmmo.name)
                        if foundWeapon1 ~= nil then
                            wblDebug("foundweapon1 name: "..foundWeapon1.name)
                            wblDebug("foundweapon1 class: "..foundWeapon1.class)
                        end
                        if foundWeapon2 ~= nil then
                            wblDebug("foundWeapon2 name: "..foundWeapon2.name)
                            wblDebug("foundweapon2 class: "..foundWeapon2.class)
                        end
                        local menuu = DermaMenu()
                        menuu:AddOption("Remove", function()
                            wblDebug("Remove Request sent")
                            wblDebug(AmmoClass)
                            if foundWeapon1 ~= nil then
                                if foundWeapon1.ammo1 == foundAmmo.name then
                                    notification.AddLegacy("Cannot Delete Ammo. "..foundWeapon1.name.." is still using this, Delete the weapon first!", NOTIFY_ERROR, 6)
                                    surface.PlaySound("buttons/button10.wav")
                                    return
                                end
                            end
                            if foundWeapon2 ~= nil then
                                if foundWeapon2.ammo2 == foundAmmo.name then
                                    notification.AddLegacy("Cannot Delete Ammo. "..foundWeapon2.name.." is still using this, Delete the weapon first!", NOTIFY_ERROR, 6)
                                    surface.PlaySound("buttons/button10.wav")
                                    return
                                end
                            end
                            net.Start("wblreqdeleteammoToS")
                            net.WriteString(foundAmmo.class)
                            net.SendToServer()
                        end)

                        
                        local subMenu, editOption = menuu:AddSubMenu("Edit")
                        
                        
                        subMenu:AddOption("Change Name", function()
                            local Editframe = vgui.Create("DFrame")
                            wblDebug("Line ID: "..tostring(lineID))
                            wblDebug("Line: "..tostring(line))
                            Editframe:SetSize(250, 120)            
                            Editframe:SetTitle("Change Weapon Name") 
                            Editframe:Center()                      
                            Editframe:MakePopup()      

                            local AmmoClass = line:GetColumnText(2)
                            local foundAmmo = FindAmmoByClass(AmmoClass)

                            local EditLabelold = vgui.Create("DLabel", Editframe)        
                            EditLabelold:Dock(TOP)
                            EditLabelold:SetText("Old Name: "..foundAmmo.name)             

                            local EditLabel = vgui.Create("DLabel", Editframe)        
                            EditLabel:Dock(TOP)
                            EditLabel:SetText("New Name: ")    

                            
                            local NewNameTextEntry = vgui.Create("DTextEntry", Editframe)       
                            NewNameTextEntry:Dock(TOP)
                            NewNameTextEntry:DockMargin( 0, 0, 0, 5 )
                            NewNameTextEntry:SetSize(250, 30)
                            NewNameTextEntry:SetText(foundAmmo.name)
                            NewNameTextEntry:RequestFocus()
                            NewNameTextEntry.OnEnter = function(self)
                                if NewNameTextEntry:GetValue() ~= "" then
                                    local foundammoname = FindAmmoByName(NewNameTextEntry:GetValue())
                                    if foundammoname == nil then
                                       foundammoname = ""
                                    end
                                    if NewNameTextEntry:GetValue() == foundammoname.name then
                                        notification.AddLegacy("Ammo Name Already Taken!", NOTIFY_ERROR, 3)
                                        surface.PlaySound("buttons/button10.wav")
                                        return
                                    end
                                    Editframe:Close()
                                    net.Start("wblreqChangenameammoToS")
                                    net.WriteString(AmmoClass)
                                    net.WriteString(NewNameTextEntry:GetValue())
                                    net.SendToServer()

                                end
                            end
                        end)

                        
                        subMenu:AddOption("Change Price", function()
                           local Editframe = vgui.Create("DFrame")
                            wblDebug("Line ID: "..tostring(lineID))
                            wblDebug("Line: "..tostring(line))
                            Editframe:SetSize(250, 120)            
                            Editframe:SetTitle("Change Ammo Price") 
                            Editframe:Center()                      
                            Editframe:MakePopup()      

                            local AmmoClass = line:GetColumnText(2)
                            local foundAmmo = FindAmmoByClass(AmmoClass)

                            local EditLabelold = vgui.Create("DLabel", Editframe)        
                            EditLabelold:Dock(TOP)
                            EditLabelold:SetText("Old price: ω"..foundAmmo.price)             

                            local EditLabel = vgui.Create("DLabel", Editframe)        
                            EditLabel:Dock(TOP)
                            EditLabel:SetText("New Price: ")    

                            
                            local NewNameTextEntry = vgui.Create("DNumberWang", Editframe) 
                            NewNameTextEntry:Dock( TOP )
                            NewNameTextEntry:DockMargin( 0, 0, 0, 5 )
                            NewNameTextEntry:SetMin(-99999) 
                            NewNameTextEntry:SetMax(math.huge)   
                            NewNameTextEntry:SetValue(foundAmmo.price)  
                            NewNameTextEntry:SetSize(250, 30)
                            NewNameTextEntry:RequestFocus()
                            NewNameTextEntry.OnEnter = function(self)
                                if NewNameTextEntry:GetValue() ~= "" then
                                    Editframe:Close()
                                    net.Start("wblreqChangepriceammoToS")
                                    net.WriteString(AmmoClass)
                                    net.WriteInt(tonumber(NewNameTextEntry:GetValue()),32)
                                    net.SendToServer()

                                end
                            end
                        end)
                        
                        subMenu:AddOption("Change Quantity on Buy", function()
                           local Editframe = vgui.Create("DFrame")
                            wblDebug("Line ID: "..tostring(lineID))
                            wblDebug("Line: "..tostring(line))
                            Editframe:SetSize(250, 120)            
                            Editframe:SetTitle("Change Quantity") 
                            Editframe:Center()                      
                            Editframe:MakePopup()      

                            local AmmoClass = line:GetColumnText(2)
                            local foundAmmo = FindAmmoByClass(AmmoClass)

                            local EditLabelold = vgui.Create("DLabel", Editframe)        
                            EditLabelold:Dock(TOP)
                            EditLabelold:SetText("Current Amount per Buy: "..foundAmmo.quantity)             

                            local EditLabel = vgui.Create("DLabel", Editframe)        
                            EditLabel:Dock(TOP)
                            EditLabel:SetText("New Amount: ")    

                            
                            local NewNameTextEntry = vgui.Create("DNumberWang", Editframe) 
                            NewNameTextEntry:Dock( TOP )
                            NewNameTextEntry:DockMargin( 0, 0, 0, 5 )
                            NewNameTextEntry:SetMin(-99999) 
                            NewNameTextEntry:SetMax(math.huge)   
                            NewNameTextEntry:SetValue(foundAmmo.quantity)  
                            NewNameTextEntry:SetSize(250, 30)
                            NewNameTextEntry:RequestFocus()
                            NewNameTextEntry.OnEnter = function(self)
                                if NewNameTextEntry:GetValue() ~= "" then
                                    Editframe:Close()
                                    net.Start("wblreqChangeqtyammoToS")
                                    net.WriteString(AmmoClass)
                                    net.WriteInt(tonumber(NewNameTextEntry:GetValue()),32)
                                    net.SendToServer()

                                end
                            end
                        end)
                        
                        subMenu:AddOption("Change Max Ammo Capacity", function()
                           local Editframe = vgui.Create("DFrame")
                            wblDebug("Line ID: "..tostring(lineID))
                            wblDebug("Line: "..tostring(line))
                            Editframe:SetSize(250, 120)            
                            Editframe:SetTitle("Change Max Cap") 
                            Editframe:Center()                      
                            Editframe:MakePopup()      

                            local AmmoClass = line:GetColumnText(2)
                            local foundAmmo = FindAmmoByClass(AmmoClass)

                            local EditLabelold = vgui.Create("DLabel", Editframe)        
                            EditLabelold:Dock(TOP)
                            EditLabelold:SetText("Current Max Cap: "..foundAmmo.maxquantity)             

                            local EditLabel = vgui.Create("DLabel", Editframe)        
                            EditLabel:Dock(TOP)
                            EditLabel:SetText("New Max Cap: ")    

                            
                            local NewNameTextEntry = vgui.Create("DNumberWang", Editframe) 
                            NewNameTextEntry:Dock( TOP )
                            NewNameTextEntry:DockMargin( 0, 0, 0, 5 )
                            NewNameTextEntry:SetMin(-99999) 
                            NewNameTextEntry:SetMax(math.huge)   
                            NewNameTextEntry:SetValue(foundAmmo.maxquantity)  
                            NewNameTextEntry:SetSize(250, 30)
                            NewNameTextEntry:RequestFocus()
                            NewNameTextEntry.OnEnter = function(self)
                                if NewNameTextEntry:GetValue() ~= "" then
                                    Editframe:Close()
                                    net.Start("wblreqChangemaxqtyammoToS")
                                    net.WriteString(AmmoClass)
                                    net.WriteInt(tonumber(NewNameTextEntry:GetValue()),32)
                                    net.SendToServer()

                                end
                            end
                        end)
                        


                        menuu:Open()
                    end
					
					-- Network receive to update ammo list
					net.Receive("wbladdammolistToC",function(Len)
						wblammolist = ReceiveAndDecompressTable()
                        if wblammolist then
                            RefreshAmmolist()
                        end
                        wblDebug("wblammolist ammo received client")
					end)

					net.Receive("wbladdweaponlistToC",function(Len)
						wblweaponlist = ReceiveAndDecompressTable()
                        if wblweaponlist then
                            wblDebug("Updated weapon list received")
                            RefreshWeaponlist()
                        end
                        wblDebug("wblweaponlist ammo received client")
					end)
					
				For0:AddItem(WepPresetLabel)
				For0:AddItem(WepPresetCombo)
				For0:AddItem(WepAddPreset)
				For0:AddItem(WepDeletePreset)
				For0:AddItem(WeplistLabel)
				For0:AddItem(WepList)
                For0:AddItem(SortLowest)
				For0:AddItem(AmmolistLabel)
				For0:AddItem(AmmoList)
                For0:AddItem(AddWeaponAmmo)
                For0:ControlHelp("Manually add weapon/ammo, 99.99% reliable")
                For0:AddItem(AddQuick)
                For0:ControlHelp("Use built-in algorithm to add current weapon, 90% reliable")
                For0:AddItem(AddQuickCategory)
                For0:ControlHelp("Use built-in algorithm to add weapons in a category, 90% reliable")
                For0:AddItem(AddEntity)
                For0:ControlHelp("Adding Entity Tip: You can go to the spawn menu of entities or npcs. Then you right click your choice of entity/npc -> Copy to Clipboard. You can paste this in the Entity class field/textbox when you're adding in the list!")
                For0:AddItem(WepNoteLabel)
				For0:ControlHelp("*When weapons share a SlotID, the shop won't give another from the same slot if the player already has one. N.A. slotID will be ignored by this feature")
                For0:ControlHelp("*NOTE: SlotID only prevents from BUYING, it will not prevent you from picking up that weapon (from the ground). Dropping weapon mods will break this immersion.")
                For0:ControlHelp("")
                For0:ControlHelp("*If you plan to arrange your weapon, please click on 'category' to arrange them by their shop category")
                For0:ControlHelp("")
				For0:ControlHelp("*'W' Ars Type refers to the Arsenal Type meaning its a weapon. 'C' Arsenal Type means its a consumable or throwable")
                For0:ControlHelp("")
                For0:ControlHelp("*Max Ammo Cap refers to the store capping ammo at this amount.")
                For0:ControlHelp("")
				For0:ControlHelp("*Category refers to the Tab the weapon belongs in when browsing the shop")
				

				local For1 = vgui.Create("DForm")
				For1:Dock(TOP)
				For1:SetSize(1,100)
				For1:SetName("Shop General Options")

                local ResetHPAPDefault = vgui.Create( "DButton", Forrm ) // Create the button and parent it to the frame
                    ResetHPAPDefault:Dock( TOP )
                    ResetHPAPDefault:SetText( "Set Shop General Options to default" )                   // Set the text on the button
                    ResetHPAPDefault:SetSize( 250, 40 )
                    ResetHPAPDefault.DoClick = function()
                        net.Start("wblResettodefaultpriceAPHP")
                        net.SendToServer()
                    end

                For1:AddItem(ResetHPAPDefault)
                local CheckBoxBA = For1:CheckBox( "Enable Buy Anywhere", "wblmoney_buyanywhere")
                For1:ControlHelp("Enabling this will allow players to open the shop anywhere by chatting '!wblbuy' or inputting 'wblbuy' in console" )
                local CheckBoxBASO = For1:CheckBox( "Enable Buy Anywhere on spawn only", "wblmoney_buyanywhere_OnSpawn")
                For1:ControlHelp("Players are only able to access the 'anywhere shop' after spawning and at a limited time" )
                local sliderBAD = For1:NumSlider( "Time Until Shop Closes (Seconds)", "wblmoney_buyanywhere_OnSpawntimelimit", 0, 100 )
                    sliderBAD:SetDecimals(0)
                CheckBoxBA.OnChange = function(checkbox, checked)
                    if checked then
                        CheckBoxBASO:SetEnabled(true)
                    else
                        CheckBoxBASO:SetEnabled(false)
                        CheckBoxBASO:SetValue(0)
                    end
                end
                CheckBoxBASO.OnChange = function(checkbox, checked)
                    if checked then
                        sliderBAD:SetEnabled(true)
                    else
                        sliderBAD:SetEnabled(false)
                    end
                end
                
                For1:CheckBox( "Can sell only weapons listed in store", "wblmoney_money_sellonlylisted")
                For1:CheckBox( "Ignore slotID when buying", "wblmoney_money_ignoreslotidinshop")
                For1:ControlHelp("If enabled, you can buy the weapon even if you have another weapon with the same SlotID" )
                For1:NumSlider( "10HP Shop Price ", "wblmoney_money_smallhealthprice", 0, 1000 )
                For1:NumSlider( "25HP Shop Price ", "wblmoney_money_largehealthprice", 0, 1000 )
                For1:NumSlider( "10AP Shop Price ", "wblmoney_money_smallarmorprice", 0, 1000 )
                For1:NumSlider( "25AP Shop Price ", "wblmoney_money_largearmorprice", 0, 1000 )

                local FormMargin2 = vgui.Create("DLabel")        
                FormMargin2:Dock(TOP)
                FormMargin2:DockMargin( 0, 60, 0, 0)
                FormMargin2:SetText("")
                For1:AddItem(FormMargin2)
                



			panel:AddItem(For0)
			panel:AddItem(For1)

		end)


--[[
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\SERVER PART 2\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
]]


		spawnmenu.AddToolMenuOption( "Options", "WeShopAdm", "Monz", "#Money Option", "", "", function( panel )
				if !LocalPlayer():IsSuperAdmin() and !LocalPlayer():IsAdmin() then
				        panel:Help("Admin only access..")
				        return
				end

				local Forrm0 = vgui.Create("DForm")
				Forrm0:Dock(TOP)
				Forrm0:SetSize(1,100)
				Forrm0:SetName("Preset Options")

				local PresetLabel = vgui.Create("DLabel")        
				PresetLabel:Dock(TOP)
				PresetLabel:SetText("Preset Settings: ")
				PresetLabel:SetTextColor(Color(0, 0, 0))

    			local PresetCombo = vgui.Create("DComboBox")
    			PresetCombo:Dock(TOP)
    			PresetCombo:AddChoice("Default")
    			PresetCombo:SetValue("Default")
    			PresetCombo:DockMargin( 0, 0, 0, 5 )


				local SavePresetset = vgui.Create( "DButton") // Create the button and parent it to the frame
				SavePresetset:Dock( TOP )
				SavePresetset:SetText( "Save/Overwrite Settings to a Preset" )					// Set the text on the button
				SavePresetset:SetSize( 250, 20 )
				SavePresetset.DoClick = function()

					local SetPresetframe = vgui.Create("DFrame")
					SetPresetframe:SetSize(250, 100)            
					SetPresetframe:SetTitle("New Preset") 
					SetPresetframe:Center()                      
					SetPresetframe:MakePopup()                   

					local SetPresetLabel = vgui.Create("DLabel", SetPresetframe)        
					SetPresetLabel:Dock(TOP)
					SetPresetLabel:SetText("Preset Name: ")    
					
					local SetPresetTextEntry = vgui.Create("DTextEntry", SetPresetframe)       
					SetPresetTextEntry:Dock(TOP)
					SetPresetTextEntry:SetSize(200, 30)  -- Width and height of the text field
					SetPresetTextEntry:SetText("")
					SetPresetTextEntry:RequestFocus()
					local SetPresetname
					SetPresetTextEntry.OnEnter = function(self)
						SetPresetname = self:GetValue()  -- Get the input text and store it in a variable
					    if SetPresetname == "Default" or SetPresetname == "default" then
					    	notification.AddLegacy("Preset cannot be saved as Default", NOTIFY_ERROR, 3)
							surface.PlaySound("buttons/button10.wav")
					    	SetPresetframe:Close()
					    	return
					    end
					    if SetPresetname == "" then
					    	SetPresetframe:Close()
					    	return
					    end
					    SetPresetframe:Close()
                        net.Start("wblSaveConVarsToFileMonsettings")
                        net.WriteString(SetPresetname)
                        net.WriteInt(1,16)
                        net.SendToServer()

						PresetCombo:SetValue(SetPresetname)
					end
				end

                net.Start("wblRefreshMonsettingsToS")
                net.SendToServer()

                net.Receive("wblRefreshMonsettingsToC",function(Len)
                    PresetCombo:Clear()
                    PresetCombo:AddChoice("Default")
                    local convarpresetlist = net.ReadTable()
                    local inttype = net.ReadInt(16)
                    local name = net.ReadString()
                    for k,v in ipairs(convarpresetlist) do
                        PresetCombo:AddChoice(v)
                    end
                    if inttype == 1 then
                        PresetCombo:SetValue(name)
                    else
                        PresetCombo:SetValue("Default")
                    end
                end)

				local DeletePresetset = vgui.Create( "DButton") // Create the button and parent it to the frame
				DeletePresetset:Dock( TOP )
				DeletePresetset:SetText( "Delete Setting Preset" )					// Set the text on the button
				DeletePresetset:SetSize( 250, 20 )
					DeletePresetset.DoClick = function()
						if PresetCombo:GetValue() == "Default" then
							notification.AddLegacy("Can't Delete Default Preset!", NOTIFY_ERROR, 6)
							surface.PlaySound("buttons/button10.wav")
							return
						end

                        local delConfirmframe = vgui.Create("DFrame")
                        delConfirmframe:SetSize(250, 150)            
                        delConfirmframe:SetTitle("ARE YOU SURE??")
                        delConfirmframe:Center()                      
                        delConfirmframe:MakePopup()  

                        local delConfirmLabel = vgui.Create("DLabel", delConfirmframe)        
                        delConfirmLabel:Dock(TOP)
                        delConfirmLabel:SetText("Are you sure you want to Delete this preset?")    

                        local delConfirmButton = vgui.Create("DButton", delConfirmframe)
                        delConfirmButton:SetText("Delete!")            
                        delConfirmButton:DockMargin( 0, 0, 0, 5 )
                        delConfirmButton:Dock(FILL)         
                        delConfirmButton.DoClick = function()
                            net.Start("wblDeleteMonsettings")
                            net.WriteString(PresetCombo:GetValue())
                            net.SendToServer()                 
                            delConfirmframe:Close()
                        end

					end

				PresetCombo.OnSelect = function(_, _, value)	
					if value == "Default" then
						net.Start("wblResetAllConVarsToDefault")
                        net.SendToServer()
					else
                        net.Start("wblLoadConVarsFromFileMonsettings")
                        net.WriteString(value)
                        net.SendToServer()
					end
                end	


				Forrm0:AddItem(PresetLabel)
				Forrm0:AddItem(PresetCombo)
				Forrm0:ControlHelp("Presets for the settings below, except for the npc list, Enable Money option and Money persist option")
				Forrm0:AddItem(SavePresetset)
				Forrm0:AddItem(DeletePresetset)


				

				local Forrm1 = vgui.Create("DForm", panel)
				Forrm1:Dock(TOP)
				Forrm1:SetSize(1,100)
				Forrm1:SetName("Money General Options")
				Forrm1:CheckBox( "Enable Money System", "wblmoney_enable")
				Forrm1:ControlHelp("Enable Money system which includes money (ω) gain/loss and money hud. All shops will be free if this is disabled")
				Forrm1:ControlHelp("This setting is unaffected by Presets")
				Forrm1:CheckBox( "Persist Money on Map Change/Restart", "wblmoney_money_persist")
				Forrm1:ControlHelp("This setting is unaffected by Presets")
				local sliderSM = Forrm1:NumSlider( "Starting Money", "wblmoney_money_start", 0, 10000 )
					sliderSM:SetDecimals(0)
				local sliderMM = Forrm1:NumSlider( "Max Money", "wblmoney_money_max", 0, 20000 )
					sliderMM:SetDecimals(0)

				local Forrm = vgui.Create("DForm", panel)
				Forrm:Dock(TOP)
				Forrm:SetName("Money Gain")
				local Dynmoncheckbox = Forrm:CheckBox( "Enable Dynamic Money", "wblmoney_dynamicmoney_enable")
				

				Forrm:ControlHelp("Dynamic Money gives money (ω) based on the Health Points (HP) of the killed NPC")
				local sliderDMM = Forrm:NumSlider( "Dyn Money Multiplier", "wblmoney_dynamicmoney_multplier", 0, 10 )
				Forrm:ControlHelp("Multiplies this value to the dynamic money")
				local sliderDMO = Forrm:NumSlider( "Dyn Money Offset", "wblmoney_dynamicmoney_offset", 0, 5000 )
					sliderDMO:SetDecimals(0)
				Dynmoncheckbox.OnChange = function(checkbox, checked)
				    if checked then
				        sliderDMM:SetEnabled(true)
				        sliderDMO:SetEnabled(true)

				    else
				        sliderDMM:SetEnabled(false)
				        sliderDMO:SetEnabled(false)
				    end
				end
				Forrm:ControlHelp("Adds this value on top of the dynamic money. Will apply after Dyn Money Multiplier")
				Forrm:SetSize(1,400)


				---------------------------------/FIXED MONEY LIST\-------------------------------------

					local NPCList = vgui.Create( "DListView", Forrm ) --List of Fixed Money on npc
					NPCList:Dock( FILL )
					NPCList:SetSize(100,((200/1080)*ScrH()))
					NPCList:SetMultiSelect( false )
					NPCList:AddColumn( "NPC" )
					NPCList:AddColumn( "Category" )
					NPCList:AddColumn( "Money Value" )


					function NPCList:DoDoubleClick( lineID, line )
							local Editframe = vgui.Create("DFrame")
							wblDebug("Line ID: "..tostring(lineID))
							wblDebug("Line: "..tostring(line))
							Editframe:SetSize(250, 100)            
							Editframe:SetTitle(line:GetColumnText(1)) 
							Editframe:Center()                      
							Editframe:MakePopup()                   

							local EditLabel = vgui.Create("DLabel", Editframe)        
							EditLabel:Dock(TOP)
							EditLabel:SetText("New Value: ")    
							
							local EditnumberWang = vgui.Create("DNumberWang", Editframe)       
							EditnumberWang:Dock(TOP)
							EditnumberWang:DockMargin( 0, 0, 0, 5 )
							EditnumberWang:SetSize(250, 30)
							EditnumberWang:SetMin(-99999) 
							EditnumberWang:SetMax(math.huge)
							EditnumberWang:SetValue(npclisttodelivermoney[lineID])      
							EditnumberWang:RequestFocus()

							--Make the money text Field empty for easy typing of number
							EditnumberWang.OnGetFocus = function(self)
							    self:SetText("")  
							end
							EditnumberWang.OnLoseFocus = function(self)
							    local value = tonumber(self:GetText())
							    if value then
							        self:SetValue(value)
							    else
							        self:SetValue(0) 
							    end
							end


							EditnumberWang.OnKeyCodePressed = function(self, keyCode)
							    -- Check if the key pressed is the "Enter" key (key code 66)
							    if keyCode == KEY_ENTER then
							        local enteredNumber = self:GetValue()  -- Get the value from DNumberWang

									npclisttodelivermoney[lineID] = enteredNumber
								    RefreshNPClist()
								    net.Start("plyNPCtableedit")
									net.WriteInt(lineID, 32)
									net.WriteInt(enteredNumber, 32)
									net.SendToServer()
								    Editframe:Close()                                
							    end
							end
					end


					NPCList.OnRowRightClick = function(_, lineID, line)
					    local menuu = DermaMenu()

					    
					    -- Add "Edit" option to the context menu
					    menuu:AddOption("Edit Value", function()
							local Editframe = vgui.Create("DFrame")
							Editframe:SetSize(250, 100)            
							Editframe:SetTitle(line:GetColumnText(1)) 
							Editframe:Center()                      
							Editframe:MakePopup()                   

							local EditLabel = vgui.Create("DLabel", Editframe)        
							EditLabel:Dock(TOP)
							EditLabel:SetText("New Value: ")    
							
							local EditnumberWang = vgui.Create("DNumberWang", Editframe)       
							EditnumberWang:Dock(TOP)
							EditnumberWang:DockMargin( 0, 0, 0, 5 )
							EditnumberWang:SetSize(250, 30)
							EditnumberWang:SetMin(-99999) 
							EditnumberWang:SetMax(math.huge)
							EditnumberWang:SetValue(npclisttodelivermoney[lineID])             
							EditnumberWang:RequestFocus()

							--Make the money text Field empty for easy typing of number
							EditnumberWang.OnGetFocus = function(self)
							    self:SetText("")  
							end
							EditnumberWang.OnLoseFocus = function(self)
							    local value = tonumber(self:GetText())
							    if value then
							        self:SetValue(value)
							    else
							        self:SetValue(0) 
							    end
							end


							EditnumberWang.OnKeyCodePressed = function(self, keyCode)
							    -- Check if the key pressed is the "Enter" key (key code 66)
							    if keyCode == KEY_ENTER then
							        local enteredNumber = self:GetValue()  -- Get the value from DNumberWang
									npclisttodelivermoney[lineID] = enteredNumber
								    RefreshNPClist()
								    net.Start("plyNPCtableedit")
									net.WriteInt(lineID, 32)
									net.WriteInt(enteredNumber, 32)
									net.SendToServer()
								    Editframe:Close()                                
							    end
							end

					    end)


					    -- Add "Remove" option to the context menu
					    menuu:AddOption("Remove", function()

					    	--remove the line and remove to update the Index of all tables affected
					        NPCList:RemoveLine(lineID)  
					        table.remove(npcdataonlist, lineID)
					        table.remove(npclisttodeliver, lineID)
					        table.remove(npclisttodelivermoney, lineID)
					        RefreshNPClist()

					        --send the line number to remove to server
							net.Start("plyNPCtableremove")
							net.WriteInt(lineID, 32)
							net.SendToServer()

							--for debugging
							wblDebug("Table updated, New table: ")
							for k,v in pairs(npclisttodeliver) do
								wblDebug("///////////////////////////")
								wblDebug(v[1])
								wblDebug(v[2]) 
								wblDebug(v[3])
								wblDebug("///////////////////////////")
							end
					    end)


					    
					    menuu:Open()
					end

				Forrm:Help("Fixed Money Value List: ") --Adds Label on top of the List
				Forrm:ControlHelp("Sets the money value of the NPC in the list. The values here will be prioritized over dynamic money value. Offset and Multiplier won't affect this. Negative values causes money loss.")
				
					local NPCPresetLabel = vgui.Create("DLabel")        
					NPCPresetLabel:Dock(TOP)
					NPCPresetLabel:SetText("NPC List Preset: ")
					NPCPresetLabel:SetTextColor(Color(0, 0, 0))

					local NPCPresetCombo = vgui.Create("DComboBox")
					NPCPresetCombo:Dock(TOP)
					NPCPresetCombo:AddChoice("Default")
					NPCPresetCombo:SetValue("Default")
					NPCPresetCombo:DockMargin( 0, 0, 0, 5 )

					local files, directories = file.Find("weshop/npclistpreset/*.txt", "DATA")
						wblDebug("Preset Reload function executed..")
					for _, fileName in ipairs(files) do
						local nameWithoutExtension = fileName:gsub("%.txt$", "")
						NPCPresetCombo:AddChoice(nameWithoutExtension)
					end

                    --CHANGE TO RECEIVE
                    --CHANGE TO RECEIVE
                    --CHANGE TO RECEIVE
                    --CHANGE TO RECEIVE
                    --wblReloadNPCListPresetToS
                    --wblReloadNPCListPresetToC
                    net.Receive("wblReloadNPCListPresetToC",function(Len)
                        local npclistoftheprest = net.ReadTable()
                        local presetnamee = net.ReadString()
                        NPCPresetCombo:Clear()
                        NPCPresetCombo:AddChoice("Default")
                        for k,v in ipairs(npclistoftheprest) do
                            NPCPresetCombo:AddChoice(v)
                        end
                        if tostring(presetnamee) == "" then
                            NPCPresetCombo:SetValue("Default")
                        else
                            NPCPresetCombo:SetValue(presetnamee)
                        end
                    end)
                    --[[
					function ReloadNPClistPreset()
						local files, directories = file.Find("weshop/npclistpreset/*.txt", "DATA")
							wblDebug("Preset Reload function executed..")
						for _, fileName in ipairs(files) do
							local nameWithoutExtension = fileName:gsub("%.txt$", "")
							NPCPresetCombo:AddChoice(nameWithoutExtension)
						end
					end
                    ]]

						local NPCAddPreset = vgui.Create( "DButton") // Create the button and parent it to the frame
						NPCAddPreset:Dock( TOP )
						NPCAddPreset:SetText( "Save/Overwrite List to a Preset" )					// Set the text on the button
						NPCAddPreset:SetSize( 250, 20 )
							NPCAddPreset.DoClick = function()
									local NPCPresetframe = vgui.Create("DFrame")
									NPCPresetframe:SetSize(250, 100)            
									NPCPresetframe:SetTitle("New Preset") 
									NPCPresetframe:Center()                      
									NPCPresetframe:MakePopup()                   

									local NPCPresetLabel = vgui.Create("DLabel", NPCPresetframe)        
									NPCPresetLabel:Dock(TOP)
									NPCPresetLabel:SetText("Preset Name: ")    
									
									local NPCPresetTextEntry = vgui.Create("DTextEntry", NPCPresetframe)       
									NPCPresetTextEntry:Dock(TOP)
									NPCPresetTextEntry:SetSize(200, 30)  -- Width and height of the text field
									NPCPresetTextEntry:SetText("")
									NPCPresetTextEntry:RequestFocus()
									local NPCPresetname
									NPCPresetTextEntry.OnEnter = function(self)
									    NPCPresetname = self:GetValue()  -- Get the input text and store it in a variable
									    if NPCPresetname == "Default" or NPCPresetname == "default" then
									    	notification.AddLegacy("Preset cannot be saved as Default", NOTIFY_ERROR, 3)
											surface.PlaySound("buttons/button10.wav")
									    	NPCPresetframe:Close()
									    	return
									    end
									    if NPCPresetname == "" then
									    	NPCPresetframe:Close()
									    	return
									    end
									    NPCPresetframe:Close()  -- Close the frame when "Enter" is pressed
									    wblDebug("New Preset name is ".. tostring(NPCPresetname))
                                        net.Start("wblPresetSaveNPClistToS")
                                        net.WriteTable(presettabletosave)
                                        net.WriteTable(presettabletosave3)
                                        net.WriteString(NPCPresetname)
                                        net.SendToServer()
                                        net.Start("wblReloadNPCListPresetToS")
                                        net.WriteString(NPCPresetname)
                                        net.SendToServer()
									end
							end



						local NPCDeletePreset = vgui.Create( "DButton") // Create the button and parent it to the frame
						NPCDeletePreset:Dock( TOP )
						NPCDeletePreset:SetText( "Delete NPC list Preset" )					// Set the text on the button
						NPCDeletePreset:SetSize( 250, 20 )
							NPCDeletePreset.DoClick = function()
                                if NPCPresetCombo:GetValue() == "Default" then
									notification.AddLegacy("Can't Delete Default Preset!", NOTIFY_ERROR, 6)
									surface.PlaySound("buttons/button10.wav")
									return
								end

                                local delConfirmframe = vgui.Create("DFrame")
                                delConfirmframe:SetSize(250, 150)            
                                delConfirmframe:SetTitle("ARE YOU SURE??")
                                delConfirmframe:Center()                      
                                delConfirmframe:MakePopup()  

                                local delConfirmLabel = vgui.Create("DLabel", delConfirmframe)        
                                delConfirmLabel:Dock(TOP)
                                delConfirmLabel:SetText("Are you sure you want to Delete this preset?")    

                                local delConfirmButton = vgui.Create("DButton", delConfirmframe)
                                delConfirmButton:SetText("Delete!")            
                                delConfirmButton:DockMargin( 0, 0, 0, 5 )
                                delConfirmButton:Dock(FILL)         
                                delConfirmButton.DoClick = function()
                                    net.Start("wblPresetDeleteNPClistToS")
                                    net.WriteString(NPCPresetCombo:GetValue())
                                    net.SendToServer()
                                    net.Start("wblReloadNPCListPresetToS")
                                    net.WriteString("")
                                    net.SendToServer()              
                                    delConfirmframe:Close()
                                end
							end
				Forrm:AddItem(NPCPresetLabel)
				Forrm:AddItem(NPCPresetCombo)
				Forrm:AddItem(NPCAddPreset)
				Forrm:AddItem(NPCSavePreset)
				Forrm:AddItem(NPCDeletePreset)
				Forrm:AddItem(NPCList) --Adds the List

					---------------------------------\FIXED MONEY LIST/-------------------------------------

					---------------------------------/ADD NPC\-------------------------------------


					local AddNPC = vgui.Create( "DButton", Forrm ) // Create the button and parent it to the frame
					AddNPC:Dock( FILL )
					AddNPC:SetText( "Add NPC" )					// Set the text on the button
					AddNPC:SetSize( 250, 20 )					// Set the size
					local RemCatvalue 
							
					function RefreshNPClist()
						NPCList:Clear()

									for k, v in pairs(npcdataonlist) do
										wblDebug("/////////////FULL NPC DATA/////////////")
										for a, b in pairs(v) do 	
											wblDebug(a,b)
										end
										wblDebug("////////////FULL NPC DATA///////////")

										if not npclisttodeliver[k] then
										    npclisttodeliver[k] = {}  -- Initialize it as an empty table
										end

										npclisttodeliver[k][1] = v["Class"] --table to be delivered to server
										npclisttodeliver[k][2] = (v["Model"] or v["Material"])
										npclisttodeliver[k][3] = npclisttodelivermoney[k]



										wblDebug("///////////////////////////")
										wblDebug(npclisttodeliver[k][1])
										wblDebug(npclisttodeliver[k][2])
										wblDebug(npclisttodeliver[k][3])
										wblDebug("///////////////////////////")
										NPCList:AddLine( v.Name, v.Category, npclisttodelivermoney[k] )

									end
							presettabletosave = npcdataonlist
							presettabletosave3 = npclisttodelivermoney
					end	

					
                    net.Start("wblUpdatePresetOnlistToS1")
                    net.WriteString("")
                    net.SendToServer()
                    net.Receive("wblUpdatePresetOnlistToC",function(Len)
                        npclisttodeliver = {}
                        npcdataonlist = net.ReadTable()
                        npclisttodelivermoney = net.ReadTable()
                        RefreshNPClist()
                        net.Start("plyNPCtable")
                        net.WriteTable(npclisttodeliver)
                        net.SendToServer()
                    end)


					NPCPresetCombo.OnSelect = function(_, _, value)
						--UpdatePresetOnlist(value)
                        net.Start("wblUpdatePresetOnlistToS1")
                        net.WriteString(value)
                        net.SendToServer()
						net.Start("npclistpresetgive")
						net.WriteString(value)
						net.SendToServer()
					end		


					AddNPC.DoClick = function()				// A custom function run when clicked ( note the . instead of : )


						local AddNPClist = vgui.Create("DFrame")
						AddNPClist:SetSize(275, 410)	
						AddNPClist:Center()
						AddNPClist:SetTitle("NPC Value Editor")
						AddNPClist:SetVisible(true)
						AddNPClist:MakePopup()
						AddNPC:SetEnabled(false)

						function AddNPClist:OnClose()
						    AddNPC:SetEnabled(true)
						end


							local AddNPCcombo = vgui.Create("DComboBox", AddNPClist) --Make The Combo box with NPC category
							AddNPCcombo:Dock( TOP )
							AddNPCcombo:DockMargin( 0, 0, 0, 5 )
							AddNPCcombo:SetSize(200, 20)
							AddNPCcombo:SetValue("Select NPC Category")
							if RemCatvalue ~= nil then
								AddNPCcombo:SetValue(RemCatvalue)
							end
							local npcList = list.Get("NPC")
							local addedCategories = {}

							for _, npcData in pairs(npcList) do
							    local category = npcData.Category or "Uncategorized"
							    if not addedCategories[category] then
							        AddNPCcombo:AddChoice(category)
							        addedCategories[category] = true
							    end
							end

							local AddNPCAftcat = vgui.Create("DListView", AddNPClist) --Make The List of NPC in ADD NPC (Not category)
							AddNPCAftcat:Dock( TOP )
							AddNPCAftcat:DockMargin( 0, 0, 0, 5 )
							AddNPCAftcat:SetSize(200,300)
							AddNPCAftcat:AddColumn( "NPC List" )

							--remembering the list of npcs
							if RemCatvalue ~= nil then
								for _, npcData in pairs(npcList) do
							        if npcData.Category == RemCatvalue then
							            AddNPCAftcat:AddLine(npcData.Name)
							            table.insert(npcitems, npcData)
							        end
							    end
							end
						

							AddNPCcombo.OnSelect = function(_, _, value) --functionality of Combo box when selected 
							    wblDebug(value .. " category was selected!")
							    RemCatvalue = value
							  	npcitems = {}
								AddNPCAftcat:ClearSelection()
								AddNPCAftcat:Clear() -- Clear the list before adding new NPCs

							    for _, npcData in pairs(npcList) do
							        if npcData.Category == value then
							            AddNPCAftcat:AddLine(npcData.Name)
							            table.insert(npcitems, npcData)
							        end
							    end
							end



							local AddMonLabel = vgui.Create("DLabel", AddNPClist)        
							AddMonLabel:Dock(TOP)
							AddMonLabel:SetText("Money Value: ")    

							--Make The List of NPC in the DListView AddNPC (Not category)
							local AddNPCMon = vgui.Create("DNumberWang", AddNPClist) 
							AddNPCMon:Dock( TOP )
							AddNPCMon:SetSize(200,20)
							AddNPCMon:DockMargin( 0, 0, 0, 5 )
							AddNPCMon:SetPlaceholderText( "NPC Money Value" )	
							AddNPCMon:SetMin(-99999) 
							AddNPCMon:SetMax(math.huge)


							--function on adding NPC to the list
							local function AddNPCtotheList()
								do
										local Selectedline = AddNPCAftcat:GetSelectedLine()
										if Selectedline == nil then
											return
										end
										wblDebug("Selected Line Number: "..tostring(Selectedline))
										local NPCSelectedLine = AddNPCAftcat:GetLines()[Selectedline]
										local NPCSelected = NPCSelectedLine:GetValue(1)
										wblDebug("Selected NPC: "..tostring(NPCSelected))
										
										--function to check if npc is on the list already, will ignore if present already
										local npctobeadded = npcitems[Selectedline]
										wblDebug("NPC to be added, Checking if it is in the list..: "..tostring(npctobeadded.Class))
										for k, v in pairs(npcdataonlist) do
											if (v.Class == npctobeadded.Class) and (v.Material == npctobeadded.Material) and (v.Model == npctobeadded.Model)  then
												wblDebug("NPC is already on the list. Ignoring....")
												AddNPClist:Close()
												AddNPC:SetEnabled(true)
												notification.AddLegacy("NPC is on the list already", NOTIFY_ERROR, 3)
												surface.PlaySound("buttons/button10.wav")
												return
											end
										end

										local MV = AddNPCMon:GetValue()
										if MV == "" then
												MV = 0
										end 	
										wblDebug("NPC Money Value: "..tostring(MV))
										table.insert(npclisttodelivermoney, MV)
										

										wblDebug("The List of added NPCs: ")
										table.insert(npcdataonlist, npcitems[Selectedline])

										RefreshNPClist()	

										net.Start("plyNPCtable")
										net.WriteTable(npclisttodeliver)
										net.SendToServer()

										AddNPClist:Close()
										AddNPC:SetEnabled(true)
								end
							end

							--Will add on double click in the list
							function AddNPCAftcat:DoDoubleClick( lineID, line )
								AddNPCtotheList()
							end
							

							AddNPCMon.OnEnter = function( self ) 
								chat.AddText( self:GetValue() )
								AddNPCtotheList()
							end

							--Make the money text Field empty for easy typing of numer
							AddNPCMon.OnGetFocus = function(self)
							    self:SetText("")  
							end
							AddNPCMon.OnLoseFocus = function(self)
							    local value = tonumber(self:GetText())
							    if value then
							        self:SetValue(value)
							    else
							        self:SetValue(0) 
							    end
							end






					end --END of ADD NPC button function
				Forrm:AddItem(AddNPC)
				local sliderMGF = Forrm:NumSlider( "Money Gain Fallback", "wblmoney_dynamicmoney_fallback", 0, 10000 )
					sliderMGF:SetDecimals(0)
				Forrm:ControlHelp("Money Gain Fallback is the money (ω) gained if the NPC is not on the list above and dynamic money detects unusual health in an npc. This is also the default money value when Dynamic Money is off")


				local plycheckbox = Forrm:CheckBox( "Enable Player Co-op", "wblmoney_money_coop")
				Forrm:ControlHelp("Enabling will share the money gain among all players in the server")
				local sliderPlymonz = Forrm:NumSlider( "Player Money Value", "wblmoney_money_plyvalue", 0, 5000 )
					sliderPlymonz:SetDecimals(0)
				plycheckbox.OnChange = function(checkbox, checked)
				    if checked then
				        sliderPlymonz:SetEnabled(false)
				        -- Perform your function here for checked state
				    else
				        sliderPlymonz:SetEnabled(true)
				        -- Perform your function here for unchecked state
				    end
				end

				local sliderentmonz = Forrm:NumSlider( "Money Entity Value", "wblmoney_money_entvalue", 0, 5000 )
					sliderentmonz:SetDecimals(0)
				

					---------------------------------\ADD NPC/-------------------------------------

				
				


				local Forrm2 = vgui.Create("DForm", panel)
				Forrm2:Dock(TOP)
				Forrm2:SetSize(1,200)
				Forrm2:SetName("Money Loss")
					local MoneylossLabel = vgui.Create("DLabel", Confirmframe)        
					MoneylossLabel:Dock(TOP)
					MoneylossLabel:SetText("Money loss Method:")
					MoneylossLabel:SetTextColor(Color(0, 0, 0))

					local MoneylossCombo = vgui.Create("DComboBox")
					MoneylossCombo:Dock(TOP)
					MoneylossCombo:AddChoice("Fixed")
					MoneylossCombo:AddChoice("Percent of Current Money")
					MoneylossCombo:SetValue("Percent of Current Money")
					MoneylossCombo:DockMargin( 0, 0, 0, 5 )

					local MoneylossFixedSlider = vgui.Create("DNumSlider")
					MoneylossFixedSlider:Dock(TOP)
					MoneylossFixedSlider:SetText("Fixed") 
					MoneylossFixedSlider:SetMin(0)
					MoneylossFixedSlider:SetMax(10000)
					MoneylossFixedSlider:SetValue(100)
					MoneylossFixedSlider:SetEnabled(false)
					MoneylossFixedSlider:SetDecimals(0)
					MoneylossFixedSlider.Label:SetTextColor(Color(0, 0, 0))
					MoneylossFixedSlider:DockMargin( 0, 0, 0, 5 )
					MoneylossFixedSlider.OnValueChanged = function(self, value)
					    RunConsoleCommand("wblmoney_moneyloss_fixed_amount", value)
					end

					local MoneylossPercentSlider = vgui.Create("DNumSlider", frame)
					MoneylossPercentSlider:Dock(TOP)
					MoneylossPercentSlider:SetText("%Loss")  
					MoneylossPercentSlider:SetMin(0)
					MoneylossPercentSlider:SetMax(100)
					MoneylossPercentSlider:SetValue(10)
					MoneylossPercentSlider:SetEnabled(true)
					MoneylossPercentSlider:SetDecimals(0)
					MoneylossPercentSlider.Label:SetTextColor(Color(0, 0, 0))
					MoneylossPercentSlider:DockMargin( 0, 0, 0, 150)
					MoneylossPercentSlider.OnValueChanged = function(self, value)
					    RunConsoleCommand("wblmoney_moneyloss_percent_amount", value)
					end

					

					MoneylossCombo.OnSelect = function(_, _, value)
						if value == "Fixed" then
							MoneylossFixedSlider:SetEnabled(true)
							MoneylossPercentSlider:SetEnabled(false)
							RunConsoleCommand("wblmoney_moneyloss_method", 1)
						elseif value == "Percent of Current Money" then
							MoneylossFixedSlider:SetEnabled(false)
							MoneylossPercentSlider:SetEnabled(true)
							RunConsoleCommand("wblmoney_moneyloss_method", 2)
						end

					end
				Forrm2:CheckBox( "Enable Money loss on death", "wblmoney_moneyloss_enabled")
				Forrm2:AddItem(MoneylossLabel)
				Forrm2:AddItem(MoneylossCombo)	
				Forrm2:AddItem(MoneylossFixedSlider)		
				Forrm2:AddItem(MoneylossPercentSlider)	
				

				local Forrmlast = vgui.Create("DForm")
				Forrmlast:Dock(TOP)
				Forrmlast:SetSize(1,200)
				Forrmlast:SetName("Others")
				Forrmlast:CheckBox( "No Money Gain on Allied NPCs", "wblmoney_Nomoneyonally")
				Forrmlast:CheckBox( "Singleplayer Campaign Mode", "wblmoney_campaignmode_singleplayer")
                Forrmlast:ControlHelp("[NEEDS  RESTART TO ENABLE] If this is enabled, money would revert to the time the map started (Saves Money on Map start and loads on player death)")
                Forrmlast:CheckBox( "Disable All Vanilla Weapon Pickup", "wblmoney_campaignmode_Disablepickup")
                Forrmlast:ControlHelp("Uncheck this if you want Vmanip Manual Pickup to work!")
                Forrmlast:CheckBox( "Disable pickup for same slot ID weapons", "wblmoney_campaignmode_Disablepickupsameslotid")
                Forrmlast:ControlHelp("Uncheck this if you want Vmanip Manual Pickup to work!")
                Forrmlast:CheckBox( "Replace All Vanilla Ammo with Money", "wblmoney_campaignmode_replaceammoentities")
                Forrmlast:CheckBox( "Enable Campaign anti-Softlock", "wblmoney_campaignmode_preventsoftlock")
                Forrmlast:ControlHelp("Specifically HL2 Campaign, Excludes Gravity Gun, RPG, grenades and Bug bait in 'Disable All Vanilla Weapon Pickup' and makes them unsellable")
                Forrmlast:CheckBox( "Replace All Vanilla Wall Chargers and Ammo Crates with Shop", "wblmoney_campaignmode_replacewallchargers")
                Forrmlast:CheckBox( "Run 'wstar' Command after respawning", "wblmoney_campaignmode_delayedwstar")
                Forrmlast:ControlHelp("*A very specific option made specifically if using Lambda - Half-Life 2 Co-Op and Weapon: Setup, Transfer And Restore mod.")
                Forrmlast:ControlHelp("*Enabling this will make you do 'wstar' command everytime players respawn, Keeping their inventory (assuming you configured wstar correctly)")
                Forrmlast:ControlHelp("*Lamda overrides wstar's respawn with loadout, but wstar works after a simple delay so i made this.")

					local FormMargin = vgui.Create("DLabel")        
					FormMargin:Dock(TOP)
					FormMargin:DockMargin( 0, 60, 0, 0)
					FormMargin:SetText("")
				Forrmlast:AddItem(FormMargin)
				

			panel:AddItem(Forrm0)
			panel:AddItem(Forrm1)
			panel:AddItem(Forrm)
			panel:AddItem(Forrm2)
			panel:AddItem(Forrmlast)
			--panel:AddItem(DPanel2)



		end)

--[[
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\CLIENT\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
]]


	spawnmenu.AddToolMenuOption( "Options", "WeShopCli", "Hudz", "#Money Hud", "", "", function( panel )
		local Forrm = vgui.Create("DForm", panel)
		Forrm:Dock(TOP)
		Forrm:SetName("Money Option")
		Forrm:SetSize(1,((400/1080)*ScrH()))

			local ResetMoney = vgui.Create( "DButton", Forrm ) 
					ResetMoney:Dock( TOP )
					ResetMoney:SetText( "Reset My Money" )					
					ResetMoney:SetSize( 250, 30 )					
					ResetMoney.DoClick = function()				

						local Confirmframe = vgui.Create("DFrame")
							Confirmframe:SetSize(250, 150)            
							Confirmframe:SetTitle("ARE YOU SURE??")
							Confirmframe:Center()                      
							Confirmframe:MakePopup()  

						local ConfirmLabel = vgui.Create("DLabel", Confirmframe)        
							ConfirmLabel:Dock(TOP)
							ConfirmLabel:SetText("Are you sure you want to Reset your Money?")    

						local ConfirmButton = vgui.Create("DButton", Confirmframe)
							ConfirmButton:SetText("Reset!")            
							ConfirmButton:DockMargin( 0, 0, 0, 5 )
							ConfirmButton:Dock(FILL)         
							
							ConfirmButton.DoClick = function()
							    net.Start("plyMonzResetToS") 
								net.SendToServer() 
							    Confirmframe:Close()                                
							end
					end

			
            

			local hudxslider = vgui.Create("DNumSlider", Forrm)
			    hudxslider:Dock( FILL )
			    hudxslider:SetSize(200, 30) -- Set size of the slider
			    hudxslider:SetText("Horizontal Position")  -- Slider label
			    hudxslider:SetMin(0)          -- Minimum value
			    hudxslider:SetMax(20)        -- Maximum value
			    hudxslider:SetValue((cookie.GetNumber("MoneyTextposx", 0.5))*20) -- Set initial value
			    hudxslider.Label:SetTextColor(Color(0, 0, 0))
                local hudxen = cookie.GetNumber("wblcheckboxenhud", 1)
                if hudxen == tonumber(0) then
                    hudxslider:SetEnabled(false)
                else
                    hudxslider:SetEnabled(true)
                end
			    
			    -- Update global variable when slider value changes
			    hudxslider.OnValueChanged = function(self, value)
			        MoneyTextposx = 0.05*value
			        cookie.Set("MoneyTextposx", MoneyTextposx)
			        -- Optionally print the new value or do something with it
			        wblDebug("Slider Value Updated:", hudxslider:GetValue())
			        wblDebug("Slider Value Updated:", MoneyTextposx)
				end
		

			local hudyslider = vgui.Create("DNumSlider", Forrm)
			    hudyslider:Dock( FILL )
			    hudyslider:SetSize(200, 30) -- Set size of the slider
			    hudyslider:SetText("Vertical Position")  -- Slider label
			    hudyslider:SetMin(0)          -- Minimum value
			    hudyslider:SetMax(20)        -- Maximum value
			    hudyslider:SetValue((cookie.GetNumber("MoneyTextposy", 0.95))*20) -- Set initial value
			    hudyslider.Label:SetTextColor(Color(0, 0, 0))
                local hudyen = cookie.GetNumber("wblcheckboxenhud", 1)
			    if hudyen == tonumber(0) then
                    hudyslider:SetEnabled(false)
                else
                    hudyslider:SetEnabled(true)
                end

			    -- Update global variable when slider value changes
			    hudyslider.OnValueChanged = function(self, value)
			        MoneyTextposy = 0.05*value
			        cookie.Set("MoneyTextposy", MoneyTextposy)
			        -- Optionally print the new value or do something with it
			        wblDebug("Slider Value Updated:", hudyslider:GetValue())
			        wblDebug("Slider Value Updated:", MoneyTextposy)

				end
		

        local ResetMoneyHud = vgui.Create( "DButton", Forrm ) 
        ResetMoneyHud:Dock( TOP )
        ResetMoneyHud:SetText( "Reset Hud settings" )                  
        ResetMoneyHud:SetSize( 250, 30 )                   
        
        Forrm:AddItem(ResetMoney)
        Forrm:AddItem(ResetMoneyHud)

        local wblcheckboxenhud = Forrm:CheckBox("Hide Money Hud when not in shop")
            local savedState = cookie.GetNumber("wblcheckboxenhud", 1) -- 0 is unchecked, 1 is checked
            wblcheckboxenhud:SetChecked(savedState == 0)
            wblcheckboxenhud.OnChange = function(self, checked)
                if checked then
                    cookie.Set("MoneyTextposxoriginal", MoneyTextposx)
                    cookie.Set("MoneyTextposyoriginal", MoneyTextposy)
                    MoneyTextposx = 1.5
                    MoneyTextposy = 1.5
                    cookie.Set("MoneyTextposx", MoneyTextposx)
                    cookie.Set("MoneyTextposy", MoneyTextposy)
                    wblhuden = 0 
                    cookie.Set("wblcheckboxenhud", wblhuden)
                    hudxslider:SetEnabled(false)
                    hudyslider:SetEnabled(false)
                else
                    local Moneytextxorig = cookie.GetNumber("MoneyTextposxoriginal", 0.5)
                    local Moneytextyorig = cookie.GetNumber("MoneyTextposyoriginal", 0.95)
                    MoneyTextposx = Moneytextxorig
                    MoneyTextposy = Moneytextyorig
                    cookie.Set("MoneyTextposx", MoneyTextposx)
                    cookie.Set("MoneyTextposy", MoneyTextposy)
                    wblhuden = 1
                    cookie.Set("wblcheckboxenhud", wblhuden)
                    hudxslider:SetEnabled(true)
                    hudyslider:SetEnabled(true)
                end
            end

        ResetMoneyHud.DoClick = function()
            MoneyTextposx = 0.5
            MoneyTextposy = 0.95
            wblhuden = 1
            cookie.Set("wblcheckboxenhud", wblhuden)
            cookie.Set("MoneyTextposx", MoneyTextposx)
            cookie.Set("MoneyTextposy", MoneyTextposy)
            wblcheckboxenhud:SetChecked(false)
            hudxslider:SetValue((cookie.GetNumber("MoneyTextposx", 0.5))*20)
            hudyslider:SetValue((cookie.GetNumber("MoneyTextposy", 0.95))*20)
            hudxslider:SetEnabled(true)
            hudyslider:SetEnabled(true)
        end



        Forrm:AddItem(hudxslider)
        Forrm:AddItem(hudyslider)

        local wblcheckboxenDebug = Forrm:CheckBox("Enable Client Side Debug")
        wblcheckboxenDebug:SetChecked(false)
        wblcheckboxenDebug.OnChange = function(self, checked)
            if checked then
                wbldeben = 1
            else
                wbldeben = 0
            end
        end

	panel:AddItem(Forrm)



	end )
end )

	
