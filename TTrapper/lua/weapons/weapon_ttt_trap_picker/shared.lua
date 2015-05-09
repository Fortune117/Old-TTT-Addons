
if( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "slam" 

if( CLIENT ) then
	SWEP.PrintName = "Trap Picker"
	SWEP.Slot = 6
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	
	SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "This weapon allows you to choose between\n three different traps.\n\nChoose wisely, as you only get one choice!"
    };

   SWEP.Icon = "vgui/ttt/icon_defuser"
end


SWEP.ViewModelFOV	= 10
SWEP.ViewModelFlip	= false

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR} -- Everyone gets to use drugs :D
SWEP.LimitedStock = true

SWEP.Primary.Automatic = false



function SWEP:PrimaryAttack()
	if CLIENT then
		if IsFirstTimePredicted() then
			local TrapMenu = vgui.Create("TrapMenu")
		 end
	end
end


