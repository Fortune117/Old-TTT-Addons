
if( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "slam" 

if( CLIENT ) then
	SWEP.PrintName = "S.L.A.M Mines"
	SWEP.Slot = 6
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	
	SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Three powerful S.L.A.M mines the user\ncan place down. Useful for setting up traps."
    };

   SWEP.Icon = "vgui/ttt/icons/icon_tripmine"
end

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.LimitedStock = false

SWEP.ViewModelFOV	= 64
SWEP.ViewModelFlip	= false

SWEP.Base = "weapon_tttbase"

SWEP.UseHands 			= true
SWEP.ViewModel			= "models/weapons/c_slam.mdl"
SWEP.WorldModel			= "models/weapons/w_slam.mdl"

SWEP.Primary.Delay				= 1
SWEP.Primary.Recoil				= 0
SWEP.Primary.Damage				= -1
SWEP.Primary.NumShots			= -1
SWEP.Primary.Cone				= -1
SWEP.Primary.ClipSize			= 3
SWEP.Primary.DefaultClip		= 3
SWEP.Primary.Automatic   		= false
SWEP.Primary.Ammo         		= "none"

SWEP.Secondary.Delay			= 1
SWEP.Secondary.Recoil			= 0
SWEP.Secondary.Damage			= -1
SWEP.Secondary.NumShots			= -1
SWEP.Secondary.Cone				= -1
SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Automatic  	 	= false
SWEP.Secondary.Ammo         	= "none"


SWEP.TriggerPlaced = false

SWEP.DrawAnim = ACT_SLAM_TRIPMINE_DRAW
SWEP.AttachAnim = ACT_SLAM_TRIPMINE_ATTACH
SWEP.LowerAnim = ACT_SLAM_TRIPMINE_IDLE
SWEP.DetAnim = ACT_SLAM_STICKWALL_DETONATE

SWEP.Animdelay = CurTime()
function SWEP:SendAnim( anim, delay )
	if CurTime() >= self.Animdelay then
		if IsFirstTimePredicted() then
			self:SendWeaponAnim( anim )
		end
	end
	self.Animdelay = CurTime() + delay
end

local ghostmdl = Model("models/weapons/w_slam.mdl")
function SWEP:Initialize()

self:SetDeploySpeed(1.3)

 if CLIENT then
      -- create ghosted indicator
      local ghost = ents.CreateClientProp(ghostmdl)
      if IsValid(ghost) then
         ghost:SetPos(self:GetPos())
         ghost:Spawn()

         -- PhysPropClientside whines here about not being able to parse the
         -- physmodel. This is not important as we won't use that anyway, and it
         -- happens in sandbox as well for the ghosted ents used there.

         ghost:SetSolid(SOLID_NONE)
         ghost:SetMoveType(MOVETYPE_NONE)
         ghost:SetNotSolid(true)
         ghost:SetRenderMode(RENDERMODE_TRANSCOLOR)
         ghost:AddEffects(EF_NOSHADOW)
         ghost:SetNoDraw(true)

         self.Ghost = ghost
      end
   end
   
   self:SetWeaponHoldType(self.HoldType)
    return self.BaseClass.Initialize(self)
end

function SWEP:Holster()
	return true
end

function SWEP:Deploy()
	self:SendAnim( self.DrawAnim, 0.2 )
if CLIENT then

if not IsValid(self.Ghost) then
      -- create ghosted indicator
      local ghost = ents.CreateClientProp(ghostmdl)
      if IsValid(ghost) then
         ghost:SetPos(self:GetPos())
         ghost:Spawn()

         -- PhysPropClientside whines here about not being able to parse the
         -- physmodel. This is not important as we won't use that anyway, and it
         -- happens in sandbox as well for the ghosted ents used there.

         ghost:SetSolid(SOLID_NONE)
         ghost:SetMoveType(MOVETYPE_NONE)
         ghost:SetNotSolid(true)
         ghost:SetRenderMode(RENDERMODE_TRANSCOLOR)
         ghost:AddEffects(EF_NOSHADOW)
         ghost:SetNoDraw(true)

         self.Ghost = ghost
      end
   end
end
return true
end

function SWEP:CanPlaceMine()
	local tr = self.Owner:GetEyeTrace()
	
	if tr.HitPos:Distance(self.Owner:GetShootPos()) <= 50 and tr.HitWorld  then
		return true
	end
return false
end

function SWEP:PlaceMine()
	local tr = self.Owner:GetEyeTrace()
	
	if self:CanPlaceMine() then
		self:SendAnim( ACT_SLAM_TRIPMINE_ATTACH2, 1 )
		if SERVER then		
			local slam = ents.Create("ttt_slam")
			slam:SetPos(tr.HitPos + tr.HitNormal*2)
			slam:SetAngles((tr.HitNormal):Angle() + Angle(90,0,0))
			slam:SetOwner( self.Owner )
			slam:Spawn()
			slam:Activate()
			self.Owner:EmitSound("weapons/slam/mine_mode.wav")
		end
		self:TakePrimaryAmmo(1)
		
		if SERVER then
			if self:Clip1() == 0 then
				self:Remove()
			end
		end
	end
end 

SWEP.HoldUp = false
function SWEP:Think()
	if self:CanPlaceMine() and self.HoldUp == false then
		self.HoldUp = true
		self:SendAnim( self.AttachAnim, 0)
	elseif !self:CanPlaceMine() and self.HoldUp == true then
		self.HoldUp = false
		self:SendAnim( self.LowerAnim, 0 )
	end
	
end


function SWEP:PrimaryAttack()
	if (!self:CanPrimaryAttack()) then return end
		self:PlaceMine()
return true
end


function SWEP:SecondaryAttack()
	local E = ents.FindByClass("ttt_slam")
	for k,v in pairs(E) do
		if v.Placer == self.Owner then
			v:Detonate()
		end
	end
end


function SWEP:PreDrop()
	if CLIENT then
		self:HideGhost()
	end
end

function SWEP:HideGhost()
   if IsValid(self.Ghost) then
      self.Ghost:Remove()
   end
end

function SWEP:Reload()
return false
end

if CLIENT then
	
   function SWEP:UpdateGhost(pos, c, a, angle, norm)
      if IsValid(self.Ghost) then
         if self.Ghost:GetPos() != pos then
		 
			self.Ghost:SetPos(pos)
			
			self.Ghost:SetAngles(angle)
           
            --self.Ghost:SetRenderMode(RENDERMODE_TRANSALPHA)
            self.Ghost:SetColor(Color(c.r,c.g,c.b,a))

            self.Ghost:SetNoDraw(true)
         end
      end
   end
   
	function SWEP:CanPlaceMineCS( dist, norm )
		if IsValid(self.Ghost) then			
			if dist > 50 then
				return false
			end
		end
		return true
	end

   
   function SWEP:Think()
		local client = LocalPlayer()
		
		local tr = self.Owner:GetEyeTrace()
	  
		local c
		if self:CanPlaceMineCS(tr.HitPos:Distance(client:GetShootPos()), tr.HitNormal) then
			c = Color(0,255,0,255)
		else
			c = Color(255,25,25,255)
		end


	self:UpdateGhost(tr.HitPos + tr.HitNormal*2, c, 255,  (tr.HitNormal):Angle() + Angle(90,0,0), tr.HitNormal )
 end  
 
end

function SWEP:Holster()
   if CLIENT and IsValid(self.Ghost) then
      self.Ghost:SetNoDraw(true)
   end
   return self.BaseClass.Holster(self)
end


function SWEP:OnRemove()
   if CLIENT and IsValid(self.Ghost) then
      self.Ghost:Remove()
   end
end


	