include("shared.lua") --gets all the codes of the shared lua (as if copy pasted shared.lua's codes to here)

function ENT:Draw()

	self:DrawModel()

	local ang = self:GetAngles() -- To position the 3d2d drawing
	local flicker = math.random(50, 255) -- Flickering effect for the word

	-- Define the size and position of the triangular cone
	-- Define your XYZ offsets
local offsetX = -30   -- Change this value to move left/right
local offsetY = 3   -- Change this value to move up/down
local offsetZ = 0 -- Change this value to move forward/backward

-- Define your rotation angles (in degrees)
local rotateX = 0   -- Rotation around the X-axis
local rotateY = 90   -- Rotation around the Y-axis
local rotateZ = -270 -- Rotation around the Z-axis

-- Get the current angles and apply rotations
local ang2 = self:GetAngles()
ang2:RotateAroundAxis(ang2:Right(), rotateX)
ang2:RotateAroundAxis(ang2:Up(), rotateY)
ang2:RotateAroundAxis(ang2:Forward(), rotateZ)

-- Start the 3D2D cam with an XYZ offset
cam.Start3D2D(self:GetPos() + ang2:Up() * offsetY + ang2:Right() * offsetX + ang2:Forward() * offsetZ, ang2, 0.1)

    -- Draw the text
    draw.SimpleText("ωelcome!", "TheDefaultSettings", 0, 0, Color(255, 255, 0, flicker), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

cam.End3D2D()

end