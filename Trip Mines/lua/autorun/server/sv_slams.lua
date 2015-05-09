
util.AddNetworkString("SendMiss")
util.AddNetworkString("SyncBonk")

function SlamDamage( slam, dmginfo )
	if slam:GetClass() == "ttt_slam" then
	
	end
end
hook.Add("EntityTakeDamage", "Slam Damage", SlamDamage )


