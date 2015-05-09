if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType			= "pistol"

if CLIENT then
   SWEP.PrintName			= "Auto Targ. Deagle"			
   SWEP.Author				= "TTT"

   SWEP.Slot				= 1


   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "A highly advanced targeting system means that\nthe user doesn't even have to aim. Allows for one\nperfect headshot."
   };
   SWEP.Icon = "VGUI/ttt/icon_deagle"
end

SWEP.Base				= "weapon_tttbase"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_PISTOL
SWEP.WeaponID = AMMO_ATD
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.LimitedStock = true

SWEP.Primary.Ammo       = "none" 
SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage = 100
SWEP.Primary.Delay = 0.6
SWEP.Primary.Cone = 0.001
SWEP.Primary.ClipSize = 1
SWEP.Primary.ClipMax = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false

SWEP.HeadshotMultiplier = 10

SWEP.MaxRange = 500

SWEP.AutoSpawnable      = false
SWEP.Primary.Sound			= Sound( "Weapon_Deagle.Single" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_deagle.mdl"


function SWEP:PointAtTarget( ent )
	local BoneIndx = ent:LookupBone("ValveBiped.Bip01_Head1")
	local BonePos , BoneAng = ent:GetBonePosition( BoneIndx )
	self.Owner:SetEyeAngles( (( BonePos - self.Owner:GetShootPos() - (self.Owner:GetVelocity():GetNormal()*8) + (ent:GetVelocity():GetNormal()*7) ):GetNormal() ):Angle() )
end

function SWEP:PrimaryAttack()
	if self:Clip1() < 1 or not self.Owner:IsTraitor() then return end
	
	local target = self:FindClosestPlayer()
	
		if self:CanTargetPlayer( target ) then
			if CLIENT then
				LocalPlayer().ShouldFixAim = true
			end
			
			if SERVER then
				self:PointAtTarget( target )
			end
				local BoneIndx = target:LookupBone("ValveBiped.Bip01_Head1")
				local BonePos , BoneAng = target:GetBonePosition( BoneIndx )
				bullet = {}
				bullet.Num=1
				bullet.Src= self.Owner:GetShootPos()
				bullet.Dir= (self.Owner:GetShootPos() - BonePos ):GetNormal()*-1
				bullet.Spread=Vector(0.001,0.001,0)
				bullet.Tracer=1	
				bullet.Force=2000
				bullet.Damage=1000
				bullet.Attacker = self.Owner
				
				if IsFirstTimePredicted() then
					self.Owner:EmitSound(self.Primary.Sound)
					self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
				end
				 
				self.Weapon:FireBullets(bullet)
				self:TakePrimaryAmmo(1)
			if CLIENT then
				timer.Simple(0.01,function()
					LocalPlayer().ShouldFixAim = false
				end)
			end
		end
end

function SWEP:FindClosestPlayer()
	local Closest = 99999999
	local target = nil
	E = ents.FindInSphere( self:GetPos(), self.MaxRange )
	for k,v in pairs(E) do
		if IsValid(v) and v:IsPlayer() and v:Alive() and v != self.Owner then
			if v:IsTraitor() then continue end
			local Dist = v:GetPos():Distance( self:GetPos() )
			if Dist < Closest then
				Closest = Dist
				target = v
				self.Target = target
			end	
		end
	end
return target
end

function SWEP:CanTargetPlayer( ply )

	if ply == nil then
		return false
	end
	
	local BoneIndx = ply:LookupBone("ValveBiped.Bip01_Head1")
	local BonePos , BoneAng = ply:GetBonePosition( BoneIndx )
	
	local trd = {}
	trd.start = self.Owner:GetShootPos()
	trd.endpos = BonePos
	trd.filter = {self,self.Owner}
	trd.mask = MASK_SOLID
	local tr = util.TraceLine(trd)
	if tr.Entity == ply then
		return true
	end
return false
end

if CLIENT then

hook.Add("InputMouseApply", "Fix Aim", function(cmd, x, y, angle)
	if LocalPlayer().ShouldFixAim == true then
		return true
	end
end)

surface.CreateFont( "smooth", { font = "Trebuchet18", size = 12, weight = 700, antialias = true } )
SWEP.Target = nil

function SWEP:HasTarget() 
	if self.Target == nil then
		return false
	end
return true
end

function SWEP:FindTarget()
	local target = self:FindClosestPlayer()
	if self:CanTargetPlayer( target ) and not target:IsTraitor() then
		return target
	end
return nil
end

function SWEP:Think()
	self.Target = self:FindTarget()
end

local linex = 0
local liney = 0
function SWEP:ViewModelDrawn()
	  if not LocalPlayer() == self.Owner then return end
      local client = LocalPlayer()
      local vm = client:GetViewModel()
      if not IsValid(vm) then return end

      local plytr = client:GetEyeTrace(MASK_SHOT)

      local muzzle_angpos = vm:GetAttachment(1)
      local spos = muzzle_angpos.Pos + muzzle_angpos.Ang:Forward() * 10
      local epos = client:GetShootPos() + client:GetAimVector() * maxrange

      -- Charge indicator
      local vm_ang = muzzle_angpos.Ang
      local cpos = muzzle_angpos.Pos + (vm_ang:Up() * -6) + (vm_ang:Forward() * -9) + (vm_ang:Right() * -2.5)
      local cang = vm:GetAngles()
      cang:RotateAroundAxis(cang:Forward(), 90)
      cang:RotateAroundAxis(cang:Right(), 90)
      cang:RotateAroundAxis(cang:Up(), 0)
	  
	cam.Start3D2D(cpos, cang, 0.05)
      local sz = 78
	  if self.Owner:IsTraitor() then
		  if self:Clip1() > 0 then
			  if self:HasTarget() then
				surface.SetDrawColor(55, 255, 55, 125)
				surface.DrawOutlinedRect(0, 0, sz+2, 15)
				surface.DrawOutlinedRect(0, 17, sz+2, 15)
				surface.SetDrawColor(10, 255, 10, 200)
				
			  else
				 surface.SetDrawColor(255, 55, 55, 125)
				surface.DrawOutlinedRect(0, 0, sz+2, 15)
				surface.DrawOutlinedRect(0, 17, sz+2, 15)
				surface.SetDrawColor(255, 10, 10, 200)
			  end

		  surface.DrawRect(1, 1, sz, 13)
		  
		  surface.DrawRect(1, 18, sz, 13)
		  
		  surface.SetFont("smooth")
		  surface.SetTextColor(255,255,255,205)
		  if self:HasTarget() then
			local name = self.Target:Nick()
			local str = string.sub( name, 1, math.Clamp(string.len( name ), 1, 15) )
			local x,y = surface.GetTextSize(str)
			surface.SetTextPos( sz/2 - x/2 ,17)
			surface.DrawText(str)
		  else
			local str = "N/A"
			local x,y = surface.GetTextSize(str)
			surface.SetTextPos(sz/2 - x/2,18)
			surface.DrawText(str)
		  end

		  surface.SetTextColor(255,255,255,205)
		  surface.SetFont("smooth")
		  if self:HasTarget() then
			surface.SetTextPos(4,1)
			surface.DrawText("Target Locked")
		  else
			surface.SetTextPos(14,1)
			surface.DrawText("No Targets")
		  end

		  surface.SetDrawColor(0,0,0, 80)
		  surface.DrawRect(sz+3, 1, 3, 13)
		  surface.DrawRect(sz+3, 18, 3, 13)

		  surface.DrawLine(1, liney, sz, liney)

		  linex = linex + 3 > 48 and 0 or linex + 1
		  liney = liney > 13 and 0 or liney + 1
		end
	else

		surface.SetDrawColor(255, 55, 55, 125)
		surface.DrawOutlinedRect(0, 0, sz+2, 15)
		surface.DrawOutlinedRect(0, 17, sz+2, 15)
		surface.SetDrawColor(255, 10, 10, 200)

		surface.DrawRect(1, 1, sz, 13)
		  
		surface.DrawRect(1, 18, sz, 13)
		  
		surface.SetTextColor(255,255,255,205)
		
		surface.SetFont("smooth")
		
		local x,y = surface.GetTextSize("Unknown User")
		surface.SetTextPos(sz/2 - x/2 + 2,1)

		surface.DrawText("Unknown User")
		
		surface.SetTextColor(255,255,255,205)
		surface.SetFont("smooth")
		  
		local x,y = surface.GetTextSize("Locked")
		surface.SetTextPos(sz/2 - x/2,18)
		surface.DrawText("Locked")

		  surface.SetDrawColor(0,0,0, 80)
		  surface.DrawRect(sz+3, 1, 3, 13)
		  surface.DrawRect(sz+3, 18, 3, 13)

		  surface.DrawLine(1, liney, sz, liney)

		  linex = linex + 3 > 48 and 0 or linex + 1
		  liney = liney > 13 and 0 or liney + 1
	end
	cam.End3D2D()
end

function SWEP:DrawHUD()
	if self:HasTarget() and self:Clip1() > 0 and self.Owner:IsTraitor() then 
	    local BoneIndx = self.Target:LookupBone("ValveBiped.Bip01_Head1")
		local BonePos , BoneAng = self.Target:GetBonePosition( BoneIndx )
		local pos = (BonePos + Vector(0,0,4) ):ToScreen()
		
		surface.SetDrawColor(Color(0,255,0,255))
		surface.DrawOutlinedRect(pos.x - 25,pos.y - 25, 50, 50 )
	end
end

end