local misses = {}


surface.CreateFont( "Miss_Smooth", { font = "BudgetLabel", size = 18, weight = 700, antialias = true } )

net.Receive("SendMiss", function( len )
	local pos = net.ReadVector()
	local velr = 2
	local miss = {}
	miss.col = Color(225,25,25)
	miss.pos = pos
	miss.text = "Miss!"
	miss.life = 5
	miss.ttl = 5
	miss.vel = Vector(math.Rand(-velr,velr), math.Rand(-velr,velr), 1)
	
	surface.SetFont("Miss_Smooth")
	local w, h = surface.GetTextSize("Miss!")
	
	miss.widthH = w/2
	miss.heightH = h/2
	
	table.insert(misses, miss)
end)

local lastcurtime = CurTime()
hook.Add( "Tick", "Miss Update", function()

	local curtime = CurTime()
	local dt = curtime - lastcurtime
	lastcurtime = curtime
	
	// Update hit texts.
	for _, miss in pairs(misses) do
		
		miss.life = miss.life - dt
	
		--ind.vel.z = math.Min(ind.vel.z - 0.05, 2)
		miss.vel.z = miss.vel.z - 0.025
		
		miss.pos.x = miss.pos.x + miss.vel.x
		miss.pos.y = miss.pos.y + miss.vel.y
		miss.pos.z = miss.pos.z + miss.vel.z
		
	end
	
	// Check for and remove expired hit texts.
	local i = 1
	while i <= #misses do
		if misses[i].life < 0 then
			table.remove(misses, i)
		else
			i = i + 1
		end
	end
	
end )

hook.Add( "PostDrawTranslucentRenderables", "hdn_drawInds", function()
	if #misses == 0 then return end
	
	local observer = ( LocalPlayer():GetViewEntity() or LocalPlayer() )
	local ang = observer:EyeAngles()
	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )
	ang = Angle( 0, ang.y, ang.r )
	
	local scale = 0.3
	
	surface.SetFont("Miss_Smooth")
	for _, miss in pairs(misses) do
		
		miss.col.a = (miss.life / miss.ttl) * 255
		surface.SetTextColor(miss.col)
		
		surface.SetTextPos(-miss.widthH, -miss.heightH)
		
		cam.Start3D2D(miss.pos, ang, scale)
			surface.DrawText(miss.text)
		cam.End3D2D()
	end
end)

net.Receive("SyncBonk",function(len)
	LocalPlayer().Bonked = false
	LocalPlayer().BonkView = 1
end)

hook.Add("CalcView", "Bonk View", function( ply, pos, ang  )
	if ply.Bonked then
		if not ply.BonkView then
			ply.BonkView = 1
		end
		
		local tr = util.QuickTrace( pos, ang:Forward()*-ply.BonkView, {ply} )
		
		local view = {}
		
		view.origin = tr.HitPos
		view.angles = ang
		view.fov = fov
		ply.BonkView = math.Clamp(ply.BonkView + 2, 1, 200 )
		return GAMEMODE:CalcView( ply, view.origin, view.angles, view.fov )
	else
		if not ply.BonkView then
			ply.BonkView = 1
		end
		
		if ply.BonkView > 1 then
		
		local tr = util.QuickTrace( pos, ang:Forward()*-ply.BonkView, {ply} )
		
		local view = {}
		
		view.origin = tr.HitPos
			view.angles = ang
			view.fov = fov
			ply.BonkView = math.Clamp(ply.BonkView - 2, 1, 200 )
			return GAMEMODE:CalcView( ply, view.origin, view.angles, view.fov )
			
		end
	end
end)

hook.Add( "ShouldDrawLocalPlayer", "MyShouldDrawLocalPlayer", function( ply )
	if ply.Bonked == false and ply.BonkView == 1 or ply.Bonked == nil and ply.BonkView == 1  then
		return false
	end
return true
end )

