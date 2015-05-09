RXCar_Tuners = {}

function RXCar_Extensions_InitValue(Type)
	if Type == "number" then
		return 0
	end
	if Type == "color" then
		return Color(255,255,255,255)
	end
	if Type == "bool" then
		return true
	end
	
end

function TunerElement_CreateStruct(LuaName)
	local STR = {}
	STR.LuaName = LuaName
	STR.Max = 5
	
	STR.Vars = {}
	
	function STR:AddOnTunerPanel(TuneData,Panel,UID,Vars,FirstInit,DupeMotherVars)
		Vars = Vars or {}
		
		TuneData.Elements = TuneData.Elements or {}
				
		local function GenUniqueID()
			local Num = math.random(100000,999999)
			if TuneData.Elements[Num] then
				return GenUniqueID()
			else
				return Num
			end
		end
				
		local UID = UID or GenUniqueID()
		local Format = {}
		Format.Type = self.LuaName
		Format.UniqueID = UID
		Format.Vars = {}
				
		for a,b in pairs(self.Vars) do
			Format.Vars[b.LuaName] = Vars[b.LuaName] or RXCar_Extensions_InitValue(b.Type)
			
			if FirstInit then
				if self.Vars[b.LuaName].StartValue then
					Format.Vars[b.LuaName] = self.Vars[b.LuaName].StartValue
				end
			end
		end
			
		if DupeMotherVars then
			Format.Vars = table.Copy(DupeMotherVars)
		end
			
		TuneData.Elements[UID] = Format
		
		
		local BG = vgui.Create("RXCAR_DSWButton")
		BG:SetTall(20)
		BG:SetTexts(self.PrintName)
		BG.BoarderCol = Color(0,0,0,0)
		BG.PaintBackGround = function(slf)
			if Panel.SelectedButton == slf then
				surface.SetDrawColor( Color(0,50,150,100) )
				surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
			end
		end
				
		Panel.ElementList:AddItem(BG)
			
		function BG:OnMousePressed(MC)
			if MC == MOUSE_RIGHT then
				local Menu = DermaMenu()
				Menu:AddSpacer()
				Menu:AddOption("Duplicate",function(slf)
					Panel:DuplicateElement(UID)
				end):SetIcon( "icon16/brick_add.png" )
				
				Menu:AddSpacer()
				Menu:AddOption("Remove",function(slf)
					Panel.ToolList:Clear()
					TuneData.Elements[UID] = nil
					self:Remove()
				end):SetIcon( "icon16/cancel.png" )
				Menu:Open()
			end
			if MC == MOUSE_LEFT then
				self:LeftClicked()
			end
		end
			
		BG.LeftClicked = function(slf)
			Panel.SelectedButton = BG
			local List = Panel.ToolList
			List:Clear()
			
			local VarsOrder = {}
				for a,b in pairs(self.Vars) do
					table.insert(VarsOrder,b)
				end
			table.SortByMember(VarsOrder, "Order", function(a, b) return a > b end)
			
			if self.Editor_Spacer[0] then
				List:AddSubTitle(self.Editor_Spacer[0])
			end
			
			for a,b in pairs(VarsOrder) do
				local VarLuaName = b.LuaName
				
				if self.Vars[VarLuaName].Type == "number" then
					local Slider = List:CreateSlider(b.LuaName,self.Vars[VarLuaName].Min,self.Vars[VarLuaName].Max,self.Vars[VarLuaName].Decimal)
					
					Slider:SetValue(TuneData.Elements[UID].Vars[VarLuaName])
					Slider.OnValueChanged = function(slf,val)
						TuneData.Elements[UID].Vars[VarLuaName] = tonumber(val)
						Panel:ApplyTuneData2Preview(TuneData)
					end
					
				end
				if self.Vars[VarLuaName].Type == "color" then
					local color = vgui.Create( "DColorMixer");
					color:SetSize( List:GetWide(), 200);
					color.ValueChanged = function(slf,color)
						TuneData.Elements[UID].Vars[VarLuaName] = color
						Panel:ApplyTuneData2Preview(TuneData)
					end
					color:SetColor(TuneData.Elements[UID].Vars[VarLuaName])
					List:AddItem(color)
				end
				
				if self.Vars[VarLuaName].Type == "optionselect" then
					List:AddSubTitle(self.Vars[VarLuaName].LuaName .. " List")
					
					local ListSelect = vgui.Create( "DPanelList");
					ListSelect:SetTall(100)
					ListSelect:EnableHorizontal( false )
					ListSelect:EnableVerticalScrollbar( true )
					ListSelect:RXCAR_PaintListBarC()
					
					local FirstSelect = false
					
					for k,v in pairs(self.Vars[VarLuaName].Options or {}) do
						local MenuButton = vgui.Create("DButton")
						MenuButton:SetTall(20)
						MenuButton:SetText("")
						MenuButton.Paint = function(slf)
							if TuneData.Elements[UID].Vars[VarLuaName] == v.Data then
								surface.SetDrawColor( Color(0,50,150,100) )
								surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
							end
							draw.SimpleText(v.DataTable.PrintName or v.Data, "RXCarFont_TrebOut_S20", 10, 1, Color(255,255,255,255))
						end
						MenuButton.DoClick = function(slf)
							TuneData.Elements[UID].Vars[VarLuaName] = v.Data
							if v.DataTable.PlayTime then
								surface.PlaySound(v.Data)
							end
						end
						
						if TuneData.Elements[UID].Vars[VarLuaName] then
							if TuneData.Elements[UID].Vars[VarLuaName] == v.Data then
								MenuButton:DoClick()
							end
						else
							if !FirstSelect then
								FirstSelect = true
								MenuButton:DoClick()
							end
						end

						ListSelect:AddItem(MenuButton)
					end
					
					List:AddItem(ListSelect)
				end
				
				if self.Editor_Spacer[a] then
					List:AddSubTitle(self.Editor_Spacer[a])
				end
			end
			
		end
				
		return Format
	end
	
	function STR:AddVars(LuaName,Type)
		local VS = {}
		VS.LuaName = LuaName
		VS.Type = Type
		
		-- for number
		VS.Min = 1
		VS.Max = 100
		VS.Decimal = 0
		VS.Order = table.Count(self.Vars)
		
		function VS:AddOption(Data,DataTable)
			DataTable = DataTable or {}
			self.Options = self.Options or {}
			self.Options[Data] = {Data = Data,DataTable = DataTable}
		end
		
		self.Vars[LuaName] = VS
		return VS
	end
	STR.Editor_Spacer = {}
	function STR:Editor_AddSpacer(Text)
		self.Editor_Spacer[table.Count(self.Vars)] = Text
	end
	
	function STR:CL_Think(TuneSysEnt,Vars)
	end
	function STR:SV_Think(TuneSysEnt,Vars)
	end
	function STR:SV_KeyPressed(TuneSysEnt,Vars,Key)
	end
	
	function STR:Render(TuneSysEnt,Vars)
	end
	function STR:RenderOnEditor(TuneSysEnt,Vars)
	end
	
	function STR:SV_OnCreated(TuneSysEnt,Vars)
	end
	
	return table.Copy(STR)
end

function TunerElement_Register(DB)
	RXCar_Tuners[DB.LuaName] = DB
end

function TunerElement_GetTable(luaname)
local TB = RXCar_Tuners[luaname]
	if TB then
		return TB
	end
	
	return false
end

function TunerElement_Include()
local path = "tuner_extensions/"
	for _, file in pairs(file.Find(path .. "*.lua","LUA")) do
		if SERVER then
			AddCSLuaFile(path .. file)
		end
		include(path .. file)
	end
end
TunerElement_Include()