if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType			= "physgun"

if CLIENT then
   SWEP.PrintName			= "Atomizer"			
   SWEP.Author				= "TTT"

   SWEP.Slot				= 6


   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "An exremely powerful cannon, designed to\natomize the target. Charge time increases with each shot."
   };
   SWEP.Icon = "vgui/ttt/icon_launch"
   
   SWEP.ViewModelFlip = false
   SWEP.ViewModelFOV = 54
   
end

SWEP.Base				= "weapon_tttbase"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.LimitedStock = true

SWEP.Primary.Ammo       = "none" 
SWEP.Primary.Recoil			= -1
SWEP.Primary.Damage = -1
SWEP.Primary.Delay = -1
SWEP.Primary.Cone = -1
SWEP.Primary.ClipSize = -1
SWEP.Primary.ClipMax = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false

SWEP.Range			= 200
SWEP.ChargeTime 	= 15
SWEP.ChargedSound	= Sound("ambient/energy/electric_loop.wav")
SWEP.FireSound 		= Sound("ambient/explosions/explode_7.wav")
SWEP.ChargeingSound = Sound("ambient/machines/combine_shield_touch_loop1.wav")

SWEP.AllowDrop = true

SWEP.UseHands			= true
SWEP.ViewModel  = "models/weapons/c_physcannon.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"

SWEP.SmallGibs = { Model( "models/gibs/HGIBS_scapula.mdl" ),
Model( "models/gibs/HGIBS_spine.mdl" ),
Model( "models/props_phx/misc/potato.mdl" ),
Model( "models/gibs/antlion_gib_small_1.mdl" ),
Model( "models/gibs/antlion_gib_small_2.mdl" ),
Model( "models/gibs/shield_scanner_gib1.mdl" ),
Model( "models/props_debris/concrete_chunk04a.mdl" ),
Model( "models/props_debris/concrete_chunk05g.mdl" ),
Model( "models/props_wasteland/prison_sinkchunk001h.mdl" ),
Model( "models/props_wasteland/prison_toiletchunk01f.mdl" ),
Model( "models/props_wasteland/prison_toiletchunk01i.mdl" ),
Model( "models/props_wasteland/prison_toiletchunk01l.mdl" ),
Model( "models/props_combine/breenbust_chunk02.mdl" ),
Model( "models/props_combine/breenbust_chunk04.mdl" ),
Model( "models/props_combine/breenbust_chunk05.mdl" ),
Model( "models/props_combine/breenbust_chunk06.mdl" ),
Model( "models/props_junk/watermelon01_chunk02a.mdl" ),
Model( "models/props_junk/watermelon01_chunk02b.mdl" ),
Model( "models/props_junk/watermelon01_chunk02c.mdl" ),
Model( "models/props/cs_office/computer_mouse.mdl" ),
Model( "models/props/cs_italy/banannagib1.mdl" ),
Model( "models/props/cs_italy/banannagib2.mdl" ),
Model( "models/props/cs_italy/orangegib1.mdl" ),
Model( "models/props/cs_italy/orangegib2.mdl" ) }

function SWEP:Initialize() 
	self.Charged = false
	self.Charge = 0
	self:SetWeaponHoldType( self.HoldType )
end


function SWEP:Atomize()
	
	local pos = self.Owner:GetPos()
	local vdir = self.Owner:GetAimVector()
	
	self.Owner:ViewPunch( Angle(math.random(-40,-28),math.random(-12,12),0))
	
	if SERVER then
		local E = ents.FindInSphere( pos, self.Range )
		for k,v in pairs( E ) do
		
			if v == self.Owner then continue end
			
			if v:IsPlayer() and v:Alive() then
			
				local dir = (v:GetPos() - pos):GetNormal()
							
				local dmg = DamageInfo()
				dmg:SetDamage(v:Health()*9)
				//dmg:SetDamageForce( dir*3000 + Vector(0,0,80) )
				dmg:SetAttacker( self.Owner )
				dmg:SetInflictor( self )
				dmg:SetDamageType( DMG_CLUB )
				
				print("DOT: "..vdir:DotProduct(dir))
				if vdir:DotProduct(dir) > 0.9 then
					v:SetVelocity( dir*1000 + Vector(0,0,80))
					
					for i = 1,20 do
						local ent = ents.Create("ttt_atom_gib")
						ent:SetPos(v:GetPos() + Vector(0,0,math.Rand(15,64)))
						ent:SetModel( table.Random( self.SmallGibs ) )
						ent:Spawn()
					end
					
					local ed = EffectData()
					ed:SetOrigin( v:LocalToWorld( v:OBBCenter() ) )
					util.Effect( "ttt_atom_gore", ed, true, true )
					
					timer.Simple(0.05,function()
						v:SetModel("models/player/skeleton.mdl")
						v:TakeDamageInfo( dmg )
					end)
					
				end
				
			end
			
		end
	end
end

SWEP.ThinkDelay = 0
SWEP.ThinkDelayNo = 0.1
function SWEP:Think()
	if CurTime() > self.ThinkDelay then
		if self.Owner:KeyDown( IN_ATTACK ) then
			self.Charge = math.Approach(self.Charge,self.ChargeTime,self.ThinkDelayNo)
			if not self.Sound and self.Charged == false then
				self.Sound = CreateSound( self, self.ChargeingSound )
				self.Sound:Play()
			elseif not self.Sound:IsPlaying() and self.Charged == false then
				self.Sound:Play()
			end
			print(self.Charge)
			if self.Charge == self.ChargeTime then
				self.Charged = true
				self.Sound:FadeOut(0.1)
				self.AllowDrop = false
				if not self.Sound2 then
					self.Sound2 = CreateSound( self, self.ChargedSound )
					self.Sound2:Play()
				else
					self.Sound2:Play()
				end
				self.ThinkDelay = CurTime() + self.ThinkDelayNo
				return
			end
		elseif self.Charged == false then
			self.Charge = math.Approach(self.Charge,0,self.ThinkDelayNo)
			if self.Sound and self.Sound:IsPlaying() then
				self.Sound:FadeOut(0.1)
			end
		end
	self.ThinkDelay = CurTime() + self.ThinkDelayNo
	end
end

function SWEP:StopSounds()
	if self.Sound then
		self.Sound:Stop()
	end
	if self.Sound2 then
		self.Sound2:Stop()
	end
end

function SWEP:SecondaryAttack()
	if self.Charged == true then
		self.Charge = 0
		self.Charged = false
		self.ThinkDelay = CurTime() + 2
		self.ChargeTime = self.ChargeTime*2
		self:Atomize()
		self:StopSounds()
		self:EmitSound(self.FireSound)
		self.AllowDrop = true
		
		if CLIENT then
			local vm = self.Owner:GetViewModel()
			local attach_id = vm:LookupAttachment( 'muzzle' )
			local attach = vm:GetAttachment( attach_id )
			local ef = EffectData()
			ef:SetOrigin( attach.Pos )
			ef:SetNormal( self.Owner:GetForward():GetNormal() )
			ef:SetScale( 10 )
			util.Effect( "AR2Explosion", ef, true, true )
			local ef = EffectData()
			ef:SetOrigin( attach.Pos )
			ef:SetNormal( self.Owner:GetForward():GetNormal() )
			ef:SetScale(10)
			util.Effect("cball_explode", ef, true, true )
		end
	end
end

function SWEP:PrimaryAttack()
end

if CLIENT then

	surface.CreateFont( "Atom_Smooth", { font = "Trebuchet18", size = 21, weight = 1500, antialias = true } )

	function draw.AAText( text, font, x, y, color, align )

		if not color then return end

		draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,math.min((color.a or 120),120)), align )
		draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,math.min((color.a or 50),50)), align )
		draw.SimpleText( text, font, x, y, color, align )

	end
	
	local w,h = ScrW()/5,25
	function SWEP:DrawHUD()
		surface.SetDrawColor(Color((self.Charged and 0 or 222),(self.Charged and 200 or 0),52,115))
		surface.DrawRect( ScrW()/2 - w/2, ScrH() - h*2, w, h )
		
		surface.SetDrawColor(Color((self.Charged and 0 or 222),(self.Charged and 200 or 0),52,255))
		surface.DrawOutlinedRect( ScrW()/2 - w/2, ScrH() - h*2, w, h )
		
		if not self.draw_w then self.draw_w = 0 end
		
		self.draw_w = Lerp( FrameTime()*5, self.draw_w, w*(self.Charge/self.ChargeTime) )
		
		surface.SetDrawColor(Color((self.Charged and 0 or 222),(self.Charged and 200 or 0),52,255))
		surface.DrawRect( ScrW()/2 - w/2, ScrH() - h*2, self.draw_w, h )
		
		local text = self.Charged and "Charged!" or math.Round(100*(self.Charge/self.ChargeTime)).."%"
		surface.SetFont("Atom_Smooth")
		local xsz,ysz = surface.GetTextSize( text )
		draw.AAText( text, "Atom_Smooth", ScrW()/2 - xsz/2, ScrH() - h*2 + ysz/16, Color(222,222,222,255), TEXT_ALIGN_LEFT )
	end
end

function SWEP:Holster()
	self.HolsterTime = CurTime()
	self:StopSounds()
return true
end 

function SWEP:Deploy()
	if self.HolsterTime and self.Charged == false then
		local diff = CurTime() - self.HolsterTime
		self.Charge = math.max( self.Charge - diff, 0 )
	end
	if self.Charged == true then
		self.Sound2:Play()
	end
return true
end

function SWEP:OnDrop()
	self:StopSounds()
end

function SWEP:Equip()
	self.Charge = 0
	self.Charged = false
end
