
if SERVER then 
AddCSLuaFile("shared.lua")
 end

if CLIENT then
   ENT.PrintName = "Bear Trap"
end

ENT.Type = "anim"
ENT.Model = "models/props_combine/combine_mine01.mdl"

ENT.CanUseKey = true
ENT.CanTouch = true
ENT.TrappedPlayer = nil

function ENT:Initialize()
	if SERVER then
		self.Entity:SetModel( self.Model )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_PLAYER)
		self.Entity:SetMoveType( MOVETYPE_NONE )
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self.Entity:SetTrigger(true)
		self.Entity:DrawShadow(false)
		self:SetNWBool("Invis", true )
		self:SetUseType( SIMPLE_USE )
	end
end

local DamageDelay = CurTime() + 1
function ENT:Think()
	if self.CanTouch == false then
		self:SetPoseParameter( "blendstates" , 30 )
	end
	
	if self.CanTouch == false then
		if IsValid(self.TrappedPlayer) and CurTime() > DamageDelay then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker(self.Placer)
			dmginfo:SetInflictor(self.Placer)
			dmginfo:SetDamageType( DMG_SLASH )
			dmginfo:SetDamagePosition( self:GetPos()  + self:GetUp()*9)
			dmginfo:SetDamage( 2 )
			
			DamageDelay = CurTime() + 1
			self.TrappedPlayer:EmitSound("npc/roller/blade_in.wav")
			self.TrappedPlayer:TakeDamageInfo(dmginfo)
		elseif not IsValid(self.TrappedPlayer) or IsValid(self.TrappedPlayer) and not self.TrappedPlayer:Alive() then
			self:Remove()
		end
	end
end

function ENT:Use( user )
	if IsValid(self.TrappedPlayer) then
		if user != self.TrappedPlayer then
			self:EmitSound("npc/roller/blade_in.wav")
			self:Remove()
		end
	end
end

function ENT:Touch(hitEnt)
	if hitEnt:IsPlayer() and self.CanTouch == true and not hitEnt:IsTraitor() then
		self:SetPoseParameter( "blendstates" , 30 )
		self:SetNWBool("Invis", false )
		self.CanTouch = false
		local dmginfo = DamageInfo()
		dmginfo:SetAttacker(self.Placer)
		dmginfo:SetInflictor(self.Placer)
		dmginfo:SetDamageType( DMG_SLASH )
		dmginfo:SetDamage( 20 )
		
		hitEnt:TakeDamageInfo( dmginfo )
		if IsValid(hitEnt) then
			self.TrappedPlayer = hitEnt
			DamageDelay = CurTime() + 1
			hitEnt:SetVelocity(self:GetVelocity()*-1)
			hitEnt.SpeedMult = 0.01
			hitEnt.OldPower = hitEnt:GetJumpPower()
			hitEnt:SetJumpPower( 0 )
			hitEnt:EmitSound("npc/roller/blade_out.wav")
		end
		hitEnt:SetPos( self:GetPos() + Vector( 0, 0, 2 ) )
	end
end

if CLIENT then
	function ENT:Draw()
		if LocalPlayer():IsActiveTraitor() then
			self:DrawModel()
		elseif self:GetNWBool("Invis") == false then
			self:DrawModel()
		end
	end
end

function ENT:OnRemove()
	if IsValid(self.TrappedPlayer) then
		self.TrappedPlayer.SpeedMult = 1
		self.TrappedPlayer:SetJumpPower( self.TrappedPlayer.OldPower )
	end
end