include("shared.lua") --gets all the codes of the shared lua (as if copy pasted shared.lua's codes to here)

function ENT:Draw()

	self:DrawModel() --The client needs a script or a way to Draw the entity in his side,
					 --or it will be invisible to the client but have collision

end