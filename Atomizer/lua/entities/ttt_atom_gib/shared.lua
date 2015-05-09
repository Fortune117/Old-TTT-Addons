
if SERVER then 
AddCSLuaFile("shared.lua")
 end

if CLIENT then
   ENT.PrintName = "Trip Mine"
end

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"


function ENT:Initialize()
		
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:SetMaterial( "models/flesh" )
		
	local phys = self.Entity:GetPhysicsObject()
	
	if IsValid( phys ) then
	
		phys:Wake()
		phys:SetMass( math.random( 20, 40 ) )
		phys:ApplyForceCenter( VectorRand() * 8000 )
		phys:AddAngleVelocity( VectorRand() * 500 )
		phys:SetMaterial( "flesh" )

	end
	self.LiveTime = CurTime() + 15
end

function ENT:Think() 
	if SERVER then
		if not self.LiveTime or CurTime() > self.LiveTime then
			self:Remove()
		end
	end
end 

ENT.GoreSplat = { "physics/flesh/flesh_squishy_impact_hard1.wav",
"physics/flesh/flesh_squishy_impact_hard2.wav",
"physics/flesh/flesh_squishy_impact_hard3.wav",
"physics/flesh/flesh_squishy_impact_hard4.wav",
"physics/flesh/flesh_bloody_impact_hard1.wav",
"physics/body/body_medium_break3.wav",
"npc/antlion_grub/squashed.wav",
"ambient/levels/canals/toxic_slime_sizzle1.wav",
"ambient/levels/canals/toxic_slime_gurgle8.wav"}

function ENT:PhysicsCollide( data, phys )

	if data.Speed > 50 and data.DeltaTime > 0.35 then
	
		self.Entity:EmitSound( table.Random( self.GoreSplat ), 75, math.random( 80, 120 ) )
		
		if not self.Splat then
		
			self.Splat = true
			
			util.Decal( "Blood", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal )
		
		end
		
	end
	
end

function ENT:OnTakeDamage( dmginfo )

	self.Entity:TakePhysicsDamage( dmginfo )

end