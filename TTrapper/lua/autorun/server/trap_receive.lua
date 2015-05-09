
util.AddNetworkString( "SelectTrap" )
local Weapons = {}
Weapons[1] = "weapon_ttt_trap_dart"
Weapons[2] = "weapon_ttt_trap_bear"
Weapons[3] = "weapon_ttt_trap_tp"

net.Receive("SelectTrap", function( len, ply )
	local TrapType = net.ReadInt( 8 )
	ply:StripWeapon("weapon_ttt_trap_picker")
	ply:Give(Weapons[TrapType])
end)