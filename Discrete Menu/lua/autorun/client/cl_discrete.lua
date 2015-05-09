
local PlayerModels = {
	{"models/player/phoenix.mdl", 1},
	{"models/player/arctic.mdl", 1},
	{"models/player/guerilla.mdl", 1},
	{"models/player/leet.mdl", 1},
	{"models/player/alyx.mdl", 3},
	{"models/player/barney.mdl", 4},
	{"models/player/breen.mdl", 6},
	{"models/player/charple.mdl", 10},
	{"models/player/eli.mdl", 10},
	{"models/player/kleiner.mdl", 12},
	{"models/player/magnusson.mdl", 12},
	{"models/player/monk.mdl", 13},
	{"models/player/corpse1.mdl", 15},
	{"models/player/mossman.mdl", 16},
	{"models/player/odessa.mdl", 16},
	{"models/player/soldier_stripped.mdl", 23 },
	{"models/player/police.mdl", 25},
	{"models/player/police_fem.mdl", 25},
	{"models/player/combine_soldier.mdl", 30},
	{"models/player/combine_soldier_prisonguard.mdl", 35 },
	{"models/player/gman_high.mdl", 38},
	{"models/player/combine_super_soldier.mdl", 40},
	{"models/player/gasmask.mdl", 45},
	{"models/player/riot.mdl", 45},
	{"models/player/urban.mdl", 47},
	{"models/player/skeleton.mdl", 48},
	{"models/player/swat.mdl", 49},
	{"models/player/zombie_classic.mdl", 50},
	{"models/player/zombie_fast.mdl", 50},
	{"models/player/zombie_soldier.mdl",50}
}

list.Set( "PlayerOptionsAnimations", "gman", { "menu_gman" } )

list.Set( "PlayerOptionsAnimations", "hostage01", { "idle_all_scared" } )
list.Set( "PlayerOptionsAnimations", "hostage02", { "idle_all_scared" } )
list.Set( "PlayerOptionsAnimations", "hostage03", { "idle_all_scared" } )
list.Set( "PlayerOptionsAnimations", "hostage04", { "idle_all_scared" } )

list.Set( "PlayerOptionsAnimations", "models/player/zombie_soldier.mdl", { "menu_zombie_01" } )
list.Set( "PlayerOptionsAnimations", "models/player/corpse1.mdl", { "menu_zombie_01" } )
list.Set( "PlayerOptionsAnimations", "models/player/zombie_fast.mdl", { "menu_zombie_01" } )
list.Set( "PlayerOptionsAnimations", "models/player/zombie_classic.mdl", { "menu_zombie_01" } )
list.Set( "PlayerOptionsAnimations", "models/player/skeleton.mdl", { "menu_zombie_01" } )

list.Set( "PlayerOptionsAnimations", "models/player/combine_soldier.mdl", { "menu_combine" } )
list.Set( "PlayerOptionsAnimations", "models/player/combine_soldier_prisonguard.mdl", { "menu_combine" } )
list.Set( "PlayerOptionsAnimations", "models/player/combine_super_soldier.mdl", { "menu_combine" } )
list.Set( "PlayerOptionsAnimations", "models/player/police.mdl", { "menu_combine" } )
list.Set( "PlayerOptionsAnimations", "models/player/police_fem.mdl", { "menu_combine" } )

list.Set( "PlayerOptionsAnimations", "models/player/arctic.mdl", { "pose_standing_02", "idle_fist" } )
list.Set( "PlayerOptionsAnimations", "models/player/gasmask.mdl", { "pose_standing_02", "idle_fist" } )
list.Set( "PlayerOptionsAnimations", "models/player/guerilla.mdl", { "pose_standing_02", "idle_fist" } )
list.Set( "PlayerOptionsAnimations", "models/player/leet.mdl", { "pose_standing_02", "idle_fist" } )
list.Set( "PlayerOptionsAnimations", "models/player/phoenix.mdl", { "pose_standing_02", "idle_fist" } )
list.Set( "PlayerOptionsAnimations", "models/player/riot.mdl", { "pose_standing_02", "idle_fist" } )
list.Set( "PlayerOptionsAnimations", "models/player/swat.mdl", { "pose_standing_02", "idle_fist" } )
list.Set( "PlayerOptionsAnimations", "models/player/urban.mdl", { "pose_standing_02", "idle_fist" } )

local Primary_Weapons =
{
	{"weapon_ttt_m16", "M4A1", 15, { damage = 7, firerate = 5, clipsize = 20, accuracy = 7 }},
	{"weapon_fort_ak47", "AK47", 15, { damage = 5, firerate = 8, clipsize = 30, accuracy = 5 } },
	{"weapon_fort_aug", "Steyr AUG", 20, { damage = 3, firerate = 7, clipsize = 30, accuracy = 9 } },
	{"weapon_fort_famas", "Famas", 10, { damage = 4, firerate = 6, clipsize = 25, accuracy = 9 } },
	{"weapon_fort_galil", "Galil", 25, { damage = 6, firerate = 7, clipsize = 30, accuracy = 4 } },
	{"weapon_fort_m3", "M3 Super", 30, { damage = 10, firerate = 2, clipsize = 8, accuracy = 3 } },
	{"weapon_zm_shotgun", "XM1014 Shotgun", 35, { damage = 9, firerate = 3, clipsize = 8, accuracy = 2 } },
	{"weapon_fort_mp5", "MP5 Navy", 15, { damage = 3, firerate = 8, clipsize = 30, accuracy = 10 } },
	{"weapon_fort_p90", "P90", 40, { damage = 2, firerate = 10, clipsize = 50, accuracy = 3} },
	{"weapon_fort_tmp", "TMP", 45, { damage = 5, firerate = 10, clipsize = 30, accuracy = 2 } },
	{"weapon_fort_ump", "UMP 45", 40, { damage = 6, firerate = 5, clipsize = 30, accuracy = 6 } },
	{"weapon_zm_mac10", "Mac 10", 20, { damage = 4, firerate = 10, clipsize = 30, accuracy = 3 } },
	{"weapon_zm_rifle", "Rifle", 25, { damage = 9, firerate = 1, clipsize = 10, accuracy = 10 } },
	{"weapon_zm_sledge", "M249", 40, { damage = 1, firerate = 10, clipsize = 100, accuracy = 2 } }
}

local Secondary_Weapons =
{
	{"weapon_zm_pistol", "Five Seven", 1, { damage = 4, firerate = 3, clipsize = 20, accuracy = 7 } },
	{"weapon_ttt_glock", "Glock 18", 5, { damage = 4, firerate = 4, clipsize = 20, accuracy = 6 } },
	{"weapon_zm_revolver", "Desert Eagle", 30, { damage = 8, firerate = 5, clipsize = 7, accuracy = 5 } },
	{"weapon_fort_p228", "P228", 12, { damage = 6, firerate = 6, clipsize = 20, accuracy = 4 } },
	{"weapon_ttt_sipistol", "USP-45", 45, { damage = 6, firerate = 5, clipsize = 20, accuracy = 8 } }
}


surface.CreateFont( "D_Smooth", { font = "Trebuchet18", size = 12, weight = 500, antialias = true } )
surface.CreateFont( "D_SmoothL", { font = "Trebuchet18", size = 24, weight = 1000, antialias = true } )
function draw.AAText( text, font, x, y, color, align )

	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,math.min(color.a,120)), align )
	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,math.min(color.a,50)), align )
	draw.SimpleText( text, font, x+3, y+3, Color(0,0,0,0), align )
	draw.SimpleText( text, font, x, y, color, align )

end

function DrawSegmentBar( x, y, full_w, w, h, t, l, g)
	local g = 0.5
	local segs = math.Round( full_w/t )
	local loop_no = math.ceil(segs*(w/full_w))
	local r =  1 - (loop_no - w/t)
	for i = 1,loop_no do
		local add = i == loop_no and (full_w/segs)*r or (full_w/segs)
		local s = x + (full_w/segs)*(i-1) + g
		local bar =
		{ 
			{x = s + l, y = y },
			{x = s + add + l - (g*2), y = y },
			{x = s + add - (g*2), y = y + h },
			{x = s, y = y + h}
		}
		surface.DrawPoly( bar )
	end
end
	
function GetModel( weapon )
	for k,v in pairs( weapons.GetList() ) do
		if v.ClassName == weapon then
			return v.WorldModel
		end
	end	
end

function CutUpString( str, len )
	
	local str_pieces = {}
	if string.len( str ) < len then return {str} end
	
	local strtbl = string.ToTable( str )

	local function sliceString( start )
		for i = start,#strtbl do
			if i == start+len then
				if strtbl[ i ] == " " then
					str_pieces[ #str_pieces + 1 ] = string.sub( str, start+1, i )
					return sliceString( i )
				else
					for i2 = i,#strtbl do
						if strtbl[ i2 ] == " " then
							str_pieces[ #str_pieces + 1 ] = string.sub( str, start+1, i2 )
							return sliceString( i2 )
						end
					end
				end
			elseif i == #strtbl then
				str_pieces[ #str_pieces + 1] = string.sub( str, start+1, #str )
			end
		end
		return str_pieces
	end

	return sliceString( 0 )
end

local ModelSounds = {"physics/cardboard/cardboard_box_break1.wav", "physics/cardboard/cardboard_box_break3.wav" }
local default_animations = { "idle_all_01", "menu_walk" }
 
local PANEL = {}

local my_h = 1080
local my_w = 1920
function PANEL:Init()

	self.XMULT = 1
	self.YMULT = 1
	
	
	local w,h = (my_h*0.6)*self.YMULT,(my_h/2)*self.YMULT
	
	self.w,self.h = w,h
	
	self:SetSize( w, h )
	self:SetTitle("Discrete Menu Beta")
	self:Center()
	self:SetVisible( true )
	self:SetBackgroundBlur( true )
	self:MakePopup()
	
	self.Draw_H = 0
	self.Head_W = 0
	
	local gap = h/10 + 7*self.YMULT
	
	self.property = vgui.Create( "DPropertySheet2", self )
	self.property:SetPos( -1, gap )
	self.property:SetSize( w+1, h-gap )
	
	self.model = vgui.Create( "DPanel" )
	self.model:SizeToContents()
	self.model.Paint = function()
		surface.SetDrawColor( Color( 22, 22, 22, 255 ) )
		surface.DrawRect( 0, 0, w, h )
	end
	
	self.primary = vgui.Create( "DPanel" )
	self.primary:SizeToContents()
	self.primary.Paint = function()
		surface.SetDrawColor( Color( 22, 22, 22, 255 ) )
		surface.DrawRect( 0, 0, w, h )
	end
	
	self.secondary = vgui.Create( "DPanel" )
	self.secondary:SizeToContents()
	self.secondary.Paint = function()
		surface.SetDrawColor( Color( 22, 22, 22, 255 ) )
		surface.DrawRect( 0, 0, w, h )
	end
	
	self.perks = vgui.Create( "DPanel" )
	self.perks:SizeToContents()
	self.perks.Paint = function()
		surface.SetDrawColor( 22, 22, 22, 255 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	self.property:AddSheet( "Player Model", self.model, "icon16/user.png", false, false, "Select your player model." )
	
		local function PlayPreviewAnimation( panel, playermodel )

			if ( !panel or !IsValid( panel.Entity ) ) then return end

			local anims = list.Get( "PlayerOptionsAnimations" )

			local anim = default_animations[ math.random( 1, #default_animations ) ]
			if ( anims[ playermodel ] ) then
				anims = anims[ playermodel ]
				anim = anims[ math.random( 1, #anims ) ]
			end

			local iSeq = panel.Entity:LookupSequence( anim )
			if ( iSeq > 0 ) then panel.Entity:ResetSequence( iSeq ) end

		end
		--
		local m_w = w/2
		local m_ph = self.property:GetTall()
		local m_h = self.property:GetTall()
		self.model_d = vgui.Create( "DModelPanel", self.model )
		self.model_d:SetSize( m_w, m_h )
		self.model_d:SetPos( w/2 - 40, m_ph/2 - m_h/2 )
		self.model_d:SetModel( LocalPlayer():GetModel() )
		self.model_d.SetUpModel = function( model )
			local add = 23
			local ent = self.model_d.Entity
			ent:SetPos( Vector( -90, 0, -55 ) )
			self.model_d.Angles = Angle( 0, 0, 0 )
			self.model_d:SetLookAt( Vector( -100, 0, -22 ) )
			self.model_d:SetCamPos( Vector( 0, 0, 0 ) )
			self.model_d:SetFOV( 36 )
			self.model_d.bAnimated = true
		end
		
		self.model_d:SetCamPos( self.model_d:GetCamPos() + Vector( 0, 0, 6 ) )
		
		self.model_d.LayoutEntity = function( entity )
			if ( self.model_d.bAnimated ) then self.model_d:RunAnimation() end
			return
		end
		self.model_d:SetUpModel()
		
		self.model_scroll = vgui.Create( "DScrollPanel", self.model )
		self.model_scroll:SetSize( (w/2)-60 , m_h-35 )
		self.model_scroll:SetPos( 0, 0 )
		
		self.modellist = vgui.Create( "DIconLayout", self.model_scroll )
		self.modellist:SetPos( 2, 2 )
		self.modellist:SetSize( w/2 , m_h )
		self.modellist:SetSpaceX( 2 )
		self.modellist:SetSpaceY( 2 )
		for i = 1,#PlayerModels do
		
			local rankno = LocalPlayer():GetRankNumber()
			
			self.modeloption = self.modellist:Add( "SpawnIcon" ) //Add DPanel to the DIconLayout
			self.modeloption:SetSize( 80, 80 )
			self.modeloption:SetModel( PlayerModels[ i ][ 1 ] )
			self.modeloption.Model = PlayerModels[ i ][ 1 ]
			self.modeloption.DoClick = function()
				self.model_d:SetModel( PlayerModels[ i ][ 1 ] )
				self.model_d:SetUpModel( PlayerModels[ i ][ 1 ] )
				net.Start( "UpdatePlayerModel" )
					net.WriteString( PlayerModels[ i ][ 1 ] )
				net.SendToServer()
				surface.PlaySound( tostring(table.Random( ModelSounds )) )
				PlayPreviewAnimation( self.model_d, PlayerModels[ i ][ 1 ] )
			end
			if rankno < PlayerModels[ i ][ 2 ] then
				self.modeloption:SetDisabled( true )
			end
			local oldpaint = self.modeloption.PaintOver
			self.modeloption.PaintOver = function( mem, _w, _h)
				oldpaint( self.modeloption )
				
				if self.modeloption.Model == self.model_d.Entity:GetModel() then
					surface.SetFont("D_Smooth")
					local xsz, ysz = surface.GetTextSize( "SELECTED" )
					draw.AAText( "SELECTED" , "D_Smooth", _w/2 - xsz/2, _h/2 - ysz/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
				end
				
				if rankno < PlayerModels[ i ][ 2 ] then
					surface.SetDrawColor( Color( 0, 0, 0, 240 ) )
					surface.DrawRect( 0, 0, _w, _h )
					
					local locktext = "Unlocked at:"
					local lockrank = RANKS.LIST[PlayerModels[ i ][ 2 ]][ 1 ]
					
					surface.SetFont("D_Smooth")
					local xsz, ysz = surface.GetTextSize( locktext )
					draw.AAText( locktext , "D_Smooth", _w/2 - xsz/2, _h/2 - ysz/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
					
					local xsz2, ysz2 = surface.GetTextSize( lockrank )
					draw.AAText( lockrank , "D_Smooth", _w/2 - xsz2/2, _h/2 - ysz/2 + ysz2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
				end
			end
			
		end
		
		--
	self.property:AddSheet( "Primary Weapon", self.primary, "icon16/user.png", false, false, "Select your primary weapon." )
		
		--
		local prim_model = "weapon_ttt_m16"
		for k,v in pairs( weapons.GetList() ) do
			if v.ClassName == prim_model then
				prim_model = v.WorldModel
			end
		end
		self.prim_model = vgui.Create( "DModelPanel", self.primary )
		self.prim_model:SetSize( m_w, m_h )
		self.prim_model:SetPos( w/2 - 40, m_ph/2 - m_h/2 )
		self.prim_model:SetModel( prim_model )
		self.prim_model.SetUpModel = function( model )
			local add = 23
			local ent = self.prim_model.Entity
			ent:SetPos( Vector( -65,(ent:GetRenderBounds()/2), -17 ) )
			ent:SetAngles( Angle(0, 90, 0 ) )
			self.prim_model.Angles = Angle( 0, 0, 0 )
			self.prim_model:SetLookAt( Vector( -100, 0, -22 ) )
			self.prim_model:SetCamPos( Vector( 0, 0, 0 ) )
			self.prim_model:SetFOV( 36 )
		end
		
		self.prim_model.weapon = Primary_Weapons[ 1 ]
		
		self.prim_model.PaintOver = function( mem, _w, _h )
			surface.SetFont("D_SmoothL")
			local xsz2, ysz2 = surface.GetTextSize( self.prim_model.weapon[2] )
			draw.AAText( self.prim_model.weapon[2] , "D_SmoothL", _w/2 - xsz2/2, ysz2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
			
			if self.prim_model.weapon[4] then
				local damage = 	 self.prim_model.weapon[4].damage
				local accuracy = self.prim_model.weapon[4].accuracy
				local firerate = self.prim_model.weapon[4].firerate
				local clipsize = self.prim_model.weapon[4].clipsize
				
				local damagepos = {_w/8 - 29, _h - 170 - ysz2}
								
				surface.SetFont("D_SmoothL")
				local xsz, ysz = surface.GetTextSize( "Damage: " )
				draw.AAText( "Damage: " , "D_SmoothL", damagepos[1], damagepos[2], Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
				
				local stat_bar_w = (_w/8)*7 - xsz
				local bar_start_x = damagepos[1] + xsz + 12
				
				surface.SetDrawColor( Color( 0, 102, 255 ) )
				surface.DrawOutlinedRect( bar_start_x, damagepos[2] + ysz/4, stat_bar_w, 15 )
				surface.DrawRect( bar_start_x, damagepos[2] + ysz/4, stat_bar_w*(damage/10), 15 )
				
				local xsz, ysz = surface.GetTextSize( "Firerate: " )
					
				local fireratepos = {_w/8 - 29, _h - 145 - ysz2}
				
				local xsz, ysz = surface.GetTextSize( "Firerate: " )
				draw.AAText( "Firerate: " , "D_SmoothL", fireratepos[1], fireratepos[2], Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
				
				surface.SetDrawColor( Color( 0, 102, 255 ) )
				surface.DrawOutlinedRect( bar_start_x, fireratepos[2] + ysz/4, stat_bar_w, 15 )
				surface.DrawRect( bar_start_x, fireratepos[2] + ysz/4, stat_bar_w*(firerate/10), 15 )
				
				local xsz, ysz = surface.GetTextSize( "Accuracy: " )
					
				local accuracypos = {_w/8 - 29, _h - 120 - ysz2}
				draw.AAText( "Accuracy: " , "D_SmoothL",accuracypos[1], accuracypos[2], Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
				
				surface.SetDrawColor( Color( 0, 102, 255 ) )
				surface.DrawOutlinedRect( bar_start_x, accuracypos[2] + ysz/4, stat_bar_w, 15 )
				surface.DrawRect( bar_start_x, accuracypos[2] + ysz/4, stat_bar_w*(accuracy/10), 15 )
				
				local xsz, ysz = surface.GetTextSize( "Clip Size: "..clipsize )
					
				local clippos = {_w/8 - 29, _h - 95 - ysz2}
				draw.AAText( "Clip Size: "..clipsize , "D_SmoothL",clippos[1], clippos[2], Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
				
			end
		end
		
		self.prim_model:SetCamPos( self.prim_model:GetCamPos() + Vector( 0, 0, 6 ) )
		
		self.prim_model.LayoutEntity = function( entity )
			return
		end
		self.prim_model:SetUpModel()
		
		self.prim_scroll = vgui.Create( "DScrollPanel", self.primary )
		self.prim_scroll:SetSize( (w/2)-60 , m_h-35 )
		self.prim_scroll:SetPos( 0, 0 )
		
		self.primlist = vgui.Create( "DIconLayout", self.prim_scroll )
		self.primlist:SetPos( 2, 2 )
		self.primlist:SetSize( w/2 , m_h )
		self.primlist:SetSpaceX( 2 )
		self.primlist:SetSpaceY( 2 )
		
		for i = 1,#Primary_Weapons do
		
			local rankno = LocalPlayer():GetRankNumber()
			
			self.primoption = self.primlist:Add( "SpawnIcon" ) //Add DPanel to the DIconLayout
			self.primoption:SetSize( 80, 80 )
			self.primoption:SetModel( GetModel( Primary_Weapons[ i ][ 1 ] ) )
			self.primoption.DoClick = function()
				self.prim_model:SetModel( GetModel( Primary_Weapons[ i ][ 1 ] ) )
				self.prim_model:SetUpModel( GetModel( Primary_Weapons[ i ][ 1 ] ) )
				self.prim_model.weapon = Primary_Weapons[ i ]
				net.Start( "UpdatePrimary" )
					net.WriteString( Primary_Weapons[ i ][ 1 ] )
				net.SendToServer()
				surface.PlaySound("buttons/weapon_confirm.wav")
			end
			if rankno < Primary_Weapons[ i ][ 3 ] then
				self.primoption:SetDisabled( true )
			end
			
			local oldpaint = self.primoption.PaintOver
			self.primoption.PaintOver = function( mem, _w, _h)
				oldpaint( self.primoption )
				
				if self.prim_model.weapon == Primary_Weapons[ i ] then
					surface.SetFont("D_Smooth")
					local xsz, ysz = surface.GetTextSize( "SELECTED" )
					draw.AAText( "SELECTED" , "D_Smooth", _w/2 - xsz/2, _h/2 - ysz/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
				end
				
				if rankno < Primary_Weapons[ i ][ 3 ] then
					surface.SetDrawColor( Color( 0, 0, 0, 240 ) )
					surface.DrawRect( 0, 0, _w, _h )
					
					local locktext = "Unlocked at:"
					local lockrank = RANKS.LIST[Primary_Weapons[ i ][ 3 ]][ 1 ]
					
					surface.SetFont("D_Smooth")
					local xsz, ysz = surface.GetTextSize( locktext )
					draw.AAText( locktext , "D_Smooth", _w/2 - xsz/2, _h/2 - ysz/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
					
					local xsz2, ysz2 = surface.GetTextSize( lockrank )
					draw.AAText( lockrank , "D_Smooth", _w/2 - xsz2/2, _h/2 - ysz/2 + ysz2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
				end
			end
			
		end
		
		--
		
	self.property:AddSheet( "Secondary Weapon", self.secondary, "icon16/user.png", false, false, "Select your secondary weapon." )
	
	--
		local prim_model = "weapon_zm_pistol"
		for k,v in pairs( weapons.GetList() ) do
			if v.ClassName == prim_model then
				prim_model = v.WorldModel
			end
		end
		self.secn_model = vgui.Create( "DModelPanel", self.secondary )
		self.secn_model:SetSize( m_w, m_h )
		self.secn_model:SetPos( w/2 - 40, m_ph/2 - m_h/2 )
		self.secn_model:SetModel( prim_model )
		self.secn_model.SetUpModel = function( model )
			local add = 23
			local ent = self.secn_model.Entity
			ent:SetPos( Vector( -30, -2, -7 ) )
			ent:SetAngles( Angle(0, 90, 0 ) )
			self.secn_model.Angles = Angle( 0, 0, 0 )
			self.secn_model:SetLookAt( Vector( -100, 0, -22 ) )
			self.secn_model:SetCamPos( Vector( 0, 0, 0 ) )
			self.secn_model:SetFOV( 36 )
		end
		
		self.secn_model.weapon = Secondary_Weapons[ 1 ]
		
		self.secn_model.PaintOver = function( mem, _w, _h )
			surface.SetFont("D_SmoothL")
			local xsz2, ysz2 = surface.GetTextSize( self.secn_model.weapon[2] )
			draw.AAText( self.secn_model.weapon[2] , "D_SmoothL", _w/2 - xsz2/2, ysz2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
			
			if self.secn_model.weapon[4] then
				local damage = 	 self.secn_model.weapon[4].damage
				local accuracy = self.secn_model.weapon[4].accuracy
				local firerate = self.secn_model.weapon[4].firerate
				local clipsize = self.secn_model.weapon[4].clipsize
				
				local damagepos = {_w/8 - 29, _h - 170 - ysz2}
								
				surface.SetFont("D_SmoothL")
				local xsz, ysz = surface.GetTextSize( "Damage: " )
				draw.AAText( "Damage: " , "D_SmoothL", damagepos[1], damagepos[2], Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
				
				local stat_bar_w = (_w/8)*7 - xsz
				local bar_start_x = damagepos[1] + xsz + 12
				
				surface.SetDrawColor( Color( 0, 102, 255 ) )
				surface.DrawOutlinedRect( bar_start_x, damagepos[2] + ysz/4, stat_bar_w, 15 )
				surface.DrawRect( bar_start_x, damagepos[2] + ysz/4, stat_bar_w*(damage/10), 15 )
				
				local xsz, ysz = surface.GetTextSize( "Firerate: " )
					
				local fireratepos = {_w/8 - 29, _h - 145 - ysz2}
				
				local xsz, ysz = surface.GetTextSize( "Firerate: " )
				draw.AAText( "Firerate: " , "D_SmoothL", fireratepos[1], fireratepos[2], Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
				
				surface.SetDrawColor( Color( 0, 102, 255 ) )
				surface.DrawOutlinedRect( bar_start_x, fireratepos[2] + ysz/4, stat_bar_w, 15 )
				surface.DrawRect( bar_start_x, fireratepos[2] + ysz/4, stat_bar_w*(firerate/10), 15 )
				
				local xsz, ysz = surface.GetTextSize( "Accuracy: " )
					
				local accuracypos = {_w/8 - 29, _h - 120 - ysz2}
				draw.AAText( "Accuracy: " , "D_SmoothL",accuracypos[1], accuracypos[2], Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
				
				surface.SetDrawColor( Color( 0, 102, 255 ) )
				surface.DrawOutlinedRect( bar_start_x, accuracypos[2] + ysz/4, stat_bar_w, 15 )
				surface.DrawRect( bar_start_x, accuracypos[2] + ysz/4, stat_bar_w*(accuracy/10), 15 )
				
				local xsz, ysz = surface.GetTextSize( "Clip Size: "..clipsize )
					
				local clippos = {_w/8 - 29, _h - 95 - ysz2}
				draw.AAText( "Clip Size: "..clipsize , "D_SmoothL",clippos[1], clippos[2], Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
				
			end
		end
		
		self.secn_model:SetCamPos( self.secn_model:GetCamPos() + Vector( 0, 0, 6 ) )
		
		self.secn_model.LayoutEntity = function( entity )
			return
		end
		self.secn_model:SetUpModel()
		
		self.secn_scroll = vgui.Create( "DScrollPanel", self.secondary )
		self.secn_scroll:SetSize( (w/2)-60 , m_h-35 )
		self.secn_scroll:SetPos( 0, 0 )
		
		self.secnlist = vgui.Create( "DIconLayout", self.secn_scroll )
		self.secnlist:SetPos( 2, 2 )
		self.secnlist:SetSize( w/2 , m_h )
		self.secnlist:SetSpaceX( 2 )
		self.secnlist:SetSpaceY( 2 )
		
		for i = 1,#Secondary_Weapons do
		
			local rankno = LocalPlayer():GetRankNumber()
			
			self.secnoption = self.secnlist:Add( "SpawnIcon" ) //Add DPanel to the DIconLayout
			self.secnoption:SetSize( 80, 80 )
			self.secnoption:SetModel( GetModel( Secondary_Weapons[ i ][ 1 ] ) )
			self.secnoption.DoClick = function()
				self.secn_model:SetModel( GetModel( Secondary_Weapons[ i ][ 1 ] ) )
				self.secn_model:SetUpModel( GetModel( Secondary_Weapons[ i ][ 1 ] ) )
				self.secn_model.weapon = Secondary_Weapons[ i ]
				net.Start( "UpdateSecondary" )
					net.WriteString( Secondary_Weapons[ i ][ 1 ] )
				net.SendToServer()
				surface.PlaySound("buttons/weapon_confirm.wav")
			end
			if rankno < Secondary_Weapons[ i ][ 3 ] then
				self.secnoption:SetDisabled( true )
			end
			
			local oldpaint = self.secnoption.PaintOver
			self.secnoption.PaintOver = function( mem, _w, _h)
				oldpaint( self.secnoption )
				
				if self.secn_model.weapon == Secondary_Weapons[ i ] then
					surface.SetFont("D_Smooth")
					local xsz, ysz = surface.GetTextSize( "SELECTED" )
					draw.AAText( "SELECTED" , "D_Smooth", _w/2 - xsz/2, _h/2 - ysz/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
				end
				
				if rankno < Secondary_Weapons[ i ][ 3 ] then
					surface.SetDrawColor( Color( 0, 0, 0, 240 ) )
					surface.DrawRect( 0, 0, _w, _h )
					
					local locktext = "Unlocked at:"
					local lockrank = RANKS.LIST[Secondary_Weapons[ i ][ 3 ]][ 1 ]
					
					surface.SetFont("D_Smooth")
					local xsz, ysz = surface.GetTextSize( locktext )
					draw.AAText( locktext , "D_Smooth", _w/2 - xsz/2, _h/2 - ysz/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
					
					local xsz2, ysz2 = surface.GetTextSize( lockrank )
					draw.AAText( lockrank , "D_Smooth", _w/2 - xsz2/2, _h/2 - ysz/2 + ysz2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
				end
			end
			
		end
	--
	
	self.property:AddSheet( "Perks", self.perks, "icon16/user.png", false, false, "Select your perk." )
	--
	
		local w,h = m_w*2, m_h
		local ysz = 200
		self.perk_scroll = vgui.Create( "DScrollPanel", self.perks )
		self.perk_scroll:SetSize( w-15, ysz )
		self.perk_scroll:SetPos( 0, h - ysz-40  )
		
		local gap = 20
		print( gap )
		self.perklist = vgui.Create( "DIconLayout", self.perk_scroll )
		self.perklist:SetPos( gap, 0 ) 
		self.perklist:SetSize( w - gap*2 , ysz )
		self.perklist:SetSpaceX( 2 )
		self.perklist:SetSpaceY( 2 )
		
		local _perks = GetPerkList()
		for k,p in pairs( _perks ) do
			local perk_op = self.perklist:Add( "DImageButton" )
			--perk_op:SetImage( p[ 3 ] )
			perk_op:SetSize( 80, 80 )
			perk_op.name = k
			perk_op.desc = CutUpString( p[ 2 ], 35 )

			if p[4] > LocalPlayer():GetRankNumber() then perk_op:SetDisabled( true ) end

			perk_op.Paint = function( mem, _w, _h )
				if p[4] > LocalPlayer():GetRankNumber() then
					surface.SetDrawColor( Color( 88, 88, 88, 88 ) )
					surface.DrawRect( 0, 0, _w, _h )

					local locktext = "Unlocked at:"
					local unlockrank = RANKS.LIST[ p[ 4 ] ][ 1 ]

					surface.SetFont( "D_Smooth" )
					local xsz2, ysz2 = surface.GetTextSize( locktext )
					draw.AAText( locktext, "D_Smooth", _w/2 - xsz2/2, _h/2 - ysz2/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

					local xsz2, ysz2 = surface.GetTextSize( unlockrank )
					draw.AAText( unlockrank, "D_Smooth", _w/2 - xsz2/2, _h/2 + ysz2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
				else
					surface.SetDrawColor( Color( 88, 88, 88, 88 ) )
					surface.DrawRect( 0, 0, _w, _h )

					surface.SetFont( "D_Smooth" )
					local xsz2, ysz2 = surface.GetTextSize( perk_op.name )
					draw.AAText( perk_op.name, "D_Smooth", _w/2 - xsz2/2, _h/2 - ysz2/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
				end
			end

			perk_op.DoClick = function()
				self.perks.name = perk_op.name
				self.perks.desc = perk_op.desc
				self.perks.image = Material( p[ 3 ] )
				local _p = p
				_p[ 6 ] = nil
				net.Start( "UpdatePerk" )
					net.WriteTable( _p )
				net.SendToServer()
			end
		end
		
		local xsz,ysz = 150,150
		self.perks.Paint = function( mem, _w, _h)
			surface.SetDrawColor( 22, 22, 22, 255 )
			surface.DrawRect( 0, 0, w, h )
			if self.perks.name then
				surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
				surface.SetMaterial( self.perks.image )
				--surface.DrawTexturedRect( w/5 - xsz/2, h/4 + 15 - ysz/2, xsz, ysz )


				surface.SetFont( "D_Smooth" )
				local xsz2, ysz2 = surface.GetTextSize( self.perks.name )
				draw.AAText( self.perks.name, "D_Smooth",  w/5 - xsz2/2, h/4 + 15 - ysz/4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
				
				surface.SetFont( "D_SmoothL" )
				local xsz2, ysz2 = surface.GetTextSize( self.perks.name )
				draw.AAText( self.perks.name , "D_SmoothL", w/5 - xsz2/2, h/4 + 15 - ysz/2 - ysz2*2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
				
				for i = 1,#self.perks.desc do
					surface.SetFont( "D_SmoothL" )
					local xsz2, ysz2 = surface.GetTextSize( self.perks.desc[ i ] )
					draw.AAText( self.perks.desc[ i ] , "D_SmoothL", w/5 + xsz/2 + 5,h/4 + 15 - ysz2/2 + 18*(i-1), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
				end
			end
		end
		
	
	--

end

local head_h = 7
function PANEL:Paint(w,h)

	local speed = 300/(1/FrameTime())*5
	surface.SetDrawColor(Color(22,22,22,245))
	surface.DrawRect(0,0,w,self.Draw_H)
	
	surface.SetDrawColor(Color(0,102,255,255))
	surface.DrawRect(0,h/10,self.Head_W,head_h)
	
	self.Draw_H = math.Approach(self.Draw_H, h, speed)
	self.Head_W = math.Approach(self.Head_W, (self.Draw_H == h and w or 0), speed)
	
end

vgui.Register( "DiscreteF3", PANEL, "DFrame" )

concommand.Add("discrete_menu",function()
	local menu = vgui.Create("DiscreteF3")
end)