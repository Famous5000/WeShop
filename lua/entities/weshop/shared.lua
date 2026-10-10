--Just a bunch of copy and paste entity setup
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "WeShop"

ENT.PrintName = "Weapon Shop"
ENT.Spawnable = true

-- Lowercase to match the file on disk: gmad lowercases paths when packing, and
-- a mounted GMA is looked up case-sensitively, so the capitalised form worked in
-- development and lost the spawn-menu icon once published. The sibling entities
-- already used lowercase; this one did not.
ENT.IconOverride = "materials/icons/weshop.png"


