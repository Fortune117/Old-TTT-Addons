
if SERVER then 
AddCSLuaFile("shared.lua")
 end

if CLIENT then
   ENT.PrintName = "Trap Laser"
end

ENT.Type = "anim"
ENT.Model = "models/props_combine/combine_mine01.mdl"

ENT.CanUseKey = false

ENT.SteppedOn = false

ENT.Canfire = true

function ENT:Initialize()
	if SERVER then
		self.Entity:SetModel( self.Model )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_PLAYER)
		self.Entity:SetMoveType( MOVETYPE_NONE )
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(false)
	end
end

local Reload = CurTime()
local ReloadSound = "weapons/crossbow/reload1.wav"
function ENT:Think()
	if SERVER then
		if self.Canfire == false and CurTime() > Reload then
			self.Canfire = true
			self:EmitSound(ReloadSound)
		end
	end
end

function ENT:FireLaser()
	if self.Canfire then
		if SERVER then
			local spear = ents.Create("ttt_spear")
			spear:SetPos(self:GetPos()+self:GetUp()*20)
			spear:SetAngles(self:GetAngles() + Angle(90,0,0) )
			spear:SetOwner(self.Placer)
			spear.Mother = self
			spear:Spawn()
			spear:Activate()
			
			self:EmitSound("weapons/crossbow/fire1.wav")
			
			local effect = EffectData()
			effect:SetOrigin(self:GetPos()+self:GetUp()*10)
			effect:SetMagnitude( 10 )
			effect:SetNormal( self:GetUp() )
			util.Effect( "StunstickImpact", effect, true, true )
			
			self.Canfire = false
			
			Reload = CurTime() + 20
		end
	end
end
