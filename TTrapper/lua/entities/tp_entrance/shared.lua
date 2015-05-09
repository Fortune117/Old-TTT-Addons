
if SERVER then 
AddCSLuaFile("shared.lua")
 end

if CLIENT then
   ENT.PrintName = "Trap Trigger"
end

ENT.Type = "anim"
ENT.Model = "models/props_combine/combine_mortar01b.mdl"
//ENT.Model = "models/xqm/button2.mdl"

ENT.CanUseKey = false

ENT.TrappedPlayer = nil

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	if SERVER then
		self.Entity:SetModel( self.Model )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_PLAYER )
		self.Entity:SetMoveType( MOVETYPE_NONE )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		self.Entity:SetTrigger( true )
		self:DrawShadow(false)
		self:SetUseType( SIMPLE_USE )
	end
	
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
end

local TouchDelay = CurTime() + 3
local TP_Delay = CurTime()

local SoundLoop = "ambient/energy/force_field_loop1.wav"
local TPSound = "ambient/machines/teleport1.wav"

ENT.Alpha = 255

if SERVER then
	util.AddNetworkString( "FadeTeleporter" )
end

function ENT:Think()
	if self.TrappedPlayer != nil then
		local effect = EffectData()
		effect:SetOrigin( self.TrappedPlayer:GetPos() )
		effect:SetEntity( self.TrappedPlayer )
		effect:SetScale(100)
		effect:SetRadius(100)
		effect:SetMagnitude(100)
		util.Effect("TeslaHitboxes", effect, true, true )
	end
	
	if self.Fade == true then
		self.Alpha = math.Clamp( self.Alpha - 8, 1, 255 )
		net.Start("FadeTeleporter")
		net.WriteInt( self.Alpha, 32 )
		net.Send( player.GetAll() )

		if self.Alpha == 1 then
			self.Fade = false
			self:SetNWBool("Fading", false )
		end
	end
	
	if CurTime() > TP_Delay and self:GetCollisionGroup() == COLLISION_GROUP_WEAPON then
		self:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	end
end

function ENT:DoSomeTPStuff( ply )
			local E = ents.FindByClass("tp_exit")
			for k,v in pairs(E) do
				if IsValid(v) and v.Placer == self.Placer then
					ply:Freeze(true)
					ply :SetPos( self:GetPos() )
					self.TrappedPlayer = ply 
					self.Alpha = 255
					
					net.Start("FadeTeleporter")
					net.WriteInt( self.Alpha, 32 )
					net.Send( player.GetAll() )
					
					self:SetNWBool("TrappedPlayer", true)
					
					self:SetNWBool("Fading", true )
					
					TP_Delay = CurTime() + 30
					self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
					
					if not self.ChargeSound then
						self.ChargeSound = CreateSound(self, "ambient/energy/force_field_loop1.wav")
					end
					self.ChargeSound:PlayEx(0.5, 100)
					
					timer.Simple(2,function()
						if IsValid(ply) and ply:Alive() then
							ply:EmitSound("ambient/machines/teleport1.wav")
							self.TrappedPlayer = nil
							v:BringPlayer( ply )
							self:SetNWBool("TrappedPlayer", false)
							
							self.Fade = true
							
							self.ChargeSound:FadeOut(0.5)
						else
							self.ChargeSound:FadeOut(0.5)
						end
					end)
				end
			end
end

function ENT:Use( user )
	if CurTime() > TouchDelay and CurTime() > TP_Delay then
		if user:IsActiveTraitor() then
			self:DoSomeTPStuff( user )
		end
		TouchDelay = CurTime() + 3
	end
end

function ENT:Touch(hitEnt)
	if CurTime() > TouchDelay and CurTime() > TP_Delay then
		if IsValid(hitEnt) and hitEnt:IsPlayer() and not hitEnt:IsTraitor() then
			self:DoSomeTPStuff( hitEnt )
		end
		TouchDelay = CurTime() + 3
	end
end

if CLIENT then
	function ENT:Draw()
	
			net.Receive("FadeTeleporter", function(len, ply )
				local alpha = net.ReadInt( 32 )
				self.Alpha = alpha
			end)
			
		if LocalPlayer():IsActiveTraitor() or self:GetNWBool("TrappedPlayer") == true or self:GetNWBool("Fading") == true then
			self:DrawModel()
		end
		
		if not LocalPlayer():IsTraitor() then
			self.Entity:SetColor(Color(255,255,255, self.Alpha ) )
		else
			self.Entity:SetColor(Color(255,255,255,255 ) )
		end
	end
end

function ENT:OnRemove()
	if self.ChargeSound then
		self.ChargeSound:Stop()
	end
end