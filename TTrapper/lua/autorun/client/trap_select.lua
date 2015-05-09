
local PANEL = {}

function PANEL:Init()

	local function FixModel( mdlpnl )
		if IsValid(mdlpnl.Entity) then
			local PrevMins, PrevMaxs = mdlpnl.Entity:GetRenderBounds()
			mdlpnl:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.5, 0.5, 0.5))
			mdlpnl:SetLookAt((PrevMaxs + PrevMins) / 2)
			mdlpnl.LayoutEntity = function( ent )
			end
		end
	end
	
	self:SetSize( 500, 355 )
	self:SetBackgroundBlur( true )
	self:SetTitle( "Select a Trap!" )
	self:MakePopup()
	self:Center()
	
	local dart_trap = vgui.Create( "DCollapsibleCategory", self )
	dart_trap:SetPos( 5, 25 )
	dart_trap:SetSize( self:GetWide() - 10, self:GetTall() - 10 )
	dart_trap:SetExpanded(0)
	dart_trap:SetLabel( "Dart Trap" )
	
	local dart_info = vgui.Create( "DPanelList" )
	dart_info:SetAutoSize( true )
	dart_info:SetSpacing( 5 )
	dart_info:EnableHorizontal( false )
	dart_info:EnableVerticalScrollbar( true )
	
	dart_trap:SetContents( dart_info )
	
	local dart_name = vgui.Create( "DLabel" )
	dart_name:SetText("Name: Dart Trap")
	dart_name:SizeToContents()
	dart_info:AddItem( dart_name )

	
	local dart_desc = vgui.Create( "DLabel" )
	dart_desc:SetText("Description: Allows the user to place a trigger and a launcher.\nWhen a player steps on the trigger, a dart will be fired. It has a 20 second reload, meaning it works\nmore than once.")
	dart_desc:SizeToContents()
	dart_info:AddItem( dart_desc )
	
	local dart_select = vgui.Create( "DButton" )
	dart_select:SetText("Select Trap!")
	dart_select.DoClick = function()
		net.Start("SelectTrap")
		net.WriteInt( 1, 8 )
		net.SendToServer()
		self:Close()
	end
	dart_info:AddItem( dart_select )

	
	

	
	local bear_trap = vgui.Create( "DCollapsibleCategory", self)
	bear_trap:SetPos( 5, 130)
	bear_trap:SetSize( self:GetWide() - 10, self:GetTall() - 10 )
	bear_trap:SetExpanded(0)
	bear_trap:SetLabel( "Bear Trap" )
	
	local bear_info = vgui.Create( "DPanelList" )
	bear_info:SetAutoSize( true )
	bear_info:SetSpacing( 5 )
	bear_info:EnableHorizontal( false )
	bear_info:EnableVerticalScrollbar( true )
	
	bear_trap:SetContents( bear_info )
	
	local bear_name = vgui.Create( "DLabel" )
	bear_name:SetText("Name: Bear Trap")
	bear_name:SizeToContents()
	bear_info:AddItem( bear_name )

	
	local bear_desc = vgui.Create( "DLabel" )
	bear_desc:SetText("Description: The user places down the trap and waits for the unsuspecting victim to step on it. Upon\nstanding on the trap the victim will take a small amount of damage and become imobile, they will\ncontinue to take an additonal two damage per second untill someone releases them from the trap.")
	bear_desc:SizeToContents()
	bear_info:AddItem( bear_desc )
	
	local bear_select = vgui.Create( "DButton" )
	bear_select:SetText("Select Trap!")
	bear_select.DoClick = function()
		net.Start("SelectTrap")
		net.WriteInt( 2, 8 )
		net.SendToServer()
		self:Close()
	end
	bear_info:AddItem( bear_select )
	
	
	local tp_trap = vgui.Create( "DCollapsibleCategory", self)
	tp_trap:SetPos( 5, 235)
	tp_trap:SetSize( self:GetWide() - 10, self:GetTall() - 10 )
	tp_trap:SetExpanded(0)
	tp_trap:SetLabel( "Teleport Trap" )
	
	local tp_info = vgui.Create( "DPanelList" )
	tp_info:SetAutoSize( true )
	tp_info:SetSpacing( 5 )
	tp_info:EnableHorizontal( false )
	tp_info:EnableVerticalScrollbar( true )
	
	tp_trap:SetContents( tp_info )
	
	local tp_name = vgui.Create( "DLabel" )
	tp_name:SetText("Name: Teleport Trap")
	tp_name:SizeToContents()
	tp_info:AddItem( tp_name )

	
	local tp_desc = vgui.Create( "DLabel" )
	tp_desc:SetText("Description: This trap is rather unique, in the way that it deals no damage. Instead, it teleports the\nplayer to another location on the map. This is designed to be used to set up ambushes, it has a 20\nsecond recharge rate before it will TP players again. It is also the only trap that you and your fellow\ntraitors will be able to use.")
	tp_desc:SizeToContents()
	tp_info:AddItem( tp_desc )
	
	local tp_select = vgui.Create( "DButton" )
	tp_select:SetText("Select Trap!")
	tp_select.DoClick = function()
		net.Start("SelectTrap")
		net.WriteInt( 3, 8 )
		net.SendToServer()
		self:Close()
	end
	tp_info:AddItem( tp_select )

	
	
	
end



vgui.Register("TrapMenu", PANEL, "DFrame")

function TRAP_MENU()
    local TrapMenu = vgui.Create("TrapMenu")
end
concommand.Add( "trap_select", TRAP_MENU ) 

function FindEntsByClassTable( tbl )
	local FullTable = {}
	for i = 1,#tbl do
		local E = ents.FindByClass( tbl[i] )
		table.Add( FullTable, E )
	end
return FullTable
end

local TrapName = {}
TrapName["dart_trap"] 	= "Dart Trap"
TrapName["bear_trap"]	= "Bear Trap"
TrapName["tp_trap"] 	= "Teleport Trap"
TrapName["trap_trigger"] 	= "Dart Trigger"
TrapName["tp_entrance"] 	= "TP Entrance"
TrapName["tp_exit"] 	= "TP Exit"

surface.CreateFont( "trap_smooth", { font = "Trebuchet18", size = 18, weight = 700, antialias = true } )

function DrawTraps()
	/*
	if LocalPlayer():IsActiveTraitor() then
		local E = FindEntsByClassTable( {"dart_trap", "bear_trap", "tp_trap", "trap_trigger", "tp_entrance", "tp_exit"} )
		for k,v in pairs(E) do
			local pos = v:GetPos()
			local scrpos = ( pos + v:GetUp() * 10):ToScreen()
			local width,height = 100,50
			
			scrpos.x = math.Clamp(scrpos.x, width/2, ScrW() - width/2)
			scrpos.y = math.Clamp(scrpos.y, height/2, ScrH() - height/2)
			
			surface.SetDrawColor(Color(225,25,25,200))
			surface.DrawRect(scrpos.x - width/2,scrpos.y - height/2,width,height)
			
			surface.SetFont("trap_smooth")
			
			local w,h = surface.GetTextSize( TrapName[v:GetClass()] )
			
			surface.SetTextColor(Color(255,255,255,255))
			surface.SetTextPos(scrpos.x -w/2 , scrpos.y - h/2 )
			surface.DrawText(TrapName[v:GetClass()] )
			
		end
	end
	*/
end
hook.Add("HUDPaint", "Draw Traps", DrawTraps )
