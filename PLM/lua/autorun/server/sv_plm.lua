
function GiveRagdollsPLM( ply, wep, atk )
	for k,v in pairs(player.GetAll()) do
		if IsValid(v:GetNWEntity("PLMTarget")) then
			local targ = v:GetNWEntity("PLMTarget")
			if ply == targ then
				for _k,_v in pairs(ents.FindByClass("prop_ragdoll")) do
					if _v.uqid == ply:UniqueID() then
						v:SetNWEntity("PLMTarget",_v)
					end
				end
			end
		end
	end
end
hook.Add("PlayerDeath", "PLM Transfer", GiveRagdollsPLM )

hook.Add("PlayerSpawn", "Remove PLM Target", function(ply)
	ply:SetNWEntity("PLMTarget", nil )
end)