
if SERVER then 
AddCSLuaFile("shared.lua")
 end

if CLIENT then
   ENT.PrintName = "Trap Spear"
end

ENT.Type = "anim"
ENT.Model = "models/Items/CrossbowRounds.mdl"
//ENT.Model = "models/crossbow_bolt.mdl"

ENT.CanUseKey = false

function ENT:Initialize()
	if SERVER then
		self.Entity:SetModel( self.Model )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_WORLD )
		self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetTrigger(true)
		self:Shoot()
		
		timer.Simple(30, function()
			if IsValid(self) then
				self:Remove()
			end
		end)
	end
end

function ENT:Shoot()
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
	
	phys:ApplyForceCenter( self.Mother:GetUp()*10000 )
end

local hitsounds = {
"weapons/crossbow/hitbod1.wav",
"weapons/crossbow/hitbod2.wav"
}

function ENT:Touch( hitEnt )
	if IsValid(hitEnt) and hitEnt:IsPlayer() then
		local dmginfo = DamageInfo()
		dmginfo:SetAttacker( self.Owner )
		dmginfo:SetInflictor( self.Owner )
		dmginfo:SetDamageType( DMG_SLASH )
		dmginfo:SetDamage( 125 )
		
		hitEnt:TakeDamageInfo( dmginfo )
		self:EmitSound(tostring(table.Random(hitsounds)))
		self:Remove()
	end
end

function ENT:PhysicsCollide(data, phys)
	if data.HitEntity:IsWorld() and data.DeltaTime > 0.8 then
		self:SetPos( data.HitPos )
		self:EmitSound("weapons/crossbow/hit1.wav")
		self:SetMoveType(MOVETYPE_NONE)
	end
end


if CLIENT then

function ENT:Draw()
	self:DrawModel()
end

end
