
function surface.PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness,bClockwise)
	local triarc = {}
	local deg2rad = math.pi / 180
	
	-- Correct start/end ang
	local startang,endang = startang or 0, endang or 0
	if bClockwise and (startang < endang) then
		local temp = startang
		startang = endang
		endang = temp
		temp = nil
	elseif (startang > endang) then 
		local temp = startang 
		startang = endang
		endang = temp
		temp = nil
	end
	
	
	-- Define step
	local roughness = math.max(roughness or 1, 1)
	local step = roughness
	if bClockwise then
		step = math.abs(roughness) * -1
	end
	
	
	-- Create the inner circle's points.
	local inner = {}
	local r = radius - thickness
	for deg=startang, endang, step do
		local rad = deg2rad * deg
		table.insert(inner, {
			x=cx+(math.cos(rad)*r),
			y=cy+(math.sin(rad)*r)
		})
	end
	
	
	-- Create the outer circle's points.
	local outer = {}
	for deg=startang, endang, step do
		local rad = deg2rad * deg
		table.insert(outer, {
			x=cx+(math.cos(rad)*radius),
			y=cy+(math.sin(rad)*radius)
		})
	end
	
	
	-- Triangulate the points.
	for tri=1,#inner*2 do -- twice as many triangles as there are degrees.
		local p1,p2,p3
		p1 = outer[math.floor(tri/2)+1]
		p3 = inner[math.floor((tri+1)/2)+1]
		if tri%2 == 0 then --if the number is even use outer.
			p2 = outer[math.floor((tri+1)/2)]
		else
			p2 = inner[math.floor((tri+1)/2)]
		end
	
		table.insert(triarc, {p1,p2,p3})
	end
	
	-- Return a table of triangles to draw.
	return triarc
	
end

function surface.DrawArc(arc)
	for k,v in ipairs(arc) do
		surface.DrawPoly(v)
	end
end

function draw.Arc(cx,cy,radius,thickness,startang,endang,roughness,color,bClockwise)
	surface.SetDrawColor(color)
	surface.DrawArc(surface.PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness,bClockwise))
end


timer.Simple(5, function()
	local table = table
	local surface = surface
	local draw = draw
	local math = math
	local string = string
	local GetLang = LANG.GetUnsafeLanguageTable


	paraHud = {};

	paraHud.SUPER_SIZE = 0.05/2;			-- 3D Hud Scale (Def: 0.05)
	paraHud.SUPER_DISTANCE = 13;			-- 3D Hud Distance (Def: 25)
	paraHud.SUPER_ANGLE = 15;				-- 3D Hud Angle (Def: 20)

	paraHud.SUPER_COLOR = Color(229, 178, 85, 255);

	paraHud.ScreenWidth = 1920;
	paraHud.ScreenHeight = 1080;
	paraHud.ScreenFOV = 0;

	timer.Create("CheckHUDRatio", 1, 0, function()
		if ScrW() != paraHud.ScreenWidth then
			local multx = ScrW()/paraHud.ScreenWidth
			local multy = ScrH()/paraHud.ScreenHeight
			paraHud.ScreenWidth = ScrW()
			paraHud.ScreenHeight = ScrH()
			paraHud.SUPER_DISTANCe = multx
		end
	end)

	function DrawCross( x, y, w, h )
		surface.DrawRect( x - w/2, y - h/2, w, h)
		surface.DrawRect( x - h/2, y - w/2, h, w) 
	end

	surface.CreateFont( "HUD_Smooth", { font = "Arkitech Light", size = 16, weight = 500, antialias = true } )
	surface.CreateFont( "HUD_SmoothSmall", { font = "Arkitech Light", size = 20, weight = 450, antialias = true } )
	surface.CreateFont( "HUD_SmoothSSmall", { font = "Arkitech Light", size = 15, weight = 350, antialias = true } )
	surface.CreateFont( "HUD_SmoothSSSmall", { font = "Arkitech Light", size = 14, weight = 350, antialias = true } )
	surface.CreateFont( "HUD_SmoothSSSSmall", { font = "Arkitech Light", size = 11, weight = 350, antialias = true } )
	function draw.AAText( text, font, x, y, color, align )

		draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,math.min(color.a,120)), align )
		draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,math.min(color.a,50)), align )
		draw.SimpleText( text, font, x+2, y+1, Color(0,0,0,255), align )
		draw.SimpleText( text, font, x-2, y+1, Color(0,0,0,255), align )
		draw.SimpleText( text, font, x, y, color, align )

	end
	
	local res_add = 0
	if ScrW() <= 1024 then
		res_add = 150
	end

	local x = 70 + res_add
	local y = 50
	local w = 220
	local w_bg = 101
	local h = 25

	local c_x = x-45 
	local c_y = y+h/2 -1
	local c_w = 2
	local c_h = 10

	local xp_x = x-1
	local xp_y = y+h+3
	local xp_w = w
	local xp_h = 12
	
	local xp_bar_w = xp_w - 40
	local xp_bar_x = xp_x + 40

	local hp_bg_add = 60
	local hp_bar_bg = 
	{
		{x = x+7 - hp_bg_add, y = y },
		{x = x + w + 9, y = y },
		{x = x + w + 1, y = y+h},
		{x = x-1 - hp_bg_add, y = y+h }
	}

	local hp_bar = 
	{
		{x = x+8, y = y },
		{x = x + w + 8, y = y },
		{x = x + w, y = y+h},
		{x = x, y = y+h }
	}

	local l = 4
	local state_bar =  {
		{x = x - hp_bg_add + l*2 + 3, y = y-h/2},
		{x = x + hp_bg_add + l*2 + 4, y = y-h/2},
		{x = x + hp_bg_add + l + 4, y = y-2},
		{x = x + l - hp_bg_add + 3, y = y-2}
	}
	
	local l = 4
	local t_x = x + hp_bg_add + l*2 + 4
	local t_w = w - hp_bg_add - l*2 + 3
	
	local time_bar =  {
		{x = t_x, y = y-h/2},
		{x = t_x + (w - hp_bg_add - l + 3), y = y-h/2},
		{x = t_x + (w - hp_bg_add - l*2 + 3), y = y-2},
		{x = t_x - l, y = y-2}
	}
		
		

	local l = 4
	local xp_bar_add = 60
	local xp_bar_add2 = 30
	
	local xp_bar_add_t = 
	{
		{x = xp_x - xp_bar_add, y = xp_y},
		{x = xp_bar_x + l - 6, y = xp_y },
		{x = xp_bar_x - 6, y = xp_y + xp_h},
		{x = xp_x-l - xp_bar_add, y = xp_y + xp_h }
	}
	
	local xp_bar_bg = 
	{
		{x = xp_bar_x, y = xp_y},
		{x = xp_bar_x + xp_w + l - 40, y = xp_y },
		{x = xp_bar_x + xp_w - 40, y = xp_y + xp_h},
		{x = xp_bar_x-l, y = xp_y + xp_h }
	}

	local ammo_x = 50 - res_add/2
	local ammo_y = 25
	local ammo_w = w
	local ammo_h = h+5

	local l2 = 8
	local ammo_bar_add = 80
 
	local ammo_bar_bg = 
	{
		{x = ammo_x - l2, y = ammo_y},
		{x = ammo_x + ammo_w - l + ammo_bar_add, y = ammo_y},
		{x = ammo_x + ammo_w + ammo_bar_add, y = ammo_y + ammo_h },
		{x = ammo_x, y = ammo_y + ammo_h }
	}


	local lastpos = {}

	function DrawSegmentBar2( x, y, full_w, w, h, t, l, g)
		local segs = math.Round( w/t )
		local segs_real = math.ceil( w/t )
		local r = w/t - segs
		print( r )
		for i = 1,segs_real do
		 
			if r > 0 and i == segs_real then
				local w_2 = w*r
				local s = x + (w/segs)*(i-1) + g
				local bar =
				{ 
					{x = s + l, y = y },
					{x = s + (w_2/segs) + l - (g*2), y = y },
					{x = s + (w_2/segs) - (g*2), y = y + h },
					{x = s, y = y + h}
				}
				surface.DrawPoly( bar )
			else
				local s = x + (w/segs)*(i-1) + g
				local bar =
				{ 
					{x = s + l, y = y },
					{x = s + (w/segs) + l - (g*2), y = y },
					{x = s + (w/segs) - (g*2), y = y + h },
					{x = s, y = y + h}
				}
				surface.DrawPoly( bar )
			end
			
		end
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

	function DrawSegmentBarReverse( x, y, full_w, w, h, t, l, g)
		local g = 0.5
		local segs = math.Round( full_w/t )
		local segs_real = math.ceil( w/t )
		local r = w/t - segs
		for i = 1,math.ceil(segs*(w/full_w)) do
			local s = x + (full_w/segs)*((i-1)*-1) + g
			local bar =
			{ 
				{x = s - l, y = y },
				{x = s + (full_w/segs) - l - (g*2), y = y },
				{x = s + (full_w/segs) - (g*2), y = y + h },
				{x = s, y = y + h}
			}
			surface.DrawPoly( bar )
		end
	end

	function math.loop( num, min, max )
		num = num + 1
		if num > max then
			num = min
		end
	return num
	end

	local col_r = 1
	local col_phase = 1
	local col_speed = 0.6

	local bg_colors = {
	   background_main = Color(0, 0, 10, 200),

	   noround = Color(100,100,100,255),
	   traitor = Color(200, 25, 25, 255),
	   innocent = Color(25, 200, 25, 255),
	   detective = Color(25, 25, 200, 255)
	};


	local roundstate_string = {
	   [ROUND_WAIT]   = "round_wait",
	   [ROUND_PREP]   = "round_prep",
	   [ROUND_ACTIVE] = "round_active",
	   [ROUND_POST]   = "round_post"
	};

	function DrawHP( ply, pos, ang, scale)
		
		local L = GetLang()
		local hp = math.Round(ply.drawhealth)
		local hp_w = (math.Round(ply.drawhealth)/ply:GetMaxHealth())*w
		cam.Start3D2D( pos, ang, scale )
				
			draw.NoTexture()
											
			surface.SetDrawColor(Color(22,22,22,255))
			surface.DrawPoly( hp_bar_bg )
			surface.DrawPoly( xp_bar_bg )
			surface.DrawPoly( xp_bar_add_t )
			surface.SetDrawColor(Color(0,175,255))
			
			local xp_p = ply:GetXPPercentage()
			DrawSegmentBar( xp_bar_x, xp_y+1, xp_bar_w, xp_bar_w*xp_p, xp_h-2, 2.5, 3, 0.1)


			if hp_w < 20 then
				if col_phase == 1 then
					col_r = math.Approach( col_r, 235, (300/FrameTime()*60)*col_speed )
					if col_r == 235 then
						col_phase = 2
					end
				elseif col_phase == 2 then
					col_r = math.Approach( col_r, 0, col_speed )
					if col_r == 0 then
						col_phase = 1
					end
				end
				local col_mult = (col_r/235)*102
				local col_mult2 = (col_r/235)*255
				surface.SetDrawColor(Color(col_r, 102 - col_mult, 255 - col_mult2,255))
			else
				surface.SetDrawColor(Color(0,102,255,255))
			end
			DrawSegmentBar( x, y, w, hp_w, h, w/30, 8, 0.5)
			
			local col = bg_colors.innocent
			if GAMEMODE.round_state != ROUND_ACTIVE then
			  col = bg_colors.noround
			elseif ply:GetTraitor() then
			  col = bg_colors.traitor
			elseif ply:GetDetective() then
			  col = bg_colors.detective
			end
	   
			surface.SetDrawColor(col)
			surface.DrawPoly( state_bar )
			
			local round_state = GAMEMODE.round_state
			local text = nil
			if round_state == ROUND_ACTIVE then
			   text = L[ ply:GetRoleStringRaw() ]
			else
			   text = L[ roundstate_string[round_state] ]
			end
			surface.SetFont("HUD_SmoothSSSSmall")
			local xsz, ysz = surface.GetTextSize( text )
			draw.AAText( text, "HUD_SmoothSSSSmall", 25 + hp_bg_add*2/2 - xsz/2 - 3, y-h-1 + ysz*1.1, Color(255,255,255,255), TEXT_ALIGN_LEFT)
			
			surface.SetDrawColor( Color( 22, 22, 22, 255 ) )
			surface.DrawPoly( time_bar )
			
			local is_haste = HasteMode() and round_state == ROUND_ACTIVE
			local is_traitor = ply:IsActiveTraitor()

			local endtime = GetGlobalFloat("ttt_round_end", 0) - CurTime()

			local text
			local font = "HUD_SSSSmooth"
			local color = Color( 255, 255, 255, 255 )
			local rx = t_x
			local ry = -h-1

			-- Time displays differently depending on whether haste mode is on,
			-- whether the player is traitor or not, and whether it is overtime.
			if is_haste then
			  local hastetime = GetGlobalFloat("ttt_haste_end", 0) - CurTime()
			  if hastetime < 0 then
				 if (not is_traitor) or (math.ceil(CurTime()) % 7 <= 2) then
					-- innocent or blinking "overtime"
					text = L.overtime
					font = "Trebuchet18"

					-- need to hack the position a little because of the font switch
					ry = ry + 5
					rx = rx - 3
				 else
					-- traitor and not blinking "overtime" right now, so standard endtime display
					text  = util.SimpleTime(math.max(0, endtime), "%02i:%02i")
					color = Color(235,25,25,255)
				 end
			  else
				 -- still in starting period
				 local t = hastetime
				 if is_traitor and math.ceil(CurTime()) % 6 < 2 then
					t = endtime
					color = Color(235,25,25,255)
				 end
				 text = util.SimpleTime(math.max(0, t), "%02i:%02i")
			  end
			else
			  -- bog standard time when haste mode is off (or round not active)
			  text = util.SimpleTime(math.max(0, endtime), "%02i:%02i")
			end
			
			local t_xpos = t_x + t_w/2
			
			surface.SetFont("HUD_SmoothSSSSmall")
			local xsz, ysz = surface.GetTextSize( text )
			draw.AAText( text, "HUD_SmoothSSSSmall", t_xpos - xsz/2, y-h-1 + ysz*1.1, Color(255,255,255,255), TEXT_ALIGN_LEFT)

			surface.SetDrawColor(Color(0,102,255,255))
			DrawCross(c_x,c_y,c_w,c_h)

			surface.SetFont("HUD_Smooth")
			local xsz, ysz = surface.GetTextSize( hp )
			draw.AAText( hp, "HUD_Smooth", c_x + xsz/4, c_y -ysz/1.7, Color(255,255,255,255), TEXT_ALIGN_LEFT)
			
			local rank, _ = ply:GetRank()
			local xp_text_pos =  xp_x - xp_bar_add
			surface.SetFont("HUD_SmoothSSSSmall")
			local xsz, ysz = surface.GetTextSize( rank )
			draw.AAText( rank, "HUD_SmoothSSSSmall", xp_text_pos, xp_y, Color(255,255,255,255), TEXT_ALIGN_LEFT)

			local xp_amount = ply:GetXP().."/"..ply:GetNextRankXP()
			local xpsz, ysz = surface.GetTextSize( xp_amount )
			draw.AAText( xp_amount, "HUD_SmoothSSSSmall", xp_text_pos + 194 - xpsz/2 , xp_y , Color(0,255,0,255), TEXT_ALIGN_LEFT)
			
			local xp_text = tostring(math.Round(xp_p*100)).."%"
			
			surface.SetFont("HUD_SmoothSSmall")
			local xsz, ysz = surface.GetTextSize( xp_text )
			//draw.AAText( xp_text, "HUD_SmoothSSmall", xp_text_pos + xsz + 12, xp_y - ysz/4, Color(255,255,255,255), TEXT_ALIGN_LEFT)
			
		cam.End3D2D()
	end

	function DrawBullet( x, y, w, h, col )
		local arc_sz = w*0.5
		draw.Arc( x + arc_sz, y + arc_sz + 1, arc_sz, arc_sz, 180, 360, 5, col , true )
		surface.DrawRect( x, y + h/3, w, h/3*2 )
		surface.DrawRect( x, y + h*1.03, w, h*0.1)
		surface.DrawRect( x, y + h*1.03, w, h*0.1)
	end


	local bullet =
	 {
		x = ammo_x + ammo_w + ammo_bar_add - 20,
		y = ammo_y, 
		w = 12,
		h = 25
	}

	function DrawAmmo( ply, pos, ang, scale)
		local wep = ply:GetActiveWeapon()
		
		if not IsValid( wep ) then return end
		local clipsz = wep.Primary.ClipSize
		
		cam.Start3D2D( pos, ang, scale )
			
			if IsValid( wep ) then
			
				if clipsz > -1 then
				
					surface.SetDrawColor(Color(22,22,22,255))
					surface.DrawPoly( ammo_bar_bg  )
					
					surface.SetDrawColor(Color(255,215,13,255))
					DrawBullet( bullet.x, bullet.y, bullet.w, bullet.h, Color(255,215,13,255) )
					
					surface.SetDrawColor(Color(255,215,13,255))
					local new_w = ammo_w - 4
					local ammo_w_draw = wep:Clip1()/clipsz
					local ammo_seg_sz = math.Round(new_w/clipsz)
					DrawSegmentBarReverse( ammo_x + ammo_w - ammo_seg_sz - 2, ammo_y+2, new_w, ammo_w_draw*new_w, ammo_h-4, ammo_seg_sz, 6, g )
					
					local ammo_text = wep:Clip1().."/"..clipsz
					surface.SetFont("HUD_SmoothSSmall")
					local xsz, ysz = surface.GetTextSize( ammo_text )
					draw.AAText( ammo_text, "HUD_SmoothSSmall", bullet.x - xsz - 5, ammo_y, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					
					local ammo_text = "+"..wep:Ammo1()
					surface.SetFont("HUD_SmoothSSSmall")
					local xsz, ysz = surface.GetTextSize( ammo_text )
					draw.AAText( ammo_text, "HUD_SmoothSSSmall", bullet.x - xsz - 5, ammo_y+ysz, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				
				end
				
			end
		cam.End3D2D()
	end

	function DrawState( ply, pos, ang, scale)
		cam.Start3D2D( pos, ang, scale )
			surface.SetDrawColor( Color( 22, 22, 22, 200 ) )
			surface.DrawPoly( state_bg )
		cam.End3D2D()
	end

	hook.Add("HUDPaint","3D HUD", function()

		local ply = LocalPlayer()
		
		local plyAng = EyeAngles();
		local plyPos = EyePos();
 
		local pos = plyPos;
		local pos2 = plyPos;
		local pos3 = plyPos;
		local centerAng = Angle(plyAng.p, plyAng.y, 0);
		
		
		pos = pos + (centerAng:Forward()*paraHud.SUPER_DISTANCE)-(centerAng:Right()*(paraHud.SUPER_DISTANCE/1.1))-(centerAng:Up()*paraHud.SUPER_DISTANCE/3)
		pos2 = pos2 + (centerAng:Forward()*(paraHud.SUPER_DISTANCE*1.1))-(centerAng:Right()*-(paraHud.SUPER_DISTANCE/2.8))-(centerAng:Up()*paraHud.SUPER_DISTANCE/3)
		pos3 = pos3 + (centerAng:Forward()*paraHud.SUPER_DISTANCE)-(centerAng:Up()*paraHud.SUPER_DISTANCE/2.5)
		
		if not ply.campos or not ply.campos2 or not ply.campos3 then
			ply.campos = pos 
			ply.campos2 = pos 
			ply.campos3 = pos 
			ply.def_campos = pos
			ply.def_campos2 = pos
			ply.def_campos3 = pos
		else
			ply.campos = LerpVector( FrameTime()*8, ply.campos, pos )
			ply.campos2 = LerpVector( FrameTime()*8, ply.campos2, pos2 )
			ply.campos3 = LerpVector( FrameTime()*8, ply.campos3, pos3 )
			ply.def_campos = LerpVector( 0.99, ply.campos, pos )
			ply.def_campos2 = LerpVector( 0.99, ply.campos2, pos2 )
			ply.def_campos3 = LerpVector( 0.99, ply.campos3, pos3 )
		end

		centerAng:RotateAroundAxis( centerAng:Right(), 90 );
		centerAng:RotateAroundAxis( centerAng:Up(), -90 );

		local leftAng = Angle(centerAng.p, centerAng.y, centerAng.r);
		local rightAng = Angle(centerAng.p, centerAng.y, centerAng.r);

		leftAng:RotateAroundAxis( leftAng:Right(), paraHud.SUPER_ANGLE*-1.5 );
		rightAng:RotateAroundAxis( rightAng:Right(), paraHud.SUPER_ANGLE );

		local centerAngDown = Angle(plyAng.p, plyAng.y, 0);

		centerAngDown:RotateAroundAxis( centerAngDown:Right(), 45 );
		centerAngDown:RotateAroundAxis( centerAngDown:Up(), 90 );
 
		local leftAngUp = Angle(centerAngDown.p, centerAngDown.y, centerAngDown.r);
		local rightAngUp = Angle(centerAngDown.p, centerAngDown.y, centerAngDown.r);

		leftAngUp:RotateAroundAxis( leftAngUp:Right(), paraHud.SUPER_ANGLE*-1 );
		rightAngUp:RotateAroundAxis( rightAngUp:Right(), paraHud.SUPER_ANGLE ); 
		
		
		if not ply.drawhealth then
			ply.drawhealth = ply:Health()
		else
			ply.drawhealth = Lerp( FrameTime()*15, ply.drawhealth, ply:Health() )
		end
		
		cam.Start3D( EyePos(), EyeAngles() )
			//cam.IgnoreZ( true )
				local ob = ply:GetObserverTarget()
				if IsValid( ob ) and ob:IsPlayer() and ob:Alive() then
					--ply = ob
				end
				DrawHP( ply, ply.def_campos, leftAng, 0.02 )
				DrawAmmo( ply, ply.def_campos2, rightAng, 0.02 )
			//cam.IgnoreZ( false )
		cam.End3D()
		
	end)
end)
