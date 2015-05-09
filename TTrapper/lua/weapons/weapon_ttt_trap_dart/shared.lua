
if( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "slam" 

if( CLIENT ) then
	SWEP.PrintName = "Dart Trap"
	SWEP.Slot = 6
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	
	SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "A herp derp."
    };

   SWEP.Icon = "vgui/ttt/icons/inviswatch"
end


SWEP.Kind = WEAPON_EQUIP

SWEP.ViewModelFOV	= 10
SWEP.ViewModelFlip	= false

SWEP.Base = "weapon_tttbase"

SWEP.ViewModel      = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel   	= "models/weapons/w_crowbar.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_Knife.Slash" )
SWEP.Primary.Delay				= 1
SWEP.Primary.Recoil				= 0
SWEP.Primary.Damage				= -1
SWEP.Primary.NumShots			= -1
SWEP.Primary.Cone				= -1
SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip		= -1
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

local ghostmdl = Model("models/maxofs2d/hover_plate.mdl")
function SWEP:Initialize()
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

function SWEP:Deploy()

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


function SWEP:PrimaryAttack()
	if self.TriggerPlaced == true then return end
	local tr = self.Owner:GetEyeTrace()
	if tr.HitNormal != Vector(0,0,1) then return end
	
	if tr.HitPos:Distance(self.Owner:GetShootPos()) <= 100 and tr.HitWorld  then
				
			local sz = 6.5
			local stuff = Vector(sz,sz,0)
			local stuff2 = Vector(sz,sz,0.3)
			local mins = stuff*-1
			local maxs = stuff2
			local startpos = tr.HitPos
			
			
			local tr2 = util.TraceHull( {
				start = startpos,
				endpos = startpos,
				maxs = maxs,
				mins = mins,
				filter = ent,
				mask = MASK_SHOT_HULL,
				hitworld = true
			} )
			
			if tr2.Hit then return end
			
		self.TriggerPlaced = true
		if SERVER then		
			local trigger = ents.Create("trap_trigger")
			trigger:SetPos(tr.HitPos)
			trigger:SetAngles(Angle(0,self.Owner:EyeAngles().y,self.Owner:EyeAngles().r))
			trigger.Placer = self.Owner
			trigger:Spawn()
			trigger:Activate()
			trigger:EmitSound("phx/eggcrack.wav")
		end
		
		if CLIENT then
			self:ChangeGhostModel()
		end
	end
end


function SWEP:SecondaryAttack()
	if not self.TriggerPlaced == true then return end
	if SERVER then
		local tr = self.Owner:GetEyeTrace()
		if tr.HitPos:Distance(self.Owner:GetShootPos()) <= 100 and tr.HitWorld  then
			local trigger = ents.Create("dart_trap")
			trigger:SetPos(tr.HitPos - tr.HitNormal*9)
			trigger:SetAngles((tr.HitNormal):Angle() + Angle(90,0,0))
			trigger.Placer = self.Owner
			trigger:Spawn()
			trigger:Activate()
			trigger:EmitSound("npc/roller/blade_in.wav")
			self:Remove()
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

	function SWEP:ChangeGhostModel()
		if IsValid(self.Ghost) then
			self.Ghost:SetModel("models/props_combine/combine_mine01.mdl")
			self.Ghost.ModelType = 2
		end
	end
	
   function SWEP:UpdateGhost(pos, c, a, angle, norm)
      if IsValid(self.Ghost) then
         if self.Ghost:GetPos() != pos then
			if self.Ghost.ModelType == 2 then		
				self.Ghost:SetPos(pos - norm*9)
			else
				self.Ghost:SetPos(pos)
			end
			
			ang = angle
			
			if self.ModelType == nil and norm == Vector(0,0,1) then
				self.Ghost:SetAngles(angle + Angle(0,self.Owner:EyeAngles().y,self.Owner:EyeAngles().r) )
			else
				self.Ghost:SetAngles(angle)
			end
           
            --self.Ghost:SetRenderMode(RENDERMODE_TRANSALPHA)
            self.Ghost:SetColor(Color(c.r,c.g,c.b,a))

            self.Ghost:SetNoDraw(false)
         end
      end
   end
   
	function SWEP:CanPlaceTrap( dist, norm )
		if IsValid(self.Ghost) then	
		
			local ent = self.Ghost
			local sz = 6.5
			local stuff = Vector(sz,sz,0)
			local stuff2 = Vector(sz,sz,0.3)
			local mins = stuff*-1
			local maxs = stuff2
			local startpos = ent:GetPos()
			
			
			local tr = util.TraceHull( {
				start = startpos,
				endpos = startpos,
				maxs = maxs,
				mins = mins,
				filter = ent,
				mask = MASK_SHOT_HULL,
				hitworld = true
			} )
			
			if norm != Vector(0,0,1) and self.Ghost.ModelType == nil or dist > 100 or self.Ghost.ModelType == nil and tr.Hit then
				return false
			end
		end
		return true
	end

   
   function SWEP:Think()
		local client = LocalPlayer()
		
		local tr = self.Owner:GetEyeTrace()
	  
		local c
		if self:CanPlaceTrap(tr.HitPos:Distance(client:GetShootPos()), tr.HitNormal) then
			c = Color(0,255,0,255)
		else
			c = Color(255,25,25,255)
		end


	self:UpdateGhost(tr.HitPos, c, 255,  (tr.HitNormal):Angle() + Angle(90,0,0), tr.HitNormal )
 end  
 
end

function SWEP:Holster()
   if CLIENT and IsValid(self.Ghost) then
      self.Ghost:SetNoDraw(true)
   end
   return self.BaseClass.Holster(self)
end

function SWEP:OnDrop()

end

function SWEP:OnRemove()
   if CLIENT and IsValid(self.Ghost) then
      self.Ghost:Remove()
   end
end


	