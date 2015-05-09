
util.AddNetworkString("SendMiss")
util.AddNetworkString("SyncBonk")

function BonkDamage( ply, dmginfo )
	if ply.Bonked == true then
		if not dmginfo:IsFallDamage() and dmginfo:GetDamage() > 0 then
			local dmgpos = dmginfo:GetDamagePosition()
			net.Start("SendMiss")
			net.WriteVector( Vector(dmgpos.x, dmgpos.y, math.Clamp( dmgpos.z, ply:GetPos().z + 65, 9999) ) )
			net.Broadcast()
		end
		dmginfo:ScaleDamage(0)
	end
end
hook.Add("EntityTakeDamage", "Bonk Damage", BonkDamage )

timer.Simple(0.01,function()
	local plymeta = FindMetaTable( "Player" )

	function plymeta:SetSpeed(slowed)
		local mul = hook.Call("TTTPlayerSpeed", GAMEMODE, self, slowed) or 1
		local speedmult
		
		if self.SpeedMult then
			speedmult = self.SpeedMult
		else
			speedmult = 1
		end
		
	   if slowed then
		  self:SetWalkSpeed(120 * mul * speedmult)
		  self:SetRunSpeed(120 * mul * speedmult)
		  self:SetMaxSpeed(120 * mul * speedmult)
	   else
		  self:SetWalkSpeed(220 * mul * speedmult)
		  self:SetRunSpeed(220 * mul * speedmult)
		  self:SetMaxSpeed(220 * mul * speedmult)
	   end
	end

	hook.Add("PlayerSpawn","Fix Speed Mult",function(ply)
		ply.SpeedMult = 1
		ply.Bonked = false
		net.Start("SyncBonk")
		net.Send(ply) 
	end)

end)

