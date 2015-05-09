timer.Simple(1,function()
	LoadRXTuner()
end)

function RXCar_InitTuneData(TuneData)
	TuneData.Color = TuneData.Color or Color(255,255,255,255)
end

function LoadRXTuner()
	local ElementsK = {}
	
	local function DuplicateElements(self,UniqueID)
		local MotherData = self.TuneData.Elements[UniqueID]
		if !MotherData then return end
		
		for k,v in pairs(RXCar_Tuners or {}) do
			if v.Type == MotherData.Type then
				local NewData = table.Copy(MotherData)
				
				v.Func(self,nil,NewData)
				return
			end
		end
	end
	function RXCarPanel_Tuner:DuplicateElement(ElementUID)
		local MotherData = self.TuneData.Elements[ElementUID]
		if !MotherData then return end
		
		for k,v in pairs(RXCar_Tuners or {}) do
			if v.LuaName == MotherData.Type then
			
				-- Max Check --
				--v.Max
				local Current = 0
				
				for UID,a in pairs(self.TuneData.Elements or {}) do
					if a.Type == v.LuaName then
						Current = Current + 1
					end
				end
				if Current >= v.Max then
					RXCar_ShowNotice("You reached max limit")
					return
				end
			
				v:AddOnTunerPanel(self.TuneData,self,nil,nil,true,MotherData.Vars)
				
				return
			end
		end
		
		
	end
	
	function RXCarPanel_Tuner:ApplyTuneData2Preview(TuneData)
		local TB2Apply = TuneData or self.TuneData
		self.BGBackGroundPanel:SetTuneData(TB2Apply)
	end
	
	function RXCarPanel_Tuner:AddElem_Car() -- Main
		local TuneData = self.TuneData
		local CarEnt = self.BGBackGroundPanel:GetCarEntity()
		
		local BG = vgui.Create("RXCAR_DSWButton")
		BG:SetTall(20)
		BG:SetTexts("Car Main")
		BG.BoarderCol = Color(0,0,0,0)
		BG.PaintBackGround = function(slf)
			if self.SelectedButton == slf then
				surface.SetDrawColor( Color(0,50,150,100) )
				surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
			end
		end
		
		self.ElementList:AddItem(BG)
		
		BG.Click = function(slf)
			self.SelectedButton = BG
			local List = self.ToolList
			List:Clear()
			
			List:AddText("Color Customizer")
			local color = vgui.Create( "DColorMixer");
			color:SetSize( List:GetWide(), 200);
			color:SetColor(Color(255,255,255,255))
			color.ValueChanged = function(slf,color)
				TuneData.Color = color
				self:ApplyTuneData2Preview()
			end
			color:SetColor(TuneData.Color or Color(255,255,255,255))
			
			List:AddItem(color)
			if CarEnt and CarEnt:IsValid() then
				List:AddSubTitle("Skin")
				local Slider = List:CreateSlider("Skin Number",1,CarEnt:SkinCount(),0)
				Slider:SetValue(TuneData.SkinNumber or 1)
				Slider.OnValueChanged = function(slf,val)
					TuneData.SkinNumber = val
					CarEnt:SetSkin(val)
				end
				List:AddSubTitle("BodyGroup")
				TuneData.BodyGroups = TuneData.BodyGroups or {}
				for k,v in pairs(CarEnt:GetBodyGroups()) do
					local Slider = List:CreateSlider(v.name,0,v.num,0)
					Slider:SetValue(TuneData.BodyGroups[k] or 0)
					Slider.OnValueChanged = function(slf,val)
						TuneData.BodyGroups[k] = val
						CarEnt:SetBodygroup(k,val)
					end
				end
			end
		end
	end

	
	function RXCarPanel_Tuner:BuildTuner(UID,TuneData)
		RXCar_InitTuneData(TuneData)
		self:ApplyTuneData2Preview(TuneData)
		self.TuneData = TuneData
		
		self.BuilderBGPanel = self:ReBulidCanvas()
		self.BuilderBGPanel.Name = "Tuner"
		self.BuilderBGPanel.CantSpin = true
		
		self.BuilderBGPanel.Paint = function(slf)
		end
			
		local EB = vgui.Create("RXCAR_DSWButton",self.BuilderBGPanel)
		EB:SetSize(100,50)
		EB:SetPos(self.BuilderBGPanel:GetWide()/2-EB:GetWide()/2,self.BuilderBGPanel:GetTall() - EB:GetTall())
		EB:SetTexts("Apply")
		EB.Click = function(slf)
			 RXCar_UpdateTuneData(UID,self.TuneData)
			 self:BuildInventory(UID)
		end
		
		local ElementListBG = vgui.Create("DPanel",self.BuilderBGPanel)
		ElementListBG:SetPos(self.BuilderBGPanel:GetWide()-220,self.BuilderBGPanel:GetTall()-200)
		ElementListBG:SetSize(220,200)
		ElementListBG.Paint = function(slf)
			surface.SetDrawColor( Color(20,20,20,253) )
			surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
			surface.SetDrawColor( Color(40,40,40,255) )
			surface.DrawRect( 0, 0, slf:GetWide(), 20 )
			draw.SimpleText("Installed Elements", "RXCarFont_TrebOut_S20", 10, 1, Color(255,255,255,255))
		end
		
		self.ElementList = vgui.Create("DPanelList",ElementListBG)
		self.ElementList:SetPos(5,25)
		self.ElementList:SetSize(ElementListBG:GetWide()-10,ElementListBG:GetTall()-30)
		self.ElementList:EnableHorizontal( false )
		self.ElementList:EnableVerticalScrollbar( true )
		self.ElementList:RXCAR_PaintListBarC()
		self.ElementList.Paint = function(slf)
		end
		
		local AddElementBG = vgui.Create("DPanel",self.BuilderBGPanel)
		AddElementBG:SetPos(0,0)
		AddElementBG:SetSize(50,self.BuilderBGPanel:GetTall())
		AddElementBG.Paint = function(slf)
			surface.SetDrawColor( Color(20,20,20,253) )
			surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
			surface.SetDrawColor( Color(40,40,40,255) )
			surface.DrawRect( 0, 0, slf:GetWide(), 20 )
			draw.SimpleText("Element", "RXCarFont_TrebOut_S18", 25, 1, Color(255,255,255,255), TEXT_ALIGN_CENTER)
		end
		
		self.AddElementList = vgui.Create("DPanelList",AddElementBG)
		self.AddElementList:SetPos(5,25)
		self.AddElementList:SetSize(40,AddElementBG:GetTall()-30)
		self.AddElementList:EnableHorizontal( false )
		self.AddElementList:EnableVerticalScrollbar( true )
		self.AddElementList:SetSpacing(5)
		self.AddElementList:RXCAR_PaintListBarC()
		self.AddElementList.Paint = function(slf)
			surface.SetDrawColor( Color(0,0,0,50) )
			surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
		end
		
		for k,v in pairs(RXCar_Tuners or {}) do
			local EB = vgui.Create("DButton")
			EB:SetSize(40,40)
			EB:SetText("")
			EB.DoClick = function(slf)
				-- Max Check --
				--v.Max
				local Current = 0
				
				for UID,a in pairs(TuneData.Elements or {}) do
					if a.Type == v.LuaName then
						Current = Current + 1
					end
				end
				if Current >= v.Max then
					RXCar_ShowNotice("You reached max limit")
					return
				end
				
				v:AddOnTunerPanel(TuneData,self,nil,nil,true)
			end
			local MAT = nil
			if v.Icon then
				MAT = Material("icon16/" .. v.Icon .. ".png")
			end
			EB.Paint = function(slf)
				if slf:IsHovered() then
					surface.SetDrawColor(60,60,60,200)
				else
					surface.SetDrawColor(60,60,60,100)
				end
				surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
				
				if MAT then
					surface.SetMaterial(MAT)
					surface.SetDrawColor(255,255,255,255)
					surface.DrawTexturedRect(12,12,16,16)
				end
			end
			EB:SetToolTip(v.PrintName)
			self.AddElementList:AddItem(EB)
		end
		
		local ToolListBG = vgui.Create("DPanel",self.BuilderBGPanel)
		ToolListBG:SetPos(self.BuilderBGPanel:GetWide()-220,0)
		ToolListBG:SetSize(220,self.BuilderBGPanel:GetTall()-200)
		ToolListBG.Paint = function(slf)
			surface.SetDrawColor( Color(20,20,20,253) )
			surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
			surface.SetDrawColor( Color(40,40,40,255) )
			surface.DrawRect( 0, 0, slf:GetWide(), 20 )
			draw.SimpleText("Element Options", "RXCarFont_TrebOut_S20", 10, 1, Color(255,255,255,255))
		end
		
		self.ToolList = vgui.Create("DPanelList",ToolListBG)
		self.ToolList:SetPos(5,25)
		self.ToolList:SetSize(ToolListBG:GetWide()-10,ToolListBG:GetTall()-30)
		self.ToolList:EnableHorizontal( false )
		self.ToolList:EnableVerticalScrollbar( true )
		self.ToolList:SetSpacing(2)
		self.ToolList:RXCAR_PaintListBarC()
		self.ToolList.Paint = function(slf)
			surface.SetDrawColor( Color(0,0,0,50) )
			surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
		end
		
		function self.ToolList:AddSubTitle(text)
			text = "※ " .. text
			local Wrapp = String_Wrap(text,self:GetWide()-20,"RXCarFont_TrebOut_S20")
			local Labels = vgui.Create("DPanel")
				Labels:SetSize(self:GetWide()-20,#Wrapp*25)
				Labels.Paint = function(slf)
					surface.SetDrawColor(40,40,40,255)
					surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
					
					for k,v in pairs(Wrapp) do
						draw.SimpleText(v, "RXCarFont_Treb_S25", 2, 1+25*(k-1), Color(180,255,180,255))
					end
				end
			self:AddItem(Labels)
			return Labels
		end
		
		function self.ToolList:AddText(text)
			local Wrapp = String_Wrap(text,self:GetWide()-20,"RXCarFont_TrebOut_S18")
			local Labels = vgui.Create("DPanel")
				Labels:SetSize(self:GetWide()-20,#Wrapp*20)
				Labels.Paint = function(slf)
					for k,v in pairs(Wrapp) do
						draw.SimpleText(v, "RXCarFont_Treb_S20", 10, -12 + 20*k, Color(200,200,200,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end
				end
				self:AddItem(Labels)
			return Labels
		end
		
		function self.ToolList:CreateSlider(text,min,max,demical)
			local BG = vgui.Create("DPanel")
			BG:SetSize(self:GetWide(),45)
			BG.Paint = function(slf)
			end
			
				local Slider = vgui.Create("RXCAR_Sliders",BG) Slider.Mother = BG
					Slider:SetSize(self:GetWide(),45)
					Slider:SetMax(max)
					Slider:SetMin(min)
					
					Slider.Last = min
					Slider:SetName(text)
					Slider:SetUp()
					Slider:SetValue(min)
					Slider:SetDemical(demical)
				self:AddItem(BG)
			return Slider
		end
			
		
		self.CamControler = vgui.Create("DPanel",self.BuilderBGPanel)
		self.CamControler:SetPos(1,1)
		self.CamControler:SetSize(1,1)

		self.CamControler.Paint = function(slf)
		end
		self.CamControler.Think = function(slf)
			if !input.IsMouseDown(MOUSE_RIGHT) then 
					local MX,MY = gui.MousePos()
					self.LastMousePos_X = MX
					self.LastMousePos_Y = MY
			return end
			
			local Speed = 1
			
			if input.IsKeyDown(KEY_LSHIFT) then
				Speed = Speed * 2
			end
			if input.IsKeyDown(KEY_W) then
				self.BGBackGroundPanel.CamPos = self.BGBackGroundPanel.CamPos + self.BGBackGroundPanel.CamAngle:Forward() *Speed
			end
			if input.IsKeyDown(KEY_S) then
				self.BGBackGroundPanel.CamPos = self.BGBackGroundPanel.CamPos - self.BGBackGroundPanel.CamAngle:Forward() *Speed
			end
			if input.IsKeyDown(KEY_A) then
				self.BGBackGroundPanel.CamPos = self.BGBackGroundPanel.CamPos - self.BGBackGroundPanel.CamAngle:Right() *Speed
			end
			if input.IsKeyDown(KEY_D) then
				self.BGBackGroundPanel.CamPos = self.BGBackGroundPanel.CamPos + self.BGBackGroundPanel.CamAngle:Right() *Speed
			end
			if input.IsKeyDown(KEY_SPACE) then
				self.BGBackGroundPanel.CamPos = self.BGBackGroundPanel.CamPos + self.BGBackGroundPanel.CamAngle:Up() *Speed
			end

			if input.IsMouseDown(MOUSE_RIGHT) then
				if !slf.LM then
					slf.LM = true
					local MX,MY = gui.MousePos()
					self.LastMousePos_X = MX
					self.LastMousePos_Y = MY
				else
					local CX,CY = gui.MousePos()
					local DX,DY = self.LastMousePos_X-CX,self.LastMousePos_Y-CY
					
					self.BGBackGroundPanel.CamAngle.p = self.BGBackGroundPanel.CamAngle.p - DY/3
					
					if self.BGBackGroundPanel.CamAngle.p > 90 then
						self.BGBackGroundPanel.CamAngle.p = 90
					end
					if self.BGBackGroundPanel.CamAngle.p < -90 then
						self.BGBackGroundPanel.CamAngle.p = -90
					end
					
					
					self.BGBackGroundPanel.CamAngle.y = self.BGBackGroundPanel.CamAngle.y + DX/6
					
					self.LastMousePos_X = CX
					self.LastMousePos_Y = CY
				end
			else
				if slf.LM then
					slf.LM = false
				end
			end
		end
		
		
		self:AddElem_Car()
		
		
		local function IsValidElement(Type)
			for _,b in pairs(RXCar_Tuners) do
				if b.LuaName == Type then
					return b
				end
			end
		end
		
		for UID,v in pairs(TuneData.Elements or {}) do
			local Element = IsValidElement(v.Type)
			if Element then
				Element:AddOnTunerPanel(TuneData,self,v.UniqueID,v.Vars)
			end
		end
	end
	
end
