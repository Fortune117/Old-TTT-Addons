

function GiveRagdollsIED( ply, wep, atk )
	/*
	for k,v in pairs(player.GetAll()) do
		if v:IsTraitor() and IsValid(v:GetNWEntity("IEDTarget")) then
			local targ = v:GetNWEntity("IEDTarget")
			if ply == targ then
				for _k,_v in pairs(ents.FindByClass("prop_ragdoll")) do
					if _v.uqid == ply:UniqueID() then
						v:SetNWEntity("IEDTarget",_v)
					end
				end
			end
		end
	end
	*/
end
hook.Add("PlayerDeath", "IED Transfer", GiveRagdollsIED )

hook.Add("PlayerSpawn", "Remove IED Target", function(ply)
	ply:SetNWEntity("IEDTarget", nil )
end)