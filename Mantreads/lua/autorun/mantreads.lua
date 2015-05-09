
if SERVER then
	resource.AddFile("sound/mantreads.wav")
end

EQUIP_TREADS = 16

local function Init()

	local treads = {  
		id       = EQUIP_TREADS,
	    loadout  = false, -- default equipment for detectives
	    type     = "item_passive",
	    material = "vgui/ttt/icon_defuser",
	    name     = "Mantreads",
	    desc     = "With these equipped, upon landing on a player\ndeal 3x normal fall damage to them as well as\nnegating all fall damage to yourself."
	}

	table.insert( EquipmentItems[ROLE_TRAITOR], treads )

end	
hook.Add( 'InitPostEntity', 'MantreadsData', Init )


if SERVER then
function MantreadDamage( ply, isWater, isFloater, speed )
/*
	if ply:HasEquipmentItem(EQUIP_TREADS) then
		local ent = ply:GetGroundEntity()
		local damage = math.pow(0.05 * (speed - 420), 1.75) * 3
		if math.floor(damage) > 0 then
			if IsValid(ent) and ent:IsPlayer() then
				
				local health = ent:Health()
				local dmginfo = DamageInfo()
				dmginfo:SetDamageType( DMG_CRUSH )
				dmginfo:SetAttacker( ply )
				dmginfo:SetInflictor( ply )
				dmginfo:SetDamageForce( Vector(0,0, -1 ) )
				dmginfo:SetDamage(damage)
				
				ent:TakeDamageInfo(dmginfo)
				
				ply.Treaded = true
				
				timer.Simple(1,function()
					ply.Treaded = false
				end)
				
				ply:EmitSound("mantreads.wav")
				
				for i = 1,30 do
				local effect = EffectData()
					effect:SetScale(1000)
					effect:SetOrigin(ply:GetPos() + Vector(math.Rand(-10,10),math.Rand(-10,10),0) )
					effect:SetNormal(Vector(0,0,-1))
					util.Effect("AR2Impact", effect, true, true )
				end
			end
		end
	end
	*/
end
hook.Add( "OnPlayerHitGround", "Mantreads", MantreadDamage)


hook.Add( "EntityTakeDamage", "MantreadFallDamage", function( ent, dmginfo )
/*
	if IsValid(ent) and ent:IsPlayer() then
		if ent:HasEquipmentItem(EQUIP_TREADS) then
			if dmginfo:IsFallDamage() and ent:GetGroundEntity():IsPlayer() or ent.Treaded == true then
				dmginfo:ScaleDamage(0)
			end
		end
	end
*/
end)
end