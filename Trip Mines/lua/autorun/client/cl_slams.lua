
surface.CreateFont( "trap_smooth", { font = "Trebuchet18", size = 18, weight = 700, antialias = true } )

function DrawSlams()
	/* 
	if not IsValid(LocalPlayer()) then return end
	if LocalPlayer():IsTraitor() then
		local E = ents.FindByClass("ttt_slam")
		for k,v in pairs(E) do
			local pos = v:GetPos()
			local scrpos = ( pos ):ToScreen()
			local width,height = 110,50
			
			scrpos.x = math.Clamp(scrpos.x, width/2, ScrW() - width/2)
			scrpos.y = math.Clamp(scrpos.y, height/2, ScrH() - height/2)
			
			surface.SetDrawColor(Color(225,25,25,200))
			surface.DrawRect(scrpos.x - width/2,scrpos.y - height/2,width,height)
			
			surface.SetFont("trap_smooth")
			
			local w,h = surface.GetTextSize( "S.L.A.M. Mine" )
			
			surface.SetTextColor(Color(255,255,255,255))
			surface.SetTextPos(scrpos.x -w/2 , scrpos.y - h/2 )
			surface.DrawText("S.L.A.M. Mine")
			
		end
	end
	*/
end
hook.Add("HUDPaint", "Draw Slams", DrawSlams )

local laser = Material("cable/redlaser")
local dot = Material("lasersights/laserglow1")
function DrawSlamLasers()
	if not IsValid(LocalPlayer()) then return end
	for k,v in pairs(ents.FindByClass("ttt_slam")) do
		if IsValid(v) and v.On == true then
			local spos = v:GetPos() + v:GetRight()*-1.4 + v:GetForward()*-2.25
			local trd = {}
			trd.start = spos
			trd.endpos = spos + v:GetUp()*9000
			trd.filter = v
			trd.mask = MASK_SOLID
			trd.ignoreworld = false
			
			local tr = util.TraceLine(trd)
			
			render.SetMaterial(laser)
			render.DrawBeam(tr.StartPos, tr.HitPos, 3, 0, 0, Color(255,75,75,70))
			
			local rand = math.Rand(15,25)
			render.SetMaterial(dot)
			render.DrawSprite( tr.StartPos ,rand,rand, Color(255,0,0,255) )
		end
	end
end

hook.Add( "PostDrawTranslucentRenderables", "Slam Lasers", DrawSlamLasers )
